import logging
import psutil
import pymem
import pymem.pattern
from contextlib import contextmanager


def get_largest_child_pid(proc):
    """
    找到 sun.exe 的所有子进程，返回内存占用最大的子进程 PID
    """
    try:
        # 遍历所有进程，找到目标进程
        children = proc.children(recursive=True)
        if not children:
            return None
        # 找出内存占用最大的子进程
        largest_child = max(children, key=lambda p: p.memory_info().rss)
        return largest_child.pid
    except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess) as e:
        print(f"获取子进程时出错: {e}")
        return None

def scan_game_instances():
    """
    遍历所有游戏进程，返回子进程 PID 列表
    """
    pids = []
    for proc in psutil.process_iter(['pid', 'name']):
        if proc.info['name'] == "SeerGame.exe":
            pid = get_largest_child_pid(proc)
            if pid:
                pids.append(pid)
    return pids


def find_aob_address(pm, pattern):
    try:
        # 使用 pymem 的 scan_pattern_page 函数进行扫描
        aob_address = pymem.pattern.pattern_scan_all(pm.process_handle,pattern)
        if aob_address:
            return aob_address
        
    except Exception as e:
        print(f"扫描过程中发生错误：{e}")
    
    return None

class XinScript:
    # 这里的 Tower_raw_pattern 是完整的特征码，用于定位
    TOWER_RAW_PATTERN = b'\x66\x0F\xD6\x41\x50\x8D'
    # 补丁字节：xorpd xmm0, xmm0 (4字节) + nop (1字节) = 5字节
    TOWER_PATCH_BYTES = b'\x90\x90\x90\x90\x90' # 4字节指令 + 5字节 NOP

    #锁图
    LOCK_RAW_PATTERN = b'\x89\x58\x10\x8B\x5D\xD8'
    LOCK_PATCH_BYTES = b'\x90\x90\x90'

    # BOSS训练
    TRAINING_RAW_PATTERN = b'\xF3\x0F\x7E\x40\x30\x66\x0F\x2E'
    TRAINING_PATCH_BYTES = b'\x66\x0F\xEF\xC0\x90'
    

    # 用于管理状态的静态变量
    injected_pids = set()
    restore_info = {} # 格式: {pid: address}

    @staticmethod
    def enable_script(TRAINING=False, MAP=False):
        logger = logging.getLogger('pymem')
        logger.setLevel(logging.ERROR)
        current_pids = scan_game_instances()
        if not current_pids:
            print("[!] 未发现正在运行的游戏子进程。")
            return

        for pid in current_pids:
            success = XinScript._inject_process(pid, TRAINING, MAP)
            if success:
                XinScript.injected_pids.add(pid)
                print(f"[+] PID {pid} 修改成功。")

        # 清理已经关闭的进程记录
        current_pids_set = set(current_pids)
        dead_pids = XinScript.injected_pids - current_pids_set
        for dead in dead_pids:
            XinScript.injected_pids.remove(dead)
            XinScript.restore_info.pop(dead, None)
        return True


# 【新增】专门用于恢复锁图的方法
    @staticmethod
    def disable_lock():
        """
        恢复锁图功能：将之前记录的地址改回原始字节
        """
        if not XinScript.restore_info:
            print("[!] 没有发现已开启的锁图记录。")
            return

        for pid, address in list(XinScript.restore_info.items()):
            try:
                pm = pymem.Pymem()
                pm.open_process_from_id(pid)
                # 直接恢复为原始特征码
                pm.write_bytes(address, XinScript.LOCK_RAW_PATTERN, len(XinScript.LOCK_RAW_PATTERN))
                pm.close_process()
                print(f"[+] PID {pid}: 锁图已恢复。")
                # 恢复后移除记录
                XinScript.restore_info.pop(pid)
            except Exception as e:
                print(f"[x] PID {pid} 恢复异常 (可能进程已关闭): {e}")
                XinScript.restore_info.pop(pid)

    @staticmethod
    def _inject_process(pid, TRAINING=False, MAP=False):
        try:
            # 使用 context manager 自动关闭 handle 会更安全
            pm = pymem.Pymem()
            pm.open_process_from_id(pid)
            # 直接使用 bytes 进行扫描
            if TRAINING:
                inject_addr= pymem.pattern.pattern_scan_all(pm.process_handle, XinScript.TRAINING_RAW_PATTERN)
            elif MAP:
                inject_addr = pymem.pattern.pattern_scan_all(pm.process_handle, XinScript.LOCK_RAW_PATTERN)
            else:
                inject_addr = pymem.pattern.pattern_scan_all(pm.process_handle, XinScript.TOWER_RAW_PATTERN)
            if not inject_addr:
                print(f"[-] PID {pid}: 未找到，可能已修改过或版本不符。")
                pm.close_process()
                return False
            # 写入 Patch
            if TRAINING:
                pm.write_bytes(inject_addr, XinScript.TRAINING_PATCH_BYTES, len(XinScript.TRAINING_PATCH_BYTES))
            elif MAP:
                # 【修改】如果是锁图，先记录地址，再写入 Patch
                XinScript.restore_info[pid] = inject_addr
                pm.write_bytes(inject_addr, XinScript.LOCK_PATCH_BYTES, len(XinScript.LOCK_PATCH_BYTES))
            else:
                pm.write_bytes(inject_addr, XinScript.TOWER_PATCH_BYTES, len(XinScript.TOWER_PATCH_BYTES))
            # 记录地址以便恢复
            XinScript.restore_info[pid] = inject_addr
            pm.close_process()
            return True
        except Exception as e:
            print(f"[x] PID {pid} 注入异常: {e}")
            return False
