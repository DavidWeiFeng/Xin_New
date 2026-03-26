from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.utils.game_data import GameData
from proxy.entities.attack_value import UseSkillInfo
from proxy.config import Direction
from proxy.events.battle_events import emit_battle_event, BattleEvents

def handle_use_skill(packet: Packet, direction: Direction):
    """
    处理技能使用相关命令
    根据前端 ActionScript 代码分析的真实数据结构
    
    CMD 2405 (USE_SKILL):
    Client -> Server: 使用技能请求
    - skillID: 技能ID (uint32)
    
    CMD 2505 (NOTE_USE_SKILL):  
    Server -> Client: 技能使用结果通知
    - UseSkillInfo: 包含双方攻击信息
      - firstAttackInfo: AttackValue - 第一个攻击者信息
      - secondAttackInfo: AttackValue - 第二个攻击者信息
    """
    buffer = ByteBuffer(packet.body)
    
    if direction == Direction.CLIENT_TO_SERVER:
        # 客户端请求包 - 技能ID
        if buffer.available() >= 4:
            skill_id = buffer.read_uint32()
            skill_name = GameData.get_skill_name(skill_id)
            
            
        elif buffer.available() > 0:
            print(f"   [Request] Use Skill (Incomplete: {buffer.available()} bytes)")
            Protocol.hex_dump(packet.body)
        else:
            print(f"   [Request] Use Skill (Empty - possibly escape/forfeit)")
            
    elif direction == Direction.SERVER_TO_CLIENT:
        # 服务器响应包 - UseSkillInfo (通过CMD 2505发送)
        try:
            # 检查数据长度，但允许较短的响应
            if buffer.available() == 0:
                print(f"   [Response] Empty skill result (possibly no effect)")
                return
            elif buffer.available() < 32:  # 如果数据太短，显示原始数据
                print(f"   [Response] Short skill result ({buffer.available()} bytes):")
                Protocol.hex_dump(packet.body)
                return
                            
            # 使用UseSkillInfo解析完整的技能使用信息
            use_skill_info = UseSkillInfo(buffer)  
            # 只发布核心的精灵状态更新事件
            if use_skill_info.first_attack:
                _emit_pet_update(use_skill_info.first_attack)
                
            if use_skill_info.second_attack:
                _emit_pet_update(use_skill_info.second_attack)
            
            # 检查是否还有剩余数据
            if buffer.available() > 0:
                print(f"   [Info] {buffer.available()} bytes remaining in packet")
                
        except Exception as e:
            print(f"   [Error] Failed to parse Use Skill result: {e}")
            print(f"   [Debug] Packet length: {len(packet.body)} bytes")

def _emit_pet_update(attack_info):
    """发布精灵状态更新事件 - 通过技能匹配精灵"""
    emit_battle_event(BattleEvents.PET_UPDATED,
        remain_hp=attack_info.remain_hp,
        skills=attack_info.skills
    )
