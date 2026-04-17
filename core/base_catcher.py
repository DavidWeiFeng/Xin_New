import time
import logging
from core.utils import *
from config.config import *
from config.app_config import app_config
from core.ogre_manager import OgreManager
from dataclasses import dataclass
import core.refresh as refresh_module
@dataclass
class CatcherConfig:
    pet_name: str
    only_normal_high_iv: bool = False
    only_rare_high_iv: bool = False
    ball_type: str = "中级胶囊"
    rare_and_shiny: bool = False
    use_cactus_sleep: bool = False
    afk_mode: bool = False
    lock_scene: bool = False
    all_catch: bool = False
    switch: bool = False
    mix: bool = False

class CaptureEngine:
    def __init__(self, catcher):
        self.catcher = catcher

    def _click_skill(self, skill_name, skill_pos=None, wait=2, log_msg=None):
        """辅助方法：查找并点击技能"""
        if skill_pos and skill_pos != (-1, -1):
            click(skill_pos[0], skill_pos[1])
            if log_msg: logging.info(log_msg)
            if wait > 0: time.sleep(wait)
            return skill_pos
            
        res, x, y = FindPic(*SEARCH_REGION, skill_name + ".bmp", 0.8)
        if res != -1:
            click(x, y)
            if log_msg: logging.info(log_msg)
            if wait > 0: time.sleep(wait)
            return (x, y)
        return None

    def _get_sleep_turn(self):
        """辅助方法：等待并获取睡眠回合数"""
        while not self.catcher.stop_flag:
            if can_use_skill():
                time.sleep(0.5)  # 等待睡眠回合数显示
                turn = ocr_sleep_turn()
                logging.info(f"当前催眠回合数: {turn}回合")
                return turn
        return 0

    def _use_mercy(self, delay=0):
        """公共逻辑：使用手下留情"""
        move_region("确定")
        while not self.catcher.stop_flag:
            res, x, y = FindPic(*SEARCH_REGION, "手下留情.bmp", 0.8)
            if x != -1 and y != -1:
                click(x + 3, y + 3)
                logging.info("使用手下留情")
                if delay > 0:
                    time.sleep(delay)
                break

    def _confirm_and_heal(self, heal_func=None):
        """公共逻辑：确认捕捉成功并回血"""
        click(CONFIRM_BUTTON[0], CONFIRM_BUTTON[1])  # 点击确认
        fast_move(100, 100)
        time.sleep(0.5)
        while not self.catcher.stop_flag:
            res, x, y = FindPic(*SEARCH_REGION, "确认.bmp", 0.8)
            if res == -1:
                if heal_func:
                    heal_func()
                break
            else:
                click(CONFIRM_BUTTON[0], CONFIRM_BUTTON[1])  # 点击确认
                fast_move(100, 100)
                time.sleep(0.5)

    def _use_item(self, item_name, confidence=0.85):
        """公共逻辑：使用物品"""
        click_region("道具")
        logging.info("点击道具")
        time.sleep(1.5)
        
        while not self.catcher.stop_flag:
            res, x, y = FindPic(*BALL_REGION, item_name + ".bmp", confidence)
            if res == -1 and "胶囊" in item_name:
                # 尝试识别第二种样子
                res, x, y = FindPic(*BALL_REGION, item_name + "2.bmp", confidence)
            if res != -1:
                click(x, y)
                fast_move(0, 0)
                logging.info(f"点击{item_name}")
                time.sleep(0.5)
                
                # 稳健点击检查：确保物品图标消失
                while not self.catcher.stop_flag:
                    res_check, _, _ = FindPic(*BALL_REGION, item_name + ".bmp", confidence)
                    if res_check == -1 and "胶囊" in item_name:
                        # 如果是胶囊且第一种样子找不到，检查第二种样子
                        res_check, _, _ = FindPic(*BALL_REGION, item_name + "2.bmp", confidence)
                    if res_check == -1:
                        break
                    else:
                        click(x, y)
                        fast_move(0, 0)
                        logging.info(f"再次点击{item_name}")
                        time.sleep(0.5)
                return
            else:
                logging.info(f"没有找到{item_name},请检查是否在前两排")
                retry_ball()
                time.sleep(0.5)

    def catch_pokemon(self):
        """尝试捕捉精灵的函数"""
        # 等待并点击"手下留情"按钮
        self._use_mercy()
        if self.catcher.stop_flag:
            return               
        # 检查是否还有野生精灵并尝试捕捉
        time.sleep(0.4)
        while not self.catcher.stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
            if res!=-1:
                logging.info("用时：%.2f 秒", time.time() - self.catcher.start_time)
                self.catcher.start_time=time.time()
                self._confirm_and_heal(heal)
                break              
            if self.catcher.stop_flag:
                return
            #还没捕捉成功    
            if can_use_skill():
                self._use_item(self.catcher.config.ball_type)
                self.catcher.ball_count += 1
                if self.catcher.stop_flag:
                    return
                time.sleep(0.2)
   
    def catch_with_cactus_sleep(self):
        self._use_mercy(delay=2)
        if self.catcher.stop_flag:
            return
            
        # 1. 切换到仙人球
        while not self.catcher.stop_flag:
            if can_use_skill():
                xianrenqiu()
                time.sleep(2)
                break
        
        if self.catcher.stop_flag:
            return
            
        # 2. 使用香甜气息*2
        xiangtian_pos = (-1, -1)
        for i in range(1, 3):
            while not self.catcher.stop_flag:
                if can_use_skill():
                    pos = self._click_skill("香甜气息", xiangtian_pos, log_msg=f"使用香甜气息*{i}")
                    if pos:
                        xiangtian_pos = pos
                        move_region("确定")
                        break
                    else:
                        logging.info("你的仙人球没有香甜气息技能，请检查配置")
                        return
        
        # 3. 睡眠抓捕循环
        sleep_turn, skill_turn = 0, 15
        miss = False  # 是否被减命中
        cuimian_pos = (-1, -1)
        
        while not self.catcher.stop_flag:
            res, x, y = FindPic(*SEARCH_REGION, "确认.bmp", 0.8)
            if res != -1:
                self._confirm_and_heal(healCactus)
                break
            
            if self.catcher.stop_flag:
                return
            
            if can_use_skill():
                if miss:
                    logging.info("被减命中,使用一次香甜气息")
                    self._click_skill("香甜气息", xiangtian_pos)
                    miss = False
                elif sleep_turn == 0 and skill_turn > 0:
                    # 使用催眠粉
                    pos = self._click_skill("催眠粉", cuimian_pos, log_msg="使用催眠粉")
                    if pos:
                        cuimian_pos = pos
                        skill_turn -= 1
                        sleep_turn = self._get_sleep_turn()
                        if sleep_turn == 0:
                            miss = True
                elif skill_turn == 0:
                    # 使用活力药剂
                    self._use_item("初级活力药剂", 0.80)
                    skill_turn += 5
                    sleep_turn -= 1
                    logging.info(f"点击初级活力药剂,技能次数+5,当前技能次数{skill_turn}")
                else:   
                    # 丢胶囊
                    self._use_item(self.catcher.config.ball_type)
                    self.catcher.ball_count += 1
                    sleep_turn -= 1

class shinyCatcher:
    def __init__(self, config: CatcherConfig):
        #--------------常量配置区--------------#
        self.config = config
        self.start_time = time.time()
        self.count = 1
        self.catch = 0
        self.ball_count = 0
        self.rare_count = 0
        self.max_wait_time = 16  # 最大等待时间，单位：秒
        self.stop_flag = False
        self.refresh_start_time = time.time()
        self.map_id = SHINY_CONFIG.get(self.config.pet_name, {}).get("map_id", 0)
        self.rare_pet = SHINY_CONFIG[self.config.pet_name].get("rare_pet", None)
        self.previous_slot_id = -1
        self.capture_engine = CaptureEngine(self)

        if self.config.mix:
            from config.config import CLEAN_PLAY_CONFIG # 确保能拿到配置
            self.mix_ctrl = refresh_module.MixModeController(CLEAN_PLAY_CONFIG)
        else:
            self.mix_ctrl = None

    def is_high_IV(self):
        if ocr is None:
            logging.warning("OCR 未初始化，跳过高个体判定。")
            return False
        hp=ocr_hp()
        level=ocr_level()
        logging.info(f"血量:{hp},等级:{level}")
        if hp=="":
            logging.info("读取不到血量，请使用波克尔")
            return False
        level_dict = HIGH_IV_CONFIG.get(self.config.pet_name)
        if level_dict is None:
            logging.info(f"没有{self.config.pet_name}的高个体数据")
            return False
        high_hp = level_dict.get(level)
        if high_hp is None:
            return False
        if hp == high_hp:
            return True
        else:
            return False

    def is_rare_high_IV(self):
        if ocr is None:
            logging.warning("OCR 未初始化，跳过高个体判定。")
            return False
        hp=ocr_hp()
        level=ocr_level()
        logging.info(f"血量:{hp},等级:{level}")
        if hp=="":
            logging.info("读取不到血量，请使用波克尔")
            return False

        pet_cfg = HIGH_IV_CONFIG.get(tuple(self.rare_pet))

        if not pet_cfg:
            logging.info(f"没有稀有精灵的高个体数据")
            return False
        level_cfg = pet_cfg[0].get(level)
        if not level_cfg:
            return False
        return hp in level_cfg

    def _wait_for_fight_start(self):
        """等待战斗开始"""
        start_wait = time.time()
        while not self.stop_flag:
            if can_use_skill():
                return True
            if time.time() - start_wait > self.max_wait_time:
                logging.info("等待进入战斗超时")
                error_handle()
                OgreManager().clear_current_slots()
                return False
            time.sleep(0.5)
        return False

    def _perform_capture_logic(self, pet_name, is_rare_check=False):
        """
        执行捕捉或战斗逻辑
        pet_name: 目标精灵名字
        is_rare_check: 是否是稀有精灵检测（如果是，会进行个体值检查）
        """
        # 2. 稀有精灵的检查逻辑
        if is_rare_check:
            should_catch = False
            
            # 优先检查暗雷
            if has_red_word():
                logging.info(f"稀有精灵 {pet_name} 是暗雷，准备捕捉")
                should_catch = True

            # 检查个体值 (如果配置了 only_rare_high_iv，且尚未决定捕捉)
            elif self.config.only_rare_high_iv:
                time.sleep(1.0)  # 等待UI加载
                if self.is_rare_high_IV():
                    logging.info(f"稀有精灵 {pet_name} 个体值达标，准备捕捉")
                    should_catch = True
                else:
                    logging.info(f"稀有精灵 {pet_name} 个体值不达标，逃跑")
            
            # 默认情况 
            elif self.config.rare_and_shiny:
                should_catch = True

            if not should_catch:    
                run_away()
                time.sleep(0.6)
                auto_cancel()
                return False

        if pet_name != self.config.pet_name and pet_name !="基摩" and pet_name !="乔乔" and not is_rare_check:
            logging.info(f"大形态异色：{pet_name},准备击杀")
            keep_use_fly_skill()
        # 4. 执行捕捉
        elif self.config.use_cactus_sleep:
            self.capture_engine.catch_with_cactus_sleep()
        else:
            self.capture_engine.catch_pokemon()
        
        # 5. 发送邮件
        prefix = "稀有精灵" if is_rare_check else "异色"
        if is_rare_check:
            self.rare_count += 1
        else:
            self.catch += 1
        send_qq_mail(f"{prefix} {pet_name} 捕捉成功！", "快来查看吧")
        return True

    def check_protocol_shiny(self):
        """使用协议数据检查异色精灵"""
        target = OgreManager().get_shiny_target()
        if not target:
            return False

        logging.info(f"检测到异色精灵！")
        
        # with OgreManager().fighting_context():
        (x, y, shiny_pet_name, slot_index) = target
        if self.stop_flag: return False
        if slot_index == self.previous_slot_id:
            logging.info("与上次点击的坐标相同")
            x1, y1 = OgreManager().get_first_empty_slot_pos()
            protocol_click(x1, y1)
            time.sleep(0.65)
        # 连续点击以确保选中
        for _ in range(2):
            protocol_click(x, y)  # 微调Y坐标
            time.sleep(0.2)
        move_region("确定")
        
        OgreManager().clear_current_slots()
        if not self._wait_for_fight_start():
            return False

        res= self._perform_capture_logic(shiny_pet_name, is_rare_check=False)
        self.previous_slot_id = slot_index  # 更新点击的槽位ID
        return res

    def check_protocol_rare(self):
        """使用协议数据检查稀有精灵"""
        rare_pet_names=None
        if not self.rare_pet:
            return False
                    
        for rare in self.rare_pet:
            target = OgreManager().get_target_by_name(rare)
            if target:
                rare_pet_names=rare
                break

        if not target:
            return False
            
        logging.info(f"检测到稀有精灵：{rare_pet_names}")
       
        # with OgreManager().fighting_context():
        (slot_index, x, y) = target
        if self.stop_flag: return False
        
        if slot_index == self.previous_slot_id:
            logging.info("与上次点击的坐标相同")
            x1, y1 = OgreManager().get_first_empty_slot_pos()
            protocol_click(x1, y1)
            time.sleep(0.65)

        for _ in range(2):
            protocol_click(x, y) 
            time.sleep(0.2)
        move_region("确定")

        OgreManager().clear_current_slots()
        if not self._wait_for_fight_start():
            return False
        self.previous_slot_id = slot_index  # 更新点击的槽位ID
        return self._perform_capture_logic(rare_pet_names, is_rare_check=True)

    def handle_normal_fight(self, pet_name=""):
        """处理普通精灵的战斗（为了刷新地图，同时检查暗雷异色及普通高个体）"""
        

        if self._wait_for_fight_start():
            
            time.sleep(0.5)
             # 1. 检查是否有红字（暗雷异色标志）
            if has_red_word():
                # logging.info(f"检测到红字！{self.config.pet_name} 可能是暗雷异色")
                return self._perform_capture_logic(pet_name, is_rare_check=False)
            
            if isNier(self.config.ball_type):
                return True
            
            if self.config.all_catch:
                if pet_name!=self.config.pet_name:
                    logging.info(f"点击了{pet_name}")
                    pass
                elif self.config.use_cactus_sleep:
                    self.capture_engine.catch_with_cactus_sleep()
                    return True
                else:
                    self.capture_engine.catch_pokemon()
                    return True
            # 2. 如果配置了抓捕普通高个体
            elif self.config.only_normal_high_iv:
                logging.info("检查普通精灵个体值...")
                if self.is_high_IV():
                    logging.info(f"发现高个体 {self.config.pet_name}！准备捕捉")
                    if self.config.use_cactus_sleep:
                        self.capture_engine.catch_with_cactus_sleep()
                    else:
                        self.capture_engine.catch_pokemon()
                    send_qq_mail(f"高个体 {self.config.pet_name} 捕捉成功！", "快来查看吧")
                    return True
                else:
                    logging.info("个体值不达标，准备逃跑")
            
            # 3. 默认逻辑：逃跑刷新
            run_away()
            time.sleep(0.3)
            auto_cancel() 
        return False

    def run(self):
        # 启动前清空旧缓存
        OgreManager().clear_current_slots()
        OgreManager().set_current_map(self.map_id)
        
        while not self.stop_flag:
            res,x,y=FindPic(372,254,535,318,"电量.bmp",0.8)
            if res!=-1:
                logging.info("电量耗尽")
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                            
            # 阻塞等待协议数据更新
            if OgreManager().wait_for_update(timeout=5):
                slots_info = OgreManager().get_slots_info()['slots']
                # 1. 优先检查是否有异色
                if self.check_protocol_shiny():
                    continue 
                
                # 2. 检查是否有稀有精灵
                if self.check_protocol_rare():
                    continue
                
                if self.config.mix:
                    self.config.afk_mode=self.mix_ctrl.should_afk()
                    
                # 3. 如果是原地挂机模式
                if self.config.afk_mode:
                    logging.info(f"第{self.count}次，遇见{self.catch}只异色精灵，{self.rare_count}只稀有精灵")
                    OgreManager().clear_current_slots()
                    time.sleep(1.0)
                    self.count += 1
                    continue
                elif self.config.lock_scene:
                    click(767,558)
                    logging.info(f"第{self.count}次，遇见{self.catch}只异色精灵，{self.rare_count}只稀有精灵")
                    OgreManager().clear_current_slots()
                    self.count += 1
                    time.sleep(1.5)
                    if isIdentifying():
                        while not self.stop_flag:
                            if not isIdentifying():
                                break
                            else:
                                while not has_non_white():
                                    time.sleep(0.2)
                                click(327,288)
                    
                elif self.config.switch:
                    logging.info(f"第{self.count}次，遇见{self.catch}只异色精灵，{self.rare_count}只稀有精灵")
                    OgreManager().clear_current_slots()
                    self.count += 1
                    switch_map(self.config.pet_name)
                    continue

                random_slot = OgreManager().get_random_valid_slot(
                    exclude_id=self.get_exclude_id(),  # 排除上一次选择的 slot
                    priority_name=self.config.pet_name
                )
                
                if random_slot:
                    slot_id, rx, ry, pet_name = random_slot
                    self.previous_slot_id = slot_id
                    logging.info(f"第{self.count}次，遇见{self.catch}只异色精灵，{self.rare_count}只稀有精灵")
                    OgreManager().clear_current_slots()
                    # 进入战斗前：屏蔽后续包 + 清空当前包
                    # with OgreManager().fighting_context():
                    for _ in range(3):
                        protocol_click(rx, ry)
                    time.sleep(1)
                    if error_handle():
                        OgreManager().clear_current_slots()
                        logging.info("点到自己了，自动处理错误")
                        continue
                    self.handle_normal_fight(pet_name)
                    self.count += 1
                    time.sleep(0.2)  # 等待地图刷新
                    if SHINY_CONFIG.get(self.config.pet_name, {}).get("reset_pos",None):
                        click(*SHINY_CONFIG[self.config.pet_name]["reset_pos"])
            else:
                res,x,y=FindPic(*SEARCH_REGION,"连接.bmp",0.80)
                if res!=-1:
                    send_qq_mail("淦你的游戏又掉线了","赶快重新上号")
                    logging.info("掉线，重新连接")
                    self.need_refresh(force=True)
                if self.need_refresh():
                    continue

    def need_refresh(self,force=False):
        if self.config.pet_name not in REFRESH_PET_ACTIONS:
            return False
        if time.time()-self.refresh_start_time>1800 and app_config().is_checked() or force:  
                      
            refresh_module.refresh_game()
            refresh_module.auto_setting()
            time.sleep(1.2)
            REFRESH_PET_ACTIONS[self.config.pet_name]()
            self.refresh_start_time=time.time()
            OgreManager().clear_current_slots()
            return True

    def stop(self):
        self.stop_flag = True
        set_global_stop_flag(True)

    def get_exclude_id(self):
        exclude_id = [self.previous_slot_id]
        if self.config.pet_name=="米隆":
            exclude_id.append(7)  # 米隆特殊处理，排除第8个槽位
        if self.config.pet_name=="浮空苗":
            exclude_id.append(6)  # 浮空苗特殊处理，排除第7个槽位
        return exclude_id