from PySide6.QtCore import QThread
from special_learner.special_learner import *
from core.base_learner import LearnerConfig, BaseLearner
from core.utils import catch_exception,set_current_hwnd

SPECIAL_LEARNER_CLASSES = {
    "仙人球": singleTypeLearner,
    "皮皮": singleTypeLearner,
    "毛毛": singleTypeLearner,
    "水草蛙":singleTypeLearner,
    "玄冰兽":singleTypeLearner,
    "利牙鱼":singleTypeLearner,
    "伊娃":singleTypeLearner,
    "查斯":singleTypeLearner,
    "丁格":singleTypeLearner,
    "幽浮":singleTypeLearner,
    "莱尼":singleTypeLearner,
    "阿兹":singleTypeLearner,
    "精灵学院":schoolLearner
}

@catch_exception
class LearnerThread(QThread):
    def __init__(self,learn_pokemon,skill,hp_recovery_frequency, process_hwnd,catch_rare):
        super().__init__()
        config = LearnerConfig(
            target_pet_name=learn_pokemon,
            skill_name=skill,
            hp_recovery_freq=hp_recovery_frequency,
            catch_rare=catch_rare
        )
        learner_cls=SPECIAL_LEARNER_CLASSES.get(learn_pokemon,BaseLearner)
        self.learner = learner_cls(config)
        self.process_hwnd = process_hwnd

    def run(self):
        set_global_stop_flag(False)
        set_current_hwnd(self.process_hwnd)
        self.learner.run()
        
    def stop(self):
        self.learner.stop()
        self.quit()
        self.wait()    
        
    def on_captcha_handled(self):
        """验证码处理完成时的回调"""
        if hasattr(self.learner, 'on_captcha_handled'):
            self.learner.on_captcha_handled()