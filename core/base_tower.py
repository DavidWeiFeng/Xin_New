import time
import logging
from core.Identify import XinScript
from core.utils import *
from typing import Tuple
from config.config import *

class BaseTower:
    def __init__(self,name:str): 
        #--------------精灵配置区--------------#
        self.pet_name = name
        self.stop_flag = False
        self.default_skill=TOWER_CONFIG.get(name).get('default_skill')
        self.battle_count=TOWER_CONFIG.get(name).get('battle_count')
        self.floor=TOWER_CONFIG.get(name).get('floor')
        self.heal_points=TOWER_CONFIG.get(name).get('heal_points')
        self.special_monster=TOWER_CONFIG.get(name).get('special_monster')
        self.skill_config=TOWER_CONFIG.get(name).get('skill_config')
        #——------------辅助变量配置区--------------#
        self.first_time=True

    def on_captcha_handled(self):
        logging.info("勇者之塔：验证码已处理，重新开始战斗")
        click_region("怪物位置")
               
    def enter_tower(self)->bool:
        while not self.stop_flag:
            res, x, y = FindPic(*SEARCH_REGION,"勇者之塔.bmp", 0.8)
            if res != -1:
                logging.info("找到勇者之塔")
                click(454,128)
                logging.info("点击勇者之塔")
                return True

            
    
    def choose_floor(self,floor: str):
        while not self.stop_flag:
            res,x,y=find_color_in_region(384,180,565,216,"ff9900")
            if res != -1:
                random_sleep(0.1)
                click(603,343)
                random_sleep(0.3)
                break
        if self.stop_flag:
            return
        if "无双号41层橙毛" in self.pet_name:
        # if self.pet_name=="无双号41层橙毛":
            click(791,434)
        else:
            click(793,411)
        logging.info(f"进入{floor}")  
          
    def enter_battle(self,i: int, special_monster) -> bool:
        if self.stop_flag:
            return
        while not self.stop_flag:
            res, x, y = FindPic(*SEARCH_REGION, "塔内标志.bmp", 0.8)
            if res != -1:
                time.sleep(0.1)
                XinScript.enable_script()
                logging.info("点击怪物")
                click(411,309)
                time.sleep(0.3)
                return True
            
    def check_identifying(self) -> bool:
        return isIdentifying()
    
    def handle_identifying(self):
        logging.info("检测到人机验证")
        send_qq_mail("检测到勇者人机验证", "出现勇者之塔人机验证")
        while not self.stop_flag:
            if not isIdentifying():
                click_region("怪物位置")
                break
            
    def handle_rewards(self):
        pass
    
    def execute_battle(self,i) -> bool:
        skill_counter = 0
        still_fighting = True
        probably_use_more_skill = False
        exceed=False
        skill_not_enough=False
        # 获取当前层数的技能配置，如果没有则使用默认配置
        current_level_skill_config = self.skill_config.get(i, self.skill_config.get("default"))
        #--------------------战斗逻辑-------------------#
        while still_fighting and (not self.stop_flag):
            
            
            #这一层，第skill_counter回合，使用什么技能 
            skill_counter += 1
            skill = current_level_skill_config.get(skill_counter, self.default_skill)
            if skill_counter in current_level_skill_config:
                skill = current_level_skill_config[skill_counter]
                logging.info(f"第{i+1}层第{skill_counter}次释放技能: {current_level_skill_config.get(skill_counter)}")
            else:
                skill = self.default_skill
                probably_use_more_skill = True
            while not self.stop_flag:
                
                if isFightEnd():
                    still_fighting = False
                    random_sleep(0.1)
                    handlePostFightClicks()
                    break
                
                if can_use_skill():
                    if probably_use_more_skill:
                        exceed=True
                    skill_graycolor_pos={"一技能":(537,471),"二技能":(654,471)}
                    for key,val in skill_graycolor_pos.items():
                        if is_color_at_point(val[0],val[1],"a7a7a7"):
                            logging.info(f"{key}技能已用完，无法释放，改用默认技能")
                            skill="一技能" if key=="二技能" else "二技能"
                            skill_not_enough=True
                            break
                    click(REGION_CONFIG[skill][0],REGION_CONFIG[skill][1])
                    time.sleep(0.5)
                    if skill == "精灵":
                        budao()
                    break
                if self.stop_flag:
                    return
        #-------------------------战斗结束-------------------------#
        # 战斗后治疗逻辑
        if i in self.heal_points:
            if self.pet_name=="补刀橙毛":
                towerheal(True)
            else:
                towerheal()
                skill_not_enough=False
        if exceed and i == 8 and self.pet_name == "特攻性格橙毛":
            towerheal()
            return True
        elif exceed and i == 6 and self.pet_name == "普通性格橙毛":
            towerheal()
            return True
        elif skill_not_enough:
            towerheal()
            skill_not_enough=False
        return True
    
    def handle_failed_battle(self):
        pass
    
    def leave_tower(self):
        click(791,475)
        logging.info("离开勇者之塔")
        towerheal()
        while not self.stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,"勇者之塔.bmp",0.8)
            if res!=-1:
                break
    def stop(self):
        self.stop_flag = True
        set_global_stop_flag(True)
    def run(self):
        # activate_window()
        time.sleep(0.2)
        while not self.stop_flag:
            if self.enter_tower():
                self.first_time=False
                self.choose_floor(self.floor)
            for i in range(self.battle_count):
                if self.stop_flag:
                    return
                if not self.enter_battle(i,self.special_monster):
                    continue
                if isIdentifying():
                    self.handle_identifying()
                if self.stop_flag:
                    return
                success = self.execute_battle(i)
                if not success:
                    self.handle_failed_battle()
                    break
            if self.stop_flag:
                return
            self.leave_tower()


class TrialTower():
    def __init__(self):
        self.enemy_pos=(483,288)
        self.stop_flag = False

    def enter_tower(self):
        time.sleep(0.5)
        click(620,410)
        while not self.stop_flag:
            if is_color_at_point(459,387,"666666"):
                time.sleep(0.3)
                break
        click(611,332)
        time.sleep(0.3)
        click(783,291)

    def enter_battle(self) -> bool:
        while not self.stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,"试炼之塔内部.bmp",0.8)
            if res != -1:
                time.sleep(0.1)
                logging.info("点击怪物")
                XinScript.enable_script()
                click(self.enemy_pos[0],self.enemy_pos[1])
                time.sleep(0.5)
                break
    def handle_identifying(self):
        while not self.stop_flag:
            if not isIdentifying():
                break
            else:
                time.sleep(2.5)
                random_click(327,288)
        time.sleep(0.3)
        click(self.enemy_pos[0],self.enemy_pos[1])

    def run(self):
        while not self.stop_flag:
            self.enter_tower()
            for _ in range(10):
                self.enter_battle()
                if isIdentifying():
                    self.handle_identifying()
                while not self.stop_flag:
                    if isFightEnd():
                        random_sleep(0.1)
                        handlePostFightClicks()
                        break
                    if can_use_skill():
                        click(REGION_CONFIG["一技能"][0],REGION_CONFIG["一技能"][1])
                        time.sleep(0.5)
            time.sleep(0.3)
            click(720,426)#离开
            while not self.stop_flag:
                if find_color_in_region(570,221,663,332,"66ddff"):
                    time.sleep(0.5)
                    break
            heal()
                

    def stop(self):
        self.stop_flag = True
        set_global_stop_flag(True)