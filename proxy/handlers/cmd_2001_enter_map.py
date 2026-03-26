from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.config import Direction
from proxy.utils.protocol import Protocol

def handle_enter_map(packet: Packet, direction: Direction, hwnd: int = -1):
    """
    处理 CMD 2001 (Enter Map)
    Client -> Server body:
      - MapType (u32)
      - MapID (u32)
      - X (u32)
      - Y (u32)
    """
    try:
        if direction != Direction.CLIENT_TO_SERVER:
            return

        buffer = ByteBuffer(packet.body)
        if buffer.available() < 8:
            return
        
        new_key = packet.body[:4]        
        Protocol.update_xor_key(new_key, hwnd=hwnd)
    
    # 如果需要的话，也可以在这里更新该窗口对应的地图ID
    # OgreManager(hwnd).set_current_map(map_id)
    except Exception as e:
        print(f"   [Error] Failed to parse Enter Map packet: {e}")
