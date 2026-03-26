from core.utils import *

import win32gui
import win32process
import psutil

def _find_hwnd_by_pid(pid):
    def _by_pid(p):
        hwnds = []  # 使用列表
        def cb(hwnd_enum, _):
            if not win32gui.IsWindowVisible(hwnd_enum):
                return
            _, wpid = win32process.GetWindowThreadProcessId(hwnd_enum)
            if wpid == p:
                hwnds.append(hwnd_enum)  # 添加到列表
        win32gui.EnumWindows(cb, None)
        return hwnds[0] if hwnds else None  # 返回第一个
    
    # 2. 父进程链查找（Electron 子进程 -> 主进程）
    try:
        proc = psutil.Process(pid)
        while proc:
            proc = proc.parent()
            if not proc:
                break
            hwnd = _by_pid(proc.pid)
            if hwnd:
                return hwnd
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        pass
    
    return None
def get_hwnd_by_key(key):

    # 通过 net_connections 反查 PID->HWND
    for conn in psutil.net_connections(kind='tcp'):
        if not (conn.laddr and conn.raddr and conn.pid):
            continue
        tuples = (conn.laddr.ip, conn.laddr.port, conn.raddr.ip, conn.raddr.port)
        if tuples == key or tuples == (key[2], key[3], key[0], key[1]):
            hwnd = _find_hwnd_by_pid(conn.pid)
            if hwnd:
                # _bind_hwnd_key(hwnd, key)
                return hwnd
            return None
    return None

key=('192.168.31.13', 1635, '140.210.17.123', 10345)
res=get_hwnd_by_key(key)
print(res)