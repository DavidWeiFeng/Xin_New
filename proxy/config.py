from enum import Enum


IP={
    'Nier': '115.238.192.7',
    'Jiaoyang': '160.202.238.39',
    'Xin':'140.210.17.123'
}
CONFIG = {
    'LOCAL_HOST': '0.0.0.0',
    # 'REMOTE_IP': 动态获取,  # 远程服务器 IP 地址
    'ENABLE_SEQUENCE_REWRITE': False,  # 是否开启序列号拦截重写功能
    'USE_WEBSOCKET': True,             # 是否解析 WebSocket 帧 (True=WS, False=Raw TCP)
    'ENABLE_TCP_REASSEMBLY': False,     # 是否开启 TCP 粘包/拆包处理 (默认关闭，防止缓冲区堆积)
}

# 数据流方向枚举
class Direction(Enum):
    CLIENT_TO_SERVER = 'CLIENT -> SERVER'
    SERVER_TO_CLIENT = 'SERVER -> CLIENT'


