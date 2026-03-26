from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.entities.user_info import UserInfo
from proxy.entities.pet_info import PetInfo
from proxy.utils.game_data import GameData
from proxy.config import Direction
from proxy.events.battle_events import emit_battle_event, BattleEvents

# 全局变量存储用户输入的米米号
user_mimi_id = None

def set_user_mimi_id(mimi_id):
    """设置用户的米米号"""
    global user_mimi_id
    user_mimi_id = mimi_id
    print(f"[Handler] 用户米米号设置为: {mimi_id}")

def get_user_mimi_id():
    """获取用户的米米号"""
    return user_mimi_id

def handle_fight_ready(packet: Packet, direction: Direction):
    """
    处理 CMD 2503 (Note Ready To Fight)
    包含双方玩家信息及精灵详情
    """
    buffer = ByteBuffer(packet.body)
    
    if direction == Direction.SERVER_TO_CLIENT:
        try:
            if buffer.available() < 4:
                print(f"   [Error] Body too short for Mode")
                return

            # 1. Mode
            mode = buffer.read_uint32()
            
            # 收集对手精灵信息
            opponent_pets = []
            my_pets = []

            # 2. Loop 2 Players
            for i in range(2):
                if buffer.available() < 24: # ID(4) + Nick(16) + PetCount(4)
                    print("   [Error] Truncated Player Info")
                    break
                    
                # --- 解析玩家信息 ---
                user = UserInfo.parse(buffer)
                pet_count = buffer.read_uint32()
                
                player_pets = []
                
                # --- 解析精灵列表 ---
                for p_idx in range(pet_count):
                    if buffer.available() < PetInfo.BYTE_SIZE_SIMPLE:
                        print("   [Error] Truncated Pet Info")
                        break

                    pet = PetInfo.parse_simple(buffer)
                    pet_name = GameData.get_pet_name(pet.id)
                    
                    pet_data = {
                        'user_id': user.uid,
                        'pet_index': p_idx,
                        'pet_name': pet_name,
                        'level': pet.level,
                        'remain_hp': pet.hp,
                        'max_hp': pet.max_hp,
                        'skills': pet.skills,
                        'player_name': user.nick_name,
                        'shiny': pet.shiny
                    }
                    
                    player_pets.append(pet_data)
                
                # 判断是敌人还是自己
                if user_mimi_id:
                    # 有设置米米号，基于米米号判断
                    if user.uid != user_mimi_id:
                        # 对手
                        opponent_pets = player_pets
                        opponent_name = user.nick_name
                        opponent_uid = user.uid
                    else:
                        # 自己
                        my_pets = player_pets
                        my_name = user.nick_name
                        my_uid = user.uid
                else:
                    # 没有设置米米号，默认第二个玩家（i=1）为对手
                    if i == 1:
                        # 对手
                        opponent_pets = player_pets
                        opponent_name = user.nick_name
                        opponent_uid = user.uid
                    else:
                        # 自己
                        my_pets = player_pets
                        my_name = user.nick_name
                        my_uid = user.uid
            
            # 打印信息
            print(f"   [Fight Ready] Mode: {mode}")
                            
            if opponent_pets:
                print(f"   [Opponent] {opponent_name} (UID: {opponent_uid})")
                print(f"异色：真" if opponent_pets[0]['shiny'] else "异色：假")
                for pet in opponent_pets:
                    skills_text = f" | Skills: {', '.join([f'{skill.name}(PP:{skill.pp})' for skill in pet['skills']])}" if pet['skills'] else ""
                    print(f"      • {pet['pet_name']} Lv.{pet['level']} HP:{pet['remain_hp']}/{pet['max_hp']}{skills_text}")
            
            # 只发布对手精灵信息到GUI
            if opponent_pets:
                emit_battle_event(BattleEvents.PETS_LOADED, pets=opponent_pets)

        except Exception as e:
            print(f"   [Error] Failed to unpack Fight Ready: {e}")
    
    else:
        # 客户端请求包
        print(f"   [Request] Fight Ready Request")
        if buffer.available() > 0:
            Protocol.hex_dump(packet.body)
