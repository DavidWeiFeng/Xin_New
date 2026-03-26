"""
事件系统 - 用于Handler和GUI之间的解耦通信
"""
import threading
from typing import Dict, List, Callable, Any
from datetime import datetime

class EventBus:
    """事件总线 - 实现观察者模式"""
    
    def __init__(self):
        self._listeners: Dict[str, List[Callable]] = {}
        self._lock = threading.RLock()
    
    def subscribe(self, event_type: str, callback: Callable):
        """订阅事件"""
        with self._lock:
            if event_type not in self._listeners:
                self._listeners[event_type] = []
            self._listeners[event_type].append(callback)
    
    def unsubscribe(self, event_type: str, callback: Callable):
        """取消订阅"""
        with self._lock:
            if event_type in self._listeners:
                try:
                    self._listeners[event_type].remove(callback)
                except ValueError:
                    pass
    
    def emit(self, event_type: str, data: Any = None):
        """发布事件"""
        with self._lock:
            listeners = self._listeners.get(event_type, []).copy()
        
        # 在锁外执行回调，避免死锁
        for callback in listeners:
            try:
                callback(data)
            except Exception as e:
                print(f"[EventBus] Error in callback for {event_type}: {e}")

# 全局事件总线实例
event_bus = EventBus()

# 事件类型常量
class BattleEvents:
    """对战事件类型定义 - 简化版"""
    
    # 核心事件
    PETS_LOADED = "pets_loaded"      # 加载所有精灵信息 (FIGHT_READY)
    PET_UPDATED = "pet_updated"      # 更新精灵状态 (USE_SKILL)

class BattleEventData:
    """对战事件数据结构"""
    
    def __init__(self, event_type: str, **kwargs):
        self.event_type = event_type
        self.timestamp = datetime.now()
        self.data = kwargs
    
    def __str__(self):
        return f"BattleEvent({self.event_type}, {self.data})"

# 便捷函数
def emit_battle_event(event_type: str, **data):
    """发布对战事件"""
    event_data = BattleEventData(event_type, **data)
    event_bus.emit(event_type, event_data)

def subscribe_battle_event(event_type: str, callback: Callable):
    """订阅对战事件"""
    event_bus.subscribe(event_type, callback)
