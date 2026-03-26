# 异色精灵捕捉系统重构方案 (In-Process Memory Approach)

## 1. 概述 (Overview)

为了提高性能并简化架构，我们将放弃文件交换 (JSON) 方案，改为 **"整合运行"** 模式。
Proxy 将作为 GUI 程序的一个后台线程运行，两者通过 **线程安全的单例对象 (Shared Memory Singleton)** 直接交换数据。

## 2. 架构设计 (Architecture)

### 核心组件

1.  **OgreManager (全局单例)**:
    - 位于 `core/ogre_manager.py`。
    - 这是一个线程安全的类，维护当前地图的精灵状态。
    - **写端**: Proxy 收到 `CMD 2004` 后，调用 `OgreManager.update_slots(slots)`。
    - **读端**: Bot (`shinyCatcher`) 每一轮循环调用 `OgreManager.get_shiny_targets()`。

2.  **Proxy Handler (`cmd_2004_ogre.py`)**:
    - 修改原有的打印逻辑。
    - 直接引用 `OgreManager` 并更新内存数据。

3.  **GUI Integration (`test_gui.py`)**:
    - 在程序启动或点击"开始"时，启动一个 `ProxyThread`。
    - 确保主程序拥有管理员权限 (WinDivert 必须)。

4.  **Coordinate Map (`map_slots.xml`)**:
    - 依然需要这个文件，用于将 0-8 号槽位映射到屏幕坐标 (x, y)。
    - `OgreManager` 负责加载和提供这个坐标映射。

## 3. 实现步骤 (Implementation Steps)

### 第一步：创建数据管理器 (Create `OgreManager`)

创建 `core/ogre_manager.py`。
它包含一个字典 `self.current_slots` (key=index, value={id, is_shiny}) 和一个 `threading.Lock()`。
同时负责加载 `proxy/data/map_slots.xml`。

### 第二步：创建坐标配置文件 (`map_slots.xml`)

创建 `proxy/data/map_slots.xml`，定义 9 个槽位的屏幕坐标。

```xml
<MapSlots>
    <Slot id="0" x="350" y="280" />
    <Slot id="1" x="450" y="320" />
    <!-- ... until id 8 -->
</MapSlots>
```

### 第三步：修改协议处理 (Update Proxy Logic)

修改 `proxy/handlers/cmd_2004_ogre.py`。
引入 `OgreManager`，在解析完数据包后调用 `OgreManager().update_slots(slots_data)`。

### 第四步：创建代理线程 (Create Proxy Thread)

创建 `threads/proxy_thread.py`。
这是一个 `QThread`，在 `run()` 方法中实例化并启动 `SeerProxy`。

### 第五步：集成 Proxy 到 GUI (Integrate Thread)

修改 `test_gui.py`：
1.  引入 `ProxyThread`。
2.  在 `MyWindow` 初始化时启动 `ProxyThread`。
3.  处理线程生命周期（随程序退出）。

### 第六步：重构捕捉逻辑 (Refactor Bot)

修改 `core/base_catcher.py`：
1.  引入 `OgreManager`。
2.  新增 `check_protocol_shiny()` 方法：
    - 调用 `OgreManager().get_shiny_targets()` 获取坐标。
    - 如果有坐标，依次点击并返回 `True`。
3.  在 `shinyCatcher` 中替换原有的 `handle_audio_detection` 或与其并存。

## 4. 关键注意事项

1.  **管理员权限**: 因为 Proxy 使用 WinDivert 驱动抓包，**必须**以管理员身份运行 `test_gui.py`。
2.  **线程安全**: `OgreManager` 内部使用了锁来保证 Proxy 线程写入和 Bot 线程读取时的安全。
3.  **依赖路径**: 确保 `test_gui.py` 运行时能正确加载 `proxy` 模块的路径。