import ctypes
import time

user32 = ctypes.WinDLL("user32", use_last_error=True)

# 鼠标消息
WM_MOUSEMOVE      = 0x0200
WM_LBUTTONDOWN    = 0x0201
WM_LBUTTONUP      = 0x0202
MK_LBUTTON        = 0x0001

# 防抢焦点/防闪烁
FLASHW_STOP       = 0
GWL_EXSTYLE       = -20
WS_EX_NOACTIVATE  = 0x08000000
SPI_SETFOREGROUNDLOCKTIMEOUT = 0x2001

# 设置不给后台窗口闪烁请求焦点的时间 = 0
# 组合坐标
def MAKELPARAM(x, y):
    x = int(x)
    y = int(y)
    return (y << 16) | (x & 0xFFFF)


class backendMouse:
    def __init__(self):
        ctypes.windll.user32.SystemParametersInfoW(
    SPI_SETFOREGROUNDLOCKTIMEOUT, 0, 0, 0
)

    # --------------------------
    #   禁止窗口任务栏闪烁
    # --------------------------
    def stop_flash(self, hwnd):
        class FLASHWINFO(ctypes.Structure):
            _fields_ = [('cbSize', ctypes.c_uint32),
                        ('hwnd', ctypes.c_void_p),
                        ('dwFlags', ctypes.c_uint32),
                        ('uCount', ctypes.c_uint32),
                        ('dwTimeout', ctypes.c_uint32)]

        fi = FLASHWINFO(ctypes.sizeof(FLASHWINFO), hwnd, FLASHW_STOP, 0, 0)
        user32.FlashWindowEx(ctypes.byref(fi))

    # --------------------------
    #   禁止窗口抢焦点
    # --------------------------
    def disable_activation(self, hwnd):
        style = user32.GetWindowLongW(hwnd, GWL_EXSTYLE)
        user32.SetWindowLongW(hwnd, GWL_EXSTYLE, style | WS_EX_NOACTIVATE)

    # --------------------------
    #   后台鼠标移动
    # --------------------------
    def MoveTo(self, hwnd, x, y):
        self.stop_flash(hwnd)

        lparam = MAKELPARAM(x, y)
        user32.SendMessageW(hwnd, WM_MOUSEMOVE, 0, lparam)

    # --------------------------
    #   后台左键点击
    # --------------------------
    def LeftClick(self, hwnd, x, y):
        lparam = MAKELPARAM(x, y)

        # 按下
        user32.SendMessageW(hwnd, WM_LBUTTONDOWN, MK_LBUTTON, lparam)
        time.sleep(0.05)

        # 放开
        user32.SendMessageW(hwnd, WM_LBUTTONUP, 0, lparam)
        self.MoveTo(hwnd,0,0)
        self.stop_flash(hwnd)
