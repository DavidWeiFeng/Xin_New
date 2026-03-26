import os
import sys
import json
from PySide6.QtWidgets import QDialog, QMessageBox
from Ui.Ui_邮箱配置 import Ui_Dialog  # 你的 .ui 转换的类


def get_documents_dir():
    """返回用户文档目录路径"""
    if os.name == 'nt':  # Windows
        return os.path.join(os.environ['USERPROFILE'], 'Documents')
    

EMAIL_CONFIG_PATH = os.path.join(get_documents_dir(), "email_config.json")


class EmailConfigDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.ui = Ui_Dialog()
        self.ui.setupUi(self)
        self.load_config()

        # 连接按钮槽
        self.ui.buttonBox.accepted.connect(self.save_config)
        self.ui.buttonBox.rejected.connect(self.reject)

    def load_config(self):
        """如果配置文件存在则加载到界面"""
        if os.path.exists(EMAIL_CONFIG_PATH):
            try:
                with open(EMAIL_CONFIG_PATH, 'r', encoding='utf-8') as f:
                    config = json.load(f)

                self.ui.senderLineEdit.setText(config.get("sender_email", ""))
                self.ui.authorizationCodeLineEdit.setText(config.get("auth_code", ""))
                self.ui.receiverLineEdit.setText(config.get("receiver_email", ""))
                self.ui.senderNameLineEdit.setText(config.get("sender_name", ""))
                self.ui.receiverNameEdit.setText(config.get("receiver_name", ""))
                self.ui.vipCodeLineEdit.setText(config.get("vip_code", ""))
            except Exception as e:
                QMessageBox.warning(self, "读取失败", f"无法读取配置文件:\n{e}")
    def save_config(self):
        """将填写的配置保存为JSON"""
        config = {
            "sender_email": self.ui.senderLineEdit.text().strip(),
            "auth_code": self.ui.authorizationCodeLineEdit.text().strip(),
            "receiver_email": self.ui.receiverLineEdit.text().strip(),
            "sender_name": self.ui.senderNameLineEdit.text().strip(),
            "receiver_name": self.ui.receiverNameEdit.text().strip(),
            "vip_code": self.ui.vipCodeLineEdit.text().strip()
        }

        try:
            os.makedirs(os.path.dirname(EMAIL_CONFIG_PATH), exist_ok=True)
            with open(EMAIL_CONFIG_PATH, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=4, ensure_ascii=False)
            self.accept()  # 关闭对话框并返回 Accepted
        except Exception as e:
            QMessageBox.critical(self, "保存失败", f"无法保存配置文件:\n{e}")
