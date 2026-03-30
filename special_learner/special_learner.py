import string
from core.base_learner import *
import time
import logging
from core.utils import *
from typing import Tuple
from config.config import *

class singleTypeLearner(BaseLearner):
    def __init__(self, config: LearnerConfig):
        super().__init__(config)
        # self.normal_pet = None # 新版 BaseLearner 已经不依赖这个属性了

class schoolLearner:
    def __init__(self, config: LearnerConfig):
        self.skill = config.skill_name
        self.hp_recovery_frequency = config.hp_recovery_freq
        self.fight_count=0
        self.stop_flag = False
        
    def run(self):
        while not self.stop_flag:
            click(479,176)
            #等待战斗开始
            time.sleep(0.3)
            if isIdentifying():
                while not self.stop_flag:
                    if not isIdentifying():
                        logging.info("验证码已处理，重新开始战斗")
                        time.sleep(0.3)
                        click(440,123)
                        break
                    else:
                        time.sleep(1.5)
                        random_click(313,291)
            while not self.stop_flag:
                if isFightStart():
                    break
            while not self.stop_flag:
                    if can_use_skill():
                        click_region(self.skill)
                    if isFightEnd():
                        handlePostFightClicks()
                        self.fight_count+=1
                        logging.info(f"战斗次数：{self.fight_count}")
                        time.sleep(1.1)   
                        break                
            if self.fight_count == self.hp_recovery_frequency:
                click(338,356)
                time.sleep(0.15)
                while not stop_flag:
                    res,x,y=FindPic(*SEARCH_REGION,"防御.bmp",0.8)
                    if x!=-1 and y!=-1:
                        break
                    else:
                        click(338,356)
                        logging.info("再次点击精灵标志")
                        time.sleep(1)
                while not stop_flag:        
                    res,x,y=FindPic(*SEARCH_REGION,"治疗图标.bmp",0.8)
                    if x!=-1 and y!=-1:
                        click(x,y)
                        logging.info("点击治疗")
                        time.sleep(0.15)
                        while not stop_flag:
                            if is_color_at_point(585,361,"ffffff",0.1):
                                break
                            else:
                                click(x,y)
                                time.sleep(0.15)
                    break
                while not stop_flag:
                    if is_color_at_point(585,361,"ffffff",0.1):
                        logging.info("点击确认")
                        click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                        time.sleep(0.15)
                    else:
                        break        
 
                while not stop_flag:
                    res,x,y=FindPic(*SEARCH_REGION,"恢复返回.bmp",0.8)
                    if res!=-1:
                        click(x,y)
                        logging.info("点击返回")
                        time.sleep(0.3)
                        fast_move(0,0)
                    else:
                        break
                self.fight_count = 0
    
    def stop(self):
        self.stop_flag = True