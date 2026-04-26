import threading
import time
from core.utils import *
import socket
refresh_lock = threading.Lock()
SWITCH_PET_ACTIONS = {
    "皮皮": [
        ("克洛斯星一层", (11,450)),
        ("克罗斯星二层", (921,350)),
    ],
    "火炎贝": [
        ("火山星一层", (842,149)),
        ("火山星二层", (45,309)),
    ],
    "贝尔": [
        ("海洋星一层", (311,510)),
        ("海洋星二层", (759,175)),
    ]
}

def beier():
    click_map("海洋星图标")
def pipi():
    click_map("克洛斯星图标")
def huoyanbei():
    click_map("火山星图标")


REFRESH_PET_ACTIONS = {
    "贝尔": beier,
    "火炎贝": huoyanbei,
    "皮皮": pipi,
}


def click_map(name):
    click(477,549)
    while not stop_flag:
        if is_color_at_point(153,400,"ff9900",0.1):
            time.sleep(0.4)
            break
    click(227,207) #关闭
    time.sleep(1)
    while not stop_flag:
        res,x,y= FindPic(*SEARCH_REGION,name+".bmp",0.8)
        if res!=-1:
            click(x,y)
            time.sleep(0.5)
            break
    send_cmd("refresh")
    send_cmd("lock")






def auto_setting():
    while not stop_flag:
        if is_color_at_point(813,556,"ff4c00"): #精灵背包
            time.sleep(1.5)
            break
    res,x,y=FindPic(*SEARCH_REGION,"电量.bmp",0.80)
    if res!=-1:
        click(CONFIRM_BUTTON[0],CONFIRM_BUTTON[1])
        time.sleep(0.4)
    if is_color_at_point(269,202,"02fdfd",0.1): #八倍经验
        time.sleep(0.3)
        click(480,375)
        time.sleep(0.3)
   
    res,x,y=FindPic(901,523,921,543,"声音.bmp",0.85)
    if res!=-1:
        # logging.info("你为什么不把游戏静音，懒狗")
        click(x,y)
        time.sleep(0.4)
    res,x,y=FindPic(927,522,943,542,"铁皮.bmp",0.85)
    if res!=-1:
        # logging.info("你为什么不屏蔽铁皮，懒狗")
        click(x,y)
        time.sleep(0.4)
    if is_color_at_point(894,339,"6a9dbf"):
        time.sleep(0.4)
    else:
        click(478,545) #地图
        while not stop_flag:
            if is_color_at_point(152,400,"ff9900"):
                time.sleep(0.4)
                click(182,446) #传送仓
                break
        while not stop_flag:
            if is_color_at_point(894,339,"6a9dbf"):
                time.sleep(1) #进入了
                break
    for _ in range(3):
        click(908,462) #nono
        time.sleep(0.1)
    time.sleep(1)
    while not stop_flag:
        res,x,y=FindPic(645,238,861,512,"召唤.bmp",0.8)
        if res!=-1:
            time.sleep(0.5)
            click(x,y) #召唤
            time.sleep(1)
            break
        else:
            for _ in range(3):
                click(908,462) #nono
                time.sleep(0.1)
            time.sleep(1)
    time.sleep(3)
    click(502,368)
    while not stop_flag:
        rex,x,y=FindPic(*SEARCH_REGION,"打开功能.bmp",0.80)
        if rex!=-1:
            time.sleep(0.5)
            click(x,y) #打开功能
            break
    while not stop_flag:
        rex,x,y=FindPic(*SEARCH_REGION,"飞行模式图标.bmp",0.80)
        if rex!=-1:
            time.sleep(0.5)
            click(x,y) #打开功能
            break
    time.sleep(1)
    click(436,359) #飞行形态




def refresh_game():
    send_cmd("unlock")
    time.sleep(0.4)
    with refresh_lock:
        time.sleep(0.1)
        activate_single_window()
        time.sleep(0.4)
        click(24,12,-1 ) #点击游戏
        time.sleep(0.4)
        click(35,34,-1)
        time.sleep(0.4)
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"我已知晓.bmp",0.85)
        if res!=-1:
            time.sleep(0.5)
            click(x,y)   #我已知晓
            fast_move(0,0)
            time.sleep(0.5)
            res1,x1,y1=FindPic(*SEARCH_REGION,"我已知晓.bmp",0.85)
            if res1==-1:
                time.sleep(2)
                break
    while not stop_flag:
        if is_color_at_point(738,453,"5dcdf1") or is_color_at_point(596,439,"d02e3b"): #蓝色登录
            time.sleep(1)
            click(622,452)   #开始
            time.sleep(0.5)
            break
    # while not stop_flag:
    #     res,x,y=FindPic(*SEARCH_REGION,"服务器.bmp",0.8)
    #     if res!=-1:
    #         time.sleep(0.5)
    #         click(171,265)
    #         break
    while not stop_flag:
        res,x,y=FindPic(*SEARCH_REGION,"服务器.bmp",0.8)
        if res!=-1:
            time.sleep(0.5)
            break
    with refresh_lock:
        click(769,154)
        send_key('1')
        time.sleep(0.5)
        click(851,146)


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



import random
import time

class MixModeController:
    def __init__(self, cfg):
        self.cfg = cfg
        self.is_afk = False
        self.next_threshold = random.randint(cfg["normal_loops_min"], cfg["normal_loops_max"])

    def should_afk(self) -> bool:
        """Main loop decision point. Returns whether the system should be in AFK state."""
        now = time.time()

        if not self.is_afk:
            self.next_threshold -= 1  # Decrease the threshold
            if self.next_threshold <= 0:
                self.is_afk = True
                duration = random.randint(self.cfg["afk_seconds_min"], self.cfg["afk_seconds_max"])
                self.next_threshold = now + duration  # Reuse threshold for timestamp
        else:
            if now >= self.next_threshold:
                self.is_afk = False
                self.next_threshold = random.randint(self.cfg["normal_loops_min"], self.cfg["normal_loops_max"])

        return self.is_afk
    
