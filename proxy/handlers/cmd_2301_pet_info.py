from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.entities.pet_info import PetInfo
from proxy.utils.game_data import GameData
from proxy.config import Direction

def handle_get_pet_info(packet: Packet, direction: Direction):
    """
    处理 CMD 2301 (Get Pet Info)
    Client -> Server: 请求 (CatchTime)
    Server -> Client: 响应 (Full Pet Info)
    """
    buffer = ByteBuffer(packet.body)
    
    if direction == Direction.CLIENT_TO_SERVER:
        _handle_request(buffer)
    elif direction == Direction.SERVER_TO_CLIENT:
        _handle_response(buffer)

def _handle_request(buffer: ByteBuffer):
    catch_time = None
    if buffer.available() >= 4:
        catch_time = buffer.read_uint32()


def _handle_response(buffer: ByteBuffer):
    try:
        pet = PetInfo.parse_full(buffer)
        # _print_pet_info(pet)
    except Exception as e:
        print(f"   [Error] Failed to parse Pet Info: {e}")
        Protocol.hex_dump(buffer)


def _print_pet_info(pet: PetInfo):
    # 使用 GameData 获取精灵名称
    pet_name = GameData.get_pet_name(pet.id)
    
    print(f"   [Response] Pet Details:")
    print(f"      {pet}")
    print(f"      Pet Name: {pet_name}")
    
    # 如果有技能信息，也显示技能名称
    if hasattr(pet, 'skill_ids') and pet.skill_ids:
        print(f"      Skills:")
        for skill_id in pet.skill_ids:
            skill_name = GameData.get_skill_name(skill_id)
            print(f"        - {skill_name} (ID: {skill_id})")
    
    if pet.evs:
        print(f"      EVs: {pet.evs}")
    if pet.effects:
        print(f"      Effects: {len(pet.effects)} active")