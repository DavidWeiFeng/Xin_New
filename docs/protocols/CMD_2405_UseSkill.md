# CMD 2405 - USE_SKILL 协议文档

## 协议概述

**命令ID**: 2405 (`CommandID.USE_SKILL`)  
**功能**: 精灵技能使用  
**类型**: 双向通信协议  
**关联命令**: 2505 (`NOTE_USE_SKILL`) - 技能使用通知

## 数据结构定义

### 请求格式 (Client -> Server)

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 4 | uint32 | skillID | 技能ID，0表示逃跑/投降 |

**使用方式:**
```actionscript
SocketConnection.send(CommandID.USE_SKILL, skillID);
```

### 响应格式 (Server -> Client)

响应包含 `UseSkillInfo` 结构，包含双方精灵的攻击结果：

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 变长 | AttackValue | firstAttackInfo | 第一个攻击者信息 |
| 变长 | 变长 | AttackValue | secondAttackInfo | 第二个攻击者信息 |

### AttackValue 结构

根据前端 `AttackValue.as` 定义，单个攻击者的完整信息：

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 4 | uint32 | userID | 使用者ID |
| 4 | 4 | uint32 | skillID | 技能ID |
| 8 | 4 | uint32 | atkTimes | 攻击次数 |
| 12 | 4 | uint32 | lostHP | 损失HP |
| 16 | 4 | int32 | gainHP | 恢复HP(负数表示额外伤害) |
| 20 | 4 | int32 | remainHP | 剩余HP |
| 24 | 4 | uint32 | maxHP | 最大HP |
| 28 | 4 | uint32 | state | 状态标志 |
| 32 | 4 | uint32 | skillCount | 更新的技能数量 |
| 36 | 8*N | PetSkillInfo[] | skillList | 技能列表 |
| 36+8*N | 4 | uint32 | isCrit | 是否暴击(1=是,0=否) |
| 40+8*N | 20 | byte[20] | status | 状态效果数组 |
| 60+8*N | 6 | byte[6] | battleLv | 能力等级变化数组 |

**构造函数源码:**
```actionscript
this._userID = param1.readUnsignedInt();
this._skillID = param1.readUnsignedInt();
this._atkTimes = param1.readUnsignedInt();
this._lostHP = param1.readUnsignedInt();
this._gainHP = param1.readInt();
this._remainHp = param1.readInt();
this._maxHp = param1.readUnsignedInt();
this._state = param1.readUnsignedInt();

var skillCount:uint = param1.readUnsignedInt();
// 读取 skillCount 个 PetSkillInfo
for(var i:uint = 0; i < skillCount; i++) {
    this._skillList.push(new PetSkillInfo(param1));
}

this._isCrit = param1.readUnsignedInt();

// 读取20个状态字节
for(var j:uint = 0; j < 20; j++) {
    this._status.push(param1.readByte());
}

// 读取6个能力等级变化字节
for(var k:uint = 0; k < 6; k++) {
    this._battleLv.push(param1.readByte());
}
```

### PetSkillInfo 结构 (8字节)

| 偏移量 | 长度 | 类型 | 字段名 | 描述 |
|--------|------|------|--------|------|
| 0 | 4 | uint32 | skillID | 技能ID |
| 4 | 4 | uint32 | pp | 当前PP值 |

**构造函数源码:**
```actionscript
this._id = param1.readUnsignedInt();
this.pp = param1.readUnsignedInt();
```

## 状态效果说明

### 状态数组 (status[20])
记录各种战斗状态效果，索引对应不同的状态类型：
- 索引0-19: 各种状态效果的剩余回合数或强度

### 能力等级数组 (battleLv[6])
记录六项能力的等级变化：
- 索引0: 攻击力 (ATK)
- 索引1: 防御力 (DEF)  
- 索引2: 特攻 (S.ATK)
- 索引3: 特防 (S.DEF)
- 索引4: 速度 (SPD)
- 索引5: 命中率 (ACC)

值域: -6 到 +6，表示能力等级的变化

## 协议使用示例

### 常见调用方式

1. **使用普通技能:**
```actionscript
SocketConnection.send(CommandID.USE_SKILL, 101); // 撞击
```

2. **逃跑/投降:**
```actionscript
SocketConnection.send(CommandID.USE_SKILL, 0); // 技能ID为0表示逃跑
```

3. **响应处理:**
```actionscript
// 注册在 ClassRegister 中
TMF.registerClass(CommandID.NOTE_USE_SKILL, UseSkillInfo);

SocketConnection.addCmdListener(CommandID.NOTE_USE_SKILL, onUseSkill);

private function onUseSkill(event:SocketEvent):void {
    var useSkillInfo:UseSkillInfo = event.data as UseSkillInfo;
    var firstAttack:AttackValue = useSkillInfo.firstAttackInfo;
    var secondAttack:AttackValue = useSkillInfo.secondAttackInfo;
    // 处理攻击结果
}
```

## 协议交互流程

```
Client                          Server
  |                               |
  |   CMD 2405 Request            |
  |------------------------------>|
  |   [skillID]                   |
  |                               |
  |   CMD 2505 Response           |
  |<------------------------------|
  |   [UseSkillInfo]              |
  |                               |
```

注意: 服务器响应使用 `CMD 2505` (`NOTE_USE_SKILL`) 而不是 `CMD 2405`

## 战斗逻辑说明

1. **攻击顺序**: 通常按速度决定，速度快的先攻击
2. **双方信息**: 即使只有一方攻击，也会返回双方的完整状态
3. **HP计算**: 
   - `lostHP`: 本回合受到的直接伤害
   - `gainHP`: 本回合的治疗量（负数表示额外伤害）
   - `remainHP`: 计算后的剩余HP
4. **暴击判定**: `isCrit` 字段指示是否发生暴击
5. **状态更新**: 包含所有状态效果和能力等级的变化

## 数据示例

### 请求示例 (Hex)
```
00 00 00 65  // skillID: 101 (撞击)
```

### 响应示例结构
```
// FirstAttackInfo (AttackValue)
12 34 56 78  // userID: 305419896
00 00 00 65  // skillID: 101  
00 00 00 01  // atkTimes: 1
00 00 00 32  // lostHP: 50
00 00 00 00  // gainHP: 0
00 00 01 90  // remainHP: 400
00 00 02 BC  // maxHP: 700
00 00 00 00  // state: 0
00 00 00 04  // skillCount: 4
// 4个 PetSkillInfo...
00 00 00 01  // isCrit: 1 (暴击)
// 20字节状态数组...
// 6字节能力等级数组...

// SecondAttackInfo (AttackValue)
// ... 第二个攻击者的完整信息
```

## Handler实现

对应的Python处理器已实现在 `src/handlers/cmd_2405_use_skill.py`，支持：

- 完整的双向数据解析
- 详细的攻击信息展示
- GameData集成显示技能名称
- 暴击、状态效果、能力变化显示
- HP变化计算和展示
- 技能PP更新显示

## 注意事项

1. **命令对应**: 请求用2405，响应通知用2505
2. **数据对齐**: 所有数值字段4字节对齐，状态数组1字节对齐
3. **技能数量**: skillCount可能为0，表示技能列表无更新
4. **HP值**: remainHP和gainHP是有符号整数，可以为负数
5. **状态效果**: status和battleLv数组中0值表示无效果

## 版本历史

- **v1.0**: 基础技能使用功能
- **v1.1**: 新增暴击判定
- **v1.2**: 扩展状态效果系统
- **v1.3**: 优化能力等级变化计算

---
*本文档基于赛尔号客户端前端ActionScript源码分析生成*
