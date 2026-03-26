import logging
import psutil
import pymem
import pymem.pattern
import re  # <--- 新增：引入正则模块
import sys
import os
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
        if proc.info['name'] == "sun.exe":
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

class JiaoyangScript:
    # 这里的 Boss_raw_pattern 是完整的特征码，用于定位
    BOSS_RAW_PATTERN = b'\xF2\x0F\x10\x40\x50\x66\x0F\x2E\xC1'
    # 补丁字节：xorpd xmm0, xmm0 (4字节) + nop (1字节) = 5字节
    PATCH_BYTES = b'\x66\x0F\x57\xC0\x90'
    # 原始字节：用于 disable 时恢复数据
    ORIGINAL_BYTES = b'\xF2\x0F\x10\x40\x50'

    # 用于管理状态的静态变量
    injected_pids = set()
    restore_info = {} # 格式: {pid: address}

    @staticmethod
    def enable_script():
        logger = logging.getLogger('pymem')
        logger.setLevel(logging.ERROR)
        current_pids = scan_game_instances()
        if not current_pids:
            print("[!] 未发现正在运行的游戏子进程。")
            return

        for pid in current_pids:
            success = JiaoyangScript._inject_process(pid)
            if success:
                JiaoyangScript.injected_pids.add(pid)
                print(f"[+] PID {pid} 修改成功。")

        # 清理已经关闭的进程记录
        current_pids_set = set(current_pids)
        dead_pids = JiaoyangScript.injected_pids - current_pids_set
        for dead in dead_pids:
            JiaoyangScript.injected_pids.remove(dead)
            JiaoyangScript.restore_info.pop(dead, None)
        return True

    @staticmethod
    def disable_script():
        """
        关闭功能：恢复所有已修改的内存
        """
        for pid, address in list(JiaoyangScript.restore_info.items()):
            JiaoyangScript._recover_process(pid, address)
        
        JiaoyangScript.injected_pids.clear()
        JiaoyangScript.restore_info.clear()
        print("[*] 所有功能已停用并尝试恢复。")

    @staticmethod
    def _inject_process(pid):
        try:
            # 使用 context manager 自动关闭 handle 会更安全
            pm = pymem.Pymem()
            pm.open_process_from_id(pid)
            # 直接使用 bytes 进行扫描
            inject_addr = pymem.pattern.pattern_scan_all(pm.process_handle, JiaoyangScript.BOSS_RAW_PATTERN)
            if not inject_addr:
                print(f"[-] PID {pid}: 未找到，可能已修改过或版本不符。")
                pm.close_process()
                return False
            # 写入 Patch
            pm.write_bytes(inject_addr, JiaoyangScript.PATCH_BYTES, len(JiaoyangScript.PATCH_BYTES))
            # 记录地址以便恢复
            JiaoyangScript.restore_info[pid] = inject_addr
            pm.close_process()
            return True
        except Exception as e:
            print(f"[x] PID {pid} 注入异常: {e}")
            return False

    @staticmethod
    def _recover_process(pid, address):
        try:
            pm = pymem.Pymem()
            pm.open_process_from_id(pid)
            pm.write_bytes(address, JiaoyangScript.ORIGINAL_BYTES, len(JiaoyangScript.ORIGINAL_BYTES))
            print(f"[v] PID {pid} 内存已恢复。")
            pm.close_process()
        except:
            pass # 进程已关闭则忽略