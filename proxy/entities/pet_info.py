from dataclasses import dataclass
from typing import List, Optional
from proxy.utils.byte_buffer import ByteBuffer
from proxy.utils.game_data import GameData
@dataclass
class PetSkillInfo:
    id: int
    pp: int

    @property
    def name(self) -> str:
        return GameData.get_skill_name(self.id)

@dataclass
class PetEffectInfo:
    item_id: int
    status: int
    left_count: int
    effect_id: int
    args: str
    
    @property
    def item_name(self) -> str:
        return GameData.get_item_name(self.item_id)

    @classmethod
    def parse(cls, buffer: ByteBuffer) -> 'PetEffectInfo':
        item_id = buffer.read_uint32()
        status = buffer.read_uint8()
        left_count = buffer.read_uint8()
        effect_id = buffer.read_uint16()
        
        arg1 = buffer.read_uint8()
        buffer.read_uint8() # skip
        arg2 = buffer.read_uint8()
        
        args = f"{arg1} {arg2}" if arg2 != 0 else str(arg1)
        
        buffer.read_bytes(13) # skip 13 bytes
        
        return cls(item_id, status, left_count, effect_id, args)

@dataclass
class PetInfo:
    id: int
    level: int
    hp: int
    max_hp: int
    skills: List[PetSkillInfo]
    catch_time: int
    skin_id: int
    shiny: int
    is_boss: bool
    
    # Full Info Fields (Optional, filled only by parse_full)
    name: Optional[str] = None
    dv: Optional[int] = None
    nature: Optional[int] = None
    evs: Optional[List[int]] = None
    effects: Optional[List[PetEffectInfo]] = None

    # 常量定义
    BYTE_SIZE_SIMPLE = 84

    @classmethod
    def parse_simple(cls, buffer: ByteBuffer) -> 'PetInfo':
        """
        解析简化版精灵信息 (84 bytes)
        用于 CMD 2503 等协议
        """
        # 基础属性 (20 bytes)
        p_id = buffer.read_uint32()
        p_lv = buffer.read_uint32()
        p_hp = buffer.read_uint32()
        p_max_hp = buffer.read_uint32()
        _skill_num = buffer.read_uint32() # 暂时不用
        
        # 技能列表 (32 bytes)
        skills = []
        for _ in range(4):
            s_id = buffer.read_uint32()
            s_pp = buffer.read_uint32()
            if s_id != 0:
                skills.append(PetSkillInfo(s_id, s_pp))
            
        # 杂项属性 (32 bytes)
        catch_time = buffer.read_uint32()
        _catch_map = buffer.read_uint32()
        _catch_rect = buffer.read_uint32()
        _catch_level = buffer.read_uint32()
        skin_id = buffer.read_uint32()
        shiny = buffer.read_uint32()
        _free_forbidden = buffer.read_uint32()
        is_boss = bool(buffer.read_uint32())
        
        return cls(
            id=p_id,
            level=p_lv,
            hp=p_hp,
            max_hp=p_max_hp,
            skills=skills,
            catch_time=catch_time,
            skin_id=skin_id,
            shiny=shiny,
            is_boss=is_boss
        )

    @classmethod
    def parse_full(cls, buffer: ByteBuffer) -> 'PetInfo':
        """
        解析完整版精灵信息 (CMD 2301)
        """
        p_id = buffer.read_uint32()
        name = buffer.read_string(16)
        dv = buffer.read_uint32()
        nature = buffer.read_uint32()
        
        level = buffer.read_uint32()
        exp = buffer.read_uint32()
        lv_exp = buffer.read_uint32()
        next_lv_exp = buffer.read_uint32()
        
        hp = buffer.read_uint32()
        max_hp = buffer.read_uint32()
        
        attack = buffer.read_uint32()
        defence = buffer.read_uint32()
        sa = buffer.read_uint32()
        sd = buffer.read_uint32()
        speed = buffer.read_uint32()
        
        # Add values (Skipping detailed assignment for brevity, but reading them)
        buffer.read_bytes(28) # 7 * 4 bytes (AddMaxHP...AddSpeed)
        
        # EVs
        evs = []
        for _ in range(6):
            evs.append(buffer.read_uint32())
            
        # Skills
        skill_num = buffer.read_uint32()
        skills = []
        for _ in range(4):
            s_id = buffer.read_uint32()
            s_pp = buffer.read_uint32()
            if s_id != 0:
                skills.append(PetSkillInfo(s_id, s_pp))
        
        # Catch Info
        catch_time = buffer.read_uint32()
        catch_map = buffer.read_uint32()
        catch_rect = buffer.read_uint32()
        catch_level = buffer.read_uint32()
        
        # Effects
        effect_count = buffer.read_uint16()
        effects = []
        for _ in range(effect_count):
            effects.append(PetEffectInfo.parse(buffer))
        
        pet_effect = buffer.read_uint32()
        
        # Misc
        skin_id = buffer.read_uint32()
        shiny = buffer.read_uint32()
        free_forbidden = buffer.read_uint32()
        is_boss = bool(buffer.read_uint32())

        return cls(
            id=p_id,
            level=level,
            hp=hp,
            max_hp=max_hp,
            skills=skills,
            catch_time=catch_time,
            skin_id=skin_id,
            shiny=shiny,
            is_boss=is_boss,
            name=name,
            dv=dv,
            nature=nature,
            evs=evs,
            effects=effects
        )

    def __str__(self):
        extras = []
        if self.shiny: extras.append(f"Shiny({self.shiny})")
        if self.skin_id: extras.append(f"Skin({self.skin_id})")
        if self.is_boss: extras.append("Boss")
        
        # 如果 full_info 的 name 为空，则从 GameData 获取默认名
        display_name = self.name.strip() if self.name and self.name.strip() else GameData.get_pet_name(self.id)
        
        name_str = f"名称: {display_name} "
        dv_str = f"DV: {self.dv} " if self.dv is not None else ""
        
        extra_str = f" | {', '.join(extras)}" if extras else ""
        skill_str = ", ".join([f"{s.name}({s.id}, PP:{s.pp})" for s in self.skills])
        
        return (f"{name_str}ID: {self.id} | Lv: {self.level} | {dv_str}HP: {self.hp}/{self.max_hp}\n"
                f"      技能: {skill_str}{extra_str}")
