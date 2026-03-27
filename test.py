from core.utils import *
from core.refresh import *

import win32api
import win32con
import win32gui
import time

import win32gui
import win32con
import time

# 获取指定窗口句柄
def find_window(title):
    hwnd = win32gui.FindWindow(None, title)
    return hwnd




send_key(984222, '1')