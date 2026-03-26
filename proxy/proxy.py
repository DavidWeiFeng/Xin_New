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

class SeerProxy:
    def __init__(self):
        self.remote_ips = []
        
        # 序列号管理
        self.current_sequence = 0
        self.sequence_active = False
        self.game_seq_offset = 0 # 应用层序列号偏移量 (Inject count)
        
        # TCP Offset 管理
        self.seq_offset = 0
        self.cached_user_id = 0
        
        # TCP 流缓冲区: (src_ip, src_port, dst_ip, dst_port) -> bytearray
        self.buffers = {}
        # 连接会话元数据：key->hwnd, hwnd->set(keys)
        self.sessions = {} 
        self.hwnd_map = {}

    def _normalize_key(self, key):
        """将 key 标准化为 (client_ip, client_port, server_ip, server_port) 格式"""
        if str(key[0]) in self.remote_ips:
            # 当前是 (server_ip, server_port, client_ip, client_port)
            return (key[2], key[3], key[0], key[1])
        return key
    
    def _find_hwnd_by_pid(self,pid):
        def _by_pid(p):
            hwnds = []  # 使用列表
            def cb(hwnd_enum, _):
                if not win32gui.IsWindowVisible(hwnd_enum):
                    return
                _, wpid = win32process.GetWindowThreadProcessId(hwnd_enum)
                if wpid == p:
                    hwnds.append(hwnd_enum)  # 添加到列表
            win32gui.EnumWindows(cb, None)
            return hwnds[0] if hwnds else None  # 返回第一个
        
        # 2. 父进程链查找（Electron 子进程 -> 主进程）
        try:
            proc = psutil.Process(pid)
            while proc:
                proc = proc.parent()
                if not proc:
                    break
                hwnd = _by_pid(proc.pid)
                if hwnd:
                    return hwnd
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
        
        return None

    def _bind_hwnd_key(self, hwnd, key):
    # 一个 hwnd 可以对应多个 key（不同的连接）
    # 一个 key 只能对应一个 hwnd
    
    # 检查这个 key 是否已经绑定到其他 hwnd
        old_hwnd = self.sessions.get(key)
        if old_hwnd and old_hwnd != hwnd:
            # 如果这个 key 之前绑定到其他 hwnd，需要解除旧绑定
            if old_hwnd in self.hwnd_map:
                self.hwnd_map[old_hwnd].discard(key)  # 从旧 hwnd 的 key 集合中移除
                if not self.hwnd_map[old_hwnd]:  # 如果旧 hwnd 没有 key 了，删除它
                    del self.hwnd_map[old_hwnd]
        
        # 添加新映射
        self.sessions[key] = hwnd
        if hwnd not in self.hwnd_map:
            self.hwnd_map[hwnd] = set()
        self.hwnd_map[hwnd].add(key)

    def _unbind_hwnd_key(self, key):
        hwnd = self.sessions.pop(key, None)
        if hwnd is not None and hwnd in self.hwnd_map:
            self.hwnd_map[hwnd].discard(key)
            if not self.hwnd_map[hwnd]:  # 如果没有 key 了，删除这个 hwnd 条目
                del self.hwnd_map[hwnd]

    def get_hwnd_by_key(self, key):
        if key in self.sessions:
            return self.sessions[key]

        # 通过 net_connections 反查 PID->HWND
        for conn in psutil.net_connections(kind='tcp'):
            if not (conn.laddr and conn.raddr and conn.pid):
                continue
            tuples = (conn.laddr.ip, conn.laddr.port, conn.raddr.ip, conn.raddr.port)
            if tuples == key or tuples == (key[2], key[3], key[0], key[1]):
                hwnd = self._find_hwnd_by_pid(conn.pid)
                if hwnd:
                    self._bind_hwnd_key(hwnd, key)
                    return hwnd
                return None
        return None

    def get_keys_by_hwnd(self, hwnd):
        """获取指定窗口对应的所有连接 key"""
        keys = self.hwnd_map.get(hwnd)
        return list(keys) if keys else []  # 返回列表而不是单个 key
            


    def _cleanup_session(self, key):
        self._unbind_hwnd_key(key)

    def start(self):
        # 支持单个 IP (str) 或 IP 列表 (list)
        remote_ip_config = Auth.REMOTE_IP
        if not remote_ip_config:
            print("[Proxy] Error: Remote IP not set in Auth config!")
            return

        if isinstance(remote_ip_config, list):
            self.remote_ips = remote_ip_config
        else:
            self.remote_ips = [remote_ip_config]
            
        # 构造过滤器: (ip.SrcAddr == IP1 or ip.DstAddr == IP1) or (ip.SrcAddr == IP2 ...)
        filter_parts = []
        for ip in self.remote_ips:
            filter_parts.append(f"ip.SrcAddr == {ip}")
            filter_parts.append(f"ip.DstAddr == {ip}")
            
        # self.filter = " or ".join(filter_parts)
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
        if not packet.tcp:
            return

        # 0. 预先计算方向和 Buffer Key
        if str(packet.ip.dst_addr) in self.remote_ips:
            direction = Direction.CLIENT_TO_SERVER
        else:
            direction = Direction.SERVER_TO_CLIENT
            
        original_key = (packet.ip.src_addr, packet.tcp.src_port, 
                        packet.ip.dst_addr, packet.tcp.dst_port)
        key = self._normalize_key(original_key)
        flags = []
        if packet.tcp.syn: flags.append("SYN")
        if packet.tcp.ack: flags.append("ACK")
        if packet.tcp.fin: flags.append("FIN")
        if packet.tcp.rst: flags.append("RST")
        if packet.tcp.psh: flags.append("PSH")
        print(f"[Debug] Packet: {original_key} -> {key} | Flags: {'-'.join(flags) if flags else 'DATA'} | Payload: {len(packet.tcp.payload)} bytes")
        
        # 🔍 调试：打印 key 标准化过程
        if original_key != key:
            pass
            # print(f"[Debug] Key normalized: {original_key} -> {key}")
        
        # 1. 连接状态管理
        if packet.tcp.syn:
            print(f"[Proxy] 🔄 SYN Packet: {original_key} -> {key}")
            if key in self.buffers:
                print(f"[Debug] Removing buffer for {key} due to SYN")
                del self.buffers[key]
            if key in self.sessions:
                print(f"[Debug] 🔥 Removing session for {key} due to SYN")
                self._cleanup_session(key)
            
            if direction == Direction.CLIENT_TO_SERVER:
                self.seq_offset = 0
                self.current_sequence = 0
                self.game_seq_offset = 0
                self.sequence_active = False
                print("[Proxy] Global state reset. Waiting for Login (CMD 1001)...")
            return 

        if packet.tcp.fin or packet.tcp.rst:
            print(f"[Proxy] 🔌 {'FIN' if packet.tcp.fin else 'RST'} Packet: {key}")
            if key in self.buffers:
                print(f"[Debug] 🔥 FIN/RST packet removing session: {key}")
                del self.buffers[key]
            if key in self.sessions:
                print(f"[Debug] 🔥 Removing session for {key} due to {'FIN' if packet.tcp.fin else 'RST'}")
                self._cleanup_session(key)
            return

        # 2. Session 初始化
        if key not in self.sessions:
            print(f"[Debug] Key not in sessions, querying: {key}")
            hwnd = self.get_hwnd_by_key(key)
            if hwnd:
                self._bind_hwnd_key(hwnd, key)
                print(f"[Proxy] ✅ Session created: {key} hwnd={hwnd}")
            else:
                self.sessions[key] = None
                print(f"[Proxy] ⚠️ No window for: {key}")
        else:
            # 可选：打印命中缓存的次数（调试用）
            if self.sessions[key] is None:
                pass  # 静默处理没有窗口的连接
            # else:
            #     print(f"[Debug] Session hit: {key} -> {self.sessions[key]}")
        
        session_hwnd = self.sessions.get(key)
        # 2. TCP SEQ/ACK 修正 (全局偏移)
        if str(packet.ip.dst_addr) in self.remote_ips:
            packet.tcp.seq_num += self.seq_offset
        elif str(packet.ip.src_addr) in self.remote_ips:
            packet.tcp.ack_num -= self.seq_offset
        
        # 只处理有负载的数据包
        if len(packet.tcp.payload) == 0:
            return

        # 3. 处理数据负载
        if CONFIG['ENABLE_TCP_REASSEMBLY']:
            # 开启重组逻辑：将数据追加到对应的持久化缓冲区
            if key not in self.buffers:
                self.buffers[key] = bytearray()
            self.buffers[key].extend(packet.tcp.payload)
            buffer = self.buffers[key]
        else:
            # 禁用重组逻辑：直接处理当前包的 payload，不使用持久化缓冲区
            buffer = bytearray(packet.tcp.payload)

        is_from_client = (direction == Direction.CLIENT_TO_SERVER)
        
        while len(buffer) >= 2:
            # --- 安全保险：防止缓冲区无限膨胀 (仅在开启重组时有意义) ---
            if CONFIG['ENABLE_TCP_REASSEMBLY'] and len(buffer) > 100 * 1024:
                print(f"[Proxy] ⚠️ Buffer overflow ({len(buffer)} bytes) - Clearing buffer.")
                del buffer[:]
                break

            # --- 过滤 HTTP 握手数据 ---
            if buffer.startswith(b'GET ') or buffer.startswith(b'HTTP') or buffer.startswith(b'POST'):
                del buffer[:]
                break

            if CONFIG['USE_WEBSOCKET']:
                decoded_data, consumed = try_decode_frame(buffer, is_from_client)
            else:
                # Raw TCP - 长度前缀协议 (Big Endian)
                if len(buffer) < 4:
                    break
                
                packet_len = int.from_bytes(buffer[:4], 'big')
                if len(buffer) < packet_len:
                    # 数据不足一包：
                    # 如果开启了重组，则退出循环等待后续包；
                    # 如果没开启重组，则直接放弃当前 buffer 剩余的所有数据
                    break
                
                decoded_data = buffer[:packet_len]
                consumed = packet_len

            if consumed == 0:
                break
            
            # 移除已处理字节
            del buffer[:consumed]
            
            # 执行业务逻辑
            if decoded_data:
                self.process_game_frame(decoded_data, direction, packet, w, consumed, session_hwnd)
            
            # 如果不开启重组，我们只尝试处理当前数据包中的完整帧。
            # 一旦发现剩余数据不足以构成下一帧，循环就会 break。
            # 注意：在禁用重组时，buffer 是局部变量，循环结束后剩余数据会被自动丢弃。
            if not CONFIG['ENABLE_TCP_REASSEMBLY']:
                # 检查是否还有足够数据处理下一帧，如果没有则退出
                if len(buffer) < 4: 
                    break

    def process_game_frame(self, data, direction, packet, w, frame_len, hwnd=None):
        if len(data) < 17: return
        if data[0] != 0 or data[1] != 0: return

        packet_obj = self.parse_packet_bytes(data, direction)
        
        if packet_obj:
            # 缓存米米号
            if direction == Direction.CLIENT_TO_SERVER and packet_obj.user_id != 0:
                self.cached_user_id = packet_obj.user_id

            # 初始化触发 (CMD 1001)
            if CONFIG['ENABLE_SEQUENCE_REWRITE'] and direction == Direction.CLIENT_TO_SERVER and packet_obj.cmd_id == 1001:
                self.current_sequence = 0
                self.sequence_active = True
                self.seq_offset = 0
                self.game_seq_offset = 0
                print(f"[Proxy] 收到 CMD 1001，序列号同步已激活")

            # --- 序列号同步 & 注入逻辑 ---
            if direction == Direction.CLIENT_TO_SERVER and self.sequence_active:
                
                # 1. 同步当前序列号 (信任客户端)
                # print(f"[Debug] Client Origin Seq={packet_obj.sequence} | Current Offset={self.game_seq_offset}")
                self.current_sequence = packet_obj.sequence + self.game_seq_offset

                # 2. 执行注入
                # 如果是拆包/粘包，跳过注入
                is_complex_frame = (frame_len != len(packet.tcp.payload))

                if not is_complex_frame:
                    while CommandQueue.has_command():
                        cmd_id, body = CommandQueue.dequeue()
                        
                        # 注入包使用 "Current Sequence" (Original + Offset)
                        # 注入后，Sequence + 1
                        inj_obj = Packet(0, 0x31, cmd_id, self.cached_user_id, self.current_sequence, body)
                        self.current_sequence += 1 
                        self.game_seq_offset += 1 # 偏移量增加
                        
                        if CONFIG['USE_WEBSOCKET']:
                            ws_data = encode_websocket(inj_obj.pack(), is_binary=True, mask=True)
                        else:
                            ws_data = inj_obj.pack()
                        
                        # 构造注入 TCP 包
                        inj_packet = pydivert.Packet(packet.raw, packet.interface, packet.direction)
                        inj_packet.tcp.seq_num = packet.tcp.seq_num
                        inj_packet.tcp.payload = ws_data
                        inj_packet.tcp.psh = True
                        
                        print(f"   [Inject] CMD={cmd_id} | BodyLen={len(body)} | GameSeq={inj_obj.sequence}")
                        
                        w.send(inj_packet)
                        
                        # 更新 TCP Offset
                        injected_len = len(ws_data)
                        self.seq_offset += injected_len
                        packet.tcp.seq_num += injected_len

                    # 3. 重写当前包 (Rewrite Original Packet)
                    if self.game_seq_offset > 0:
                        original_seq = packet_obj.sequence
                        self._rewrite_client_packet(packet, packet_obj)
                        print(f"   [Rewrite] CMD={packet_obj.cmd_id} | Seq: {original_seq} -> {packet_obj.sequence}")

                else:
                    if CommandQueue.has_command():
                        print(f"[Proxy] ⚠️ Skipped injection due to fragmented/sticky frame.")

            handle_command(packet_obj.cmd_id, packet_obj, direction)
            
    def _rewrite_client_packet(self, packet, packet_obj):
        """
        重写客户端数据包的 Sequence，并重新封装 WebSocket/TCP Payload。
        用于在注入数据包后，保持后续包的序列号连续性。
        """
        # 修改应用层 Sequence
        packet_obj.sequence += self.game_seq_offset
        
        # 重新打包应用层数据
        new_body = packet_obj.pack()
        
        # 重新封装 WebSocket 帧 (必须带 Mask)
        if CONFIG['USE_WEBSOCKET']:
            new_ws_payload = encode_websocket(new_body, is_binary=True, mask=True)
        else:
            new_ws_payload = new_body
        
        old_tcp_len = len(packet.tcp.payload)
        new_tcp_len = len(new_ws_payload)
        
        # 替换 TCP Payload (pydivert 会自动计算 Checksum)
        packet.tcp.payload = new_ws_payload
        
        # 如果长度发生变化，修正 TCP 层的全局 Offset
        if old_tcp_len != new_tcp_len:
            diff = new_tcp_len - old_tcp_len
            self.seq_offset += diff
            # print(f"   [Rewrite] Length changed: {old_tcp_len} -> {new_tcp_len} (Diff: {diff})")

    def parse_packet_bytes(self, data: bytes, direction: Direction):
        if len(data) < Protocol.HEADER_SIZE: return None
        try:
            header_data = data[:Protocol.HEADER_SIZE]
            # Unpack 5 values: len, ver, cmd, uid, seq
            length, version, cmd_id, user_id, sequence = Packet.unpack_header(header_data)
            body = data[Protocol.HEADER_SIZE:]
            # 解密 body (如果需要)
            # encrypted_body = data[Protocol.HEADER_SIZE:length]
            # decrypted_body = Protocol.xor_cipher(encrypted_body)
            
            return Packet(length, version, cmd_id, user_id, sequence, body)
        except Exception as e:
            print(f"[{direction.value}] Parse Error: {e}")
            return None
