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
        # 连接会话元数据：key->dict(pid, hwnds, state...)
        self.sessions = {}

    #根据 PID 查找hwnd
    def _find_hwnds_by_pid(pid):
        def _by_pid(p):
            hwnds = []
            def cb(hwnd, _):
                if not win32gui.IsWindowVisible(hwnd):
                    return
                _, wpid = win32process.GetWindowThreadProcessId(hwnd)
                if wpid == p:
                    hwnds.append(hwnd)
            win32gui.EnumWindows(cb, None)
            return hwnds
        # 2. 查一级父进程
        try:
            proc = psutil.Process(pid)
            parent = proc.parent()
            if parent:
                hwnds = _by_pid(parent.pid)
                if hwnds:
                    return hwnds
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass

        return []
    #根据会话，查找hwnd
    def _init_session(self, key, packet):
        meta = {"pid": None, "hwnds": [], "key": key}
        for conn in psutil.net_connections(kind='tcp'):
            if conn.laddr and conn.raddr and conn.pid:
                if (conn.laddr.ip, conn.laddr.port, conn.raddr.ip, conn.raddr.port) == key:
                    meta["pid"] = conn.pid
                    meta["hwnds"] = self._find_hwnds_by_pid(conn.pid)
                    break
                # 反向也可能
                if (conn.laddr.ip, conn.laddr.port, conn.raddr.ip, conn.raddr.port) == (key[2], key[3], key[0], key[1]):
                    meta["pid"] = conn.pid
                    meta["hwnds"] = self._find_hwnds_by_pid(conn.pid)
                    break
        self.sessions[key] = meta
        return meta
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
            
        key = (packet.ip.src_addr, packet.tcp.src_port, packet.ip.dst_addr, packet.tcp.dst_port)

        # 1. 连接状态管理 (SYN/FIN/RST)
        if packet.tcp.syn:
            print(f"[Proxy] 🔄 New Connection Detected: {packet.ip.src_addr}:{packet.tcp.src_port}")
            if key in self.buffers:
                del self.buffers[key]
            
            if key in self.sessions:
                del self.sessions[key]
            
            # 重置所有状态
            if direction == Direction.CLIENT_TO_SERVER:
                self.seq_offset = 0
                self.current_sequence = 0
                self.game_seq_offset = 0
                self.sequence_active = False
                print("[Proxy] Global state reset. Waiting for Login (CMD 1001)...")
            return 

        if packet.tcp.fin or packet.tcp.rst:
            if key in self.buffers:
                del self.buffers[key]
            if key in self.sessions:
                del self.sessions[key]
            return

        if key not in self.sessions:
            session_meta = self._init_session(key, packet)
            print(f"[Proxy] Session init: {key} pid={session_meta['pid']} hwnds={session_meta['hwnds']}")

        session_meta = self.sessions.get(key)
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
                self.process_game_frame(decoded_data, direction, packet, w, consumed)
            
            # 如果不开启重组，我们只尝试处理当前数据包中的完整帧。
            # 一旦发现剩余数据不足以构成下一帧，循环就会 break。
            # 注意：在禁用重组时，buffer 是局部变量，循环结束后剩余数据会被自动丢弃。
            if not CONFIG['ENABLE_TCP_REASSEMBLY']:
                # 检查是否还有足够数据处理下一帧，如果没有则退出
                if len(buffer) < 4: 
                    break

    def process_game_frame(self, data, direction, packet, w, frame_len):
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
