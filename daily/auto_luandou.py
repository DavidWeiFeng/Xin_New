from core.utils import *
from config.config import REGION_CONFIG
import time
import logging


class LuandouBot:
    def __init__(self):
        self.stop_flag = False
        self.switch_pet_num=0

    def start_luandou(self):
        while not self.stop_flag:
            if self.stop_flag:
                return
            res, x, y = FindPic(*SEARCH_REGION, "太空站.bmp", 0.8,True)
            if res != -1:
                click(219,231)
                break
        while not self.stop_flag:
            if self.stop_flag:
                return
            res, x, y = FindPic(*SEARCH_REGION, "对战规则.bmp", 0.8)
            if res != -1:
                click(485,384)
                break
        logging.info("开始大乱斗")

    def success_enter_fight(self):
        return isFightStart()

    def find_first_available_skill(self,regions, forbid_pic, sim):      
        for idx, (x1, y1, x2, y2) in enumerate(regions):
            res, x, y = FindPic(x1, y1, x2, y2, forbid_pic, sim)
            if res == -1:
                return idx  # 找不到表示可以释放
        return 0  # 四个技能都被禁止释放
        
    def use_skill(self):
        skill_regions  = [
            REGION_CONFIG["图标一"],
            REGION_CONFIG["图标二"],
            REGION_CONFIG["图标三"],
            REGION_CONFIG["图标四"]
        ]
        skill_index = self.find_first_available_skill(skill_regions, "属性技能.bmp", 0.75)
        if skill_index is not None:
            logging.info(f"释放{skill_index + 1}技能")
            if skill_index==0:
                click_region("一技能")
            if skill_index==1:
                click_region("二技能")
            if skill_index==2:
                click_region("三技能")
            if skill_index==3:
                click_region("四技能")
            fast_move(0,0)                                            
        else:
            logging.info("没有可释放的技能")

        
    def pet_was_kill(self):
        res, x, y = FindPic(*SEARCH_REGION, "灰色出战.bmp",0.8)
        res2=can_use_skill()
        time.sleep(0.5)
        if res!=-1:
            return True
        elif res2:
            return False
        else:
            return None

    def run(self):
        # activate_window()
        time.sleep(0.2)
        while not self.stop_flag:
            if self.stop_flag:
                return
            auto_cancel()
            self.start_luandou()
            while not self.stop_flag:
                if self.success_enter_fight():
                    logging.info("成功进入战斗")
                    break  # 根据逻辑添加 break 或其他操作
                
            #----------战斗状态------------#
            while not self.stop_flag:
                if self.stop_flag:
                    return
                if isFightEnd():
                    logging.info("战斗结束")
                    handlePostFightClicks()
                    self.switch_pet_num=0
                    break
                if self.stop_flag:
                    return
                res=self.pet_was_kill()
                if res is None:
                    continue
                if not res:
                    self.use_skill()
                else:
                    self.switch_pet_num+=1
                    if self.switch_pet_num==1:
                        click(508,446)
                    else:
                        click(545,447)
                    while not self.stop_flag:
                        res,x,y=FindPic(*SEARCH_REGION,"蓝色出战.bmp",0.8)
                        if res!=-1:
                            time.sleep(0.3)
                            click_region("出战")    
                            time.sleep(1)
                            break
    def stop(self):
        self.stop_flag = True
        set_global_stop_flag(True)
