# TCP 拆包与粘包处理技术说明 (TCP Reassembly)

## 背景
在早期版本的 SeerProxy 中，数据包处理逻辑是基于单个 TCP 报文段（Segment）直接进行 WebSocket 解码的。这种方式基于一个假设：一个 TCP 包包含且仅包含一个完整的 WebSocket 帧。

虽然赛尔号的协议包通常较小，但在处理大数据量场景（如加载完整背包、好友列表、复杂地图资源）时，会出现以下问题：
1.  **拆包（Fragmentation）**：一个大的 WebSocket 帧被拆分成多个 TCP 包发送。代理只处理第一个包（导致解析失败），并忽略后续的包。
2.  **粘包（Stickiness）**：多个小的 WebSocket 帧被合并到一个 TCP 包中发送。代理只解析第一个帧，后续帧被丢弃。

## 解决方案：流式重组 (Stream Reassembly)

为了解决上述问题，我们引入了基于内存缓冲区的流式重组机制。

### 核心组件

#### 1. 缓冲区管理 (`src/proxy.py`)
我们在 `SeerProxy` 类中维护了一个字典 `self.buffers`，用于存储每个 TCP 连接的待处理数据。

*   **Key**: 四元组 `(SrcIP, SrcPort, DstIP, DstPort)`，确保唯一标识一个 TCP 流的方向。
*   **Value**: `bytearray`，动态增长的字节流。

#### 2. 帧检测与切分 (`src/utils/websocket.py`)
新增函数 `try_decode_frame(data)`，用于“窥探”缓冲区头部：
*   **输入**: 字节流。
*   **逻辑**: 解析 WebSocket 头部（Opcode, Payload Length, Masking Key），计算帧的**完整预期长度**。
*   **输出**: 
    *   `decoded_payload`: 解析后的数据（如果是 Text/Binary 帧）。
    *   `consumed_bytes`: 该帧在缓冲区中占用的实际字节数。

### 处理流程

1.  **捕获**: WinDivert 捕获到一个 TCP 数据包。
2.  **入队**: 将 `packet.tcp.payload` 追加（Extend）到对应流的 Buffer 末尾。
3.  **循环切分**:
    *   调用 `try_decode_frame(buffer)`。
    *   **情况 A (完整帧)**: 缓冲区数据量 >= 帧长度。
        *   从 Buffer 头部**切除** `consumed_bytes` 长度的数据。
        *   将解码后的 Payload 交给 `process_game_frame` 处理业务逻辑。
        *   **继续循环**，尝试解析 Buffer 里剩下的数据（处理粘包）。
    *   **情况 B (数据不足)**: 缓冲区数据量 < 帧长度。
        *   返回 `consumed=0`。
        *   **跳出循环**，保留 Buffer 中的数据，等待下一个 TCP 包（处理拆包）。
4.  **转发**: 原样转发原始 TCP 包，确保游戏连接不受影响。

## 注入逻辑的兼容性
注入（Injection）逻辑依赖于修改当前数据包的 SEQ 号。在重组模式下，注入时机被移动到了 `process_game_frame` 内部。
这意味着只有在成功组装并解析出一个客户端指令后，代理才会检查命令队列并尝试注入。注入所使用的 `packet` 对象是触发当前帧解析完成的那个 TCP 包。

## 代码变更概览
*   **`src/utils/websocket.py`**: 新增 `try_decode_frame`。
*   **`src/proxy.py`**:
    *   引入 `self.buffers`。
    *   重构 `handle_packet` 为“累积-切分”模式。
    *   业务逻辑抽离至 `process_game_frame`。

## 验证案例
| 场景 | 现象 | 旧版行为 | 新版行为 |
| :--- | :--- | :--- | :--- |
| **普通指令** (Len=50) | 单包单帧 | 正常解析 | 正常解析 |
| **大列表** (Len=3000) | 分为 1460 + 1460 + 80 三个包 | 丢弃包1(不完整)，忽略包2/3(无头) | 缓存包1/2，收到包3后一次性输出 |
| **极速连点** | 一个包包含 CMD_A, CMD_B | 只执行 CMD_A，忽略 CMD_B | 循环执行 CMD_A 和 CMD_B |
