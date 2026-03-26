# CMD 2503: Note Ready To Fight (战斗准备通知)

## 1. 概述
**Command ID**: `2503`  
**Direction**: Server -> Client  
**Description**: 当战斗（PVP 或 PVE）即将开始时，服务器下发此包。它包含了对战双方玩家的基本信息（米米号、昵称）以及他们各自携带的精灵详细数据。

## 2. 数据结构 (Data Structure)

### 2.1 Packet Header
使用标准游戏协议头 (17 字节)。

### 2.2 Packet Body
**总长度**: 动态长度。计算公式：`4 + 2 * (20 + 4 + PetCount * 84)`。

| Offset | Type | Name | Description |
| :--- | :--- | :--- | :--- |
| 0 | `uint32` | Mode | 战斗模式标识 |
| 4 | `Struct` | Player 1 Data | 玩家 1 的完整数据块 |
| ... | `Struct` | Player 2 Data | 玩家 2 的完整数据块 |

#### 玩家数据块结构 (Player Structure)
| Relative Offset | Type | Name | Description |
| :--- | :--- | :--- | :--- |
| 0 | `uint32` | User ID | 玩家米米号 |
| 4 | `char[16]` | Nickname | 玩家昵称 (UTF-8, 不足16字节以 \x00 填充) |
| 20 | `uint32` | Pet Count | 携带精灵的数量 (N) |
| 24 | `Struct[N]` | Pet List | 精灵详情列表 (每个精灵 84 字节) |

#### 精灵详情结构 (Pet Info Structure - 84 Bytes)
基于 `PetInfo.as` 的简化模式 (`param2=false`)。

| Relative Offset | Type | Name | Description |
| :--- | :--- | :--- | :--- |
| 0 | `uint32` | Pet ID | 精灵种类 ID |
| 4 | `uint32` | Level | 当前等级 |
| 8 | `uint32` | HP | 当前血量 |
| 12 | `uint32` | Max HP | 最大血量 |
| 16 | `uint32` | Skill Num | 技能数量 |
| 20 | `uint32` | Skill 1 ID | 技能 1 ID |
| 24 | `uint32` | Skill 1 PP | 技能 1 当前 PP |
| 28 | `uint32` | Skill 2 ID | 技能 2 ID |
| 32 | `uint32` | Skill 2 PP | 技能 2 当前 PP |
| 36 | `uint32` | Skill 3 ID | 技能 3 ID |
| 40 | `uint32` | Skill 3 PP | 技能 3 当前 PP |
| 44 | `uint32` | Skill 4 ID | 技能 4 ID |
| 48 | `uint32` | Skill 4 PP | 技能 4 当前 PP |
| 52 | `uint32` | Catch Time | 捕获时间戳 (唯一标识符) |
| 56 | `uint32` | Catch Map | 捕获地图 ID |
| 60 | `uint32` | Catch Rect | 捕获坐标/区域 |
| 64 | `uint32` | Catch Level | 捕获时的等级 |
| 68 | `uint32` | Skin ID | 皮肤 ID (0 为原版) |
| 72 | `uint32` | Shiny | 异色/闪光标识 (0 为普通) |
| 76 | `uint32` | Forbidden | 禁赛/特殊状态标识 |
| 80 | `uint32` | Is Boss | 是否为 Boss (0: 否, 1: 是) |

## 3. 业务逻辑 (Logic)
1.  **解析流程**:
    *   读取 4 字节 Mode。
    *   进入 2 次循环（双方玩家）。
    *   读取 20 字节玩家信息（ID 和 16 字节昵称）。
    *   读取该玩家携带的精灵数。
    *   循环读取每个精灵的 84 字节数据。
2.  **客户端行为**:
    *   调用 `PetFightEntry.setup()` 初始化战斗场景。
    *   关闭“等待对手”面板 (`FightWaitPanel.hide()`)。

## 4. 注意事项
*   **字符串处理**: 昵称字段为固定 16 字节，读取后需去除末尾的空字节 (`\x00`)。
*   **技能槽**: 协议固定预留了 4 个技能槽位，如果精灵携带技能不足 4 个，未使用的槽位 ID 为 0。