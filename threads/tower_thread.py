from PySide6.QtCore import QThread
from core.base_tower import BaseTower,TrialTower
from core.utils import set_global_stop_flag,catch_exception,set_current_hwnd

@catch_exception
class TowerThread(QThread):
    def __init__(self,tower_pokemon,process_hwnd):
        super().__init__()
        if tower_pokemon=="试炼之塔":
            self.tower = TrialTower()
        else:
            self.tower = BaseTower(tower_pokemon)
        self.process_hwnd=process_hwnd

    def run(self):
        set_global_stop_flag(False)
        set_current_hwnd(self.process_hwnd)
        self.tower.run()
    def stop(self):
        self.tower.stop()
        self.quit()
        self.wait()    