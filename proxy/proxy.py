import pydivert
from proxy.config import CONFIG, Direction
from proxy.utils.protocol import Protocol, Packet
from proxy.utils.websocket import decode_websocket, encode_websocket, try_decode_frame
from proxy.utils.command_queue import CommandQueue
from proxy.handlers.dispatcher import handle_command
from config.config import Auth
import psutil
import win32process
import win32gui
from typing import Dict, Set, Optional, Tuple, List
from dataclasses import dataclass
from collections import defaultdict


@dataclass
class SequenceState:
    """序列号状态管理"""
    current: int = 0
    active: bool = False
    game_offset: int = 0  # 应用层序列号偏移量
    tcp_offset: int = 0   # TCP层偏移量
    
    def reset(self):
        self.current = 0
        self.active = False
        self.game_offset = 0
        self.tcp_offset = 0
    
    def activate(self):
        self.current = 0
        self.active = True
        self.game_offset = 0
        self.tcp_offset = 0


class SeerProxy:
    def __init__(self):
        self.remote_ips: List[str] = []
        
        # 序列号管理
        self.seq_state = SequenceState()
        self.cached_user_id = 0
        
        # TCP 流缓冲区: (src_ip, src_port, dst_ip, dst_port) -> bytearray
        self.buffers: Dict[Tuple, bytearray] = {}
        # 连接会话元数据：key->hwnd, hwnd->set(keys)
        self.sessions: Dict[Tuple, Optional[int]] = {}
        self.hwnd_map: Dict[int, Set[Tuple]] = {}

    # ==================== 辅助方法 ====================
    
    def _is_server_ip(self, ip: str) -> bool:
        """判断是否为服务器IP"""
        return ip in self.remote_ips
    
    def _is_client_to_server(self, src_ip: str, dst_ip: str) -> bool:
        """判断是否为客户端到服务器的方向"""
        return self._is_server_ip(dst_ip)
    
    def _get_normalized_key(self, src_ip: str, src_port: int, dst_ip: str, dst_port: int) -> Tuple:
        """
        标准化 key 为 (client_ip, client_port, server_ip, server_port) 格式
        """
        key = (src_ip, src_port, dst_ip, dst_port)
        # 如果源IP是服务器IP，说明方向反了，需要交换
        if self._is_server_ip(src_ip):
            return (dst_ip, dst_port, src_ip, src_port)
        return key
    
    def _extract_packet_info(self, packet) -> Tuple[Direction, Tuple]:
        """提取数据包的方向和标准化key"""
        src_ip = str(packet.ip.src_addr)
        dst_ip = str(packet.ip.dst_addr)
        
        direction = Direction.CLIENT_TO_SERVER if self._is_server_ip(dst_ip) else Direction.SERVER_TO_CLIENT
        key = self._get_normalized_key(src_ip, packet.tcp.src_port, dst_ip, packet.tcp.dst_port)
        
        return direction, key
    
    def _is_control_packet(self, packet) -> bool:
        """判断是否为控制包（SYN/FIN/RST）"""
        return packet.tcp.syn or packet.tcp.fin or packet.tcp.rst
    
    def _cleanup_connection(self, key: Tuple):
        """清理连接相关的所有资源"""
        # 清理缓冲区
        if key in self.buffers:
            del self.buffers[key]
        
        # 清理会话绑定
        hwnd = self.sessions.pop(key, None)
        if hwnd is not None and hwnd in self.hwnd_map:
            self.hwnd_map[hwnd].discard(key)
            if not self.hwnd_map[hwnd]:
                del self.hwnd_map[hwnd]
    
    def _adjust_tcp_sequence(self, packet, direction: Direction):
        """修正TCP序列号（全局偏移）"""
        if direction == Direction.CLIENT_TO_SERVER:
            packet.tcp.seq_num += self.seq_state.tcp_offset
        else:
            packet.tcp.ack_num -= self.seq_state.tcp_offset
    
    def _get_or_create_buffer(self, key: Tuple) -> bytearray:
        """获取或创建TCP缓冲区"""
        if key not in self.buffers:
            self.buffers[key] = bytearray()
        return self.buffers[key]
    
    def _check_buffer_overflow(self, buffer: bytearray) -> bool:
        """检查缓冲区是否溢出"""
        if len(buffer) > 100 * 1024:
            print(f"[Proxy] ⚠️ Buffer overflow ({len(buffer)} bytes) - Clearing buffer.")
            buffer.clear()
            return True
        return False
    
    def _is_http_handshake(self, buffer: bytearray) -> bool:
        """判断是否为HTTP握手数据"""
        return (buffer.startswith(b'GET ') or 
                buffer.startswith(b'HTTP') or 
                buffer.startswith(b'POST'))
    
    def _decode_frame(self, buffer: bytearray, is_from_client: bool) -> Tuple[Optional[bytes], int]:
        """解码帧数据"""
        if CONFIG['USE_WEBSOCKET']:
            return try_decode_frame(buffer, is_from_client)
        else:
            # Raw TCP - 长度前缀协议 (Big Endian)
            if len(buffer) < 4:
                return None, 0
            packet_len = int.from_bytes(buffer[:4], 'big')
            if len(buffer) < packet_len:
                return None, 0
            return buffer[:packet_len], packet_len
    
    # ==================== 窗口管理方法 ====================
    
    def _find_hwnd_by_pid(self, pid: int) -> Optional[int]:
        """通过PID查找窗口句柄（包括父进程）"""
        def enum_windows_by_pid(target_pid):
            hwnds = []
            def callback(hwnd_enum, _):
                if not win32gui.IsWindowVisible(hwnd_enum):
                    return
                _, wpid = win32process.GetWindowThreadProcessId(hwnd_enum)
                if wpid == target_pid:
                    hwnds.append(hwnd_enum)
            win32gui.EnumWindows(callback, None)
            return hwnds[0] if hwnds else None
        
        # 查找当前进程
        hwnd = enum_windows_by_pid(pid)
        if hwnd:
            return hwnd
        
        # 查找父进程链（Electron 子进程 -> 主进程）
        try:
            proc = psutil.Process(pid)
            while proc:
                proc = proc.parent()
                if not proc:
                    break
                hwnd = enum_windows_by_pid(proc.pid)
                if hwnd:
                    return hwnd
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
        
        return None

    def _bind_hwnd_key(self, hwnd: int, key: Tuple):
        """绑定窗口句柄和连接key"""
        # 检查这个 key 是否已经绑定到其他 hwnd
        old_hwnd = self.sessions.get(key)
        if old_hwnd and old_hwnd != hwnd:
            # 解除旧绑定
            if old_hwnd in self.hwnd_map:
                self.hwnd_map[old_hwnd].discard(key)
                if not self.hwnd_map[old_hwnd]:
                    del self.hwnd_map[old_hwnd]
        
        # 添加新映射
        self.sessions[key] = hwnd
        self.hwnd_map.setdefault(hwnd, set()).add(key)

    def _unbind_hwnd_key(self, key: Tuple):
        """解除窗口绑定"""
        hwnd = self.sessions.pop(key, None)
        if hwnd is not None and hwnd in self.hwnd_map:
            self.hwnd_map[hwnd].discard(key)
            if not self.hwnd_map[hwnd]:
                del self.hwnd_map[hwnd]

    def get_hwnd_by_key(self, key: Tuple) -> Optional[int]:
        """获取连接对应的窗口句柄"""
        if key in self.sessions:
            return self.sessions[key]

        # 通过网络连接反查 PID->HWND
        for conn in psutil.net_connections(kind='tcp'):
            if not (conn.laddr and conn.raddr and conn.pid):
                continue
            conn_tuple = (conn.laddr.ip, conn.laddr.port, conn.raddr.ip, conn.raddr.port)
            if conn_tuple == key or conn_tuple == (key[2], key[3], key[0], key[1]):
                hwnd = self._find_hwnd_by_pid(conn.pid)
                if hwnd:
                    self._bind_hwnd_key(hwnd, key)
                    return hwnd
                return None
        return None

    def get_keys_by_hwnd(self, hwnd: int) -> List[Tuple]:
        """获取指定窗口对应的所有连接 key"""
        return list(self.hwnd_map.get(hwnd, []))
    
    def _ensure_session(self, key: Tuple):
        """确保会话存在"""
        if key not in self.sessions:
            hwnd = self.get_hwnd_by_key(key)
            if hwnd:
                self._bind_hwnd_key(hwnd, key)
                print(f"[Proxy] ✅ Session created: {key} hwnd={hwnd}")
            else:
                self.sessions[key] = None
                print(f"[Proxy] ⚠️ No window for: {key}")

    # ==================== 数据包处理核心 ====================
    
    def start(self):
        """启动代理"""
        # 加载配置
        remote_ip_config = Auth.REMOTE_IP
        if not remote_ip_config:
            print("[Proxy] Error: Remote IP not set in Auth config!")
            return

        self.remote_ips = [remote_ip_config] if isinstance(remote_ip_config, str) else remote_ip_config
        
        # 构造过滤器
        filter_parts = []
        for ip in self.remote_ips:
            filter_parts.append(f"ip.SrcAddr == {ip}")
            filter_parts.append(f"ip.DstAddr == {ip}")
        self.filter = f"(tcp or udp) and ({' or '.join(filter_parts)})"
        
        print(f"[Proxy] Starting WinDivert transparent proxy...")
        print(f"[Proxy] Filter: {self.filter}")
        print("[Proxy] Waiting for game traffic... (Run the game now)")

        try:
            with pydivert.WinDivert(self.filter) as w:
                for packet in w:
                    try:
                        self.handle_packet(packet, w)
                        w.send(packet)
                    except Exception as e:
                        print(f"[Error] Packet handling failed: {e}")
        except OSError as e:
            if "Admin" in str(e) or "Access is denied" in str(e):
                print("\n[CRITICAL ERROR] WinDivert requires Administrator privileges.")
            else:
                raise e

    def handle_packet(self, packet, w):
        """处理单个数据包（主入口）"""
        if not packet.tcp:
            return

        # 提取基础信息
        direction, key = self._extract_packet_info(packet)
        
        
        # 处理连接控制包（SYN/FIN/RST）
        if self._is_control_packet(packet):
            self._handle_control_packet(packet, key, direction)
            return

        # 确保会话存在
        self._ensure_session(key)
        
        # 修正TCP序列号
        self._adjust_tcp_sequence(packet, direction)
        
        # 处理数据负载
        if packet.tcp.payload:
            self._process_payload(packet, direction, key, w)
    
    
    def _handle_control_packet(self, packet, key: Tuple, direction: Direction):
        """处理控制包（SYN/FIN/RST）"""
        if packet.tcp.syn:
            print(f"[Proxy] 🔄 SYN Packet: {key}")
            self._cleanup_connection(key)
            
            if direction == Direction.CLIENT_TO_SERVER:
                self.seq_state.reset()
                print("[Proxy] Global state reset. Waiting for Login (CMD 1001)...")
        
        elif packet.tcp.fin or packet.tcp.rst:
            flag = 'FIN' if packet.tcp.fin else 'RST'
            print(f"[Proxy] 🔌 {flag} Packet: {key}")
            self._cleanup_connection(key)
    
    def _process_payload(self, packet, direction: Direction, key: Tuple, w):
        """处理数据负载"""
        is_from_client = direction == Direction.CLIENT_TO_SERVER
        session_hwnd = self.sessions.get(key)
        
        # 获取缓冲区
        if CONFIG['ENABLE_TCP_REASSEMBLY']:
            buffer = self._get_or_create_buffer(key)
            buffer.extend(packet.tcp.payload)
        else:
            buffer = bytearray(packet.tcp.payload)
        
        # 处理完整的帧
        self._process_frames(buffer, is_from_client, packet, direction, key, w, session_hwnd)
        
        # 如果不重组，清理缓冲区
        if not CONFIG['ENABLE_TCP_REASSEMBLY']:
            buffer.clear()
    
    def _process_frames(self, buffer: bytearray, is_from_client: bool, packet,
                        direction: Direction, key: Tuple, w, session_hwnd: Optional[int]):
        """处理缓冲区中的完整帧"""
        while len(buffer) >= 2:
            # 安全检查
            if self._check_buffer_overflow(buffer):
                break
            
            # 过滤HTTP握手
            if self._is_http_handshake(buffer):
                buffer.clear()
                break
            
            # 解码帧
            decoded_data, consumed = self._decode_frame(buffer, is_from_client)
            if consumed == 0:
                break
            
            # 移除已处理数据
            del buffer[:consumed]
            
            # 处理游戏数据
            if decoded_data:
                self.process_game_frame(decoded_data, direction, packet, w, consumed, session_hwnd)
            
            # 如果不重组，只处理一个完整帧
            if not CONFIG['ENABLE_TCP_REASSEMBLY']:
                break

    def process_game_frame(self, data: bytes, direction: Direction, packet, w, frame_len: int, hwnd: Optional[int] = None):
        """处理游戏协议帧（公共接口，不能改动）"""
        if len(data) < 17 or data[0] != 0 or data[1] != 0:
            return

        packet_obj = self.parse_packet_bytes(data, direction)
        
        if packet_obj:
            # 缓存米米号
            if direction == Direction.CLIENT_TO_SERVER and packet_obj.user_id != 0:
                self.cached_user_id = packet_obj.user_id

            # 初始化触发 (CMD 1001)
            if CONFIG['ENABLE_SEQUENCE_REWRITE'] and direction == Direction.CLIENT_TO_SERVER and packet_obj.cmd_id == 1001:
                self.seq_state.activate()
                print(f"[Proxy] 收到 CMD 1001，序列号同步已激活")

            # 序列号同步 & 注入逻辑
            if direction == Direction.CLIENT_TO_SERVER and self.seq_state.active:
                self._handle_sequence_operations(packet_obj, packet, frame_len, w)

            # 分发命令
            handle_command(packet_obj.cmd_id, packet_obj, direction)
    
    def _handle_sequence_operations(self, packet_obj, packet, frame_len: int, w):
        """处理序列号相关操作（同步、注入、重写）"""
        # 同步当前序列号
        self.seq_state.current = packet_obj.sequence + self.seq_state.game_offset

        # 检查是否为复杂帧（拆包/粘包）
        is_complex_frame = frame_len != len(packet.tcp.payload)

        if not is_complex_frame:
            # 执行注入
            self._inject_commands(packet, w)
            # 重写当前包
            if self.seq_state.game_offset > 0:
                self._rewrite_client_packet(packet, packet_obj)
        elif CommandQueue.has_command():
            print(f"[Proxy] ⚠️ Skipped injection due to fragmented/sticky frame.")
    
    def _inject_commands(self, packet, w):
        """注入待发送的命令"""
        while CommandQueue.has_command():
            cmd_id, body = CommandQueue.dequeue()
            
            # 创建注入包
            inj_obj = Packet(0, 0x31, cmd_id, self.cached_user_id, self.seq_state.current, body)
            self.seq_state.current += 1
            self.seq_state.game_offset += 1
            
            # 封装数据
            if CONFIG['USE_WEBSOCKET']:
                ws_data = encode_websocket(inj_obj.pack(), is_binary=True, mask=True)
            else:
                ws_data = inj_obj.pack()
            
            # 发送注入包
            inj_packet = pydivert.Packet(packet.raw, packet.interface, packet.direction)
            inj_packet.tcp.seq_num = packet.tcp.seq_num
            inj_packet.tcp.payload = ws_data
            inj_packet.tcp.psh = True
            
            print(f"   [Inject] CMD={cmd_id} | BodyLen={len(body)} | GameSeq={inj_obj.sequence}")
            w.send(inj_packet)
            
            # 更新TCP偏移
            self.seq_state.tcp_offset += len(ws_data)
            packet.tcp.seq_num += len(ws_data)

    def _rewrite_client_packet(self, packet, packet_obj):
        """重写客户端数据包的序列号（公共接口，不能改动逻辑）"""
        # 修改应用层 Sequence
        old_seq = packet_obj.sequence
        packet_obj.sequence += self.seq_state.game_offset
        
        # 重新打包
        new_body = packet_obj.pack()
        
        # 重新封装
        if CONFIG['USE_WEBSOCKET']:
            new_ws_payload = encode_websocket(new_body, is_binary=True, mask=True)
        else:
            new_ws_payload = new_body
        
        # 替换TCP Payload
        old_tcp_len = len(packet.tcp.payload)
        new_tcp_len = len(new_ws_payload)
        packet.tcp.payload = new_ws_payload
        
        # 更新TCP偏移
        if old_tcp_len != new_tcp_len:
            diff = new_tcp_len - old_tcp_len
            self.seq_state.tcp_offset += diff
        
        print(f"   [Rewrite] CMD={packet_obj.cmd_id} | Seq: {old_seq} -> {packet_obj.sequence}")

    def parse_packet_bytes(self, data: bytes, direction: Direction):
        """解析数据包（公共接口，不能改动）"""
        if len(data) < Protocol.HEADER_SIZE:
            return None
        try:
            header_data = data[:Protocol.HEADER_SIZE]
            length, version, cmd_id, user_id, sequence = Packet.unpack_header(header_data)
            body = data[Protocol.HEADER_SIZE:length]
            return Packet(length, version, cmd_id, user_id, sequence, body)
        except Exception as e:
            print(f"[{direction.value}] Parse Error: {e}")
            return None