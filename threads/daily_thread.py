from PySide6.QtCore import QThread
from daily.auto_luandou import *
from daily.auto_miner import *
from core.utils import catch_exception

DAILY_CLASSES={
    "自动大乱斗":LuandouBot,
    "全星球自动挖矿（先进入斯科尔星）":Miner,
}

@catch_exception
class DailyThread(QThread):
    def __init__(self,daily_name,process_hwnd):
        super().__init__()
        self.process_hwnd=process_hwnd
        self.dailyer = DAILY_CLASSES.get(daily_name)()

    def run(self):
        set_global_stop_flag(False)
        set_current_hwnd(self.process_hwnd)
        self.dailyer.run()
    def stop(self):
        self.dailyer.stop()
        self.quit()
        self.wait()    
        
    def on_captcha_handled(self):
        """验证码处理完成时的回调"""
        if hasattr(self.dailyer, 'on_captcha_handled'):
            self.dailyer.on_captcha_handled()
            