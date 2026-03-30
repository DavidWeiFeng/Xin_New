from core.utils import *
from config.config import *

class killBoss:
    
    def __init__(self,boss_name) -> None:
        self.stop_flag=False
        self.boss_name=boss_name
        self.boss_position=.get(boss_name,[-1,-1])

    def stop(self):
        self.stop_flag=True
        set_global_stop_flag(True)
        
    def on_captcha_handled(self):
        pass
        
    def run(self):
        # activate_window()
        time.sleep(0.2)
        count=0
        while not self.stop_flag:
            click(self.boss_position[0],self.boss_position[1]) #点击boss位置
            time.sleep(0.3)
            if isIdentifying():
                send_qq_mail("赛维尔人机验证","1")
                while not stop_flag:
                    if not isIdentifying():
                        click(637,213)
                        break
            if is_color_at_point(614,350,"ffffff"):
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                time.sleep(0.5)
                click(459,207)
                
            time.sleep(0.35)
            #进入战斗
            fightend=False
            while not self.stop_flag and not fightend:
                if can_use_skill():
                    click(REGION_CONFIG["一技能"][0],REGION_CONFIG["一技能"][1])
                    count+=1  
                    logging.info(f"瞬杀次数:{count}")
                    time.sleep(1)
                if isFightLose():
                    time.sleep(0.35)
                    click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                    heal()
                    time.sleep(0.6)
                    break
                if isFightWin():
                    logging.info(f"秒杀成功,尝试{count}次")
                    send_qq_mail("BOSS秒杀成功",f"尝试{count}次")
                    return
                    
                    
              