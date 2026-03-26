import threading
from typing import Optional, Tuple

class CommandQueue:
    _instance = None
    _lock = threading.Lock()
    _queue = []

    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super(CommandQueue, cls).__new__(cls)
        return cls._instance

    @classmethod
    def enqueue(cls, cmd_id: int, body: bytes):
        """
        加入待发送的指令队列
        :param cmd_id: 协议命令号
        :param body: 二进制包体
        """
        with cls._lock:
            cls._queue.append((cmd_id, body))
            print(f"[Queue] Command queued: {cmd_id}")

    @classmethod
    def dequeue(cls) -> Optional[Tuple[int, bytes]]:
        """
        取出一条待发送指令
        """
        with cls._lock:
            if cls._queue:
                return cls._queue.pop(0)
            return None

    @classmethod
    def has_command(cls) -> bool:
        with cls._lock:
            return len(cls._queue) > 0

# 全局单例辅助函数
def send_packet(cmd_id: int, body: bytes = b''):
    """
    主动发送数据包（加入发送队列，等待下一次心跳包 piggyback）
    """
    CommandQueue.enqueue(cmd_id, body)
