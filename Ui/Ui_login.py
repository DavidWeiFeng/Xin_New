# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'login.ui'
##
## Created by: Qt User Interface Compiler version 6.7.3
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QApplication, QCheckBox, QDialog, QGroupBox,
    QLabel, QLineEdit, QPlainTextEdit, QPushButton,
    QSizePolicy, QWidget)

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        if not Dialog.objectName():
            Dialog.setObjectName(u"Dialog")
        Dialog.resize(357, 262)
        Dialog.setAutoFillBackground(True)
        Dialog.setStyleSheet(u"label->setStyleSheet(\"background-color: white;\");")
        self.loginButton = QPushButton(Dialog)
        self.loginButton.setObjectName(u"loginButton")
        self.loginButton.setGeometry(QRect(110, 220, 121, 31))
        self.remebercheckBox = QCheckBox(Dialog)
        self.remebercheckBox.setObjectName(u"remebercheckBox")
        self.remebercheckBox.setGeometry(QRect(210, 190, 71, 19))
        self.autoLogincheckBox = QCheckBox(Dialog)
        self.autoLogincheckBox.setObjectName(u"autoLogincheckBox")
        self.autoLogincheckBox.setGeometry(QRect(70, 190, 71, 19))
        self.cardEdit = QLineEdit(Dialog)
        self.cardEdit.setObjectName(u"cardEdit")
        self.cardEdit.setGeometry(QRect(60, 160, 251, 21))
        font = QFont()
        font.setPointSize(10)
        self.cardEdit.setFont(font)
        self.label = QLabel(Dialog)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(15, 160, 39, 16))
        font1 = QFont()
        font1.setPointSize(11)
        self.label.setFont(font1)
        self.announcementTextEdit = QPlainTextEdit(Dialog)
        self.announcementTextEdit.setObjectName(u"announcementTextEdit")
        self.announcementTextEdit.setGeometry(QRect(20, 20, 321, 111))
        self.announcementTextEdit.setFont(font)
        self.groupBox = QGroupBox(Dialog)
        self.groupBox.setObjectName(u"groupBox")
        self.groupBox.setGeometry(QRect(10, 0, 341, 141))
        font2 = QFont()
        font2.setPointSize(9)
        self.groupBox.setFont(font2)
        self.loginButton.raise_()
        self.remebercheckBox.raise_()
        self.autoLogincheckBox.raise_()
        self.cardEdit.raise_()
        self.label.raise_()
        self.groupBox.raise_()
        self.announcementTextEdit.raise_()

        self.retranslateUi(Dialog)

        QMetaObject.connectSlotsByName(Dialog)
    # setupUi

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle(QCoreApplication.translate("Dialog", u"\u4e4c\u7687\u79d1\u6280\uff0c\u552f\u4e00\u4f5c\u8005QQ2485416708 ", None))
        self.loginButton.setText(QCoreApplication.translate("Dialog", u"\u767b\u5f55", None))
        self.remebercheckBox.setText(QCoreApplication.translate("Dialog", u"\u8bb0\u4f4f\u5361\u5bc6", None))
        self.autoLogincheckBox.setText(QCoreApplication.translate("Dialog", u"\u81ea\u52a8\u767b\u5f55", None))
        self.label.setText(QCoreApplication.translate("Dialog", u"\u5361\u5bc6\uff1a", None))
        self.groupBox.setTitle(QCoreApplication.translate("Dialog", u"\u516c\u544a", None))
    # retranslateUi

