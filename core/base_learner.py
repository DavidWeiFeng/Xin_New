import time
import logging
from dataclasses import dataclass
from typing import Tuple, Optional

from core.utils import *
from config.config import *
from core.ogre_manager import OgreManager

@dataclass
class LearnerConfig:
    target_pet_name: str
    skill_name: str
    hp_recovery_freq: int
    catch_rare: bool = False

class BaseLearner:
    def __init__(self, config: LearnerConfig):
        self.config = config
        self.stop_flag = False
        self.fight_count = 0
        self.previous_slot_id = -1
        self.max_wait_time = 11
        
        # 加载配置：优先 LEARNING_CONFIG，其次 SHINY_CONFIG
        self.pokemon_config = LEARNING_CONFIG.get(config.target_pet_name)
        if not self.pokemon_config:
            self.pokemon_config = SHINY_CONFIG.get(config.target_pet_name, {})
            
        self.map_id = self.pokemon_config.get("map_id", 0)
        self.rare_pet = self.pokemon_config.get("rare_pet")
        

    def _wait_for_fight_start(self):
        """等待战斗开始"""
        start_wait = time.time()
        while not self.stop_flag:
            if can_use_skill():
                return True
            if time.time() - start_wait > self.max_wait_time:
                logging.info("等待进入战斗超时")
                error_handle()
                return False
            time.sleep(0.5)
        return False

    def check_protocol_shiny_rare(self):
        """检查并捕捉异色或稀有精灵"""
        target_coords = None
        is_rare = False
        pet_name = None
        slot_index = -1
        # 1. 检查异色
        shiny_target = OgreManager().get_shiny_target()
        if shiny_target:
            x, y, shiny_pet_name, slot_index = shiny_target  # 异色：(x, y, pet_name, slot_index)
            target_coords = (x, y)
            pet_name = shiny_pet_name
            logging.info(f"检测到异色精灵：{shiny_pet_name}！")
        
        # 2. 检查稀有 (如果没有异色)
        elif self.config.catch_rare and not target_coords:
            for rare in self.rare_pet:
                pet_name = rare
                rare_target = OgreManager().get_target_by_name(rare)
                if rare_target:
                    break

            if rare_target:
                slot_idx, x, y = rare_target  # 稀有：(slot_idx, x, y)
                target_coords = (x, y)
                
                is_rare = True
                logging.info(f"检测到稀有精灵：{pet_name}！")

        if not target_coords:
            return False

        # 执行捕捉流程
        # with OgreManager().fighting_context():
        x, y = target_coords
        if self.stop_flag: return False
        
        if self.previous_slot_id == slot_index:
            logging.info("与上次点击的坐标相同")
            x1, y1 = OgreManager().get_first_empty_slot_pos()  # 获取一个空槽位坐标
            protocol_click(x1, y1)  # 点击刷新
            time.sleep(0.5)  #
        # 点击进入战斗
        for _ in range(3):
            protocol_click(x, y)
            time.sleep(0.2)
        move_region("确定")
        
        self.previous_slot_id = slot_index  # 更新排除的槽位
        if not self._wait_for_fight_start():
            return False
        
        # 如果是异色且配置了击杀，且不是稀有精灵
        if pet_name != self.config.target_pet_name and not is_rare:
            logging.info(f"大形态异色：{pet_name},准备击杀")
            keep_use_fly_skill()
            return True
        
        success = switch_boker()
        if success:
            catch_shiny(True, is_rare)
        else:
            catch_shiny(False, is_rare)

        send_qq_mail(f"{'稀有' if is_rare else '异色'}精灵 {pet_name} 捕捉成功！", "快去背包查看吧")


        return True

    def _perform_capture_logic(self, pet_name, is_rare_check=False):

        # 如果是异色且配置了击杀，且不是稀有精灵
        if pet_name != self.config.target_pet_name and not is_rare_check and pet_name !="基摩" and pet_name !="乔乔":
            logging.info(f"大形态异色：{pet_name},准备击杀")
            keep_use_fly_skill()
            return True
        
        success = switch_boker()
        if success:
            catch_shiny(True, is_rare_check)
        else:
            catch_shiny(False, is_rare_check)
        
        send_qq_mail(f"暗雷{pet_name}捕捉成功！", "快去背包查看吧")
        return True

    def handle_learning_fight(self, pet_name):
        """正常的刷学习力战斗流程"""
        if not self._wait_for_fight_start():
            return

        time.sleep(0.5)
        # 1. 检查是否有红字（暗雷异色标志）
        if has_red_word():
            # logging.info(f"检测到红字！{self.config.target_pet_name} 可能是暗雷异色")
            return self._perform_capture_logic(pet_name, is_rare_check=False)

        if isNier():
            return True
        # 战斗循环
        while not self.stop_flag:
            if can_use_skill():
                click_region(self.config.skill_name)
                time.sleep(0.5)
            
            if isFightEnd():
                handlePostFightClicks()
                self.fight_count += 1
                logging.info(f"战斗次数：{self.fight_count}")
                error_handle()
                break
        
        # 回血逻辑
        if self.fight_count >= self.config.hp_recovery_freq:
            OgreManager().set_fighting_state(False)
            heal()
            self.fight_count = 0

    def run(self):
        res,x,y=FindPic(881,501,931,544,"声音.bmp",0.85)
        if res!=-1:
            logging.info("淦！！！你为什么不把游戏静音")
            click(898,527)
            
        OgreManager().clear_current_slots()
        OgreManager().set_current_map(self.map_id)

        while not self.stop_flag:
            if OgreManager().wait_for_update(timeout=10):
                
                # 1. 优先检查异色/稀有
                if self.check_protocol_shiny_rare():
                    OgreManager().clear_current_slots()
                    continue
                
                # 2. 查找目标怪物
                target_slot = OgreManager().get_random_valid_slot(
                    priority_name=self.config.target_pet_name,
                    exclude_id=self.previous_slot_id,
                )
                
                if target_slot:
                    self.previous_slot_id =target_slot[0]
                    pet_name = target_slot[3]
                    logging.info(f"点击精灵 {pet_name}")
                    # with OgreManager().fighting_context():
                    OgreManager().clear_current_slots()
                    protocol_click(target_slot[1], target_slot[2])
                    self.handle_learning_fight(pet_name)
                else:
                    pass
                    # 这里不需要 not_found_hook 了，因为 get_random_valid_slot 已经有了保底随机点击逻辑
            
    def stop(self):
        self.stop_flag = True
        set_global_stop_flag(True)