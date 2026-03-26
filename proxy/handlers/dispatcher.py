from proxy.utils.protocol import Packet, Protocol
from proxy.handlers.cmd_2004_ogre import handle_ogre_list
from proxy.handlers.cmd_2001_enter_map import handle_enter_map
from proxy.handlers.cmd_2503_fight_ready import handle_fight_ready
from proxy.handlers.cmd_2301_pet_info import handle_get_pet_info
from proxy.handlers.cmd_2405_use_skill import handle_use_skill
from proxy.handlers.cmd_2408_fight_npc import handle_fight_npc_monster
from proxy.handlers.cmd_2605_item_list import handle_item_list
from proxy.handlers.cmd_1001_login import handle_login
from proxy.config import Direction

def handle_command(cmd_id: int, packet: Packet, direction: Direction):
    """
    根据 cmd_id 分发处理逻辑
    """
    # 过滤高频日志，不打印 CMD 1002 和 2101 的详细信息
    if cmd_id not in [1002,2101,2003,1004,2021,2002,2301]:
        print(f"[Cmd调试]Direction: {direction.value}  CMD: {cmd_id}")

    # --- Command Routing ---
    
    if cmd_id == 1001:
        handle_login(packet, direction)
        return

    if cmd_id == 2004:
        handle_ogre_list(packet)
        return

    if cmd_id == 2001:
        handle_enter_map(packet, direction)
        return

    if cmd_id == 2503:
        # handle_fight_ready(packet, direction)
        return

    if cmd_id == 2301:
        # handle_get_pet_info(packet, direction)
        return

    if cmd_id == 2405:  # USE_SKILL (Client -> Server)
        # handle_use_skill(packet, direction)
        return

    if cmd_id == 2408:  # FIGHT_NPC_MONSTER
        # handle_fight_npc_monster(packet, direction)
        return

    if cmd_id == 2505:  # NOTE_USE_SKILL (Server -> Client)
        # handle_use_skill(packet, direction)
        return

    if cmd_id == 2605:  # ITEM_LIST
        # handle_item_list(packet, direction)
        return
