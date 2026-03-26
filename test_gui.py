from PySide6.QtWidgets import QApplication, QWidget,QRadioButton,QButtonGroup,QPlainTextEdit,QComboBox,QDialog,QPushButton,QMessageBox
from PySide6.QtCore import QObject, Signal
from Ui.Ui_脚本 import Ui_Form
from pathlib import Path
import threading
import keyboard
import logging
from config.config import *
from config.email_config_dialog import EmailConfigDialog
from config.login_dialog import CardLoginDialog
from threads.catcher_thread import *
from threads.learner_thread import *
from threads.tower_thread import *
from threads.daily_thread import *
from threads.proxy_thread import ProxyThread
from core.utils import get_all_hwnds,Config
from core import network_dll
import sys
import traceback
import os
from core.backendMouse import backendMouse
from config.app_config import app_config
RESULT=None
CARD=None
# === 全局异常处理 ===
def global_exception_handler(exctype, value, tb):
    """
    捕获所有未处理的异常，记录日志并向用户显示一个友好的错误消息。
    """
    # 格式化异常信息
    error_message = "".join(traceback.format_exception(exctype, value, tb))
    log_content = f"程序意外崩溃:\n\n{error_message}"
    
    # 尝试将日志写入“我的文档”
    try:
        documents_path = Path.home() / 'Documents'
        documents_path.mkdir(parents=True, exist_ok=True)
        crash_log_file = documents_path / 'crash_report.txt'
        with open(crash_log_file, 'w', encoding='utf-8') as f:
            f.write(log_content)
        log_path_str = str(crash_log_file)
        
    except Exception as e:
        # 如果写入“我的文档”失败，则尝试写入程序当前目录
        try:
            fallback_path = Path(sys.argv[0]).parent / 'crash_report.txt'
            with open(fallback_path, 'w', encoding='utf-8') as f:
                f.write(log_content)
            log_path_str = str(fallback_path)
        except Exception as e_inner:
            log_path_str = f"无法写入日志文件: {e_inner}"

    # 记录到现有的 logger (如果可用)
    try:
        logging.critical(log_content)
    except:
        pass

    # 显示一个错误消息框
    msg_box = QMessageBox()
    msg_box.setIcon(QMessageBox.Critical)
    msg_box.setWindowTitle("程序异常")
    msg_box.setText("抱歉，程序遇到无法恢复的错误，即将退出。\n"
                    "错误详情已记录在以下文件中，请将此文件发送给开发者以解决问题。")
    msg_box.setDetailedText(error_message)
    msg_box.setInformativeText(f"日志文件路径: {log_path_str}")
    msg_box.setStandardButtons(QMessageBox.Ok)
    msg_box.exec()
    
    # 清理并退出
    cleanup_handler()
    sys.exit(1)


# 创建线程安全的信号类
class LogEmitter(QObject):
    new_log = Signal(str)
# 自定义日志处理器
class QTextEditLogger(logging.Handler):
    def __init__(self, text_edit: QPlainTextEdit):
        super().__init__()
        self.text_edit = text_edit
        self.emitter = LogEmitter()
        self.emitter.new_log.connect(self.append_log)

    def emit(self, record):
        log_entry = self.format(record)
        self.emitter.new_log.emit(log_entry)

    def append_log(self, log_entry):
        self.text_edit.appendPlainText(log_entry)
    
class MyWindow(QWidget,Ui_Form):  
    pause_signal = Signal()
    def __init__(self): # 初始化函数，用于创建窗口
        super().__init__()
        self.setupUi(self) #    
        self.xuexili_button_group = QButtonGroup(self)
        self.xuexili_button_group.setExclusive(True)
        self.fightmode_button_group = QButtonGroup(self)
        self.daily_button_group = QButtonGroup(self)
        self.daily_button_group.setExclusive(True)
        self.bind() # 绑定函数，用于绑定按钮的点击事件
        self.setup_radio_buttons()
        self.set_up_daily_buttons()
        self.set_up_fightmode_buttons()
        self.setup_logger()
        self.read_config()
        self.learn_Pokemon=None
        self.pause_signal.connect(self.handle_pause)#将信号连接到主线程的处理函数
        self.windows={}
        threading.Thread(target=self.listen_global_hotkey, daemon=True).start()
        # self.refreshCheckBox.toggled.connect(app_config().set_checked)
        # app_config().set_checked(self.refreshCheckBox.isChecked())
        # 多窗口线程列表
        self.threads = []
        
        # 启动代理线程 (Protocol Proxy)
        try:
            self.proxy_thread = ProxyThread()
            self.proxy_thread.error_occurred.connect(lambda msg: logging.error(f"Error: {msg}"))
            self.proxy_thread.start()
        except Exception as e:
            logging.error(f"Failed to start : {e}")

    def setupNier(self):
        pass
        if self.onlyHighNierCheckBox.isChecked():
            Config.ONLY_HIGH_NIER=True
        else:
            Config.ONLY_HIGH_NIER=False

    def move_window_only(self,hwnd, x, y):
        win32gui.SetWindowPos(
            hwnd,
            win32con.HWND_TOP,
            x,
            y,
            0,
            0,
            win32con.SWP_NOSIZE | win32con.SWP_SHOWWINDOW
        )
    def register_window(self,hwnd):
        rect = win32gui.GetWindowRect(hwnd)  # (left, top, right, bottom)
        self.windows[hwnd] = {
            "rect": rect,       # 原始位置和大小
        }

    def hide_game(self, hwnd):
        self.register_window(hwnd)
        self.move_window_only(hwnd, -10000, -10000)  # 移动到屏幕外

    def show_game(self, hwnd):
        if hwnd in self.windows:
            rect = self.windows[hwnd]["rect"]
            # 先确保窗口可见且不是最小化状态
            win32gui.ShowWindow(hwnd, win32con.SW_SHOW)  # 先显示窗口
            win32gui.ShowWindow(hwnd, win32con.SW_RESTORE)  # 恢复最小化窗口
            self.move_window_only(hwnd, rect[0], rect[1])
            win32gui.SetForegroundWindow(hwnd)  # 置顶激活窗口
            self.windows.pop(hwnd, None)  # 移除记录
    def listen_global_hotkey(self):
        keyboard.add_hotkey("f1", lambda: self.pause_signal.emit())
        
    def closeEvent(self, event):
        event.accept()
        
    def on_captcha_handled(self):
        if hasattr(self, 'thread') and self.thread:
            if hasattr(self.thread, 'on_captcha_handled'):
                self.thread.on_captcha_handled()

    def setup_logger(self):
        
        # 1. 获取“我的文档”路径
        documents_path = Path.home() / 'Documents'
        documents_path.mkdir(parents=True, exist_ok=True)
        log_file = documents_path / f'乌皇_log.txt'
        
        logger = logging.getLogger()
        logger.setLevel(logging.INFO)

        # 清空旧的 handler，避免重复输出
        if logger.hasHandlers():
            logger.handlers.clear()
            
        formatter = logging.Formatter('%(asctime)s %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        # 自定义 Handler 输出到 QPlainTextEdit
        text_edit_handler = QTextEditLogger(self.logText)
        text_edit_handler.setFormatter(formatter)
        logger.addHandler(text_edit_handler)
        
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        logger.addHandler(console_handler)
        
        # 输出到文件
        file_handler = logging.FileHandler(log_file, encoding='utf-8')
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
        
    def setup_radio_buttons(self):
        # 收集所有学习力区域的 QRadioButton
        group_boxes = [
            self.gongjiGroupBox, self.tegongGroupBox,
            self.fangyuGroupBox, self.tefangGroupBox,
            self.tiliGroupBox, self.suduGroupBox,
        ]
        for group_box in group_boxes:
            for child in group_box.findChildren(QRadioButton):
                self.xuexili_button_group.addButton(child)  # 加入互斥组
                
        self.xuexili_button_group.addButton(self.othersButton)
        self.xuexili_button_group.addButton(self.schoolButton)   
        items=["中级胶囊","初级胶囊","高级胶囊","超级胶囊","无敌胶囊","时空胶囊"]
        self.ballComboBox.addItems(items)
    
    def set_up_fightmode_buttons(self):
        for child in self.stackedWidget.widget(1).findChildren(QRadioButton):
            self.fightmode_button_group.addButton(child)
    def set_up_daily_buttons(self):
        for child in self.stackedWidget.widget(3).findChildren(QRadioButton):
            self.daily_button_group.addButton(child)  # 加入互斥组      
    def handle_pause(self):
        """根据当前页面，暂停正在运行的任务"""
        current_index = self.functionListWidget.currentRow()
        current_page = self.stackedWidget.widget(current_index)

        # 遍历当前页面下所有子控件，查找文本为“停止运行”的按钮
        toggle_button = None
        for child in current_page.findChildren(QPushButton):
            if (child.text() == "停止运行" or child.text() == "开始运行"):
                toggle_button = child
                break
        if toggle_button:
            toggle_button.click()
        else:
            logging.info("未找到切换按钮")         
    def read_config(self):
        page = self.stackedWidget.widget(1)
        shiny_comboBox = page.findChild(QComboBox, "shinyComboBox")
        shiny_comboBox.addItems(SHINY_CONFIG.keys())  
        page_3 = self.stackedWidget.widget(2)
        tower_comboBox = page_3.findChild(QComboBox, "towerPokemonComboBox")
        tower_comboBox.addItems(TOWER_CONFIG.keys())  # 添加所有键作为选项
        tower_comboBox.addItems(["试炼之塔"])

        page_1=self.stackedWidget.widget(0)
        others_comboBox=page_1.findChild(QComboBox, "othersComboBox")
        others_comboBox.addItems(OTHERS_CONFIG)  # 添加所有键作为选项

        page_4=self.stackedWidget.widget(3)
        
    def get_selected_skill_text(self):
        for child in self.skillSetting.findChildren(QRadioButton):
            if child.isChecked():
                return child.text()
        return None  # 没有选中
    def handle_email_setting(self,item):
        if item.text() == "打开游戏":
            launch_game("SeerGame")

        elif item.text() == "设置":  # 第一个选项："邮箱配置"
            dialog = EmailConfigDialog(self)
            if dialog.exec() == QDialog.DialogCode.Accepted:  # 检查是否点击了"确定"按钮
                logging.info("邮箱配置已保存")

        elif item.text() == "打开日志":
            # 获取文档目录
            documents_path = Path.home() / 'Documents'
            log_file = documents_path / f'乌皇_log.txt'
            if not log_file.exists():
                logging.warning("日志文件不存在：%s", log_file)
                return
            # 跨平台打开日志文件
            try:
                os.startfile(log_file)
            except Exception as e:
                logging.error("打开日志文件失败", exc_info=True)
        elif item.text() == "清空日志":
            documents_path = Path.home() / 'Documents'
            log_file = documents_path / f'乌皇_log.txt'
            logger = logging.getLogger()

            # === 关闭并移除所有 handler ===
            for handler in logger.handlers[:]:
                try:
                    logger.removeHandler(handler)
                    handler.close()
                except Exception as e:
                    logging.info("移除 handler 时出错：", e)
                                                                                                                                                                    
            # === 删除日志文件 ===
            try:
                if log_file.exists():
                    log_file.unlink()
                    logging.info("日志文件已成功删除")
                else:
                    logging.info("日志文件不存在，无需删除")
            except Exception as e:
                logging.info("删除日志文件失败：", e)
                return  # 删除失败就不继续重建日志
            self.setup_logger()  # 重新设置日志处理器
            logging.info("日志已清空")

            
    def bind(self): # 绑定函数，用于绑定按钮的点击事件
        self.functionListWidget.currentRowChanged.connect(self.stackedWidget.setCurrentIndex)
        self.startCatch.clicked.connect(self.start_catch_running)
        self.startXuexili.clicked.connect(self.start_learn_running)
        self.settingListWidget.itemClicked.connect(self.handle_email_setting)
        self.startTower.clicked.connect(self.start_tower_running)
        self.startDaily.clicked.connect(self.start_daily_running)

    #-----------------------功能函数------------------------#
    def start_catch_running(self):
        if self.startCatch.text() == "开始运行":
            only_normal_high_IV = self.onlyHighCheckBox.isChecked()  # 获取 checkbox 状态
            only_rare_high_IV = self.onlyHighCheckBox2.isChecked()  # 获取 checkbox 状态
            all_catch=self.AllCheckBox.isChecked()
            if only_rare_high_IV:
                self.shinyAndRareCheckBox.setChecked(True)
            rareAndShiny=self.shinyAndRareCheckBox.isChecked()
            cactus=self.cactusCheckBox.isChecked()
            afk=self.afkButton.isChecked()
            switch=self.switchMapButton.isChecked()
            mix=self.greenPlayerButton.isChecked()
            type_name = "异色"    # 给 log 输出使用
            pet_name=self.shinyComboBox.currentText()           # 给 CatcherThread 使用
            ball_type=self.ballComboBox.currentText()
            self.setupNier()
            # 获取所有游戏窗口句柄
            hwnds = get_all_hwnds()
            logging.info(f"检测到 {len(hwnds)} 个游戏窗口")
            logging.info(f"开始捕捉{type_name}精灵{pet_name},使用{ball_type}")
            logging.info(f"请先开启功能再进入地图！！")
             # 为每个窗口创建一个线程
            self.threads = []
            try:
                heart=network_dll.send_heartbeat(CARD,RESULT['token'])
                print(heart)
                if heart['message']=="1":
                    from core.base_catcher import CatcherConfig
                    catcher_config = CatcherConfig(
                        pet_name=pet_name,
                        only_normal_high_iv=only_normal_high_IV,
                        only_rare_high_iv=only_rare_high_IV,
                        ball_type=ball_type,
                        rare_and_shiny=rareAndShiny,
                        use_cactus_sleep=cactus,
                        afk_mode=afk,
                        all_catch=all_catch,
                        switch=switch,
                        mix=mix,
                    )
                    for i, hwnd in enumerate(hwnds):
                        
                        resize_window(hwnd)
                        thread = CatcherThread(catcher_config, hwnd)
                        self.threads.append(thread)
                        # dm.MoveTo(hwnd,0,0)
                else:
                    cleanup_handler()
                    QApplication.quit()  # 使用安全退出
                    return
            except Exception as e:
                cleanup_handler()
                QApplication.quit()  # 使用安全退出
                return            
            for thread in self.threads:
                thread.start()
            self.startCatch.setText("停止运行")
        else:
            for thread in self.threads:
                thread.stop()
            self.threads = []
            self.logText.clear()
            self.startCatch.setText("开始运行")
            
    def start_learn_running(self):
        if self.startXuexili.text() == "开始运行":
            learn_pokemon = self.xuexili_button_group.checkedButton().text()
            if learn_pokemon == "刷材料：":
                learn_pokemon=self.othersComboBox.currentText()
            if learn_pokemon == "精灵学院":
                learn_pokemon="精灵学院"
            selected_skill=self.get_selected_skill_text()
            hp_recovery_frequency=self.heal_spinBox.value()
            catch_rare=self.catchRareCheckBox.isChecked()
            self.setupNier()
            logging.info(f"开始刷{learn_pokemon}，使用{selected_skill}，恢复频率为{hp_recovery_frequency}")
            
            # 获取所有游戏窗口句柄
            hwnds = get_all_hwnds()
            logging.info(f"检测到 {len(hwnds)} 个游戏窗口")
            logging.info(f"请先开启功能再进入地图！！")
            # 为每个窗口创建一个线程
            self.threads = []
            try:
                heart=network_dll.send_heartbeat(CARD,RESULT['token'])
                if heart['message']=="1":
                    for i, hwnd in enumerate(hwnds):
                        resize_window(hwnd)
                        thread = LearnerThread(learn_pokemon, selected_skill, hp_recovery_frequency, hwnd,catch_rare)
                        self.threads.append(thread)
                        # dm.MoveTo(hwnd,0,0)
                else:
                    cleanup_handler()
                    QApplication.quit()  # 使用安全退出
                    return
            except Exception as e:  
                cleanup_handler()
                QApplication.quit()  # 使用安全退出
                return
            for thread in self.threads:
                thread.start()
            self.startXuexili.setText("停止运行")
        else:
            # 停止所有线程
            for thread in self.threads:
                if thread:
                    thread.stop()
            self.threads = []
            self.logText.clear()
            self.startXuexili.setText("开始运行")
    
    def start_tower_running(self):
        if self.startTower.text() == "开始运行":
            pet_name=self.towerPokemonComboBox.currentText()
            hwnds = get_all_hwnds()
            logging.info(f"检测到 {len(hwnds)} 个游戏窗口")
            # 为每个窗口创建一个线程
            self.threads = []
            try:
                heart=network_dll.send_heartbeat(CARD,RESULT['token'])
                if heart['message']=="1":
                    for i, hwnd in enumerate(hwnds):
                        thread = TowerThread(pet_name, hwnd)
                        self.threads.append(thread)
                        # dm.MoveTo(hwnd,0,0)
                else:
                    cleanup_handler()
                    QApplication.quit()  # 使用安全退出
                    return
            except Exception as e:
                cleanup_handler()
                QApplication.quit()  # 使用安全退出
                return
        
            for thread in self.threads:
                thread.start()
            self.startTower.setText("停止运行")
        else:
            for thread in self.threads:
                if thread:
                    thread.stop()
            self.threads = []
            self.logText.clear()
            self.startTower.setText("开始运行")
            
    def start_daily_running(self):
        if self.startDaily.text() == "开始运行":
            daily_name=self.daily_button_group.checkedButton().text()
            hwnds = get_all_hwnds()

            logging.info(f"检测到 {len(hwnds)} 个游戏窗口")
            # 为每个窗口创建一个线程
            self.threads = []
            try:
                heart=network_dll.send_heartbeat(CARD,RESULT['token'])
                if heart['message']=="1":
                    for i, hwnd in enumerate(hwnds):
                        resize_window(hwnd)
                        thread = DailyThread(daily_name,hwnd)
                        self.threads.append(thread)
                        # dm.MoveTo(hwnd,0,0)
                else:
                    cleanup_handler()
                    QApplication.quit()  # 使用安全退出
                    return
            except Exception as e:
                cleanup_handler()
                QApplication.quit()  # 使用安全退出
                return
            for thread in self.threads:
                thread.start()
            logging.info(f"开始{daily_name}")
            self.startDaily.setText("停止运行")
        else:
            # 停止所有线程
            for thread in self.threads:
                if thread:
                    thread.stop()
            self.threads = []
            self.logText.clear()
            self.startDaily.setText("开始运行")

def cleanup_handler():
    """清理处理函数"""
    try:
        if RESULT:
            network_dll.cleanup()
            logging.info("清理完成")
    except Exception as e:
        logging.error(f"清理时出错: {e}")


if __name__=="__main__":

    # 设置全局异常钩子
    sys.excepthook = global_exception_handler
    is_compiled = hasattr(sys.modules[__name__], "__compiled__")
    if is_compiled:
        # 创建一个空设备指向
        devnull = open(os.devnull, 'w')
        sys.stdout = devnull
        sys.stderr = devnull
        # 彻底重写 print，使其在底层不执行任何操作
        import builtins
        def dummy_print(*args, **kwargs):
            pass
        builtins.print = dummy_print


    app=QApplication([])
    app.aboutToQuit.connect(lambda: network_dll.cleanup())  # 注册清理函数
    if not is_scale_100():   
        QMessageBox.warning(
            None,
            "DPI 缩放提示",
            "本脚本仅支持 100% 显示缩放（检测到当前非 100%）。\n\n"
            "点击“ok”将自动打开显示设置，请将显示缩放调整为 100% 后,重新运行本程序和游戏。"
            )
        os.system("start ms-settings:display")
        sys.exit(0)  # 直接退出
    login=CardLoginDialog()
    if login.exec() == QDialog.DialogCode.Accepted:
        RESULT=login.login_result
        try:
            expire=RESULT['expire']
        except ValueError as e:
            network_dll.block_card(RESULT['card'])
            cleanup_handler()

        window=MyWindow()
        window.show()
        # 启动后台心跳线程
        t = threading.Thread(target=lambda:network_dll.heartbeat_check(), daemon=True)
        t.start()
        app.exec()
    else:
        sys.exit(0)