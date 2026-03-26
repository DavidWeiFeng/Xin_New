from PySide6.QtWidgets import QDialog, QMessageBox
from PySide6.QtCore import Qt, Signal, QSettings, QTimer
from Ui.Ui_login import Ui_Dialog  # 你的 .ui 转换的类
import concurrent.futures
import requests
from core import network_dll
from core.utils import Config
from config.config import Auth

class CardLoginDialog(QDialog):

    login_finished = Signal(dict)  # 用于从线程回传结果
    announcement_finished = Signal(str) # 用于回传公告内容

    def __init__(self,parent=None):
        super().__init__(parent)
        self.ui=Ui_Dialog()
        self.ui.setupUi(self)
        self.bind_ui()
        self.settings = QSettings("Wuhuang", "CardLogin")  # 可自定义组织和应用名
        # 读取是否记住卡号
        self.load_saved_card()
        self.login_result=None
        # 创建一个线程池，用于执行后台任务
        self.executor = concurrent.futures.ThreadPoolExecutor(max_workers=2)
        # 获取公告
        self.fetch_announcement()

    def bind_ui(self):
        # 连接信号
        self.ui.loginButton.clicked.connect(self.on_login_clicked)
        #激活信号
        self.login_finished.connect(self.on_login_result)
        self.announcement_finished.connect(self.handle_announcement)

    def handle_announcement(self, text: str):
        """处理公告内容及版本检测"""
        self.ui.announcementTextEdit.setPlainText(text)
        
        # 提取版本信息并校验
        try:
            parts = text.strip().split(":")
            # 假设 : 后面的是版本号，或者最后一部分是版本号
            if len(parts) > 1:
                remote_version = parts[0].strip()
                if remote_version != Auth.VERSION:
                    QMessageBox.warning(self, "版本更新", f"检测到新版本或版本不一致\n最新版本: {remote_version}\n请更新软件后使用。")
                    # 禁止登录
                    self.set_ui_enabled(False)
                    # 取消自动登录（如果有）
                    self.ui.autoLogincheckBox.setChecked(False)
                    self.should_auto_login = False
                    return
        except Exception as e:
            print(f"版本检测出错: {e}")
        
        # 只有在版本检测通过后，才执行自动登录
        if getattr(self, "should_auto_login", False):
            self.should_auto_login = False # 防止重复
            self.on_login_clicked()

    def fetch_announcement(self):
        """异步获取公告"""
        self.executor.submit(self._do_fetch_announcement)

    def _do_fetch_announcement(self):
        try:
            url = "http://101.43.13.55:6666/2x5y5z0k1l5e5m2m"
            response = requests.post(url, timeout=5)
            response.encoding = 'gbk'  # 根据服务器返回的编码设置
            if response.status_code == 200:
                self.announcement_finished.emit(response.text)
            else:
                self.announcement_finished.emit(f"无法获取公告 (HTTP {response.status_code})")
        except Exception as e:
            self.announcement_finished.emit(f"获取公告失败: {e}")


    def set_ui_enabled(self, enabled: bool):
        self.ui.loginButton.setEnabled(enabled)
        self.ui.cardEdit.setEnabled(enabled)
        self.ui.remebercheckBox.setEnabled(enabled)
        self.ui.autoLogincheckBox.setEnabled(enabled)

    def load_saved_card(self):
        saved = self.settings.value("saved_card", "")
        remember = bool(self.settings.value("remember", False))
        auto_login = bool(self.settings.value("auto_login", False))
        
        # 初始化自动登录标志
        self.should_auto_login = False

        if saved and remember:
            self.ui.cardEdit.setText(saved)
            self.ui.remebercheckBox.setChecked(True)
            self.ui.autoLogincheckBox.setChecked(auto_login)
            if auto_login:
                # 只是设置标志，不立即登录，等待公告检测
                self.should_auto_login = True
        else:
            self.ui.remebercheckBox.setChecked(False)
            self.ui.autoLogincheckBox.setChecked(False)

    def save_card_if_needed(self, card: str):
        if self.ui.remebercheckBox.isChecked():
            self.settings.setValue("saved_card", card)
            self.settings.setValue("remember", True)
            self.settings.setValue("auto_login", self.ui.autoLogincheckBox.isChecked())
        else:
            self.settings.remove("saved_card")
            self.settings.setValue("remember", False)
            self.settings.setValue("auto_login", False)

  

    def on_login_clicked(self):
        card = self.ui.cardEdit.text().strip()
        # 简单前端校验
        if not card:
            QMessageBox.warning(self, "提示", "请输入卡密")
            return
        # 禁用 UI，避免重复点击
        self.set_ui_enabled(False)
        self.ui.loginButton.setText("登录中...")
        # 提交任务到线程池，并添加回调
        future = self.executor.submit(self._do_login_thread, card)
        future.add_done_callback(self._on_login_done)

    def _do_login_thread(self, card: str):
        """此函数在后台线程中执行"""
        try:
            # 直接调用DLL函数
            result = network_dll.card_login(card)
            return {"input_card": card, "result": result}
        except Exception as e:
            # 捕获DLL调用期间的任何异常
            return {"input_card": card, "result": {"status": "error", "message": f"登录时发生未知异常: {e}"}}

    def _on_login_done(self, future: concurrent.futures.Future):
        """线程池任务完成时的回调，此回调仍在后台线程中"""
        try:
            # 获取结果，这里可以设置超时，但更稳妥的方式是在 on_login_clicked 中处理
            payload = future.result()
        except concurrent.futures.TimeoutError:
            payload = {"input_card": self.ui.cardEdit.text().strip(), "result": {"status": "error", "message": "登录超时，请检查网络或联系管理员"}}
        except Exception as e:
            payload = {"input_card": self.ui.cardEdit.text().strip(), "result": {"status": "error", "message": f"处理登录结果时出错: {e}"}}
        
        # 将最终结果发送到主线程
        self.login_finished.emit(payload)

    def on_login_result(self, payload: dict):
        card = payload.get("input_card", "")
        result = payload.get("result", {})
        # 恢复 UI
        self.set_ui_enabled(True)
        self.ui.loginButton.setText("登录")

        if result.get("status") == "success":
            # 保存卡号（如果选中）
            self.save_card_if_needed(card)
            expire = result.get("expire")
 # 创建消息框并设置位置
            msg_box = QMessageBox(self)
            msg_box.setWindowTitle("登录成功")
            msg_box.setText(f"登录成功\n到期时间: {expire}")
            msg_box.setIcon(QMessageBox.Information)
            # 设置消息框位置（相对于对话框向下偏移）
            msg_box.move(self.x()+50, self.y() + 150)
            msg_box.exec()
            # 关闭对话框并返回 Accepted
            self.login_result = result
            self.accept()
        else:
            msg = result.get("message", "登录失败")
            QMessageBox.critical(self, "登录失败", msg)

    def closeEvent(self, event):
        # 关闭窗口时，确保线程池被关闭
        self.executor.shutdown(wait=False)
        super().closeEvent(event)