# TCP 拆包/粘包与协议脱节修复技术报告 (TCP Reassembly & Desync Fix)

## 1. 现象描述 (Symptoms)

在引入基于缓冲区的 TCP 流式重组（Stream Reassembly）机制后，代理在处理高频或特定场景（如刷新游戏、加载大型资源）时出现了严重的协议解析异常，具体表现为：

1.  **Buffer 无限积压**：控制台日志显示 Buffer 大小持续增长（如 `Size: 10648`），且始终提示 "Incomplete frame"。
2.  **协议脱节 (Desynchronization)**：
    *   大量出现 `[Decoder] Insane Length` 错误，解析器试图分配 PB 级别的内存。
    *   解析出无效的游戏指令（如 `CMD: 624361472`, `CMD: 0`），导致业务逻辑混乱。
3.  **死循环**：在特定情况下，程序陷入死循环，不断尝试解析同一段无效数据。

## 2. 原因分析 (Root Cause Analysis)

问题核心在于**“错位解析”**与**“滑动窗口机制的副作用”**。

### 2.1 错位解析 (Misalignment)
TCP 是字节流协议，没有边界。当我们在 Buffer 中寻找 WebSocket 帧头（如 `0x81`）时，如果没有严格的校验，很容易将 payload 数据中间的某个 `0x81` 字节误认为是帧的开始。
一旦发生一次误判，解析器就会按照错误的长度字段（Payload Length）去截取数据，导致后续的所有数据全部错位。

*   **诱因**：HTTP 握手数据残留、TCP 拆包导致的断层、Payload 数据本身包含类似帧头的字节序列。

### 2.2 滑动窗口副作用 (Sliding Window Side-effect)
为了从错位中恢复，我们引入了“逐字节丢弃（Sliding Window）”机制（当 opcode 不合法时跳过 1 字节）。
然而，由于缺乏**方向性校验**（Mask 位），这个机制在遇到像 HTTP Header 这种非 WebSocket 数据时，可能会错误地锁定到一个伪造的帧头，导致“假阳性”解析。

### 2.3 死循环 (Infinite Loop)
在一次代码迭代中，为了防止 Buffer 溢出添加了保护逻辑，但不慎在 `break` 前遗漏了 `del buffer[:consumed]` 操作，导致程序不断重复处理同一段已消耗的数据。

## 3. 修复实现 (Fix Implementation)

我们实施了多层防御机制来彻底解决上述问题。

### 3.1 严格的 Mask 位校验 (Strict Mask Bit Validation)
在 `src/utils/websocket.py` 中，增加了 `is_from_client` 参数。利用 WebSocket 协议规范进行强校验：
*   **Client -> Server**：必须包含 Mask 位 (`Mask=1`)。
*   **Server -> Client**：严禁包含 Mask 位 (`Mask=0`)。
任何违反此规则的帧头都被视为错位，直接跳过。这是防止错位的最强防线。

### 3.2 协议层二次校验 (Protocol Sanity Check)
在 `src/proxy.py` 的 `process_game_frame` 中增加了业务层校验。即便 WebSocket 解码成功，也会检查解密后数据的**赛尔号协议头**：
*   如果 `Packet Length > 100,000` 或 `< 17`，视为无效数据（可能是误解出来的垃圾数据）。
*   直接丢弃此类包，防止污染后续的 `CMD` 处理逻辑。

### 3.3 HTTP 握手隔离
完善了 HTTP 握手数据的过滤逻辑。如果 Buffer 头部检测到 `GET`、`POST` 或 `HTTP` 关键字，直接清空 Buffer，防止文本协议干扰二进制协议解析。

### 3.4 连接状态重置
在检测到 TCP `SYN` 包时，强制清空对应的 Buffer 并重置所有序列号状态，确保每次刷新页面都是一次全新的会话，消除旧连接残留数据的干扰。

## 4. 结果 (Outcome)
经过上述修复，代理现在能够：
*   稳定处理刷新、重连等边缘情况。
*   自动修正微小的网络错位，并在几字节内重新对齐。
*   准确过滤非游戏流量，不再产生乱码 CMD。
