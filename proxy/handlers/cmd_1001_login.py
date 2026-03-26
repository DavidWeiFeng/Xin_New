from proxy.utils.protocol import Packet
from proxy.config import Direction

def handle_login(packet: Packet, direction: Direction):
    """
    处理登陆命令 (CMD 1001)
    """
    if direction == Direction.CLIENT_TO_SERVER: # Client -> Server
        # LOGIN_IN 响应体结构:
        # Session: 16 bytes (用于后续加密的密钥来源)
        # 其他字段: UserInfo.setForLoginInfo (大量数据)
        
        body = packet.body
        print(f"[Login] Received Login Packet: {body.hex()}")
