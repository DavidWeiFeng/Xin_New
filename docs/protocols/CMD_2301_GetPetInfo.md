# CMD 2301: Get Pet Info (获取精灵详情)

## 1. 概述
**Command ID**: `2301`  
**Description**: 查询指定精灵的详细属性信息。常用于打开精灵背包、战斗中查看属性等场景。

## 2. 请求 (Client -> Server)
**Body Length**: 4 Bytes

| Offset | Type | Name | Description |
| :--- | :--- | :--- | :--- |
| 0 | `uint32` | Catch Time | 精灵的捕获时间 (唯一标识符) |

## 3. 响应 (Server -> Client)
**Body Length**: 不定长 (约 200+ 字节)
**结构**: 完整的 `PetInfo` 结构。

| Type | Name | Description |
| :--- | :--- | :--- |
| `uint32` | ID | 精灵种类 ID |
| `char[16]` | Name | 精灵昵称 |
| `uint32` | DV | 个体值 (0-31) |
| `uint32` | Nature | 性格 ID |
| `uint32` | Level | 等级 |
| `uint32` | Exp | 当前经验 |
| ... | ... | (包含 HP, MaxHP, Atk, Def, SA, SD, Spd 等基础属性) |
| `uint32[7]` | Add Values | 刻印/加成属性 |
| `uint32[6]` | EVs | 努力值 (HP, Atk, Def, SA, SD, Spd) |
| `uint32` | Skill Num | 技能数量 |
| `Struct[4]` | Skills | 技能列表 |
| `uint32` | Catch Time | 捕获时间 |
| ... | ... | 捕获地点等 |
| `uint16` | Effect Count | 效果数量 |
| `Struct[]` | Effects | 药剂/Buff 效果 |
| `uint32` | Pet Effect | 通用特效 |
| `uint32` | Skin ID | 皮肤 |
| `uint32` | Shiny | 异色 |
| `uint32` | Forbidden | 禁赛 |
| `uint32` | Boss | Boss 标记 |

## 4. 示例交互
**Request:**
```text
[CLIENT -> SERVER] CMD: 2301
   [Request] Query Pet Info for CatchTime: 1678889900
```

**Response:**
```text
[SERVER -> CLIENT] CMD: 2301
   [Response] Pet Details:
      Name: SuperPipi ID: 133 | Lv: 100 | DV: 31 HP: 300/300
      Skills: 1001(PP:20), 1002(PP:15) | Shiny(1), Skin(2001)
      EVs: [255, 0, 0, 0, 0, 255]
      Effects: 0 active
```
