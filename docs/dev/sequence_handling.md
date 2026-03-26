# 中间层序列号拦截模块实现文档

## 1. 核心目标
开发一个中间层拦截模块，通过维护本地序列号计数器，实现对客户端外发数据包（Outbound Packets）的序列号（Result Field）动态重写，确保服务器端的验证一致性。

## 2. 技术逻辑

### 2.1 初始化
在 `SeerProxy` 类中定义全局变量用于状态管理：
*   `current_sequence`: 整数型，初始值为 `0`。用于存储当前应当发送的正确序列号。
*   `sequence_active`: 布尔型，初始值为 `False`。用于标记序列号同步是否已激活。

### 2.2 触发机制
系统持续监听下行（Server -> Client）数据包。
*   **触发条件**: 捕获到 Command ID 为 `1001` (登录成功/完成) 的响应包。
*   **动作**: 
    1.  将 `sequence_active` 置为 `True`。
    2.  将 `current_sequence` 重置为 `0`。
    3.  输出日志确认序列号计数器已激活。

### 2.3 拦截与修改流程
在 CMD 1001 之后，对于每一个上行（Client -> Server）数据包，执行以下操作：

1.  **解包**: 将 WebSocket 帧解码为原始游戏协议数据。
2.  **解析**: 读取游戏协议头，生成 `Packet` 对象。
3.  **重写**:
    *   将 `Packet.result` 字段的值强制替换为当前的 `current_sequence`。
    *   `current_sequence` 自增 1。
4.  **重打包**:
    *   调用 `Packet.pack()` 重新计算包长并生成二进制游戏协议数据。
    *   调用 `encode_websocket(data, mask=True)` 将数据重新封装为带有掩码的 WebSocket 帧。
5.  **注入**: 将封装好的新 Payload 覆盖原 TCP 包的 payload。
6.  **发送**: 将修改后的 TCP 包发送至网络层。

## 3. 代码实现摘要

### `src/proxy.py`
主要修改位于 `handle_packet` 方法中。

```python
# 伪代码逻辑
if direction == CLIENT_TO_SERVER and self.sequence_active:
    # 1. 覆盖序列号
    packet_obj.result = self.current_sequence
    self.current_sequence += 1
    
    # 2. 重新打包
    new_game_data = packet_obj.pack()
    new_ws_payload = encode_websocket(new_game_data, mask=True)
    
    # 3. 注入修改后的数据
    packet.tcp.payload = new_ws_payload
```

### `src/utils/websocket.py`
新增 `encode_websocket` 函数，支持将二进制数据封装为符合 WebSocket 标准的帧（支持 FIN, Opcode=Binary, Masking）。

## 4. 注意事项
*   **WebSocket Masking**: 客户端发往服务器的包**必须**进行掩码处理（Masking），否则服务器可能会断开连接。
*   **Checksum**: `pydivert` 库在 `w.send(packet)` 时会自动重新计算 TCP/IP 校验和，因此应用层无需处理。
*   **并发安全**: 当前模型为单线程处理网络包，不存在并发竞争问题。
