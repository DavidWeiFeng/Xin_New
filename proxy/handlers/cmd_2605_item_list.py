from proxy.utils.protocol import Packet, Protocol
from proxy.utils.byte_buffer import ByteBuffer
from proxy.utils.game_data import GameData
from proxy.config import Direction

def handle_item_list(packet: Packet, direction: Direction):
    """
    处理 CMD 2605 (Item List)
    根据前端 ActionScript 代码分析的真实数据结构
    
    Client -> Server: 请求物品列表
    - param1: 开始物品ID (uint32)
    - param2: 结束物品ID (uint32)  
    - param3: 类型标志 (uint32) - 2表示查询所有
    
    Server -> Client: 返回物品列表
    - 物品数量 (uint32)
    - 对每个物品：itemID, itemNum, leftTime, itemLevel (各4字节)
    """
    buffer = ByteBuffer(packet.body)
    
    if direction == Direction.CLIENT_TO_SERVER:
        # 客户端请求包 - 3个参数
        if buffer.available() >= 12:
            start_id = buffer.read_uint32()
            end_id = buffer.read_uint32()
            flag_type = buffer.read_uint32()
            
            print(f"   [Request] Get Item List:")
            print(f"      Range: {start_id} - {end_id}")
            print(f"      Type Flag: {flag_type}")
            
            # 解释标志位
            if flag_type == 0:
                print(f"      -> FLAG_IN_BAG (背包中的物品)")
            elif flag_type == 1:
                print(f"      -> FLAG_ON_BODY (身上的物品)")
            elif flag_type == 2:
                print(f"      -> FLAG_ALL (所有物品)")
            else:
                print(f"      -> Unknown flag: {flag_type}")
                
        elif buffer.available() > 0:
            print(f"   [Request] Get Item List (Incomplete: {buffer.available()} bytes)")
            Protocol.hex_dump(packet.body)
        else:
            print(f"   [Request] Get Item List (Empty request)")
            
    elif direction == Direction.SERVER_TO_CLIENT:
        # 服务器响应包 - 物品列表
        try:
            if buffer.available() < 4:
                print(f"   [Error] Response too short for item count")
                return
                
            # 读取物品数量
            item_count = buffer.read_uint32()
            print(f"   [Response] Item List with {item_count} items:")
            
            if item_count > 1000:  # 合理性检查
                print(f"   [Warning] Item count seems too large: {item_count}")
                Protocol.hex_dump(packet.body)
                return
            
            # 计算所需的数据长度 (每个物品16字节)
            expected_bytes = item_count * 16
            if buffer.available() < expected_bytes:
                print(f"   [Warning] Data truncated. Expected {expected_bytes} bytes, got {buffer.available()}")
            
            # 解析每个物品 (SingleItemInfo 结构)
            for i in range(item_count):
                if buffer.available() < 16:  # itemID + itemNum + leftTime + itemLevel
                    print(f"   [Error] Truncated item data at item {i+1}")
                    break
                
                item_id = buffer.read_uint32()
                item_num = buffer.read_uint32()
                left_time = buffer.read_uint32()
                item_level = buffer.read_uint32()
                
                # 使用 GameData 获取物品名称
                item_name = GameData.get_item_name(item_id)
                
                # 确定物品类型（根据前端逻辑）
                item_type = get_item_type(item_id)
                
                print(f"      {i+1:3d}. {item_num:3d}x {item_name} (ID: {item_id})")
                print(f"           Type: {item_type} | Level: {item_level}")
                
                # 显示剩余时间（如果有）
                if left_time > 0:
                    print(f"           Left Time: {left_time} seconds")
                
                # 特殊物品提示
                if item_type == "CLOTH":
                    print(f"           -> Clothing/装备物品")
                elif item_type == "PET_PROPERTY":
                    print(f"           -> Pet item/精灵道具")
                elif item_type == "COLLECTION":
                    print(f"           -> Collection item/收藏品")
                elif item_type == "DOODLE":
                    print(f"           -> Doodle item/涂鸦物品")
            
            # 检查是否还有剩余数据
            if buffer.available() > 0:
                print(f"   [Info] {buffer.available()} bytes remaining in packet")
                
        except Exception as e:
            print(f"   [Error] Failed to parse Item List: {e}")
            Protocol.hex_dump(packet.body)

def get_item_type(item_id: int) -> str:
    """
    根据前端 SingleItemInfo 的逻辑确定物品类型
    """
    if (100001 <= item_id <= 101001) or (1300001 <= item_id <= 1390001):
        return "CLOTH"  # 服装
    elif 200001 <= item_id <= 300000:
        return "DOODLE"  # 涂鸦
    elif 300001 <= item_id <= 400000:
        return "PET_PROPERTY"  # 精灵道具
    elif 400001 <= item_id <= 500000:
        return "COLLECTION"  # 收藏品
    else:
        return "UNKNOWN"
