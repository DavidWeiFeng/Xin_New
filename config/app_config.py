from PySide6.QtCore import QObject, Signal


class AppConfig(QObject):
    state_changed = Signal(bool)

    def __init__(self):
        super().__init__()
        self._checked = False

    def is_checked(self):
        return self._checked

    def set_checked(self, checked: bool):
        if self._checked == checked:
            return
        self._checked = checked
        self.state_changed.emit(checked)


# ✅ 只创建一次
_app_config = AppConfig()


def app_config() -> AppConfig:
    return _app_config
