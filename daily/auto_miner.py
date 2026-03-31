from core.utils import *
from config.config import *

class Miner:
    def __init__(self):
       self.stop_flag=False
       
                   
    def miner(self,planet_name):
        miner_num=-1
        count=0
        while  not self.stop_flag:
            click_region(planet_name+"矿物")
            logging.info(f"开始挖掘{planet_name}")
            while not self.stop_flag:
                res,x,y=FindPic(*SEARCH_REGION,"再来.bmp",0.80)
                #--------异常情况-----------------#
                if res!=-1:
                    time.sleep(0.25)
                    logging.info("已经挖过了")
                    random_click(466,375)
                    time.sleep(0.25)
                    logging.info(f"{planet_name}挖矿完毕")
                    return
                res,x,y=FindPic(*SEARCH_REGION,"已经.bmp",0.80)
                if res!=-1:
                    time.sleep(0.25)
                    logging.info("已经挖过了")
                    random_click(466,375)
                    time.sleep(0.25)
                    logging.info(f"{planet_name}挖矿完毕")
                    return
                #---------------------
                res,x,y=FindPic(*SEARCH_REGION,"探测.bmp",0.80)
                if res!=-1:
                    time.sleep(0.25)
                    click(408,376)#挖矿确认键
                    logging.info("确认挖矿")
                    time.sleep(0.25)
                    break
            #等待挖矿结束
            while not self.stop_flag:
                res,x,y=FindPic(*SEARCH_REGION,"能量石.bmp",0.80)
                if res!=-1:
                    click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                    time.sleep(0.4)
                res,x,y=find_color_in_region(300,217,677,421,"ff0000")
                if res!=-1:
                    time.sleep(0.5)
                    res,x,y=FindPic(*SEARCH_REGION,"能量石.bmp",0.80)
                    if res!=-1:
                        time.sleep(0.4)
                        click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                    time.sleep(0.5)
                    click_region("挖矿完毕确认")
                    count+=1
                    logging.info(f"第{count}次挖矿完毕")
                    time.sleep(0.3)
                    break
        logging.info(f"{planet_name}挖矿完毕")
        
    def click_until_enter(self,plant_name):
        while not self.stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,plant_name+"图标.bmp",0.7)
            if res!=-1:
                logging.info(f"找到{plant_name}")
                time.sleep(0.3)
                click(x,y)
                time.sleep(1)
            res2,x2,y2=FindPic(*SEARCH_REGION,plant_name+"一层.bmp",0.80)
            if res2 !=-1:
                logging.info(f"成功进入{plant_name}")
                time.sleep(0.5)
                return
                
    def wait_until_arrive(self,plant_name):
        while not self.stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,plant_name+".bmp",0.80)
            if res!=-1:
                logging.info(f"到达{plant_name}")
                return    
    def run(self):
        time.sleep(0.2)             
        self.miner("斯科尔星一层")
        if  self.stop_flag:
            return
        click_region("地图")
        if  self.stop_flag:
            return
        time.sleep(0.4)
        click(786,176)#返回
        time.sleep(1)
        click(197,203)#帕诺星系
        time.sleep(1)
 #------------露希欧星--------------#
        if  self.stop_flag:
            return
        self.click_until_enter("露希欧星")
        if  self.stop_flag:
            return
        time.sleep(0.5)
        self.miner("露希欧星一层1")
        if  self.stop_flag:
            return
        time.sleep(0.5)
        self.miner("露希欧星一层2")
        if  self.stop_flag:
            return
        time.sleep(0.5)
        self.miner("露希欧星一层3")
        if  self.stop_flag:
            return
        time.sleep(0.5)
        #------------贝塔星--------------#
        click_region("地图")
        if  self.stop_flag:
            return
        self.click_until_enter("贝塔星")
        if  self.stop_flag:
            return
        click_region("贝塔星二层")
        if  self.stop_flag:
            return
        self.wait_until_arrive("贝塔星二层")
        if  self.stop_flag:
            return
        self.miner("贝塔星二层")
        if  self.stop_flag:
            return
       #------------阿尔法星--------------#
        click_region("地图")
        if  self.stop_flag:
            return
        self.click_until_enter("阿尔法星")
        if  self.stop_flag:
            return
        self.wait_until_arrive("阿尔法星一层")
        if  self.stop_flag:
            return
        self.miner("阿尔法星一层")
        if  self.stop_flag:
            return
        click_region("阿尔法星二层")
        if  self.stop_flag:
            return
        self.wait_until_arrive("阿尔法星二层")
        if  self.stop_flag:
            return
        self.miner("阿尔法星二层1")
        if  self.stop_flag:
            return
        self.miner("阿尔法星二层2")
        if  self.stop_flag:
            return
        logging.info("挖矿完成")
        #------------海洋星--------------#
        click_region("地图")
        time.sleep(1)
        for _ in range(4):
            random_click(70,305)
            time.sleep(0.2)
        self.click_until_enter("海洋星")
        if  self.stop_flag:
            return
        self.miner("海洋星一层")
        if  self.stop_flag:
            return
        click_region("海洋星二层")
        if  self.stop_flag:
            return
        self.wait_until_arrive("海洋星二层")
        if  self.stop_flag:
            return
        self.miner("海洋星二层")
        
        #------------克洛斯星--------------#
        click_region("地图")
        if  self.stop_flag:
            return
        self.click_until_enter("克洛斯星")
        if  self.stop_flag:
            return
        self.miner("克洛斯星一层")
        if  self.stop_flag:
            return    
        #------------火山星--------------#
        click_region("地图")
        self.click_until_enter("火山星")
        if  self.stop_flag:
            return
        self.miner("火山星一层")
        if  self.stop_flag:
            return
        click_region("火山星二层")
        if  self.stop_flag:
            return
        self.wait_until_arrive("火山星二层")
        if  self.stop_flag:
            return
        self.miner("火山星二层")
        if  self.stop_flag:
            return
        click_region("地图")
        if  self.stop_flag:
            return
        time.sleep(0.4)
        click(784,172)#返回
        time.sleep(1)
        click(517,241)#帕诺星系
        time.sleep(1)
        self.click_until_enter("比格星")
        if  self.stop_flag:
            return
        time.sleep(0.5)
        self.miner("比格星")
        if  self.stop_flag:
            return
        logging.info("挖矿全部完成")
        return
            
    def stop(self):
        self.stop_flag=True
        set_global_stop_flag(True)
        