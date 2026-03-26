from PySide6.QtCore import QThread
from special_catcher.special_catcher import *
from core.base_catcher import CatcherConfig
from core.utils import set_global_stop_flag, catch_exception,set_current_hwnd


SPECIAL_CATCHER_PETS = ["霹雳兽","该隐","扳手","达比拉","卡卡","小鳍鱼","吉斯","乌鲁","依依","卡西"]  # 需要特殊处理的精灵列表
@catch_exception
class CatcherThread(QThread):
    def __init__(self, config: CatcherConfig, process_hwnd):
        super().__init__()
        self.process_hwnd = process_hwnd
        if config.pet_name in SPECIAL_CATCHER_PETS:
            self.catcher = SpecialCatcher(config)
        else:
            self.catcher = shinyCatcher(config)

    def run(self):
        set_current_hwnd(self.process_hwnd)  # 设置当前线程的hwnd
        set_global_stop_flag(False)
        self.catcher.run() 

    def stop(self):
        self.catcher.stop()
        self.quit()
        self.wait()     
        
    def on_captcha_handled(self):
        """验证码处理完成时的回调"""
        if hasattr(self.catcher, 'on_captcha_handled'):
            self.catcher.on_captcha_handled()