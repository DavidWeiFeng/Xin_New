from proxy.utils.byte_buffer import ByteBuffer
from proxy.utils.game_data import GameData

class PetSkillInfo:
    def __init__(self, buffer: ByteBuffer = None):
        self.id = 0
        self.pp = 0
        
        if buffer and buffer.available() >= 8:
            self.id = buffer.read_uint32()
            self.pp = buffer.read_uint32()
    
    @property
    def name(self) -> str:
        return GameData.get_skill_name(self.id)
    
    def __str__(self) -> str:
        return f"{self.name} (PP: {self.pp})"

class AttackValue:

    def __init__(self, buffer: ByteBuffer = None):
        # 基本攻击信息
        self.user_id = 0
        self.skill_id = 0
        self.atk_times = 0
        self.lost_hp = 0
        self.gain_hp = 0
        self.remain_hp = 0
        self.max_hp = 0
        self.state = 0
        
        # 技能列表
        self.skills = []
        
        # 暴击标志
        self.is_crit = False
        
        # 状态数组 (20个状态效果)
        self.status = [0] * 20
        
        # 战斗等级数组 (6项能力变化)
        self.battle_lv = [0] * 6
        
        if buffer:
            self._parse_from_buffer(buffer)
    
    def _parse_from_buffer(self, buffer: ByteBuffer):
        """从字节缓冲区解析数据"""
        try:
            # 基本攻击信息 (8个字段)
            self.user_id = buffer.read_uint32()
            self.skill_id = buffer.read_uint32()
            self.atk_times = buffer.read_uint32()
            self.lost_hp = buffer.read_uint32()
            self.gain_hp = buffer.read_int32()  # 注意这是int32
            self.remain_hp = buffer.read_int32()  # 注意这是int32
            self.max_hp = buffer.read_uint32()
            self.state = buffer.read_uint32()
            
            # 技能列表数量和技能数据
            skill_count = buffer.read_uint32()
            self.skills = []
            for _ in range(skill_count):
                if buffer.available() >= 8:
                    skill = PetSkillInfo(buffer)
                    self.skills.append(skill)
                else:
                    break
            
            # 暴击标志
            if buffer.available() >= 4:
                crit_flag = buffer.read_uint32()
                self.is_crit = (crit_flag == 1)
            
            # 状态数组 (20个byte)
            for i in range(20):
                if buffer.available() >= 1:
                    self.status[i] = buffer.read_uint8()
                else:
                    break
            
            # 战斗等级数组 (6个byte)
            for i in range(6):
                if buffer.available() >= 1:
                    self.battle_lv[i] = buffer.read_uint8()
                else:
                    break
                    
        except Exception as e:
            raise ValueError(f"Failed to parse AttackValue: {e}")
    
    @property
    def skill_name(self) -> str:
        """获取技能名称"""
        return GameData.get_skill_name(self.skill_id) if self.skill_id > 0 else "No Skill"
    
    @property
    def hp_percentage(self) -> float:
        """获取HP百分比"""
        return (self.remain_hp / self.max_hp * 100) if self.max_hp > 0 else 0
    
    @property
    def active_status_effects(self) -> list:
        """获取激活的状态效果"""
        effects = []
        for i, status in enumerate(self.status):
            if status != 0:
                effects.append(f"S{i}:{status}")
        return effects
    
    @property
    def stat_changes(self) -> list:
        """获取能力等级变化"""
        changes = []
        stat_names = ["ATK", "DEF", "S.ATK", "S.DEF", "SPD", "ACC"]
        
        for i, lv in enumerate(self.battle_lv):
            if lv != 0 and i < len(stat_names):
                sign = "+" if lv > 0 else ""
                changes.append(f"{stat_names[i]}:{sign}{lv}")
        
        return changes
    
    def display_info(self, indent: str = "") -> str:
        """格式化显示攻击信息"""
        lines = []
        
        # 基本信息
        lines.append(f"{indent}User ID: {self.user_id}")
        lines.append(f"{indent}Skill: {self.skill_name} (ID: {self.skill_id})")
        lines.append(f"{indent}Attack Times: {self.atk_times}")
        
        # HP变化信息
        if self.lost_hp > 0:
            lines.append(f"{indent}Damage: -{self.lost_hp} HP")
        if self.gain_hp > 0:
            lines.append(f"{indent}Heal: +{self.gain_hp} HP")
        elif self.gain_hp < 0:
            lines.append(f"{indent}Additional damage: {self.gain_hp} HP")
        
        lines.append(f"{indent}HP: {self.remain_hp}/{self.max_hp} ({self.hp_percentage:.1f}%)")
        
        # 暴击信息
        if self.is_crit:
            lines.append(f"{indent}>>> CRITICAL HIT! <<<")
        
        # 状态信息
        if self.state > 0:
            lines.append(f"{indent}State: {self.state}")
        
        # 技能列表（如果有更新）
        if self.skills:
            lines.append(f"{indent}Updated Skills ({len(self.skills)}):")
            for i, skill in enumerate(self.skills):
                lines.append(f"{indent}  {i+1}. {skill}")
        
        # 状态效果（非零的）
        status_effects = self.active_status_effects
        if status_effects:
            lines.append(f"{indent}Status Effects: {', '.join(status_effects)}")
        
        # 战斗等级变化（非零的）
        stat_changes = self.stat_changes
        if stat_changes:
            lines.append(f"{indent}Stat Changes: {', '.join(stat_changes)}")
        
        return '\n'.join(lines)
    
    def __str__(self) -> str:
        return f"AttackValue(user={self.user_id}, skill={self.skill_name}, hp={self.remain_hp}/{self.max_hp})"

class UseSkillInfo:

    def __init__(self, buffer: ByteBuffer = None):
        self.first_attack = None
        self.second_attack = None
        
        if buffer:
            self._parse_from_buffer(buffer)
    
    def _parse_from_buffer(self, buffer: ByteBuffer):
        """从字节缓冲区解析数据"""
        try:
            # 解析第一个攻击者信息
            self.first_attack = AttackValue(buffer)
            
            # 解析第二个攻击者信息
            self.second_attack = AttackValue(buffer)
            
        except Exception as e:
            raise ValueError(f"Failed to parse UseSkillInfo: {e}")
    
    def display_info(self, indent: str = "") -> str:
        """格式化显示技能使用信息"""
        lines = []
        
        if self.first_attack:
            lines.append(f"{indent}=== First Attacker ===")
            lines.append(self.first_attack.display_info(indent))
        
        if self.second_attack:
            lines.append(f"{indent}=== Second Attacker ===")
            lines.append(self.second_attack.display_info(indent))
        
        return '\n'.join(lines)
    
    def __str__(self) -> str:
        return f"UseSkillInfo(first={self.first_attack}, second={self.second_attack})"
