import time
from core.utils import CONFIRM_BUTTON, click, FindPic,SEARCH_REGION,stop_flag,is_color_at_point
PET_NAME=None
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








# def refresh_game():
#     send_cmd("unlock")
#     while not stop_flag :
#         kill_process(PROCESS_NAME)
#         exe_path, work_dir = get_target_from_shortcut(shortcut_path)
#         start_exe(exe_path, work_dir, ARGS)
#         time.sleep(6)  # 等待游戏启动
#         hwnds= find_windows_by_title(["骄阳号"])  # 传入列表
#         set_current_hwnd(hwnds[0]) 
#         res,x,y=FindPic(46,165,99,184,"开始游戏.bmp",0.8)  
#         print(f"查找开始游戏结果: {res}, 坐标: ({x}, {y})")
#         if res!=-1:
#             click(x,y)
#         time.sleep(4) 
#         res,x,y=FindPic(*SEARCH_REGION,"赛尔.bmp",0.8)  
#         if res!=-1:
#             click(x,y)
#             break
#     InitGame()
#     send_cmd("refresh")
#     send_cmd("lock")



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




