# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file '邮箱配置.ui'
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
from PySide6.QtWidgets import (QAbstractButton, QApplication, QDialog, QDialogButtonBox,
    QHBoxLayout, QLabel, QLineEdit, QSizePolicy,
    QVBoxLayout, QWidget)

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        if not Dialog.objectName():
            Dialog.setObjectName(u"Dialog")
        Dialog.resize(267, 237)
        self.buttonBox = QDialogButtonBox(Dialog)
        self.buttonBox.setObjectName(u"buttonBox")
        self.buttonBox.setGeometry(QRect(20, 190, 181, 31))
        self.buttonBox.setOrientation(Qt.Orientation.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.StandardButton.Cancel|QDialogButtonBox.StandardButton.Save)
        self.layoutWidget = QWidget(Dialog)
        self.layoutWidget.setObjectName(u"layoutWidget")
        self.layoutWidget.setGeometry(QRect(23, 13, 217, 160))
        self.horizontalLayout = QHBoxLayout(self.layoutWidget)
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_2 = QVBoxLayout()
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.senderLabel = QLabel(self.layoutWidget)
        self.senderLabel.setObjectName(u"senderLabel")

        self.verticalLayout_2.addWidget(self.senderLabel)

        self.authorizationCodeLabel = QLabel(self.layoutWidget)
        self.authorizationCodeLabel.setObjectName(u"authorizationCodeLabel")

        self.verticalLayout_2.addWidget(self.authorizationCodeLabel)

        self.receiverLabel = QLabel(self.layoutWidget)
        self.receiverLabel.setObjectName(u"receiverLabel")

        self.verticalLayout_2.addWidget(self.receiverLabel)

        self.senderNameLabel = QLabel(self.layoutWidget)
        self.senderNameLabel.setObjectName(u"senderNameLabel")

        self.verticalLayout_2.addWidget(self.senderNameLabel)

        self.receiverNameLabel = QLabel(self.layoutWidget)
        self.receiverNameLabel.setObjectName(u"receiverNameLabel")

        self.verticalLayout_2.addWidget(self.receiverNameLabel)

        self.vipCodeLabel = QLabel(self.layoutWidget)
        self.vipCodeLabel.setObjectName(u"vipCodeLabel")

        self.verticalLayout_2.addWidget(self.vipCodeLabel)


        self.horizontalLayout.addLayout(self.verticalLayout_2)

        self.verticalLayout = QVBoxLayout()
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.senderLineEdit = QLineEdit(self.layoutWidget)
        self.senderLineEdit.setObjectName(u"senderLineEdit")

        self.verticalLayout.addWidget(self.senderLineEdit)

        self.authorizationCodeLineEdit = QLineEdit(self.layoutWidget)
        self.authorizationCodeLineEdit.setObjectName(u"authorizationCodeLineEdit")

        self.verticalLayout.addWidget(self.authorizationCodeLineEdit)

        self.receiverLineEdit = QLineEdit(self.layoutWidget)
        self.receiverLineEdit.setObjectName(u"receiverLineEdit")

        self.verticalLayout.addWidget(self.receiverLineEdit)

        self.senderNameLineEdit = QLineEdit(self.layoutWidget)
        self.senderNameLineEdit.setObjectName(u"senderNameLineEdit")

        self.verticalLayout.addWidget(self.senderNameLineEdit)

        self.receiverNameEdit = QLineEdit(self.layoutWidget)
        self.receiverNameEdit.setObjectName(u"receiverNameEdit")

        self.verticalLayout.addWidget(self.receiverNameEdit)

        self.vipCodeLineEdit = QLineEdit(self.layoutWidget)
        self.vipCodeLineEdit.setObjectName(u"vipCodeLineEdit")

        self.verticalLayout.addWidget(self.vipCodeLineEdit)


        self.horizontalLayout.addLayout(self.verticalLayout)


        self.retranslateUi(Dialog)
        self.buttonBox.accepted.connect(Dialog.accept)
        self.buttonBox.rejected.connect(Dialog.reject)

        QMetaObject.connectSlotsByName(Dialog)
    # setupUi

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle(QCoreApplication.translate("Dialog", u"\u90ae\u7bb1\u914d\u7f6e", None))
        self.senderLabel.setText(QCoreApplication.translate("Dialog", u"\u53d1\u4ef6\u90ae\u7bb1\uff1a", None))
        self.authorizationCodeLabel.setText(QCoreApplication.translate("Dialog", u"QQ \u6388\u6743\u7801\uff1a", None))
        self.receiverLabel.setText(QCoreApplication.translate("Dialog", u"\u6536\u4ef6\u90ae\u7bb1\uff1a", None))
        self.senderNameLabel.setText(QCoreApplication.translate("Dialog", u"\u53d1\u4ef6\u4eba\u79f0\u547c\uff1a", None))
        self.receiverNameLabel.setText(QCoreApplication.translate("Dialog", u"\u6536\u4ef6\u4eba\u79f0\u547c\uff1a", None))
        self.vipCodeLabel.setText(QCoreApplication.translate("Dialog", u"\u540e\u53f0\u591a\u5f00\u7801\uff1a", None))
    # retranslateUi

