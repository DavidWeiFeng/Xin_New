from PySide6.QtCore import QThread, Signal
import time
from core.utils import numIdentify

class CaptchaThread(QThread):
    # 定义信号
    captcha_handled = Signal()  # 验证码处理完成信号
    
    def __init__(self, check_interval=0.3):
        super().__init__()
        self._running = True
        self.check_interval = check_interval

    def run(self):
        while self._running:
            # 这里直接调用numIdentify，如果没有验证码会自动sleep
            boolean,res=numIdentify()
            if not boolean:
                time.sleep(self.check_interval)  # 防止过度占用CPU
            elif res==-1:
                time.sleep(15) #等待15秒后重试
            else :
                # 验证码处理完成，发送信号
                self.captcha_handled.emit()
                time.sleep(self.check_interval)

    def stop(self):
        self._running = False
        self.quit()
        self.wait()