from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.config import Direction

def handle_fight_npc_monster(packet: Packet, direction: Direction):
    """
    处理 CMD 2408 (FIGHT_NPC_MONSTER)
    """
    if direction == Direction.CLIENT_TO_SERVER:
        # Client Request        
        buffer = ByteBuffer(packet.body)
        if buffer.available() >= 4:
            monster_id = buffer.read_uint32()
            print(f"   [Request] 挑战野外精灵 (Fight NPC): ID={monster_id}")
        else:
            print(f"   [Request] 挑战野外精灵 (Fight NPC) - No Data")
    elif direction == Direction.SERVER_TO_CLIENT:
        # Server Response
        # 根据 MapProcess_423.as，客户端监听此命令但未处理具体数据，可能仅作为信号
        # 或者数据为空
        print(f"   [Response] 挑战野外精灵 (Fight NPC) - Start Signal")
