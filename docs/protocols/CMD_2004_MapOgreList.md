# CMD 2004: Map Ogre List (地图野怪列表 - 异色版)

## 1. 概述
**Command ID**: `2004`  
**Direction**: Server -> Client  
**Description**: 当玩家进入地图或野怪刷新时，服务器下发此包，告知客户端当前地图上所有野怪的位置、种类以及**异色(Shiny)**状态。

## 2. 数据结构 (Data Structure)

### 2.1 Packet Header (固定头)
| Offset | Type | Name | Value | Description |
| :--- | :--- | :--- | :--- | :--- |
| 0 | `uint32` | Length | `17 + 72 = 89` | 包总长度 (Header + Body) |
| 4 | `uint8` | Version | `0x37` | 协议版本号 |
| 5 | `uint32` | Cmd ID | `2004` | 命令号 |
| 9 | `uint32` | User ID | `uid` | 接收包的用户米米号 |
| 13 | `uint32` | Result | `0` | 状态码 (0 表示成功) |

### 2.2 Packet Body (数据体)
**总长度**: 72 Bytes (9 * 8 Bytes)
**结构**: 9 个连续的 `Slot Info` 结构体。

#### Slot Info 结构 (8 Bytes)
每个槽位包含两个 32 位无符号整数。

| Offset (Relative) | Type | Name | Description |
| :--- | :--- | :--- | :--- |
| +0 | `uint32` | Ogre ID | 野怪种类 ID (0 表示该位置无野怪) |
| +4 | `uint32` | Shiny Type | 异色/特殊状态标识 (0: 普通, >0: 异色/特殊) |

#### 完整 Body 布局
| Offset | Field | Description |
| :--- | :--- | :--- |
| 0 | Slot 0 - ID | 槽位 0 的野怪 ID |
| 4 | Slot 0 - Shiny | 槽位 0 的异色状态 |
| 8 | Slot 1 - ID | 槽位 1 的野怪 ID |
| 12 | Slot 1 - Shiny | 槽位 1 的异色状态 |
| ... | ... | ... |
| 64 | Slot 8 - ID | 槽位 8 的野怪 ID |
| 68 | Slot 8 - Shiny | 槽位 8 的异色状态 |

*注意：所有整数均为 **Big-Endian (大端序)**。*

## 3. 业务逻辑 (Logic)
客户端 (`OgreCmdListener.as`) 收到此包后的处理逻辑：
1.  循环 9 次。
2.  每次读取两个 `UnsignedInt`：`_loc2_` (ID) 和 `shiny`。
3.  如果 `ID != 0`，调用 `OgreController.add(index, id, shiny)` 显示野怪（可能带有特殊光效）。
4.  如果 `ID == 0`，清除该位置野怪。

## 4. 示例数据 (Example)
**场景**: 槽位 0 有一只普通的皮皮(ID 133)，槽位 1 有一只**异色**皮皮。

**Hex Dump Body:**
```
00 00 00 85 00 00 00 00  (Slot 0: ID=133, Shiny=0)
00 00 00 85 00 00 00 01  (Slot 1: ID=133, Shiny=1)
00 00 00 00 00 00 00 00  (Slot 2: Empty)
...
```