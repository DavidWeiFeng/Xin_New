import math
from ddddocr import DdddOcr
import numpy as np
from functools import reduce
import time
import cv2
import os
import pygetwindow as gw
import random
from pycaw.pycaw import AudioUtilities, IAudioMeterInformation
import logging
import uuid  # 用来生成随机文件名
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
import io
import json
import mss
from PIL import Image
import win32gui
from functools import wraps
import threading
import win32process
import psutil
import requests
import functools
import inspect
from email.mime.text import MIMEText
from email.utils import formataddr
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
import win32process
import win32con
import win32api
import win32ui
import ctypes
from pynput.mouse import Button, Controller
from core.backendMouse import backendMouse
from config.config import Auth
import sys
import os
mouse = Controller()
PIC_PATH = ""
SEARCH_REGION=(0,0,956,590)
CONFIRM_BUTTON=(479,376)
BALL_REGION=(325,445,622,564)
HOME=(777,562)
click_lock = threading.Lock()  # 定义一个全局的“遥控器锁”
stop_flag = False

bm=backendMouse()
from config.email_config_dialog import EMAIL_CONFIG_PATH
from config.config import REGION_CONFIG

refresh_lock = threading.Lock()

_thread_local = threading.local()

# 全局配置类
class Config:
    GAME_NAME = ["xin计划"]
    MODULE_NAME = ["SeerGame"]
    ONLY_HIGH_NIER = False
    KILL_SHINY=False

def set_current_hwnd(hwnd):
    """设置当前线程的hwnd"""
    _thread_local.hwnd = hwnd

def get_current_hwnd():
    """获取当前线程的hwnd，如果没有设置则返回默认值-1,如果你没有手动传入 process_hwnd，它就自动从当前线程取："""
    return getattr(_thread_local, 'hwnd', -1)

def auto_fill_process_hwnd(func):
    sig = inspect.signature(func)

    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        bound_args = sig.bind_partial(*args, **kwargs)
        bound_args.apply_defaults()

        # 如果 process_hwnd 还没被传入（不论是位置还是关键字）
        if 'process_hwnd' in sig.parameters and 'process_hwnd' not in bound_args.arguments:
            kwargs['process_hwnd'] = get_current_hwnd()
        return func(*args, **kwargs)

    return wrapper

def find_windows_by_title(title_substring: list[str]) -> list[int]:
    """
    查找所有标题中包含指定子串的窗口，并返回它们的 HWND 列表。
    
    :param title_substring: 要匹配的窗口标题子串
    :return: 匹配到的窗口句柄列表
    """
    import win32gui
    hwnd_list = []
    def enum_window_callback(hwnd, _):
        if win32gui.IsWindowVisible(hwnd):
            title = win32gui.GetWindowText(hwnd)
            if any(sub in title for sub in title_substring):
                hwnd_list.append(hwnd)
    win32gui.EnumWindows(enum_window_callback, None)
    return hwnd_list

def get_all_hwnds():
    return find_windows_by_title(Config.GAME_NAME)  # 替换为你的浏览器窗口标题
def get_pid_by_hwnd(hwnd: int) -> int:
    """
    根据窗口句柄获取所属进程的 PID
    """
    _, pid = win32process.GetWindowThreadProcessId(hwnd)
    return pid

@auto_fill_process_hwnd
def get_window_pos(process_hwnd):
    if process_hwnd==-1:
        hwnds=get_all_hwnds()
        if hwnds:
            hwnd=hwnds[0]
        if not hwnds:
            logging.info("窗口未找到")
            return -1, -1
        # 获取客户区左上角相对于窗口的位置（通常是 (0, 0)）
        point = (0, 0)
        # 将客户区坐标转换为屏幕坐标
        screen_point = win32gui.ClientToScreen(hwnd, point)
        return screen_point
    else:
        point = (0, 0)
        # 将客户区坐标转换为屏幕坐标
        screen_point = win32gui.ClientToScreen(process_hwnd, point)
        return screen_point

    
def get_window_offset():
    """返回当前游戏窗口左上角的偏移坐标"""
    x, y = get_window_pos()
    if x == -1:
        logging.warning("无法获取游戏窗口位置")
        return -1,-1
    return x, y
    
        
def load_email_config():
    if not os.path.exists(EMAIL_CONFIG_PATH):
        return None  # 配置不存在
    with open(EMAIL_CONFIG_PATH, 'r', encoding='utf-8') as f:
        return json.load(f)
    
def SetPath():
    """设置图片文件夹路径"""
    global PIC_PATH
    current_dir = os.path.dirname(os.path.abspath(__file__))
    pre_dir=os.path.dirname(current_dir)
    PIC_PATH = os.path.join(pre_dir, "assets")
SetPath()
ocr=DdddOcr()

@auto_fill_process_hwnd
def click(x,y,process_hwnd):
    #接收相对坐标，内部自动转换为绝对坐标
    win_x, win_y = get_window_offset()

    # 缩放坐标后进行点击
    abs_x = int(win_x + x )
    abs_y = int(win_y + y )

    # 加锁：保证下面的点击过程是“独占”的
    if process_hwnd==-1:
        mouse.position = (abs_x, abs_y)
        time.sleep(0.1)  # 模拟 human-like 延迟
        # 左键单击
        mouse.press(Button.left)
        time.sleep(0.02)
        mouse.release(Button.left)
    else:
        bm.LeftClick(process_hwnd,x,y)

@auto_fill_process_hwnd
def protocol_click(x,y,process_hwnd):
    #接收相对坐标，内部自动转换为绝对坐标
    win_x, win_y = get_window_offset()

    # 缩放坐标后进行点击
    abs_x = int(win_x + x )
    abs_y = int(win_y + y )  # 协议点击时 Y 坐标下移15像素，适应协议偏差

    # 加锁：保证下面的点击过程是“独占”的
    if process_hwnd==-1:
        mouse.position = (abs_x, abs_y)
        time.sleep(0.1)  # 模拟 human-like 延迟
        # 左键单击
        mouse.press(Button.left)
        time.sleep(0.02)
        mouse.release(Button.left)
    else:
        bm.LeftClick(process_hwnd,x,y+28)

def catch_exception(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception:
            logging.error("发生未捕获异常", exc_info=True)
            # 可选：也可以 logging.info(traceback.format_exc())
    return wrapper

@auto_fill_process_hwnd
def guussian_move_in_rect(x1, y1, x2, y2,process_hwnd):
    """在矩形区域内以高斯分布随机点击"""
    center_x = (x1 + x2) / 2
    center_y = (y1 + y2) / 2
    sigma_x = (x2 - x1) / 6
    sigma_y = (y2 - y1) / 6
    x = int(random.gauss(center_x, sigma_x))
    y = int(random.gauss(center_y, sigma_y))
    # 限制点击坐标不能超出边界
    x = max(x1, min(x, x2))
    y = max(y1, min(y, y2))
    x_w,y_w=get_window_offset()

    if process_hwnd==-1:
        mouse.position = (x+x_w,y+y_w)
    else:
        bm.MoveTo(process_hwnd, x,y)

def gaussian_click_in_rect(x1, y1, x2, y2):
    center_x = (x1 + x2) / 2
    center_y = (y1 + y2) / 2
    sigma_x = (x2 - x1) / 6
    sigma_y = (y2 - y1) / 6
    x = int(random.gauss(center_x, sigma_x))
    y = int(random.gauss(center_y, sigma_y))
    # 限制点击坐标不能超出边界
    x = max(x1, min(x, x2))
    y = max(y1, min(y, y2))
    click(x, y)# 此处 click 已自动加偏移

@auto_fill_process_hwnd
def random_click(x, y,process_hwnd):
    #接收相对坐标，内部自动转换为绝对坐标
    """
    添加随机偏移的点击
    :param x: 相对x坐标
    :param y: 相对y坐标
    偏移范围：4-12像素
    """
    offset_x = random.randint(1,3) * random.choice([-1, 1])
    offset_y = random.randint(1,3) * random.choice([-1, 1])
    win_x, win_y = get_window_offset()
    abs_x = int(win_x + x+offset_x )
    abs_y = int(win_y + y+offset_y)
    if process_hwnd==-1:
        mouse.position=(abs_x,abs_y)
        mouse.press(Button.left)
        time.sleep(0.02)
        mouse.release(Button.left)
    else:
        bm.LeftClick(process_hwnd, x+offset_x,y+offset_y)

@auto_fill_process_hwnd
def fast_move(x,y,process_hwnd):
    win_x, win_y = get_window_offset()
    abs_x = int(win_x + x)
    abs_y = int(win_y + y)
    if process_hwnd==-1:
        mouse.position = (abs_x, abs_y)
    else:
        bm.MoveTo(process_hwnd, x,y)

def click_region(region_name: str):
    if region_name not in REGION_CONFIG:
        raise ValueError(f"区域未定义：{region_name}")
    x1, y1, x2, y2 = REGION_CONFIG[region_name]
    gaussian_click_in_rect(x1, y1, x2, y2)

def move_region(region_name: str):
    if region_name not in REGION_CONFIG:
        raise ValueError(f"区域未定义：{region_name}")
    
    x1, y1, x2, y2 = REGION_CONFIG[region_name]
    guussian_move_in_rect(x1, y1, x2, y2)

from concurrent.futures import ThreadPoolExecutor
 # 创建全局线程池，限制并发数
_upload_executor = ThreadPoolExecutor(max_workers=3, thread_name_prefix="ImageUpload")   
def capture_audio_screenshot(save_name="有音频", upload=False):
    try:
        img = capture_window_region(*SEARCH_REGION)  
        pil_img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        filename = f"{save_name}.png"
        pil_img.save(filename)
        logging.info(f"保存截图成功: {save_name}")
        
        if upload:
            # 使用线程池，不会无限创建线程
            _upload_executor.submit(upload_image_to_server, filename)
        
        return True
    except Exception as e:
        logging.warning(f"截图失败: {e}")
        return False
#101.43.13.55
def upload_image_to_server(image_path, server_ip="101.43.13.55", port=5000):
    """
    上传图片到Flask服务器
    :return: bool 上传是否成功
    """
    try:
        url = f"http://{server_ip}:{port}/upload"
        # 检查文件是否存在
        if not os.path.exists(image_path):
            logging.error(f"图片文件不存在: {image_path}")
            return False
        
        # 准备文件上传
        with open(image_path, 'rb') as f:
            files = {'file': (os.path.basename(image_path), f, 'image/png')}           
            # 发送POST请求上传文件
            response = requests.post(url, files=files, timeout=30)           
            if response.status_code == 200:
                result = response.json()
                if result.get('success', False):
                    return True
                else:
                    logging.error(f"服务器返回错误: {result.get('message', 'Unknown error')}")
                    return False
            else:
                logging.error(f"图片HTTP请求失败，状态码: {response.status_code}")
                return False
                
    except requests.exceptions.Timeout:
        logging.error("上传请求超时")
        return False
    except requests.exceptions.ConnectionError:
        logging.error("无法连接到服务器")
        return False
    except Exception as e:
        logging.error(f"上传图片时发生未知错误: {e}")
        return False
def random_sleep(base_time):
    """
    随机延迟
    :param base_time: 基础时间
    延迟范围：基础时间 + 0.2-0.3秒
    """
    additional_time = random.uniform(0.20, 0.3)
    time.sleep(base_time + additional_time)

def activate_window():
    hwnds=get_all_hwnds()
    for hwnd in hwnds:
        try:
            # 还原窗口（如果最小化了）
            win32gui.ShowWindow(hwnd, win32con.SW_RESTORE)
            # 设置前台
            win32api.keybd_event(win32con.VK_MENU, 0, 0, 0)  # 按下 Alt
            time.sleep(0.05)
            win32api.keybd_event(win32con.VK_MENU, 0, win32con.KEYEVENTF_KEYUP, 0)
            win32gui.SetForegroundWindow(hwnd)    
        except Exception as e:
            logging.warning(f"激活窗口失败: hwnd={hwnd}, 错误: {e}")      

@auto_fill_process_hwnd
def activate_single_window(process_hwnd):
    try:
        # 还原窗口（如果最小化了）
        win32gui.ShowWindow(process_hwnd, win32con.SW_RESTORE)
        # 设置前台
        win32api.keybd_event(win32con.VK_MENU, 0, 0, 0)  # 按下 Alt
        time.sleep(0.05)
        win32api.keybd_event(win32con.VK_MENU, 0, win32con.KEYEVENTF_KEYUP, 0)
        win32gui.SetForegroundWindow(process_hwnd)    
    except Exception as e:
        logging.warning(f"激活窗口失败: hwnd={process_hwnd}, 错误: {e}")    
        
def mss_screenshot(x1, y1, x2, y2):
    img=capture_window_region(x1,y1,x2,y2)
    img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    return img
    
def get_pixel_rgb(x, y):
    img = capture_window_region(x, y, x + 1, y + 1)
    if np.max(img) == 0 and np.min(img) == 0:
    # if img is None or img.shape[0] == 0 or img.shape[1] == 0:
        return np.array([0, 0, 0], dtype=np.uint8)
    # img 是 numpy 数组，格式为 [height, width, channels]
    b, g, r = img[0, 0]  # 注意OpenCV默认是BGR
    return (r, g, b)
@auto_fill_process_hwnd
def is_process_playing_audio(process_hwnd: int, threshold: float = 0.1) -> bool:
    # 自动获取 hwnd
    if process_hwnd == -1:
        process_hwnd = get_all_hwnds()[0] if get_all_hwnds() else -1
        if process_hwnd == -1:
            print("[ERROR] 未找到窗口 'XIN计划'")
            return False

    try:
        parent_pid = get_pid_by_hwnd(process_hwnd)
        parent = psutil.Process(parent_pid)
        children = parent.children(recursive=True)
        cef_pids = [p.pid for p in children if any(name in p.name() for name in Config.MODULE_NAME)]
    except Exception as e:
        logging.info(f"[ERROR] 获取子进程失败: {e}")
        return False
    sessions = AudioUtilities.GetAllSessions()
    for session in sessions:
        proc = session.Process
        if proc and proc.pid in cef_pids:
            try:
                audio_meter = session._ctl.QueryInterface(IAudioMeterInformation)
                peak = audio_meter.GetPeakValue()
                print(f"检测到音频峰值: {peak}")
                if peak > threshold:
                    print(f"音频峰值 {peak} 超过阈值 {threshold}")
                    return True
            except Exception:
                continue
    return False
def wait_for_audio_activity(duration: float = 1.0, interval: float = 0.01) -> bool:
    """
    持续检查 process_name 是否播放音频，持续 duration 秒，只要检测到一次就返回 True。
    """
    start = time.time()
    while time.time() - start < duration:
        if is_process_playing_audio():
            return True
    return False
def hex_to_rgb(hex_color):
    """HEX 转 RGB"""
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def color_distance(c1, c2):
    """计算两种 RGB 颜色的欧几里得距离"""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1, c2)))

def find_color_in_region(x1, y1, x2, y2, target_rgb):
    # 截取指定区域的屏幕
    img= capture_window_region(x1, y1, x2, y2)
    # 获取图像尺寸
    if np.max(img) == 0 and np.min(img) == 0:
        return -1,-1,-1
    height, width = img.shape[:2]
    
    # 将目标RGB转换为numpy数组
    target_color = np.array(hex_to_rgb(target_rgb))
    
    # 重塑图像数组，使其更容易进行向量化操作
    r = img[:,:,2].reshape(1, height * width)
    g = img[:,:,1].reshape(1, height * width)
    b = img[:,:,0].reshape(1, height * width)
    
    # 使用numpy的where函数找到匹配的像素
    key_r = np.where(r == target_color[0])
    key_g = np.where(g == target_color[1])
    key_b = np.where(b == target_color[2])
    
    # 如果所有通道都有匹配的像素
    if len(key_r[0]) and len(key_g[0]) and len(key_b[0]):
        # 找到所有通道都匹配的像素位置
        keys = reduce(np.intersect1d, [key_r[1], key_g[1], key_b[1]])
        if len(keys):
            # 将一维索引转换为二维坐标
            y, x = divmod(keys[0], width)
            # 返回相对于原始区域的坐标
            return 1,x1 + x, y1 + y
    return -1,-1, -1

def is_color_at_point(x, y, target_rgb,tolerance=10):
    
    """
    判断屏幕上某一点的颜色是否与目标 RGB 值相同（可选容差）。 相对坐标
    
    参数:
        x, y: 需要检查的屏幕坐标
        target_rgb: 目标颜色（可以是 RGB 元组或十六进制字符串）
        tolerance: 容差值，默认为0表示精确匹配
        
    返回:
        True 表示颜色匹配，False 表示不匹配
    """
    # 支持传入 hex 字符串
    if isinstance(target_rgb, str):
        target_rgb = hex_to_rgb(target_rgb)

    # 获取屏幕该点颜色
    pixel_rgb = get_pixel_rgb(x, y)

    # 判断是否在容差范围内
    diff = np.abs(np.array(pixel_rgb) - np.array(target_rgb))
    res=np.all(diff <= tolerance)   
    print(f"找色结果{res}")
    return res

def imread(path):
    """读取图片（支持中文路径）"""
    return cv2.imdecode(np.fromfile(path, dtype=np.uint8), cv2.IMREAD_COLOR)

def front_screenshot(x1, y1, x2, y2):
    #绝对坐标
    with mss.mss() as sct:
        monitor = {"left": x1, "top": y1, "width": x2 - x1, "height": y2 - y1}
        sct_img = sct.grab(monitor)
        img = Image.frombytes("RGB", sct_img.size, sct_img.rgb)
        return img
        
@auto_fill_process_hwnd
def capture_window_region(x1, y1, x2, y2, process_hwnd):
    """
    截取后台窗口中指定区域，返回图像（失败则返回空黑图）
    """
    if process_hwnd==-1:
        win_x, win_y = get_window_offset()
        abs_x1, abs_y1 = x1 + win_x, y1 + win_y
        abs_x2, abs_y2 = x2 + win_x, y2 + win_y
        screenshot = front_screenshot(abs_x1, abs_y1, abs_x2, abs_y2)
        screen_img = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
        return screen_img
    hwnd = None
    hWndDC = None
    mfcDC = None
    saveDC = None
    saveBitMap = None

    try:
        # 找窗口句柄
        if process_hwnd == -1:
            hwnds=get_all_hwnds()
            if hwnds:
                hwnd=hwnds[0]
        else:
            hwnd = process_hwnd
        if not hwnd:
            raise RuntimeError("窗口句柄无效")

         # 获取客户区大小
        left, top, right, bottom = win32gui.GetClientRect(hwnd)
        win_width = right - left
        win_height = bottom - top

        # 限制区域范围
        x1 = int(max(0, x1))
        y1 = int(max(0, y1))
        x2 = int(min(win_width, x2))
        y2 = int(min(win_height, y2))

        if x2 <= x1 or y2 <= y1:
            return np.zeros((max(1, y2 - y1), max(1, x2 - x1), 3), dtype=np.uint8)

        # if win32gui.IsIconic(hwnd):
        #     return np.zeros((height, width, 3), dtype=np.uint8)
        # 获取窗口设备上下文
        hWndDC = win32gui.GetDC(hwnd)
        if not hWndDC:
            raise RuntimeError("GetWindowDC 失败")

        mfcDC = win32ui.CreateDCFromHandle(hWndDC)
        if not mfcDC:
            raise RuntimeError("CreateDCFromHandle 失败")

        saveDC = mfcDC.CreateCompatibleDC()
        if not saveDC:
            raise RuntimeError("CreateCompatibleDC 失败")

        saveBitMap = win32ui.CreateBitmap()
        saveBitMap.CreateCompatibleBitmap(mfcDC, win_width, win_height)
        saveDC.SelectObject(saveBitMap)

        # 选择合适的 window number，如0，1，2，3，直到截图从黑色变为正常画面
        result = ctypes.windll.user32.PrintWindow(hwnd, saveDC.GetSafeHdc(), 3)
        # 截图
        # saveDC.BitBlt((0, 0), (width, height), mfcDC, (x1, y1), win32con.SRCCOPY)

        # 转成 numpy 图像
        bmp_info = saveBitMap.GetInfo()
        bmp_str = saveBitMap.GetBitmapBits(True)
        img = np.frombuffer(bmp_str, dtype='uint8').reshape(
            bmp_info['bmHeight'], bmp_info['bmWidth'], 4
        )

        # 裁剪图像到指定区域
        img = img[y1:y2, x1:x2]

        # final_img = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
        # cv2.imwrite("debug_screenshot.png", final_img)

        return cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
    except Exception as e:
        return np.zeros((max(1, y2 - y1), max(1, x2 - x1), 3), dtype=np.uint8)

    finally:
        try:
            if saveBitMap and saveBitMap.GetHandle():
                win32gui.DeleteObject(saveBitMap.GetHandle())
            if saveDC:
                saveDC.DeleteDC()
            if mfcDC:
                mfcDC.DeleteDC()
            if hWndDC and hwnd:
                win32gui.ReleaseDC(hwnd, hWndDC)
        except Exception as cleanup_err:
            pass

def FindPic(x1, y1, x2, y2, pic_name, sim,print_max=True):
    """
    以图找图功能
    :param x1: 区域的左上X坐标
    :param y1: 区域的左上Y坐标
    :param x2: 区域的右下X坐标
    :param y2: 区域的右下Y坐标
    :param sim: 相似度 0.1-1.0
    :return: (整数, x坐标, y坐标) 找到返回(0,x,y)，未找到返回(-1,-1,-1)
    """
    screen_img = capture_window_region(x1,y1,x2,y2)  # 使用 -1 获取当前窗口的截图
    if np.max(screen_img) == 0 and np.min(screen_img) == 0:
        logging.warning("无法识别游戏内容，可能是因为游戏被最小化")
        return -1, -1, -1
    # 构建完整的图片路径
    full_path = os.path.join(PIC_PATH, pic_name)
    if not os.path.exists(full_path):
        logging.warning(f"图片缺失: {pic_name}！请联系群主")
        return -1, -1, -1
    # 读取模板图片（使用支持中文路径的方法）
    template = imread(full_path)
    if template is None:
        return -1, -1, -1
    h, w = template.shape[:2]  # 获取模板的高和宽
    # 模板匹配
    result = cv2.matchTemplate(screen_img, template, cv2.TM_CCOEFF_NORMED)
    
    # 获取最大匹配值和位置
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
    if print_max:
        print(f"{pic_name}匹配度：{max_val}")
    # 如果匹配度达到要求
    if max_val >= sim:
        center_x = x1 + max_loc[0] + w // 2
        center_y = y1 + max_loc[1] + h // 2
        return 0, center_x , center_y  # 转为相对坐标
    return -1, -1, -1

def error_handle():
    res,x,y=FindPic(372,254,535,318,"电量.bmp",0.8)
    if res!=-1:
        click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
        return False
    res,x,y=FindPic(*SEARCH_REGION,"连接.bmp",0.80)
    if res!=-1:
        send_qq_mail("淦你的游戏又掉线了","赶快重新上号")
        logging.info("掉线，重新连接")
        return True
    
    error_list=["信息面板","NONO面板","确认"]
    for error in error_list:
        res,x,y=FindPic(*SEARCH_REGION,error+".bmp",0.80)
        if res!=-1:
            if error =="确认":
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            else:
                click(x,y)
                logging.info("关闭"+error)
                move_region("射击图标")
            time.sleep(3)
            return True
    return False

def catch_shiny(use_boker=True,rare=False):
        if rare:
            capture_audio_screenshot("稀有精灵")
        else:
            capture_audio_screenshot("异色精灵")
        """尝试捕捉精灵的函数"""
        # 等待并点击"手下留情"按钮
        move_region("确定")
        while not stop_flag:
            if can_use_skill():
                res,x,y=FindPic(*SEARCH_REGION,"手下留情.bmp",0.8)
                if res!=-1:
                    use_boker=True
                else:
                    use_boker=False
                break
        if use_boker:
            click(x+3,y+3)
            logging.info("使用手下留情")
        if stop_flag:
            return               
        # 检查是否还有野生精灵并尝试捕捉
        time.sleep(0.4)
        while not stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
            if x!=-1 and y!=-1:
                click_region("捕捉成功")
                if rare:
                    send_qq_mail(f"稀有精灵捕捉成功！", "快去背包查看吧")
                else:
                    send_qq_mail("异色精灵捕捉成功！", "快去背包查看吧")
                heal()
                break
            if stop_flag:
                return
            #还没捕捉成功    
            if can_use_skill():
                click_region("道具")
                logging.info("点击道具")
                time.sleep(1.5)
                while not stop_flag:
                    res,x,y=FindPic(*SEARCH_REGION,"中级胶囊.bmp",0.80)
                    res2,x2,y2=FindPic(*SEARCH_REGION,"中级胶囊2.bmp",0.80)
                    if res!=-1 or res2!=-1:
                        click(x,y) if res!=-1 else click(x2,y2)
                        logging.info("点击超级胶囊")
                        fast_move(x+100,y+100)
                        time.sleep(0.5)
                        break
                    else:
                        retry_ball()
                if stop_flag:
                    return
                
def run_away():
    global stop_flag
    click_region("逃跑")
    # logging.info("逃跑")
    time.sleep(0.3)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"逃离.bmp",0.85)
        if res!=-1:
            break
        else:
            # logging.info("点击逃跑失败，重新尝试")
            print("逃离1")
            click_region("逃跑")
            time.sleep(0.3)
            
    click_region("确认逃跑")
    # logging.info("确认逃跑")
    time.sleep(0.2)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"逃离.bmp",0.85)
        if res!=-1:
            logging.info("点击确认逃跑失败，重新尝试")
            random_click(REGION_CONFIG["确认逃跑"][0],REGION_CONFIG["确认逃跑"][1])
            time.sleep(0.3)
        else:
            break 
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"逃跑成功.bmp",0.85)
        if res!=-1:
            time.sleep(0.35)
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])#点击确认
            fast_move(0,0)
            time.sleep(0.35)
            break
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"逃跑成功.bmp",0.85)
        if res==-1:
            break
        else:
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])#点击确认
            time.sleep(0.3)

def catch_nier(ball_type="中级胶囊"):
    """尝试捕捉精灵的函数"""
    # 等待并点击"手下留情"按钮
    move_region("确定")
    wait_until_can_use_skill()
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"手下留情.bmp",0.8)
        if x!=-1 and y!=-1:
            click(x+3,y+3)
            logging.info("使用手下留情")
            break
    if stop_flag:
        return               
    # 检查是否还有野生精灵并尝试捕捉
    time.sleep(0.4)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
        if res!=-1:
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])#点击确认
            time.sleep(0.3)
            while not stop_flag:
                res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
                if res==-1:
                    send_qq_mail(f"高个体尼尔捕捉成功！", "捕捉成功")
                    heal()
                    break
                else:
                    click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])#点击确认
                    time.sleep(0.5)
            break           
        if stop_flag:
            return
        #还没捕捉成功    
        if can_use_skill():
            click_region("道具")
            logging.info("点击道具")
            time.sleep(1.5)
            while not stop_flag:
                res,x,y=FindPic(*BALL_REGION,f"{ball_type}.bmp",0.88)
                res2,x2,y2=FindPic(*BALL_REGION,f"{ball_type}2.bmp",0.88)
                if res!=-1 or res2!=-1:
    
                    click(x,y) if res!=-1 else click(x2,y2)
                    fast_move(x+100,y+100)
                    logging.info(f"点击{ball_type}")
                    time.sleep(0.5)  
                    break
                else:
                    logging.info(f"没有找到{ball_type}")
                    retry_ball()
            if stop_flag:
                return

def swtich_to_boker() -> bool:
    click_region("精灵")
    logging.info("点击精灵")
    time.sleep(1.5)
    while not stop_flag:
        res, x, y = FindPic(*SEARCH_REGION, "灰色出战.bmp", 0.8)
        if res != -1:
            break

    res1, x1, y1 = FindPic(*SEARCH_REGION, "波克尔.bmp", 0.8)
    res2, x2, y2 = FindPic(*SEARCH_REGION, "闪光波克尔.bmp", 0.8)

    if res1 != -1:
        click(x1, y1)
    elif res2 != -1:
        click(x2, y2)
    else:
        logging.info("没有找到波克尔/闪光波克尔,请检查是否携带")
        return False

    time.sleep(1)
    click_region("出战")
    logging.info("点击出战，切换波克尔")

    while not stop_flag:
        if can_use_skill():
            time.sleep(0.5)
            return True

    # 如果 stop_flag 一直为 True 结束循环，则也返回 False
    return False

def nier_strategy(ball_type="中级胶囊"):
    hp=ocr_hp()
    logging.info(f"尼尔的血量为{hp}")
    if not Config.ONLY_HIGH_NIER:
        catch_nier(ball_type)
        return True
    elif hp=="46":
        catch_nier(ball_type)
    else:
        run_away()

def auto_cancel():
    res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.85)
    if res!=-1:
        click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
        logging.info("点击确认")
        time.sleep(0.3)
        
        
def isFightStart():
    if can_use_skill(): 
        logging.info("战斗开始")
        return True
    return False


def isFightEnd():
    """
    检查战斗是否结束
    :return: bool, 战斗结束返回 True，否则返回 False
    """
    res, x, y = FindPic(*SEARCH_REGION, "战斗结束确认.bmp", 0.80)
    if x != -1 and y != -1:
        logging.info("战斗结束")
        return True
    return False

def handlePostFightClicks():
    """
    处理战斗结束后的点击步骤
    """
    global stop_flag
    while not stop_flag:
        if isFightEnd():
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.5)
            break
    res,x,y=FindPic(*SEARCH_REGION,"绿色箭头.bmp",0.8)
    if res!=-1:
        logging.info("精灵升级了")
        random_sleep(0.2)
        click(489,450)
        random_sleep(0)
    #一直等待到白色出现
    while not stop_flag:
        if is_color_at_point(593,354,"ffffff",1):   
            break
    #继续循环处理
    while not stop_flag:
        if is_color_at_point(593,354,"ffffff",1):
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.2)
        else:
            break

def heal():
    global stop_flag
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"精灵标志.bmp",0.8)
        if res!=-1:
            logging.info("找到精灵标志")
            x_jl,y_jl=x,y
            time.sleep(0.3)
            res,x1,y1=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
            if res!=-1:
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])#点击确认
                time.sleep(0.3)
            click(x_jl,y_jl)
            break
    if stop_flag:
        return  
    time.sleep(0.3)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"防御.bmp",0.8)
        if x!=-1 and y!=-1:
            time.sleep(0.2)
            break
        else:
            res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
            if res!=-1:
                click(x,y)
                time.sleep(0.2)
            click(x_jl,y_jl)
            logging.info("再次点击精灵标志")
            time.sleep(1)
    if stop_flag:
        return  
    while not stop_flag:        
        res,x,y=FindPic(*SEARCH_REGION,"治疗图标.bmp",0.8)
        if x!=-1 and y!=-1:
            click(x,y)
            logging.info("点击治疗")
            time.sleep(0.15)
            while not stop_flag:
                if is_color_at_point(585,361,"ffffff",0.1):
                    break
                else:
                    click(x,y)
                    time.sleep(0.15)
            break
    if stop_flag:
        return
    while not stop_flag:
        if is_color_at_point(585,361,"ffffff",0.1):
            logging.info("点击确认")
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.15)
        else:
            break        
    if stop_flag:
        return  
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"恢复返回.bmp",0.8)
        if res!=-1:
            time.sleep(0.3)
            click(x,y)
            logging.info("点击返回")
            fast_move(0,0)
            break
        
def healCactus():
    global stop_flag
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"精灵标志.bmp",0.8)
        if x!=-1 and y!=-1:
            logging.info("找到精灵标志")
            x_jl,y_jl=x,y
            res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
            if res!=-1:
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])#点击确认
                time.sleep(0.3)
            click(x_jl,y_jl)
            break
    time.sleep(0.3)
    if stop_flag:
        return  
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"防御.bmp",0.8)
        if x!=-1 and y!=-1:
            time.sleep(0.3)
            break
        else:
            res,x,y=FindPic(*SEARCH_REGION,"确认.bmp",0.8)
            if res!=-1:
                click(x,y)
                time.sleep(0.3)
            click(x_jl,y_jl)
            logging.info("再次点击精灵标志")
            time.sleep(1)
    while not stop_flag:        
        res,x,y=FindPic(*SEARCH_REGION,"治疗图标.bmp",0.8)
        if res!=-1:
            click(x,y)
            logging.info("点击治疗")
            time.sleep(0.15)
            while not stop_flag:
                if is_color_at_point(585,361,"ffffff",0.1):
                    break
                else:
                    click(x,y)
                    time.sleep(0.15)
        break
    if stop_flag:
        return
    while not stop_flag:
        if is_color_at_point(585,361,"ffffff",0.1):
            logging.info("点击确认")
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.15)
        else:
            break        
    if stop_flag:
        return  
    #-------------------恢复仙人掌-------------------------#
    while not stop_flag:
        res,x,y=find_color_in_region(195,214,465,443,"9cb557")
        res2,x2,y2=find_color_in_region(195,214,465,443,"57b59c")
        if res!=-1 or res2!=-1:
            click(x,y) if res!=-1 else click(x2,y2)
            break
    while not stop_flag:        
        res,x,y=FindPic(*SEARCH_REGION,"治疗图标.bmp",0.8)
        if res!=-1:
            click(x,y)
            logging.info("点击治疗")
            time.sleep(0.15)
            while not stop_flag:
                if is_color_at_point(585,361,"ffffff",0.1):
                    break
                else:
                    click(x,y)
                    time.sleep(0.15)
        break
    if stop_flag:
        return
    while not stop_flag:
        if is_color_at_point(585,361,"ffffff",0.1):
            logging.info("点击确认")
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.15)
        else:
            break        
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"恢复返回.bmp",0.8)
        if res!=-1:
            click(x,y)
            logging.info("点击返回")
            time.sleep(0.3)
            fast_move(0,0)
            break

    
def towerheal(heal_all=False):
    global stop_flag
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"塔内标志.bmp",0.8)
        if x!=-1 and y!=-1:
            logging.info("找到塔内标志")
            click(x,y)
            break
    if stop_flag:
        return  
    time.sleep(0.3)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"防御.bmp",0.8)
        if x!=-1 and y!=-1:
            break
        res,x,y=FindPic(*SEARCH_REGION,"塔内标志.bmp",0.8)
        if res!=-1:
            click(x,y)
            logging.info("再次点击精灵标志")
            time.sleep(1)
    if stop_flag:
        return  
    while not stop_flag:        
        res,x,y=FindPic(*SEARCH_REGION,"治疗图标.bmp",0.8)
        if x!=-1 and y!=-1:
            click(x,y)
            logging.info("点击治疗")
            time.sleep(0.15)
            while not stop_flag:
                if is_color_at_point(585,361,"ffffff",0.1):
                    break
                else:
                    click(x,y)
                    time.sleep(0.15)
        break
    if stop_flag:
        return
    while not stop_flag:
        if is_color_at_point(585,361,"ffffff",0.1):
            logging.info("点击确认")
            click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
            time.sleep(0.15)
        else:
            break        
    if stop_flag:
        return
    if heal_all:
        click(358,253)
        while not stop_flag:        
                res,x,y=FindPic(*SEARCH_REGION,"治疗图标.bmp",0.8)
                if x!=-1 and y!=-1:
                    click(x,y)
                    logging.info("点击治疗")
                    time.sleep(0.15)
                    while not stop_flag:
                        if is_color_at_point(585,361,"ffffff",0.1):
                            break
                        else:
                            click(x,y)
                            time.sleep(0.15)
                break
        if stop_flag:
            return
        while not stop_flag:
            if is_color_at_point(585,361,"ffffff",0.1):
                logging.info("点击确认")
                click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
                time.sleep(0.15)
            else:
                break        
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"恢复返回.bmp",0.8)
        if res!=-1:
            click(x,y)
            logging.info("点击返回")
            time.sleep(0.15)
        else:
            break
def can_use_skill():
    res,x,y=find_color_in_region(750,460,887,562,"13619e")
    if res!=-1:
        time.sleep(0.2)
        return True
    return False

def wait_until_can_use_skill():
    global stop_flag
    while not stop_flag:
        if can_use_skill():
            return True
        time.sleep(0.1)


    
def ocr_region(x1, y1, x2, y2,only_num=False):
    global ocr
    
    """
    对指定区域进行截图并使用OCR识别文字
    
    参数:
        x1, y1: 区域左上角坐标
        x2, y2: 区域右下角坐标
        
    返回:
        str: OCR识别出的文字
    """
    # 截取指定区域的屏幕
    screenshot = mss_screenshot(x1,y1,x2,y2)

    # 如果图片尺寸太小，放大3倍以提高OCR识别准确率
    width, height = screenshot.size
    if width < 50 or height < 50:
        scale_factor = 3
        new_width = width * scale_factor
        new_height = height * scale_factor
        screenshot = screenshot.resize((new_width, new_height), Image.LANCZOS)

    # 将PIL图像转换为字节流
    img_byte = io.BytesIO()
    screenshot.save(img_byte, format='PNG')
    img_byte = img_byte.getvalue()

    # 使用OCR识别文字

    # 识别设置
    if only_num:
        ocr.set_ranges(0)  # 仅限 0-9
    else:
        ocr.set_ranges(7)  # 默认字符集
    result = ocr.classification(img_byte)
    
    return result

def ocr_hp():
    global ocr
    
    result=ocr_region(628,37,653,57,True)   
    return result

def ocr_level():
    global ocr
    result=ocr_region(771,39,791,58,True)   
    return result

def ocr_sleep_turn():
    res1,x1,y1=FindPic(165,541,201,563,"一回合.bmp",0.9)
    res2,x2,y2=FindPic(165,541,201,563,"两回合.bmp",0.9)
    if res1!=-1:
        return 1
    if res2!=-1:
        return 2
    else:
        return 0
    
from email.header import Header

def _send_mail_task(subject: str, content: str, image_filename: str = None):
    """
    这是实际执行发送任务的函数，将在子线程中运行。
    """
    # 建议在线程开始时重新获取配置，或者通过参数传入配置，避免多线程读取全局变量冲突
    config = load_email_config()
    if not config:
        logging.info("邮件发送失败！请先在设置中填写邮箱信息")
        return

    try:
        # 创建邮件对象（MIMEMultipart）
        msg = MIMEMultipart('related')
        # 中文名字用 Header 包裹
        msg['From'] = formataddr((str(Header(config['sender_name'], 'utf-8')), config['sender_email']))
        msg['To'] = formataddr((str(Header(config['receiver_name'], 'utf-8')), config['receiver_email']))
        msg['Subject'] = Header(subject, 'utf-8')

        # 构建 HTML 内容
        if image_filename:
            # HTML 中引用 cid:image1
            html_content = f'''
                <html>
                    <body>
                        <p>{content}</p>
                        <p><img src="cid:image1"></p> 
                    </body>
                </html>
            '''
        else:
            html_content = f"<p>{content}</p>"

        msg.attach(MIMEText(html_content, 'html', 'utf-8'))

        # 如果传入了图片，则添加图片对象
        if image_filename:
            # 注意：在多线程中 os.getcwd() 可能会有变动，建议传入绝对路径，或者在这里尽快处理
            image_path = os.path.join(os.getcwd(), f"{image_filename}.png")
            if os.path.exists(image_path):
                with open(image_path, 'rb') as img_file:
                    img = MIMEImage(img_file.read(), _subtype='png')
                    img.add_header('Content-ID', '<image1>')
                    msg.attach(img)
            else:
                logging.warning(f"邮件附件图片未找到: {image_path}")

        # 发送邮件 (耗时操作)
        server = smtplib.SMTP_SSL('smtp.qq.com', 465, local_hostname='localhost')
        server.login(config['sender_email'], config['auth_code'])
        server.sendmail(config['sender_email'], [config['receiver_email']], msg.as_string())
        server.quit()
        
        logging.info(f"邮件发送成功: {subject}")
        print(f"邮件发送成功: {subject}")
        
    except Exception as e:
        # 子线程的报错如果不捕获，控制台可能不会打印，或者静默失败
        logging.exception(f"邮件发送失败: {e}")


def send_qq_mail(subject: str, content: str, image_filename: str = None):
    """
    主调函数：只负责启动线程，立刻返回，不阻塞主线程。
    """
    # 创建线程
    # target: 目标函数
    # args: 目标函数的参数
    email_thread = threading.Thread(
        target=_send_mail_task, 
        args=(subject, content, image_filename),
        daemon=True  # 设置为非守护线程
    )
    
    # 设置为守护线程 (Daemon) 的权衡：
    # daemon=True:  主程序关闭时，如果邮件还没发完，邮件线程会被强制杀死（邮件发不出去）。
    # daemon=False: (默认) 主程序关闭时，会等待邮件线程执行完毕才真正退出。
    # 建议设为 False，保证邮件能发完。
    # 启动线程
    email_thread.start()
        
def budao():
    global stop_flag
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"灰色出战.bmp",0.8)
        if res!=-1:
            break
    if stop_flag:
        return  
    res,x,y=find_color_in_region(430,448,462,475,"fe6700")
    if res==1:
    #橙毛在第一个格子
        for _ in range(3):
            random_click(485,460)
            random_sleep(-0.1)
        # click(532,507)
    #第二个格子
    else:
        for _ in range(3):
            random_click(447,454)
            random_sleep(-0.1)
        # click(492,505)
    logging.info("点击补刀精灵")
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"蓝色出战.bmp",0.8)
        if res!=-1:
            click_region("出战")
            time.sleep(0.5)    
            break
def set_global_stop_flag(b):
    global stop_flag
    stop_flag = b

def xianrenqiu():
    global stop_flag
    while not stop_flag:
        if can_use_skill():
            time.sleep(0.2)
            break
        
    click_region("精灵")
    logging.info("点击精灵")
    time.sleep(1.5)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"灰色出战.bmp",0.8)
        if res!=-1:
            break
        else:
            logging.info("没有进入精灵界面，重新点击")
            click_region("道具")
            time.sleep(0.5)
            click_region("精灵")
            time.sleep(1.5)
    if stop_flag:
        return  
    res,x1,y1=FindPic(391,410,660,488,"仙人掌图标.bmp",0.75)
    if res!=1:
        while not stop_flag:
            res,x,y=FindPic(*SEARCH_REGION,"巨型.bmp",0.8)
            if res!=-1:
                click_region("出战")
                fast_move(0,0)    
                logging.info("点击出战，切换仙人球")
                time.sleep(0.5)
                break
            else:
                click(x1,y1)
                logging.info("点击仙人掌图标")
                random_sleep(-0.1)
    else:
        logging.info("没有人找到巨型仙人掌，请检查是否携带")
        
def isIdentifying():
    res,x,y=FindPic(*SEARCH_REGION,"请选择.bmp",0.8)
    if res!=-1:
        logging.info("出现人机验证")
        return True
    else:
        return False
   
def retry_ball():
 # 切换到胶囊界面
        click(REGION_CONFIG["精灵"][0], REGION_CONFIG["精灵"][1])
        random_sleep(0.1)
        click(REGION_CONFIG["道具"][0], REGION_CONFIG["道具"][1])
        time.sleep(3)

def is_scale_100():
    # 获取屏幕设备上下文
    hdc = ctypes.windll.user32.GetDC(0)
    # 获取水平和垂直 DPI
    dpi_x = ctypes.windll.gdi32.GetDeviceCaps(hdc, 88)  # LOGPIXELSX
    ctypes.windll.user32.ReleaseDC(0, hdc)

    # Windows 默认 DPI 是 96，对比得出缩放比例
    scale_x = dpi_x / 96
    return scale_x==1

def switch_boker():
    res,x,y=FindPic(*SEARCH_REGION,"手下留情.bmp",0.8)
    if res!=-1:
        return True
    else:
        click_region("精灵")
        logging.info("点击精灵")
        time.sleep(1.5)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"灰色出战.bmp",0.8)
        if res!=-1:
            break
    res1,x1,y1=FindPic(*SEARCH_REGION, "波克尔.bmp", 0.8)
    res2,x2,y2=FindPic(*SEARCH_REGION, "闪光波克尔.bmp", 0.8)
    if res1!=-1:
        click(x1,y1)
    elif res2!=-1:
        click(x2,y2)
    else:
        logging.info("没有找到波克尔/闪光波克尔,请检查是否携带")
        click_region("出战")
        return False
    time.sleep(1)
    click_region("出战")
    logging.info("点击出战，切换波克尔")
    time.sleep(2)
    return True

def resize_window(hwnd, width=976, height=640, x=None, y=None):
    """
    调整窗口大小（并可选择性移动窗口位置）
    :param hwnd: 窗口句柄
    :param width: 新宽度
    :param height: 新高度
    :param x: 新的窗口左上角X坐标（不传则保持不变）
    :param y: 新的窗口左上角Y坐标（不传则保持不变）
    """
    # 获取当前窗口位置和大小
    rect = win32gui.GetWindowRect(hwnd)
    cur_x, cur_y, cur_right, cur_bottom = rect
    cur_width = cur_right - cur_x
    cur_height = cur_bottom - cur_y
    
    # 检查当前窗口大小是否已经是目标大小
    if cur_width == width and cur_height == height:
        return

    if x is None:
        x = cur_x
    if y is None:
        y = cur_y

    # 调整窗口位置和大小
    win32gui.SetWindowPos(
            hwnd,
            win32con.HWND_TOP,
            1080,
            900,
            width,
            height,
            win32con.SWP_SHOWWINDOW
        )
    win32gui.SetWindowPos(
        hwnd,
        win32con.HWND_TOP,
        x,
        y,
        width,
        height,
        win32con.SWP_SHOWWINDOW
    )
    # 弹出提示框
    alert_user()

def alert_user():
    msg = "窗口大小不匹配！\n\n请点击微端顶部菜单栏：\n【设置】 -> 【放大】，连续执行 2 次。"
    title = "操作提示"
    
    try:
        logging.info(msg.replace('\n', ' '))
        # 显式传递所有参数：句柄, 内容, 标题, 按钮类型
        win32api.MessageBox(0, msg, title, win32con.MB_OK | win32con.MB_ICONWARNING)
    except Exception as e:
        # 如果 win32api 报错，回退到通用日志
        logging.error(f"弹窗失败: {e}")
        print(msg)

    
def test_find_color_in_image(image_path, target_rgb, save_dir="./output", around=8):
    """
    在图片中查找目标颜色的位置，并截取该点周围区域保存为新图片
    :param image_path: 图片文件路径
    :param target_rgb: 目标RGB颜色，例如 "#FFFFFF"
    :param save_dir: 保存输出图片的目录
    :param around: 目标点周围截取像素范围（上下左右）
    :return: (x, y)，其中x和y是图片内的坐标，找不到返回(-1, -1)
    """
    # 读取图片
    img = cv2.imread(image_path)
    if img is None:
        raise ValueError(f"无法读取图片：{image_path}")

    # 获取图像尺寸
    height, width = img.shape[:2]

    # 将目标RGB转换为numpy数组
    target_color = np.array(hex_to_rgb(target_rgb))

    # 重塑图像数组，方便向量化操作
    r = img[:, :, 2].reshape(1, height * width)
    g = img[:, :, 1].reshape(1, height * width)
    b = img[:, :, 0].reshape(1, height * width)

    # 使用numpy的where函数找到匹配的像素
    key_r = np.where(r == target_color[0])
    key_g = np.where(g == target_color[1])
    key_b = np.where(b == target_color[2])

    # 如果所有通道都有匹配的像素
    if len(key_r[0]) and len(key_g[0]) and len(key_b[0]):
        # 找到所有通道都匹配的像素位置
        keys = reduce(np.intersect1d, [key_r[1], key_g[1], key_b[1]])
        if len(keys):
            # 将一维索引转换为二维坐标
            y, x = divmod(keys[0], width)

            # 截取目标点周围上下左右各around个像素
            x_start = max(x - around, 0)
            x_end = min(x + around, width)
            y_start = max(y - around, 0)
            y_end = min(y + around, height)
            
            cropped_img = img[y_start:y_end, x_start:x_end]

            # 创建保存目录
            if not os.path.exists(save_dir):
                os.makedirs(save_dir)

            # 保存图片
            cropped_img_rgb = cv2.cvtColor(cropped_img, cv2.COLOR_BGR2RGB)
            save_path = os.path.join(save_dir, f"cropped_{x}_{y}.png")
            cv2.imwrite(save_path, cropped_img)
            print(f"截取图片已保存到：{save_path}")

            return x, y

    return -1, -1

def test_FindPic(image_path, pic_name, sim=0.8, save_dir="./output",
                 search_x1=None, search_y1=None, search_x2=None, search_y2=None):
    """
    在已有图片中查找子图（模板图），可设置匹配区域
    :param image_path: 大图路径
    :param pic_name: 模板图名称
    :param sim: 相似度阈值
    :param save_dir: 保存路径
    :param search_x1, search_y1, search_x2, search_y2: 搜索范围（可不传）
    :return: (code, x, y)
    """
    # 读取背景图
    screen_img = imread(image_path)
    if screen_img is None:
        print(f"无法读取背景图：{image_path}")
        return -1, -1, -1

    # 读取模板图
    pic_name = os.path.join(r"D:\UGit\SeerXin_70version\assets", pic_name)
    template = imread(pic_name)
    if template is None:
        print(f"无法读取模板图：{pic_name}")
        return -1, -1, -1

    # 模板尺寸
    h, w = template.shape[:2]

    # ==============================
    # 处理搜索范围
    # ==============================
    H, W = screen_img.shape[:2]

    if None in (search_x1, search_y1, search_x2, search_y2):
        # 默认搜索整张大图
        search_x1, search_y1 = 0, 0
        search_x2, search_y2 = W, H
    else:
        # 防止越界
        search_x1 = max(0, search_x1)
        search_y1 = max(0, search_y1)
        search_x2 = min(W, search_x2)
        search_y2 = min(H, search_y2)

    # 裁剪搜索区域
    search_img = screen_img[search_y1:search_y2, search_x1:search_x2]

    # 模板匹配
    result = cv2.matchTemplate(search_img, template, cv2.TM_CCOEFF_NORMED)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)

    print(f"匹配度：{max_val}")

    if max_val >= sim:
        # 匹配坐标是相对 search_img 的，要加回偏移
        true_x = search_x1 + max_loc[0]
        true_y = search_y1 + max_loc[1]

        center_x = true_x + w // 2
        center_y = true_y + h // 2

        # 截取匹配区域
        cropped = screen_img[true_y:true_y + h, true_x:true_x + w]

        # 保存截图
        os.makedirs(save_dir, exist_ok=True)
        save_path = os.path.join(save_dir, f"matched_{os.path.basename(pic_name)}")

        _, encoded_img = cv2.imencode(".bmp", cropped)
        encoded_img.tofile(save_path)

        print(f"匹配截图已保存到：{os.path.abspath(save_path)}")

        return 0, center_x, center_y

    return -1, -1, -1

def has_red_word():
    res,x,y=find_color_in_region(40,441,271,553,"ff0000")
    if res!=-1:
        logging.info("检测到暗雷~")
        return True
    return False

def keep_use_fly_skill():
    while not stop_flag:
        if can_use_skill():
            res, sx, sy = FindPic(*SEARCH_REGION, "飞行系.bmp", 0.8)
            if res != -1:
                click(sx, sy)
                logging.info("使用飞行系技能")
                fast_move(100, 100)
            else:
                logging.info("没有找到飞行系技能")
        
        if isFightEnd():
            handlePostFightClicks()
            heal()
            break

def isNier(ball_type="中级胶囊") -> bool:
    global stop_flag
    res,x,y=FindPic(786,83,835,113,"尼尔.bmp",0.75)
    if res!=-1:
        logging.info(f"尼尔出现")
        while not stop_flag:
            if can_use_skill():
                random_sleep(0)
                break
        if stop_flag:
            return False
        res,x,y=FindPic(*SEARCH_REGION,"手下留情.bmp",0.8)
        if res==-1:
            if swtich_to_boker():
                nier_strategy(ball_type)
            else:
                run_away()
            
        else:
            nier_strategy(ball_type)
        return True
    return False

import os, subprocess, winshell
from pathlib import Path
def launch_game(lnk_name="SeerGame", params="--disable-features=CalculateNativeWinOcclusion"):
    # 1. 查找路径 (合并为一行)
    possible_names = [f"{lnk_name}.lnk", f"{lnk_name}.exe.lnk"]
    desktops = [Path(winshell.desktop()), Path(winshell.common_desktop())]
    shortcut = next((d / name for d in desktops for name in possible_names if (d / name).exists()), None)

    if not shortcut:
        ctypes.windll.user32.MessageBoxW(0, f"桌面未找到: {lnk_name}", "启动错误", 0x10)
        return

    try:
        with winshell.shortcut(str(shortcut)) as link:
            subprocess.Popen([link.path] + params.split(), cwd=link.working_directory)
        time.sleep(2.5)  # 等待游戏启动
        hwnds = get_all_hwnds()
        for hwnd in hwnds:
            resize_window(hwnd)
    except Exception as e:
        ctypes.windll.user32.MessageBoxW(0, f"启动失败: {e}", "错误", 0x10)

def has_non_white():
    return (
        find_color_in_region(299,262,333,311,"ffffff") != -1 and
        find_color_in_region(399,260,442,314,"ffffff") != -1 and
        find_color_in_region(503,264,548,307,"ffffff") != -1 and
        find_color_in_region(606,263,650,307,"ffffff") != -1
    )

@auto_fill_process_hwnd
# 向窗口发送键盘消息
def send_key(key, process_hwnd):
    # 发送按下键消息 (WM_KEYDOWN)
    win32gui.PostMessage(process_hwnd, win32con.WM_KEYDOWN, ord(key), 0)

    time.sleep(0.1)  # 模拟按键持续时间

    # 发送松开键消息 (WM_KEYUP)
    win32gui.PostMessage(process_hwnd, win32con.WM_KEYUP, ord(key), 0)

from core.refresh import REFRESH_PET_ACTIONS,SWITCH_PET_ACTIONS
def switch_handle_identifying():
    if isIdentifying():
        # 等待精灵加载完成
        while not has_non_white():
            time.sleep(0.2)  
        random_click(313,291)
        time.sleep(0.4)
        if isIdentifying():
            while not has_non_white():
                time.sleep(0.2)
            random_click(313,291)
        time.sleep(3)
        if is_color_at_point(899,248,"777777"):
            return False
    return True

def perform_move(pet_name,target_info):
    """执行单次地图跳转任务"""
    map_name, (target_x, target_y) = target_info
    while not stop_flag:
        res, _, _ = FindPic(*SEARCH_REGION, f"{map_name}.bmp", 0.80)
        if res != -1:
            click(target_x, target_y)
            break
    start_time = time.time()
    while not stop_flag:
        res, _, _ = FindPic(*SEARCH_REGION, f"{map_name}.bmp", 0.80)
        # res == -1 表示当前地图图样消失，切换成功
        if res == -1:
            return True 
        # 超时处理逻辑
        if time.time() - start_time > 10:
            # 重试点击并重置计时
            if not switch_handle_identifying():
                REFRESH_PET_ACTIONS[pet_name]()
            click(target_x, target_y)
            start_time = time.time()
        time.sleep(0.5)
    return False


def switch_map(pet_name):
    # 依次执行 PET_ACTIONS 中的前两个动作
    for i in range(2):
        if stop_flag: break
        perform_move(pet_name, SWITCH_PET_ACTIONS[pet_name][i])
    time.sleep(0.5)
    switch_handle_identifying()
    
