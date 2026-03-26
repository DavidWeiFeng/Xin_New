# Command 105: Get Recommended Server List (COMMEND_ONLINE)

## 概述
客户端登录成功后，向登录服务器发送此命令以获取可用的游戏服务器（分服）列表。

**Command ID:** `105`
**方向:** Client -> Server -> Client

## 请求 (Request)
**Body:** 无 (或由头部长度决定，通常为空)

## 响应 (Response)
服务器返回二进制数据流，由客户端的 `others.CommendSvrInfo` 类解析。

### 1. 头部信息 (Header Info)

| 顺序 | 字段名 | 类型 | 长度 (Bytes) | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `maxOnlineID` | UInt32 (BE) | 4 | 当前最大的服务器 ID，用于 UI 计算分页总数。 |
| 2 | `isVIP` | UInt32 (BE) | 4 | 用户的 VIP 状态标识（如超能NoNo状态）。 |
| 3 | `onlineCnt` | UInt32 (BE) | 4 | 本次响应中包含的服务器数量 ($N$)。 |

### 2. 服务器列表 (Server List)
紧接着头部信息，包含 $N$ 个服务器信息块。每个块固定 **30 字节**。由 `others.ServerInfo` 类解析。

| 顺序 | 字段名 | 类型 | 长度 (Bytes) | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `onlineID` | UInt32 (BE) | 4 | 服务器的唯一 ID。 |
| 2 | `userCnt` | UInt32 (BE) | 4 | 当前在线用户数量。 |
| 3 | `ip` | String (UTF-8) | 16 | 服务器 IP 地址。定长 16 字节，不足部分用 `\0` 填充。 |
| 4 | `port` | UInt16 (BE) | 2 | 服务器 TCP 端口号。 |
| 5 | `friends` | UInt32 (BE) | 4 | 该服务器上的好友数量（用于 UI 显示热度/好友）。 |

### 3. 附加数据 (Friend Data)
在读取完 $N$ 个服务器块后，剩余的所有数据被视为好友/黑名单相关数据。

| 顺序 | 字段名 | 类型 | 长度 (Bytes) | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `friendCnt` | UInt32 (BE) | 4 | 好友列表数量。 |
| ... | `friends` | ... | ... | (后续根据好友协议解析) |
| ... | `blacklistCnt`| UInt32 (BE) | 4 | 黑名单列表数量。 |
| ... | `blacklist` | ... | ... | (后续根据黑名单协议解析) |

## 数据示例 (Hex)

```
00 00 00 1D       ; maxOnlineID = 29
00 00 00 01       ; isVIP = 1
00 00 00 02       ; onlineCnt = 2 (返回2个服务器)

; --- Server 1 ---
00 00 00 01       ; ID = 1
00 00 00 64       ; Users = 100
31 32 37 2E 30 2E 30 2E 31 00 00 00 00 00 00 00 ; IP = "127.0.0.1" (padded)
13 89             ; Port = 5001
00 00 00 05       ; Friends = 5

; --- Server 2 ---
00 00 00 02       ; ID = 2
00 00 00 32       ; Users = 50
31 32 37 2E 30 2E 30 2E 31 00 00 00 00 00 00 00 ; IP = "127.0.0.1" (padded)
13 8A             ; Port = 5002
00 00 00 00       ; Friends = 0

; --- Friend Data ---
00 00 00 00       ; Friend Count = 0
00 00 00 00       ; Blacklist Count = 0
```
