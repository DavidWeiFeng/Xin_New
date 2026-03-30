import logging
import time
from core.ogre_manager import OgreManager
from core.utils import *
from core.base_catcher import shinyCatcher, CatcherConfig
from core.Identify import XinScript
class SpecialCatcher(shinyCatcher):
    def __init__(self, config: CatcherConfig):
        # 继承父类的初始化（计数器、引擎等）
        super().__init__(config)
        self.max_wait_time = 10
        self._special_handlers = {
            "霹雳兽": self._handle_pilishou,
            "该隐": self._handle_gaiying,  
            "扳手": self._handle_banshou,  
            "达比拉": self._handle_dabila,
            "卡卡": self._handle_kaka,
            "小鳍鱼": self._handle_xiaoqiyu,
            "吉斯": self._handle_jisi,
            "乌鲁": self._handle_wulu,
            "依依": self._handle_yiyi,
            "卡西":self._handle_kaxi,
        }
        self._error_handlers = {
            "扳手": self._handle_error_banshou,
            "该隐": self._handle_gaiying, 
            "依依": self._handle_yiyi,
            "达比拉": self._handle_error_dabila,
            "卡西":self._handle_kaxi,
        }

    def original_run(self):
        if OgreManager().wait_for_update(timeout=5):
            slots_info = OgreManager().get_slots_info()['slots']
            # 1. 优先检查是否有异色
            if self.check_protocol_shiny():
                return 
            
            # 2. 检查是否有稀有精灵
            if self.check_protocol_rare():
                return

            # 3. 如果没有异色且没抓到稀有，点击普通精灵以刷新地图 (优先点击目标精灵)
            if self.config.lock_scene:
                logging.info(f"第{self.count}次，遇见{self.catch}次异色精灵")
                click(785, 557)
                OgreManager().clear_current_slots()
                time.sleep(1.0)
                self.count += 1
                return
            
            random_slot = OgreManager().get_random_valid_slot(
                exclude_id=self.get_exclude_id(),  # 排除上一次选择的 slot
                priority_name=self.config.pet_name
            )
            
            if random_slot:
                slot_id, rx, ry, pet_name = random_slot
                self.previous_slot_id = slot_id
                logging.info(f"第{self.count}次，遇见{self.catch}次异色精灵")
                OgreManager().clear_current_slots()
                # 进入战斗前：屏蔽后续包 + 清空当前包
                with OgreManager().fighting_context():
                    for _ in range(3):
                        protocol_click(rx, ry)
                    self.handle_normal_fight(pet_name)
                self.count += 1

    def _standard_protocol_flow(self):
        """封装父类中常用的 协议等待 -> 识别 -> 战斗 流程"""
        if self.stop_flag:
            return
        if self._wait_for_fight_start():
            if has_red_word():
                logging.info(f"{self.config.pet_name} 是暗雷，准备捕捉")
                if Config.KILL_SHINY:
                    logging.info("配置了击杀异色，正在击杀暗雷...")
                    keep_use_fly_skill()
                elif self.config.use_cactus_sleep:
                    self.capture_engine.catch_with_cactus_sleep()
                else:
                    self.capture_engine.catch_pokemon()
            else:
                run_away()
        else:
            error_handler = self._error_handlers.get(self.config.pet_name, self._handle_default)
            error_handler()

    def run(self):
        OgreManager().set_current_map(self.map_id)
        inject_bit=False
        while not self.stop_flag:
            res,x,y=FindPic(372,254,535,318,"电量.bmp",0.8)
            if res!=-1:
                logging.info("电量耗尽")
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])

            # 2. 核心逻辑：分发任务
            # 根据 config.pet_name 获取对应的函数，如果没有特殊的，执行默认逻辑
            handler = self._special_handlers.get(self.config.pet_name, self._handle_default)
            handler()
            if not inject_bit:
                if JiaoyangScript().enable_script():
                    inject_bit = True


# --- 各个精灵的特殊点击逻辑 ---

    def _handle_default(self):
        """默认点击逻辑"""
        logging.info(f"{self.config.pet_name} 没有特殊配置!")
        pass

    def _handle_pilishou(self):
        """霹雳兽的特殊点击逻辑"""
        for _ in range(35):
            click(820,200)
            time.sleep(0.1)
        
        while not self.stop_flag:
             res,x,y=FindPic(*SEARCH_REGION,"霹雳兽.bmp",0.8)
             if res!=-1:
                 time.sleep(0.3)
                 click(x,y)
                 break
             
        self._standard_protocol_flow()

    def _handle_gaiying(self):
        """该隐的特殊点击逻辑"""
        for i in range(1,4):
            res,x,y=FindPic(*SEARCH_REGION,f"奇怪的石头{i}.bmp",0.8)
            if res!=-1:
                click(x,y)
                time.sleep(0.4)

        fast_move(0,0)
        time.sleep(0.5)  # 等待界面反应
        res,x,y=FindPic(*SEARCH_REGION,"该隐.bmp",0.8)
        if res!=-1:
            click(x,y)
            self._standard_protocol_flow()
        else:
            click(785,552)
            while not self.stop_flag:
                if is_color_at_point(298,545,"cc0000",tolerance=0):
                    time.sleep(0.8)
                    break

    def _handle_banshou(self):
        """扳手的特殊点击逻辑"""
        for _ in range(3):
            click(348,467)
            time.sleep(1.0)
        while not self.stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,"170.bmp",0.8)
            if res!=-1:
                time.sleep(0.3)
                click(420,471)
                break
        time.sleep(1.2)
        click(502,461)
        time.sleep(2.0)
        for _ in range(3):
            time.sleep(0.1)
            click(849,259)
        self._standard_protocol_flow()
        time.sleep(0.3)
        if is_color_at_point(666,212,"003366"):
            click(666,212)
            time.sleep(0.1)

    def _handle_dabila(self):
        click(419,463) 
        time.sleep(0.3)
        click(532,333)
        now=time.time()
        while not self.stop_flag and time.time()-now<12:
            res,x,y=FindPic(*SEARCH_REGION,"达比拉.bmp",0.8)
            if res!=-1:
                time.sleep(0.3)
                click(518,342)
                break
        self._standard_protocol_flow()

    def _handle_kaka(self):
        # 卡卡的特殊点击逻辑
        self.original_run()
        time.sleep(0.5)
        click(552,244)

    def _handle_xiaoqiyu(self):
        # 小奇鱼的特殊点击逻辑
        self.original_run()
        time.sleep(0.5)
        click(659,156)

    def _handle_jisi(self):
        # 吉斯的特殊点击逻辑
        click(686,84)
        while not self.stop_flag:
            if is_color_at_point(691,50,"ffffee"):
                break
        click(749,84)
        time.sleep(0.2)
        click(814,96)
        time.sleep(0.2)
        click(852,140)
        self.original_run()

    def _handle_wulu(self):
        # 乌鲁的特殊点击逻辑
        while not self.stop_flag:
            res,x,y=FindPic(497,335,547,382,"乌鲁.bmp",0.8)
            if res!=-1:
                click(809,453)
                time.sleep(2.5)
                click(597,359)
                break
        self._standard_protocol_flow()

    def _handle_yiyi(self):
        # 依依的特殊点击逻辑
        click(355,305)
        x1=-1
        y1=-1
        for _ in range(3):
            click(302,557)
            time.sleep(0.3)
            click(267,440)
            while not self.stop_flag:
                res,x1,y1=FindPic(9,51,332,506,"依依.bmp",0.75)
                if res!=-1:
                    click(x1,y1)
                    time.sleep(1)
                    break
        time.sleep(0.5)
        click(x1,y1)
        self._standard_protocol_flow()
        time.sleep(0.6)
        click(355,305)
        
    def _handle_kaxi(self):
        if is_color_at_point(266,196,"02fdfd"):
            click(665,212)
            time.sleep(0.1)
        self.original_run()

# --- 各个精灵的错误处理逻辑 ---
    def _handle_error_banshou(self):
        """扳手的错误处理逻辑"""
        self._handle_banshou()  # 直接重试一次

    def _handle_error_dabila(self):
        """达比拉的错误处理逻辑"""
        click(150,431)
        time.sleep(0.3)
        self._handle_dabila()  # 直接重试一次
