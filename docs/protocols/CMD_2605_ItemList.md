# CMD 2605 - ITEM_LIST 协议文档

## 协议概述

**命令ID**: 2605 (`CommandID.ITEM_LIST`)  
**功能**: 获取玩家物品列表  
**类型**: 双向通信协议  

## 数据结构定义

### 请求格式 (Client -> Server)

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 4 | uint32 | startID | 查询起始物品ID |
| 4 | 4 | uint32 | endID | 查询结束物品ID |
| 8 | 4 | uint32 | flag | 查询类型标志 |

**查询类型标志 (flag):**
- `0` - FLAG_IN_BAG: 背包中的物品
- `1` - FLAG_ON_BODY: 身上装备的物品  
- `2` - FLAG_ALL: 所有物品

### 响应格式 (Server -> Client)

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 4 | uint32 | itemCount | 物品总数量 |
| 4 | 16 * N | SingleItemInfo[] | items | 物品列表 |

### SingleItemInfo 结构 (16字节)

根据前端 `SingleItemInfo.as` 定义：

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 4 | uint32 | itemID | 物品ID |
| 4 | 4 | uint32 | itemNum | 物品数量 |
| 8 | 4 | uint32 | leftTime | 剩余时间(秒) |
| 12 | 4 | uint32 | itemLevel | 物品等级 |

**构造函数源码:**
```actionscript
this.itemID = param1.readUnsignedInt();
this.itemNum = param1.readUnsignedInt(); 
this.leftTime = param1.readUnsignedInt();
this._itemLevel = param1.readUnsignedInt();
```

## 物品类型分类

根据前端代码 `SingleItemInfo.as` 中的类型判断逻辑：

| 物品ID范围 | 类型常量 | 中文名称 | 英文名称 | 描述 |
|------------|----------|----------|----------|------|
| 100001-101001 | ItemType.CLOTH | 服装 | Clothing | 角色服装装备 |
| 1300001-1390001 | ItemType.CLOTH | 服装 | Clothing | 角色服装装备(扩展) |
| 200001-300000 | ItemType.DOODLE | 涂鸦 | Doodle | 涂鸦相关物品 |
| 300001-400000 | ItemType.PET_PROPERTY | 精灵道具 | Pet Property | 精灵相关道具 |
| 400001-500000 | ItemType.COLLECTON | 收藏品 | Collection | 收藏类物品 |

**类型判断源码:**
```actionscript
if(this._itemID >= 100001 && this._itemID <= 101001 || 
   this._itemID >= 1300001 && this._itemID <= 1390001)
{
    this.type = ItemType.CLOTH;
}
else if(this._itemID >= 200001 && this._itemID <= 300000)
{
    this.type = ItemType.DOODLE;
}
else if(this._itemID >= 300001 && this._itemID <= 400000)
{
    this.type = ItemType.PET_PROPERTY;
}
else if(this._itemID >= 400001 && this._itemID <= 500000)
{
    this.type = ItemType.COLLECTON;
}
```

