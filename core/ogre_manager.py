import threading
import logging
import xml.etree.ElementTree as ET
import os
import random
import time
from contextlib import contextmanager
from enum import Enum


class OgreManager:
    _instances = {}
    _lock = threading.Lock()

    def __new__(cls, hwnd=None):
        if hwnd is None:
            from core.utils import get_current_hwnd
            hwnd = get_current_hwnd()
        
        with cls._lock:
            if hwnd not in cls._instances:
                instance = super(OgreManager, cls).__new__(cls)
                instance._initialized = False
                cls._instances[hwnd] = instance
            return cls._instances[hwnd]

    def __init__(self, hwnd=None):
        if self._initialized:
            return
        self._initialized = True
        
        # 存储当前地图的精灵数据
        self.current_slots = {}
        self.all_map_coords = {}
        self.current_map_id = 0
        # 数据锁
        self.data_lock = threading.Lock()
        
        # 数据更新事件
        self.data_updated_event = threading.Event()
        
        # 战斗状态标识
        self.is_fighting = False
        
        # 加载坐标配置
        self.load_coords()


    def set_current_map(self, map_id):
        with self.data_lock:
            if self.current_map_id != map_id:
                self.current_map_id = map_id
                self.current_slots.clear()

    def update_slots(self, new_slots_data):
        """Proxy 调用：更新数据并设置 Flag 为 True"""
        with self.data_lock:
            self.current_slots = new_slots_data
            
            # 调试日志：显示收到的精灵数量
            count = len(new_slots_data)
            if count == 0:
                # logging.info("[OgreManager] Received UPDATE but list is EMPTY (Map has no ogres?)")
                pass
            else:
                # logging.info(f"[Debug][OgreManager] Updated with {count} slots.")
                print(self.current_slots)

            self.data_updated_event.set() # Set Flag = True

    def wait_for_update(self, timeout=None):
        """
        Bot 调用：阻塞等待 Flag 为 True。
        收到后立即将 Flag 重置为 False (消费此次更新)。
        """
        success = self.data_updated_event.wait(timeout)
        if success:
            self.data_updated_event.clear() # Reset Flag = False
        return success

    def clear_current_slots(self):
        """清空当前精灵状态，防止重复使用旧数据"""
        with self.data_lock:
            self.current_slots.clear()

    def get_shiny_target(self):
        target = None
        with self.data_lock:
            map_coords = self.all_map_coords.get(self.current_map_id)
            if not map_coords:
                logging.warning(f"No defined for Map ID: {self.current_map_id}")
                return []
            for slot_idx, info in self.current_slots.items():
                if info.get('is_shiny', False):
                    pet_name = info.get('name', 'Unknown')
                    coords = map_coords.get(slot_idx)
                    if coords:
                        target = (coords[0], coords[1], pet_name, slot_idx) # 保持一致的微调
                        # logging.info(f"Detected Shiny: {info.get('name')} at Map {map_id} Slot {slot_idx} {coords}")
                        break
        time.sleep(0.5)  #略微延时，等待客户端渲染
        return target

    def get_target_by_name(self, pet_name):
        """根据名字查找目标精灵的坐标"""
        target = None
        with self.data_lock:
            map_coords = self.all_map_coords.get(self.current_map_id)
            if not map_coords:
                return None
            
            for slot_idx, info in self.current_slots.items():
                if info.get('name') == pet_name:
                    coords = map_coords.get(slot_idx)
                    if coords:
                        target = (slot_idx, coords[0], coords[1]) # 保持一致的微调
                        # logging.info(f"Detected Rare: {pet_name} at Map {map_id} Slot {slot_idx} {target}")
                        break
        
        if target:
            time.sleep(0.4) # 等待渲染
            
        return target

    def get_random_valid_slot(self, exclude_id=None, priority_name=None):
        """
        获取一个当前有精灵的普通槽位坐标。
        优先选择名字匹配 priority_name 的槽位。
        如果只有一个槽位，则忽略 exclude_id 以免死锁。
        返回: (slot_idx, x, y)
        """
        priority_slots = []
        other_slots = []

        # 将 exclude_id 统一转换为列表或 set 格式
        if exclude_id is not None:
            if isinstance(exclude_id, (list, tuple)):
                exclude_id = set(exclude_id)
            else:
                # 单个整数也支持
                exclude_id = {exclude_id}
        else:
            exclude_id = set()
        with self.data_lock:
            map_coords = self.all_map_coords.get(self.current_map_id)
            if not map_coords:
                return None

            # 1. 收集所有非异色的有效槽位
            all_valid_items = []
            for slot_idx, info in self.current_slots.items():
                if not info.get('is_shiny', False):
                    coords = map_coords.get(slot_idx)
                    if coords:
                        all_valid_items.append((slot_idx, info, coords))
            
            if not all_valid_items:
                return None
            
            # 2. 如果有多个槽位，则尝试排除上次点击的
            candidate_items = all_valid_items
            # logging.info(f"上次点击的槽位 ID: {exclude_id}, 可选槽位: {candidate_items}")
            if len(all_valid_items) > 1 and exclude_id:
                candidate_items = [item for item in all_valid_items if item[0] not in exclude_id]
            
            # 3. 在候选列表中应用优先级逻辑
            for slot_idx, info, coords in candidate_items:
                pet_name = info.get('name', 'Unknown')
                slot_data = (slot_idx, coords[0], coords[1], pet_name)
                if priority_name and pet_name == priority_name:
                    priority_slots.append(slot_data)
                else:
                    other_slots.append(slot_data)
        
        target_slots = priority_slots if priority_slots else other_slots
        
        if target_slots:
            time.sleep(0.4)  #略微延时，等待
            return random.choice(target_slots)
        return None

    def get_slots_info(self):
        with self.data_lock:
            return {"slots": self.current_slots.copy()}

    def set_fighting_state(self, state: bool):
        with self.data_lock:
            self.is_fighting = state
            # logging.info(f"[OgreManager] Fighting State: {state}")

    @contextmanager
    def fighting_context(self):
        """
        战斗状态上下文管理器。
        进入时自动设置为 True，退出（包括 return 或异常）时自动重置为 False。
        """
        self.set_fighting_state(True)
        try:
            yield
        finally:
            self.set_fighting_state(False)

    def load_coords(self):
    #     map_id: {
    #     point_index: (x, y),
    #     point_index: (x, y),
    # },
        """加载 map_slots.xml 坐标配置"""
        try:
            base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
            xml_path = os.path.join(base_path, 'proxy', 'data', 'map_slots.xml')
            # logging.info(f"Loading map config from: {xml_path}")
            
            if not os.path.exists(xml_path):
                logging.warning(f"Map config not found")
                return

            tree = ET.parse(xml_path)
            root = tree.getroot()
            
            with self.data_lock:
                self.all_map_coords.clear()
                # 查找 ogre 节点下的所有 item
                ogre_node = root.find('ogre')
                if ogre_node is not None:
                    for item in ogre_node.findall('item'):
                        try:
                            map_id = int(item.get('id', 0))
                            p_list_str = item.get('pList', '')
                            if not p_list_str: continue
                            map_coords = {}
                            points = p_list_str.split('|')
                            for idx, point_str in enumerate(points):
                                if ',' in point_str:
                                    x_str, y_str = point_str.split(',')
                                    map_coords[idx] = (int(x_str), int(y_str))
                            if map_coords:
                                self.all_map_coords[map_id] = map_coords
                        except Exception as e:
                            logging.warning(f"Error parsing map item {item.get('id')}:")
            print(f"Loaded coordinates for {len(self.all_map_coords)} maps.")
        except Exception as e:
            logging.error(f"Failed to load map : {str(e)}")

    def get_first_empty_slot_pos(self):
        """
        获取第一个在 current_slots 中不存在的 slot 索引 (0~8)。
        如果 0~8 全部被占用，则返回 None。
        """
        with self.data_lock:
            # 获取当前已占用的所有 key
            occupied_slots = set(self.current_slots.keys())
            
            # 遍历 0 到 8
            for slot in range(9):
                if slot not in occupied_slots:

                    return self.all_map_coords.get(self.current_map_id, {}).get(slot)
            
            # 如果不存在
            return -1, -1 