from dataclasses import dataclass
from proxy.utils.byte_buffer import ByteBuffer

@dataclass
class UserInfo:
    uid: int
    nick_name: str

    @classmethod
    def parse(cls, buffer: ByteBuffer) -> 'UserInfo':
        """
        解析 20 字节的用户信息
        4 bytes: UID
        16 bytes: Nickname (UTF-8)
        """
        uid = buffer.read_uint32()
        nick_name = buffer.read_string(16)
        return cls(uid, nick_name)