import struct
from dataclasses import dataclass
from typing import Optional, Tuple

@dataclass
class Packet:
    length: int
    version: int
    cmd_id: int
    user_id: int
    sequence: int
    body: bytes
    hwnd: int = -1

    def pack(self) -> bytes:
        """将 Packet 对象打包成二进制数据流"""
        # 计算包含头的总长度
        self.length = 17 + len(self.body)
        header = struct.pack(">IBIII", self.length, self.version, self.cmd_id, self.user_id, self.sequence)
        
        # 加密 body
        encrypted_body = Protocol.xor_cipher(self.body, self.hwnd)
        return header + encrypted_body

    @classmethod
    def unpack_header(cls, header_data: bytes) -> Tuple[int, int, int, int, int]:
        """解包 17 字节的固定头部"""
        return struct.unpack(">IBIII", header_data)

class Protocol:
    HEADER_SIZE = 17
    VERSION = 0x37
    DEFAULT_XOR_KEY = b"CWF" # 默认密钥
    _XOR_KEYS = {} # hwnd -> key

    @staticmethod
    def update_xor_key(new_key: bytes, hwnd: int = -1):
        Protocol._XOR_KEYS[hwnd] = new_key

    @staticmethod
    def xor_cipher(data: bytes, hwnd: int = -1) -> bytes:
        key = Protocol._XOR_KEYS.get(hwnd, Protocol.DEFAULT_XOR_KEY)
        if not key:
            return data
        key_len = len(key)
        return bytes(data[i] ^ key[i % key_len] for i in range(len(data)))

    @staticmethod
    def create_packet(cmd_id: int, user_id: int, sequence: int = 0, body: bytes = b"") -> Packet:
        """方便快捷地创建 Packet 对象"""
        return Packet(
            length=17 + len(body),
            version=Protocol.VERSION,
            cmd_id=cmd_id,
            user_id=user_id,
            sequence=sequence,
            body=body
        )

    @staticmethod
    def hex_dump(data: bytes, title: str = "Hex Dump"):
        """调试辅助：生成类似于 Lua 版本的 Hex Dump 输出"""
        print(f"[{title}] ({len(data)} bytes):")
        for i in range(0, len(data), 16):
            chunk = data[i:i+16]
            hex_part = " ".join(f"{b:02X}" for b in chunk)
            ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
            padding = "   " * (16 - len(chunk))
            print(f"  {i:04X}: {hex_part}{padding} |{ascii_part}|")
