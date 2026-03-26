import socket
import time
from core.utils import CONFIRM_BUTTON, click, find_windows_by_title,set_current_hwnd,FindPic,SEARCH_REGION,stop_flag
import psutil
import subprocess
import os
from pathlib import Path
import win32com.client
PET_NAME=None
PET_ACTIONS = {
    "皮皮": [
        ("克洛斯星一层", (41, 436)),
        ("克罗斯星二层", (912, 340)),
    ],
    "仙人球": [
        ("克罗斯星二层", (927,329)),
        ("克洛斯星一层", (10,443)),
    ]
}
# 进程名
PROCESS_NAME = "sun.exe"
ARGS = "--disable-features=CalculateNativeWinOcclusion"
# 桌面快捷方式路径（假设叫 sun.lnk）
desktop = Path(os.path.join(os.environ["USERPROFILE"], "Desktop"))
shortcut_path = desktop / "sun.lnk"

# 1. 关闭 sun.exe
def kill_process(name):
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            if proc.info['name'].lower() == name.lower():
                print(f"关闭进程: {proc.info['name']} PID={proc.info['pid']}")
                proc.kill()
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass

# 2. 从快捷方式获取真实 exe 路径
def get_target_from_shortcut(lnk_path):
    shell = win32com.client.Dispatch("WScript.Shell")
    shortcut = shell.CreateShortcut(str(lnk_path))
    return shortcut.Targetpath, shortcut.WorkingDirectory

# 3. 启动 exe 并添加参数
def start_exe(exe_path, work_dir, args):
    cmd = f'"{exe_path}" {args}'
    print(f"启动: {cmd}")
    subprocess.Popen(cmd, cwd=work_dir)



def refresh_game():
    send_cmd("unlock")
    while not stop_flag :
        kill_process(PROCESS_NAME)
        exe_path, work_dir = get_target_from_shortcut(shortcut_path)
        start_exe(exe_path, work_dir, ARGS)
        time.sleep(6)  # 等待游戏启动
        hwnds= find_windows_by_title(["骄阳号"])  # 传入列表
        set_current_hwnd(hwnds[0]) 
        res,x,y=FindPic(46,165,99,184,"开始游戏.bmp",0.8)  
        print(f"查找开始游戏结果: {res}, 坐标: ({x}, {y})")
        if res!=-1:
            click(x,y)
        time.sleep(4) 
        res,x,y=FindPic(*SEARCH_REGION,"赛尔.bmp",0.8)  
        if res!=-1:
            click(x,y)
            break
    InitGame()
    send_cmd("refresh")
    send_cmd("lock")



def InitGame():
    while not stop_flag:
        map_name, (target_x, target_y) = PET_ACTIONS[PET_NAME][0]
        res,x,y=FindPic(*SEARCH_REGION,map_name+".bmp",0.8)
        if res!=-1:
            time.sleep(1)
            res,x,y=FindPic(352,251,613,341,"电量.bmp",0.85)
            if res!=-1:
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.5)
            click(904,522)
            time.sleep(0.3)
            click(926,523)
            click(target_x, target_y)
            break

    while not stop_flag:
        map_name, (target_x, target_y) = PET_ACTIONS[PET_NAME][1]
        res,x,y=FindPic(*SEARCH_REGION,map_name+".bmp",0.85)
        if res!=-1:
            time.sleep(0.5)
            click(target_x, target_y)
            break

    while not stop_flag:
        map_name, (target_x, target_y) = PET_ACTIONS[PET_NAME][0]
        res,x,y=FindPic(*SEARCH_REGION,map_name+".bmp",0.85)
        if res!=-1:
            break




def send_cmd(cmd):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1.0)  # 设置 1 秒超时，不让它死等
        s.connect(("127.0.0.1", 56789))
        s.send(cmd.encode())
        print("返回:", s.recv(1024)) # 可选：接收返回
    except (ConnectionRefusedError, socket.timeout, Exception) as e:
        # 捕获“积极拒绝”或其他网络错误，但不抛出
        print(f"IPC命令 '{cmd}' 发送跳过 (服务器未就绪): {e}")
    finally:
        try:
            s.close()
        except:
            pass
