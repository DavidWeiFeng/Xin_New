from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.config import Direction
from proxy.utils.protocol import Protocol

def handle_enter_map(packet: Packet, direction: Direction):
    """
    处理 CMD 2001 (Enter Map)
    Client -> Server body:
      - MapType (u32)
      - MapID (u32)
      - X (u32)
      - Y (u32)
    """
    if direction != Direction.CLIENT_TO_SERVER:
        return

    buffer = ByteBuffer(packet.body)
    if buffer.available() < 8:
        return
    
    new_key = packet.body[:4]        
    Protocol.update_xor_key(new_key)
    # print(f"Dynamic XOR Key Updated: {new_key.hex().upper()}")
    # print(f"{packet.body.hex()}  [CMD 2001] Enter Map")

    # decrypted_data = Protocol.xor_cipher(packet.body) 
    # decrypted_buffer = ByteBuffer(decrypted_data)
    # try:
    #     map_type = decrypted_buffer.read_uint32()
    #     map_id = decrypted_buffer.read_uint32()

    #     # 更新全局地图状态
    #     # OgreManager().set_current_map(map_id)
    #     print(f"   [Map Entry] MapID: {map_id} (Type: {map_type})")

    # except Exception as e:
    #     print(f"   [Error] Failed to parse Enter Map packet: {e}")
