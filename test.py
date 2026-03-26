from core.utils import *

import win32gui
import win32process
import psutil

def _find_hwnds_by_pid_debug(pid, debug=True):
    def _by_pid(p, debug_prefix=""):
        hwnds = []
        def cb(hwnd, _):
            if not win32gui.IsWindowVisible(hwnd):
                return
            _, wpid = win32process.GetWindowThreadProcessId(hwnd)
            if wpid == p:
                window_text = win32gui.GetWindowText(hwnd)
                if debug:
                    print(f"{debug_prefix}找到可见窗口: PID={p}, HWND={hwnd}, 标题='{window_text[:50]}'")
                hwnds.append(hwnd)
        win32gui.EnumWindows(cb, None)
        return hwnds
    
    if debug:
        print(f"\n开始查找PID: {pid}")
    
    # 1. 直接查
    if debug:
        print(f"1. 直接检查PID {pid}")
    hwnds = _by_pid(pid, "  ")
    if hwnds:
        if debug:
            print(f"✓ 在PID {pid} 本身找到 {len(hwnds)} 个窗口")
        return hwnds
    
    if debug:
        print(f"  PID {pid} 本身没有可见窗口")
    
    # 2. 父进程查（Electron 子进程->主进程）
    try:
        proc = psutil.Process(pid)
        if debug:
            print(f"2. 向上查找父进程链")
            print(f"   当前进程: {proc.name()} (PID: {pid})")
        
        parent_chain = []
        current = proc
        while True:
            parent = current.parent()
            if not parent:
                break
            parent_chain.append(parent)
            current = parent
        
        if debug and parent_chain:
            print(f"   父进程链: {' -> '.join([f'{p.name()}({p.pid})' for p in parent_chain])}")
        
        for parent in parent_chain:
            if debug:
                print(f"   检查父进程: {parent.name()} (PID: {parent.pid})")
            hwnds = _by_pid(parent.pid, "     ")
            if hwnds:
                if debug:
                    print(f"✓ 在父进程 {parent.name()}({parent.pid}) 找到 {len(hwnds)} 个窗口")
                return hwnds
        
        if debug:
            print(f"   父进程链中没有找到窗口")
            
    except psutil.NoSuchProcess:
        if debug:
            print(f"  ✗ 进程不存在")
        return []
    except Exception as e:
        if debug:
            print(f"  ✗ 处理父进程时出错: {e}")
    
    # 3. 也可查子进程
    try:
        proc = psutil.Process(pid)
        if debug:
            print(f"3. 向下查找子进程")
        
        children = list(proc.children(recursive=True))
        if debug:
            print(f"   找到 {len(children)} 个子进程")
            for child in children[:5]:  # 只显示前5个
                print(f"     - {child.name()} (PID: {child.pid})")
            if len(children) > 5:
                print(f"     ... 等 {len(children)} 个")
        
        for child in children:
            if debug:
                print(f"   检查子进程: {child.name()} (PID: {child.pid})")
            hwnds = _by_pid(child.pid, "     ")
            if hwnds:
                if debug:
                    print(f"✓ 在子进程 {child.name()}({child.pid}) 找到 {len(hwnds)} 个窗口")
                return hwnds
                
    except Exception as e:
        if debug:
            print(f"  ✗ 处理子进程时出错: {e}")
    
    if debug:
        print(f"✗ 最终未找到任何可见窗口")
    return []

# 测试你的PID
pid = 34240
res = _find_hwnds_by_pid_debug(pid, debug=True)
print(f"\n最终结果: {res}")