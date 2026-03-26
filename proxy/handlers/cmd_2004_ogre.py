from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.utils.game_data import GameData
from proxy.entities.pet_glow_filter import PetGlowFilter
from core.ogre_manager import OgreManager  # Import the manager

def handle_ogre_list(packet: Packet, hwnd: int = -1):
    """
    处理 CMD 2004 (Map Ogre List) - Updated for OgreManager Integration
    Protocol:
    Loop 9 times:
      - MonID (u32)
      - IsShiny (u32)
      - If IsShiny != 0:
        - ShinyInfo (98 bytes)
    """
    # 如果正在战斗中，忽略地图刷新包，防止误判
    if OgreManager(hwnd).is_fighting:
        # print("   [Ogre Ignored] Battle in progress.")
        return

    buffer = ByteBuffer(packet.body)
    
    # Check minimum length (9 * 8 bytes = 72 bytes)
    if buffer.available() < 72:
        # print(f"   [Error] Body too short for CMD 2004. Expected at least 72, got {buffer.available()}")
        return

    # Dictionary to store slot data: { slot_index: { "id": ..., "is_shiny": ... } }
    slots_data = {}
    
    try:
        found_any = False
        
        for index in range(9):
            if buffer.available() < 8:
                 break

            ogre_id = buffer.read_uint32()
            is_shiny_val = buffer.read_uint32()
            is_shiny = (is_shiny_val != 0)
            
            if ogre_id != 0:
                ogre_name = GameData.get_pet_name(ogre_id)
                
                # Store valid ogre in our data structure
                slots_data[index] = {
                    "id": ogre_id,
                    "name": ogre_name,
                    "is_shiny": is_shiny
                }
                found_any = True
        
        # Log BEFORE updating manager to ensure chronological console output
        print(f"   [Server->Client] Map Ogres Refreshed: {len(slots_data)} slots active. HWND: {hwnd}")
        
        # Update the global thread-safe manager (Wakes up the bot)
        OgreManager(hwnd).update_slots(slots_data)

    except Exception as e:
        print(f"   [Error] Failed to unpack Ogre List: {e}")