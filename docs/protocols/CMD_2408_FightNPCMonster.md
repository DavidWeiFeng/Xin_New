# CMD 2408: Fight NPC Monster (挑战野外精灵)

## 1. 概述
**Command ID**: `2408`
**Direction**: Client <-> Server
**Description**: 客户端请求与地图上的野外精灵（NPC）进行战斗。

## 2. 数据结构 (Data Structure)

### 2.1 Client Request (客户端请求)
| Offset | Type | Name | Description |
| :--- | :--- | :--- | :--- |
| 0 | `uint32` | Monster ID | 想要挑战的野外精灵的 ID |

### 2.2 Server Response (服务器响应)
**注意**: 此命令的响应通常仅作为确认信号，客户端在 `MapProcess` 中收到此命令后，往往会注册后续战斗结果的监听器（如 CMD 4552）或等待 `NOTE_READY_TO_FIGHT` (CMD 2503) 进入战斗。响应包体通常为空或被忽略。

## 3. 业务逻辑 (Logic)

### 客户端 (Client)
1.  **触发**: 用户点击地图上的野怪时触发。
2.  **代码位置**: `com.robot.app.fightNote.FightInviteManager.fightWithNpc(param1:uint)`
3.  **流程**:
    *   检查战斗开关 (`fightSwitch`)。
    *   设置 `PetFightModel` 的模式为 `MULTI_MODE` 和状态为 `FIGHT_WITH_NPC`。
    *   发送 CMD 2408，附带怪物 ID。
    *   暂时禁用战斗开关（防抖动）。

### 服务器 (Server)
1.  验证请求合法性。
2.  若合法，初始化战斗会话。
3.  向客户端发送 CMD 2503 (`NOTE_READY_TO_FIGHT`) 包含双方精灵信息，正式开始战斗加载。

## 4. 示例数据 (Example)

**Client Request Hex:**
请求挑战 ID 为 `133` (0x85) 的皮皮。
```
00 00 00 85  (Monster ID: 133)
```
