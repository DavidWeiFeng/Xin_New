import os
import xml.etree.ElementTree as ET
from typing import Dict


class GameData:
    """
    游戏静态数据管理类（懒加载）
    - 模块级天然单例
    - 无实例状态
    - 只负责数据读取与查询
    """

    _items: Dict[int, str] = {}
    _pets: Dict[int, str] = {}
    _skills: Dict[int, str] = {}
    _initialized: bool = False

    @classmethod
    def initialize(cls):
        """
        初始化并加载所有 XML 数据（仅执行一次）
        """
        if cls._initialized:
            return

        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        data_dir = os.path.join(base_dir, 'data')

        cls._load_items(os.path.join(data_dir, 'items.xml'))
        cls._load_pets(os.path.join(data_dir, 'pets.xml'))
        cls._load_skills(os.path.join(data_dir, 'skills.xml'))

        cls._initialized = True
        print(
            f"[GameData] Loaded {len(cls._items)} items, "
            f"{len(cls._pets)} pets, "
            f"{len(cls._skills)} skills."
        )

    @classmethod
    def _load_items(cls, path: str):
        if not os.path.exists(path):
            print(f"[GameData] Warning: {path} not found.")
            return

        try:
            tree = ET.parse(path)
            root = tree.getroot()

            # <Items><Cat><Item ID="..." Name="..." /></Cat></Items>
            for cat in root.findall('Cat'):
                for item in cat.findall('Item'):
                    try:
                        item_id = int(item.get('ID'))
                        name = item.get('Name')
                        if name:
                            cls._items[item_id] = name
                    except (TypeError, ValueError):
                        continue
        except Exception as e:
            print(f"[GameData] Error loading items: {e}")

    @classmethod
    def _load_pets(cls, path: str):
        if not os.path.exists(path):
            print(f"[GameData] Warning: {path} not found.")
            return

        try:
            tree = ET.parse(path)
            root = tree.getroot()

            # <Monsters><Monster ID="..." DefName="..." /></Monsters>
            for monster in root.findall('Monster'):
                try:
                    pet_id = int(monster.get('ID'))
                    name = monster.get('DefName')
                    if name:
                        cls._pets[pet_id] = name
                except (TypeError, ValueError):
                    continue
        except Exception as e:
            print(f"[GameData] Error loading pets: {e}")

    @classmethod
    def _load_skills(cls, path: str):
        if not os.path.exists(path):
            print(f"[GameData] Warning: {path} not found.")
            return

        try:
            tree = ET.parse(path)
            root = tree.getroot()

            # <MovesTbl><Moves><Move ... /></Moves></MovesTbl>
            parent = root.find('Moves') or root

            for move in parent.findall('Move'):
                try:
                    skill_id = int(move.get('ID'))
                    name = move.get('Name')
                    if name:
                        cls._skills[skill_id] = name
                except (TypeError, ValueError):
                    continue
        except Exception as e:
            print(f"[GameData] Error loading skills: {e}")

    # ================= 对外接口 =================

    @classmethod
    def get_item_name(cls, item_id: int) -> str:
        if not cls._initialized:
            cls.initialize()
        return cls._items.get(item_id, f"Unknown Item ({item_id})")

    @classmethod
    def get_pet_name(cls, pet_id: int) -> str:
        if not cls._initialized:
            cls.initialize()
        return cls._pets.get(pet_id, f"Unknown Pet ({pet_id})")

    @classmethod
    def get_skill_name(cls, skill_id: int) -> str:
        if not cls._initialized:
            cls.initialize()
        return cls._skills.get(skill_id, f"Unknown Skill ({skill_id})")