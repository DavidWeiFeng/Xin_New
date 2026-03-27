# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file '脚本.ui'
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
from PySide6.QtWidgets import (QApplication, QCheckBox, QComboBox, QGridLayout,
    QGroupBox, QHBoxLayout, QLabel, QListWidget,
    QListWidgetItem, QPlainTextEdit, QPushButton, QRadioButton,
    QSizePolicy, QSpinBox, QStackedWidget, QWidget)

class Ui_Form(object):
    def setupUi(self, Form):
        if not Form.objectName():
            Form.setObjectName(u"Form")
        Form.resize(653, 487)
        Form.setStyleSheet(u"QListWidget {\n"
"    border: none;\n"
"    outline: none;\n"
"}\n"
"\n"
"QListWidget::item {\n"
"    height: 40px;\n"
"    padding-left: 12px;\n"
"    font-size: 14px;\n"
"    color: #2d2d2d;\n"
"    border: none;\n"
"}\n"
"\n"
"QListWidget::item:selected {\n"
"    background-color: #dcdcdc;\n"
"    color: black;\n"
"    border: none;\n"
"}\n"
"\n"
"QListWidget::item:hover {\n"
"    background-color: #eaeaea;\n"
"}\n"
"")
        self.functionListWidget = QListWidget(Form)
        QListWidgetItem(self.functionListWidget)
        QListWidgetItem(self.functionListWidget)
        QListWidgetItem(self.functionListWidget)
        QListWidgetItem(self.functionListWidget)
        self.functionListWidget.setObjectName(u"functionListWidget")
        self.functionListWidget.setGeometry(QRect(0, 0, 71, 171))
        self.functionListWidget.setAutoFillBackground(False)
        self.functionListWidget.setStyleSheet(u"QListWidget {\n"
"    background-color: #f4f4f4;\n"
"    border: none;\n"
"    outline: none;\n"
"}\n"
"\n"
"QListWidget::item {\n"
"    height: 40px;\n"
"    padding-left: 12px;\n"
"    font-size: 14px;\n"
"    color: #2d2d2d;\n"
"    border: none;\n"
"}\n"
"\n"
"QListWidget::item:selected {\n"
"    background-color: #dcdcdc;\n"
"    color: black;\n"
"    border: none;\n"
"}\n"
"\n"
"QListWidget::item:hover {\n"
"    background-color: #e6e6e6;\n"
"}\n"
"")
        self.functionListWidget.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAsNeeded)
        self.settingListWidget = QListWidget(Form)
        QListWidgetItem(self.settingListWidget)
        QListWidgetItem(self.settingListWidget)
        QListWidgetItem(self.settingListWidget)
        QListWidgetItem(self.settingListWidget)
        self.settingListWidget.setObjectName(u"settingListWidget")
        self.settingListWidget.setGeometry(QRect(0, 320, 71, 161))
        self.settingListWidget.setStyleSheet(u"QListWidget {\n"
"    background-color: #f4f4f4;\n"
"    border: none;\n"
"    outline: none;\n"
"}\n"
"\n"
"QListWidget::item {\n"
"    height: 40px;\n"
"    padding-left: 12px;\n"
"    font-size: 14px;\n"
"    color: #2d2d2d;\n"
"    border: none;\n"
"}\n"
"\n"
"QListWidget::item:selected {\n"
"    background-color: #dcdcdc;\n"
"    color: black;\n"
"    border: none;\n"
"}\n"
"\n"
"QListWidget::item:hover {\n"
"    background-color: #e6e6e6;\n"
"}\n"
"")
        self.settingListWidget.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAsNeeded)
        self.stackedWidget = QStackedWidget(Form)
        self.stackedWidget.setObjectName(u"stackedWidget")
        self.stackedWidget.setGeometry(QRect(80, 0, 591, 321))
        self.page = QWidget()
        self.page.setObjectName(u"page")
        self.gridLayoutWidget = QWidget(self.page)
        self.gridLayoutWidget.setObjectName(u"gridLayoutWidget")
        self.gridLayoutWidget.setGeometry(QRect(0, 10, 521, 151))
        self.gridLayout = QGridLayout(self.gridLayoutWidget)
        self.gridLayout.setObjectName(u"gridLayout")
        self.gridLayout.setContentsMargins(0, 0, 0, 0)
        self.tefangGroupBox = QGroupBox(self.gridLayoutWidget)
        self.tefangGroupBox.setObjectName(u"tefangGroupBox")
        self.layoutWidget = QWidget(self.tefangGroupBox)
        self.layoutWidget.setObjectName(u"layoutWidget")
        self.layoutWidget.setGeometry(QRect(10, 30, 126, 22))
        self.horizontalLayout_5 = QHBoxLayout(self.layoutWidget)
        self.horizontalLayout_5.setObjectName(u"horizontalLayout_5")
        self.horizontalLayout_5.setContentsMargins(0, 0, 0, 0)
        self.dayiwaButton_2 = QRadioButton(self.layoutWidget)
        self.dayiwaButton_2.setObjectName(u"dayiwaButton_2")
        self.dayiwaButton_2.setAutoExclusive(False)

        self.horizontalLayout_5.addWidget(self.dayiwaButton_2)


        self.gridLayout.addWidget(self.tefangGroupBox, 1, 1, 1, 1)

        self.tegongGroupBox = QGroupBox(self.gridLayoutWidget)
        self.tegongGroupBox.setObjectName(u"tegongGroupBox")
        self.layoutWidget1 = QWidget(self.tegongGroupBox)
        self.layoutWidget1.setObjectName(u"layoutWidget1")
        self.layoutWidget1.setGeometry(QRect(10, 30, 138, 22))
        self.horizontalLayout_2 = QHBoxLayout(self.layoutWidget1)
        self.horizontalLayout_2.setObjectName(u"horizontalLayout_2")
        self.horizontalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.xianrenqiuButton = QRadioButton(self.layoutWidget1)
        self.xianrenqiuButton.setObjectName(u"xianrenqiuButton")
        self.xianrenqiuButton.setAutoExclusive(False)

        self.horizontalLayout_2.addWidget(self.xianrenqiuButton)


        self.gridLayout.addWidget(self.tegongGroupBox, 0, 1, 1, 1)

        self.gongjiGroupBox = QGroupBox(self.gridLayoutWidget)
        self.gongjiGroupBox.setObjectName(u"gongjiGroupBox")
        self.layoutWidget2 = QWidget(self.gongjiGroupBox)
        self.layoutWidget2.setObjectName(u"layoutWidget2")
        self.layoutWidget2.setGeometry(QRect(10, 30, 146, 22))
        self.horizontalLayout = QHBoxLayout(self.layoutWidget2)
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.pipiButton = QRadioButton(self.layoutWidget2)
        self.pipiButton.setObjectName(u"pipiButton")
        self.pipiButton.setAutoExclusive(False)

        self.horizontalLayout.addWidget(self.pipiButton)


        self.gridLayout.addWidget(self.gongjiGroupBox, 0, 0, 1, 1)

        self.suduGroupBox = QGroupBox(self.gridLayoutWidget)
        self.suduGroupBox.setObjectName(u"suduGroupBox")
        self.layoutWidget3 = QWidget(self.suduGroupBox)
        self.layoutWidget3.setObjectName(u"layoutWidget3")
        self.layoutWidget3.setGeometry(QRect(10, 30, 126, 22))
        self.horizontalLayout_3 = QHBoxLayout(self.layoutWidget3)
        self.horizontalLayout_3.setObjectName(u"horizontalLayout_3")
        self.horizontalLayout_3.setContentsMargins(0, 0, 0, 0)
        self.maomaoButton = QRadioButton(self.layoutWidget3)
        self.maomaoButton.setObjectName(u"maomaoButton")
        self.maomaoButton.setAutoExclusive(False)

        self.horizontalLayout_3.addWidget(self.maomaoButton)


        self.gridLayout.addWidget(self.suduGroupBox, 0, 2, 1, 1)

        self.fangyuGroupBox = QGroupBox(self.gridLayoutWidget)
        self.fangyuGroupBox.setObjectName(u"fangyuGroupBox")
        self.widget = QWidget(self.fangyuGroupBox)
        self.widget.setObjectName(u"widget")
        self.widget.setGeometry(QRect(11, 31, 114, 21))
        self.horizontalLayout_9 = QHBoxLayout(self.widget)
        self.horizontalLayout_9.setObjectName(u"horizontalLayout_9")
        self.horizontalLayout_9.setContentsMargins(0, 0, 0, 0)
        self.chasiButton = QRadioButton(self.widget)
        self.chasiButton.setObjectName(u"chasiButton")
        self.chasiButton.setAutoExclusive(False)

        self.horizontalLayout_9.addWidget(self.chasiButton)


        self.gridLayout.addWidget(self.fangyuGroupBox, 1, 0, 1, 1)

        self.tiliGroupBox = QGroupBox(self.gridLayoutWidget)
        self.tiliGroupBox.setObjectName(u"tiliGroupBox")
        self.dadinggeButton = QRadioButton(self.tiliGroupBox)
        self.dadinggeButton.setObjectName(u"dadinggeButton")
        self.dadinggeButton.setGeometry(QRect(10, 30, 80, 19))
        self.dadinggeButton.setAutoExclusive(False)

        self.gridLayout.addWidget(self.tiliGroupBox, 1, 2, 1, 1)

        self.skillSetting = QGroupBox(self.page)
        self.skillSetting.setObjectName(u"skillSetting")
        self.skillSetting.setGeometry(QRect(0, 200, 351, 81))
        self.firstskillButton = QRadioButton(self.skillSetting)
        self.firstskillButton.setObjectName(u"firstskillButton")
        self.firstskillButton.setGeometry(QRect(22, 23, 59, 19))
        self.firstskillButton.setChecked(True)
        self.secondskillButton = QRadioButton(self.skillSetting)
        self.secondskillButton.setObjectName(u"secondskillButton")
        self.secondskillButton.setGeometry(QRect(87, 23, 59, 19))
        self.thirdskillButton = QRadioButton(self.skillSetting)
        self.thirdskillButton.setObjectName(u"thirdskillButton")
        self.thirdskillButton.setGeometry(QRect(22, 48, 59, 19))
        self.fouthskillButton = QRadioButton(self.skillSetting)
        self.fouthskillButton.setObjectName(u"fouthskillButton")
        self.fouthskillButton.setGeometry(QRect(87, 48, 59, 19))
        self.label = QLabel(self.skillSetting)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(180, 20, 111, 16))
        self.heal_spinBox = QSpinBox(self.skillSetting)
        self.heal_spinBox.setObjectName(u"heal_spinBox")
        self.heal_spinBox.setGeometry(QRect(180, 50, 61, 21))
        self.heal_spinBox.setValue(5)
        self.startXuexili = QPushButton(self.page)
        self.startXuexili.setObjectName(u"startXuexili")
        self.startXuexili.setGeometry(QRect(380, 210, 81, 51))
        self.label_3 = QLabel(self.page)
        self.label_3.setObjectName(u"label_3")
        self.label_3.setGeometry(QRect(380, 260, 111, 31))
        self.layoutWidget4 = QWidget(self.page)
        self.layoutWidget4.setObjectName(u"layoutWidget4")
        self.layoutWidget4.setGeometry(QRect(0, 170, 482, 23))
        self.horizontalLayout_8 = QHBoxLayout(self.layoutWidget4)
        self.horizontalLayout_8.setObjectName(u"horizontalLayout_8")
        self.horizontalLayout_8.setContentsMargins(0, 0, 0, 0)
        self.othersButton = QRadioButton(self.layoutWidget4)
        self.othersButton.setObjectName(u"othersButton")

        self.horizontalLayout_8.addWidget(self.othersButton)

        self.othersComboBox = QComboBox(self.layoutWidget4)
        self.othersComboBox.setObjectName(u"othersComboBox")

        self.horizontalLayout_8.addWidget(self.othersComboBox)

        self.catchRareCheckBox = QCheckBox(self.layoutWidget4)
        self.catchRareCheckBox.setObjectName(u"catchRareCheckBox")

        self.horizontalLayout_8.addWidget(self.catchRareCheckBox)

        self.schoolButton = QRadioButton(self.layoutWidget4)
        self.schoolButton.setObjectName(u"schoolButton")

        self.horizontalLayout_8.addWidget(self.schoolButton)

        self.stackedWidget.addWidget(self.page)
        self.page_2 = QWidget()
        self.page_2.setObjectName(u"page_2")
        self.shinyGroupBox = QGroupBox(self.page_2)
        self.shinyGroupBox.setObjectName(u"shinyGroupBox")
        self.shinyGroupBox.setGeometry(QRect(-10, 10, 171, 61))
        self.shinyLabel = QLabel(self.shinyGroupBox)
        self.shinyLabel.setObjectName(u"shinyLabel")
        self.shinyLabel.setGeometry(QRect(11, 31, 60, 16))
        self.shinyComboBox = QComboBox(self.shinyGroupBox)
        self.shinyComboBox.setObjectName(u"shinyComboBox")
        self.shinyComboBox.setGeometry(QRect(77, 31, 69, 21))
        self.catchSettingGroupBox = QGroupBox(self.page_2)
        self.catchSettingGroupBox.setObjectName(u"catchSettingGroupBox")
        self.catchSettingGroupBox.setGeometry(QRect(-10, 80, 581, 141))
        self.ballLabel = QLabel(self.catchSettingGroupBox)
        self.ballLabel.setObjectName(u"ballLabel")
        self.ballLabel.setGeometry(QRect(11, 31, 60, 16))
        self.ballComboBox = QComboBox(self.catchSettingGroupBox)
        self.ballComboBox.setObjectName(u"ballComboBox")
        self.ballComboBox.setGeometry(QRect(77, 31, 71, 21))
        self.catchingTypelabel_3 = QLabel(self.catchSettingGroupBox)
        self.catchingTypelabel_3.setObjectName(u"catchingTypelabel_3")
        self.catchingTypelabel_3.setGeometry(QRect(11, 71, 60, 16))
        self.catchingTypelabel_2 = QLabel(self.catchSettingGroupBox)
        self.catchingTypelabel_2.setObjectName(u"catchingTypelabel_2")
        self.catchingTypelabel_2.setGeometry(QRect(11, 111, 60, 16))
        self.AllCheckBox = QCheckBox(self.catchSettingGroupBox)
        self.AllCheckBox.setObjectName(u"AllCheckBox")
        self.AllCheckBox.setGeometry(QRect(471, 71, 111, 19))
        self.onlyHighCheckBox2 = QCheckBox(self.catchSettingGroupBox)
        self.onlyHighCheckBox2.setObjectName(u"onlyHighCheckBox2")
        self.onlyHighCheckBox2.setGeometry(QRect(269, 71, 95, 19))
        self.cactusCheckBox = QCheckBox(self.catchSettingGroupBox)
        self.cactusCheckBox.setObjectName(u"cactusCheckBox")
        self.cactusCheckBox.setGeometry(QRect(180, 71, 83, 19))
        self.shinyAndRareCheckBox = QCheckBox(self.catchSettingGroupBox)
        self.shinyAndRareCheckBox.setObjectName(u"shinyAndRareCheckBox")
        self.shinyAndRareCheckBox.setGeometry(QRect(79, 71, 95, 19))
        self.onlyHighCheckBox = QCheckBox(self.catchSettingGroupBox)
        self.onlyHighCheckBox.setObjectName(u"onlyHighCheckBox")
        self.onlyHighCheckBox.setGeometry(QRect(370, 71, 95, 19))
        self.layoutWidget5 = QWidget(self.catchSettingGroupBox)
        self.layoutWidget5.setObjectName(u"layoutWidget5")
        self.layoutWidget5.setGeometry(QRect(81, 111, 232, 21))
        self.horizontalLayout_4 = QHBoxLayout(self.layoutWidget5)
        self.horizontalLayout_4.setObjectName(u"horizontalLayout_4")
        self.horizontalLayout_4.setContentsMargins(0, 0, 0, 0)
        self.defaultButton_2 = QRadioButton(self.layoutWidget5)
        self.defaultButton_2.setObjectName(u"defaultButton_2")
        self.defaultButton_2.setChecked(True)

        self.horizontalLayout_4.addWidget(self.defaultButton_2)

        self.afkButton = QRadioButton(self.layoutWidget5)
        self.afkButton.setObjectName(u"afkButton")
        self.afkButton.setChecked(False)

        self.horizontalLayout_4.addWidget(self.afkButton)

        self.switchMapButton = QRadioButton(self.layoutWidget5)
        self.switchMapButton.setObjectName(u"switchMapButton")
        self.switchMapButton.setChecked(False)

        self.horizontalLayout_4.addWidget(self.switchMapButton)

        self.greenPlayerButton = QRadioButton(self.layoutWidget5)
        self.greenPlayerButton.setObjectName(u"greenPlayerButton")
        self.greenPlayerButton.setChecked(False)

        self.horizontalLayout_4.addWidget(self.greenPlayerButton)

        self.startCatch = QPushButton(self.page_2)
        self.startCatch.setObjectName(u"startCatch")
        self.startCatch.setGeometry(QRect(430, 230, 81, 51))
        self.label_4 = QLabel(self.page_2)
        self.label_4.setObjectName(u"label_4")
        self.label_4.setGeometry(QRect(430, 280, 111, 31))
        self.stackedWidget.addWidget(self.page_2)
        self.page_3 = QWidget()
        self.page_3.setObjectName(u"page_3")
        self.towerPokemonlabel = QLabel(self.page_3)
        self.towerPokemonlabel.setObjectName(u"towerPokemonlabel")
        self.towerPokemonlabel.setGeometry(QRect(11, 41, 51, 16))
        self.towerPokemonComboBox = QComboBox(self.page_3)
        self.towerPokemonComboBox.setObjectName(u"towerPokemonComboBox")
        self.towerPokemonComboBox.setGeometry(QRect(68, 41, 121, 21))
        self.towerPokemonComboBox.setStyleSheet(u"")
        self.startTower = QPushButton(self.page_3)
        self.startTower.setObjectName(u"startTower")
        self.startTower.setGeometry(QRect(240, 30, 81, 51))
        self.label_5 = QLabel(self.page_3)
        self.label_5.setObjectName(u"label_5")
        self.label_5.setGeometry(QRect(240, 90, 111, 31))
        self.stackedWidget.addWidget(self.page_3)
        self.page_4 = QWidget()
        self.page_4.setObjectName(u"page_4")
        self.auotoLuanDouButton = QRadioButton(self.page_4)
        self.auotoLuanDouButton.setObjectName(u"auotoLuanDouButton")
        self.auotoLuanDouButton.setGeometry(QRect(10, 20, 95, 19))
        self.startDaily = QPushButton(self.page_4)
        self.startDaily.setObjectName(u"startDaily")
        self.startDaily.setGeometry(QRect(410, 200, 81, 51))
        self.label_2 = QLabel(self.page_4)
        self.label_2.setObjectName(u"label_2")
        self.label_2.setGeometry(QRect(410, 260, 111, 31))
        self.sageluosiButton = QRadioButton(self.page_4)
        self.sageluosiButton.setObjectName(u"sageluosiButton")
        self.sageluosiButton.setGeometry(QRect(10, 50, 171, 19))
        self.haidaoButton = QRadioButton(self.page_4)
        self.haidaoButton.setObjectName(u"haidaoButton")
        self.haidaoButton.setGeometry(QRect(10, 80, 171, 19))
        self.wakuangButton = QRadioButton(self.page_4)
        self.wakuangButton.setObjectName(u"wakuangButton")
        self.wakuangButton.setGeometry(QRect(10, 110, 231, 19))
        self.killBossButton = QRadioButton(self.page_4)
        self.killBossButton.setObjectName(u"killBossButton")
        self.killBossButton.setGeometry(QRect(10, 140, 261, 19))
        self.bossNamecomboBox = QComboBox(self.page_4)
        self.bossNamecomboBox.setObjectName(u"bossNamecomboBox")
        self.bossNamecomboBox.setGeometry(QRect(240, 140, 69, 22))
        self.autoHeChengButton = QRadioButton(self.page_4)
        self.autoHeChengButton.setObjectName(u"autoHeChengButton")
        self.autoHeChengButton.setGeometry(QRect(10, 170, 181, 19))
        self.autoSettingButton = QRadioButton(self.page_4)
        self.autoSettingButton.setObjectName(u"autoSettingButton")
        self.autoSettingButton.setGeometry(QRect(10, 200, 191, 19))
        self.stackedWidget.addWidget(self.page_4)
        self.logText = QPlainTextEdit(Form)
        self.logText.setObjectName(u"logText")
        self.logText.setGeometry(QRect(80, 320, 571, 171))
        self.logText.setStyleSheet(u"QPlainTextEdit {\n"
"    background-color: #f4f4f4;\n"
"    border: 1px solid #d0d0d0;\n"
"    font-family: Consolas, \"Courier New\", monospace;\n"
"    font-size: 13px;\n"
"    color: #2d2d2d;\n"
"    padding: 6px;\n"
"}\n"
"")
        self.layoutWidget6 = QWidget(Form)
        self.layoutWidget6.setObjectName(u"layoutWidget6")
        self.layoutWidget6.setGeometry(QRect(0, 0, 2, 2))
        self.horizontalLayout_6 = QHBoxLayout(self.layoutWidget6)
        self.horizontalLayout_6.setObjectName(u"horizontalLayout_6")
        self.horizontalLayout_6.setContentsMargins(0, 0, 0, 0)
        self.onlyHighNierCheckBox = QCheckBox(Form)
        self.onlyHighNierCheckBox.setObjectName(u"onlyHighNierCheckBox")
        self.onlyHighNierCheckBox.setGeometry(QRect(3, 290, 111, 21))
        self.refreshCheckBox = QCheckBox(Form)
        self.refreshCheckBox.setObjectName(u"refreshCheckBox")
        self.refreshCheckBox.setGeometry(QRect(3, 270, 71, 21))
        self.refreshCheckBox.setChecked(True)
        self.widget1 = QWidget(Form)
        self.widget1.setObjectName(u"widget1")
        self.widget1.setGeometry(QRect(0, 0, 2, 2))
        self.horizontalLayout_7 = QHBoxLayout(self.widget1)
        self.horizontalLayout_7.setObjectName(u"horizontalLayout_7")
        self.horizontalLayout_7.setContentsMargins(0, 0, 0, 0)

        self.retranslateUi(Form)

        self.stackedWidget.setCurrentIndex(1)


        QMetaObject.connectSlotsByName(Form)
    # setupUi

    def retranslateUi(self, Form):
        Form.setWindowTitle(QCoreApplication.translate("Form", u"\u4e4c\u7687\u79d1\u6280\uff0c\u552f\u4e00\u4f5c\u8005QQ2485416708", None))

        __sortingEnabled = self.functionListWidget.isSortingEnabled()
        self.functionListWidget.setSortingEnabled(False)
        ___qlistwidgetitem = self.functionListWidget.item(0)
        ___qlistwidgetitem.setText(QCoreApplication.translate("Form", u"\u5b66\u4e60\u529b", None));
        ___qlistwidgetitem1 = self.functionListWidget.item(1)
        ___qlistwidgetitem1.setText(QCoreApplication.translate("Form", u"\u6355\u6349\u7cbe\u7075", None));
        ___qlistwidgetitem2 = self.functionListWidget.item(2)
        ___qlistwidgetitem2.setText(QCoreApplication.translate("Form", u"\u722c\u5854", None));
        ___qlistwidgetitem3 = self.functionListWidget.item(3)
        ___qlistwidgetitem3.setText(QCoreApplication.translate("Form", u"\u65e5\u5e38", None));
        self.functionListWidget.setSortingEnabled(__sortingEnabled)


        __sortingEnabled1 = self.settingListWidget.isSortingEnabled()
        self.settingListWidget.setSortingEnabled(False)
        ___qlistwidgetitem4 = self.settingListWidget.item(0)
        ___qlistwidgetitem4.setText(QCoreApplication.translate("Form", u"\u6253\u5f00\u6e38\u620f", None));
        ___qlistwidgetitem5 = self.settingListWidget.item(1)
        ___qlistwidgetitem5.setText(QCoreApplication.translate("Form", u"\u6253\u5f00\u65e5\u5fd7", None));
        ___qlistwidgetitem6 = self.settingListWidget.item(2)
        ___qlistwidgetitem6.setText(QCoreApplication.translate("Form", u"\u6e05\u7a7a\u65e5\u5fd7", None));
        ___qlistwidgetitem7 = self.settingListWidget.item(3)
        ___qlistwidgetitem7.setText(QCoreApplication.translate("Form", u"\u8bbe\u7f6e", None));
        self.settingListWidget.setSortingEnabled(__sortingEnabled1)

        self.tefangGroupBox.setTitle(QCoreApplication.translate("Form", u"\u7279\u9632", None))
        self.dayiwaButton_2.setText(QCoreApplication.translate("Form", u"\u4f0a\u5a03", None))
        self.tegongGroupBox.setTitle(QCoreApplication.translate("Form", u"\u7279\u653b", None))
        self.xianrenqiuButton.setText(QCoreApplication.translate("Form", u"\u4ed9\u4eba\u7403", None))
        self.gongjiGroupBox.setTitle(QCoreApplication.translate("Form", u"\u653b\u51fb", None))
        self.pipiButton.setText(QCoreApplication.translate("Form", u"\u76ae\u76ae", None))
        self.suduGroupBox.setTitle(QCoreApplication.translate("Form", u"\u901f\u5ea6", None))
        self.maomaoButton.setText(QCoreApplication.translate("Form", u"\u6bdb\u6bdb", None))
        self.fangyuGroupBox.setTitle(QCoreApplication.translate("Form", u"\u9632\u5fa1", None))
        self.chasiButton.setText(QCoreApplication.translate("Form", u"\u67e5\u65af", None))
        self.tiliGroupBox.setTitle(QCoreApplication.translate("Form", u"\u4f53\u529b", None))
        self.dadinggeButton.setText(QCoreApplication.translate("Form", u"\u4e01\u683c", None))
        self.skillSetting.setTitle(QCoreApplication.translate("Form", u"\u91ca\u653e\u6280\u80fd", None))
        self.firstskillButton.setText(QCoreApplication.translate("Form", u"\u4e00\u6280\u80fd", None))
        self.secondskillButton.setText(QCoreApplication.translate("Form", u"\u4e8c\u6280\u80fd", None))
        self.thirdskillButton.setText(QCoreApplication.translate("Form", u"\u4e09\u6280\u80fd", None))
        self.fouthskillButton.setText(QCoreApplication.translate("Form", u"\u56db\u6280\u80fd", None))
        self.label.setText(QCoreApplication.translate("Form", u"\u6bcf\u591a\u5c11\u573a\u56de\u590d\u4f53\u529b", None))
        self.startXuexili.setText(QCoreApplication.translate("Form", u"\u5f00\u59cb\u8fd0\u884c", None))
        self.label_3.setText(QCoreApplication.translate("Form", u"F1\u5feb\u901f\u8fd0\u884c/\u505c\u6b62", None))
        self.othersButton.setText(QCoreApplication.translate("Form", u"\u5237\u6750\u6599\uff1a", None))
        self.catchRareCheckBox.setText(QCoreApplication.translate("Form", u"\u6355\u6349\u9047\u5230\u7684\u7a00\u6709\uff08\u80cc\u5305\u9700\u643a\u5e26\u6ce2\u514b\u5c14\u7cfb\u5217\uff09", None))
        self.schoolButton.setText(QCoreApplication.translate("Form", u"\u7cbe\u7075\u5b66\u9662", None))
        self.shinyGroupBox.setTitle(QCoreApplication.translate("Form", u"\u5f02\u8272\u7cbe\u7075\u6355\u6349", None))
        self.shinyLabel.setText(QCoreApplication.translate("Form", u"\u76ee\u6807\u7cbe\u7075\uff1a", None))
        self.catchSettingGroupBox.setTitle(QCoreApplication.translate("Form", u"\u7cbe\u7075\u6355\u6349\u8bbe\u7f6e", None))
        self.ballLabel.setText(QCoreApplication.translate("Form", u"\u80f6\u56ca\u9009\u62e9\uff1a", None))
        self.catchingTypelabel_3.setText(QCoreApplication.translate("Form", u"\u6355\u6349\u7b56\u7565\uff1a", None))
        self.catchingTypelabel_2.setText(QCoreApplication.translate("Form", u"\u6355\u6349\u6a21\u5f0f\uff1a", None))
        self.AllCheckBox.setText(QCoreApplication.translate("Form", u"\u6293\u666e\u901a\u6240\u6709\u4e2a\u4f53", None))
        self.onlyHighCheckBox2.setText(QCoreApplication.translate("Form", u"\u6293\u7a00\u6709\u9ad8\u4e2a\u4f53", None))
        self.cactusCheckBox.setText(QCoreApplication.translate("Form", u"\u4ed9\u4eba\u638c\u50ac\u7720", None))
        self.shinyAndRareCheckBox.setText(QCoreApplication.translate("Form", u"\u540c\u65f6\u6355\u6349\u7a00\u6709", None))
        self.onlyHighCheckBox.setText(QCoreApplication.translate("Form", u"\u6293\u666e\u901a\u9ad8\u4e2a\u4f53", None))
        self.defaultButton_2.setText(QCoreApplication.translate("Form", u"\u5bf9\u6218", None))
        self.afkButton.setText(QCoreApplication.translate("Form", u"\u539f\u5730\u6302\u673a", None))
        self.switchMapButton.setText(QCoreApplication.translate("Form", u"\u5207\u56fe", None))
        self.greenPlayerButton.setText(QCoreApplication.translate("Form", u"\u7eff\u73a9", None))
        self.startCatch.setText(QCoreApplication.translate("Form", u"\u5f00\u59cb\u8fd0\u884c", None))
        self.label_4.setText(QCoreApplication.translate("Form", u"F1\u5feb\u901f\u8fd0\u884c/\u505c\u6b62", None))
        self.towerPokemonlabel.setText(QCoreApplication.translate("Form", u"\u722c\u5854\u7cbe\u7075:", None))
        self.startTower.setText(QCoreApplication.translate("Form", u"\u5f00\u59cb\u8fd0\u884c", None))
        self.label_5.setText(QCoreApplication.translate("Form", u"F1\u5feb\u901f\u8fd0\u884c/\u505c\u6b62", None))
        self.auotoLuanDouButton.setText(QCoreApplication.translate("Form", u"\u81ea\u52a8\u5927\u4e71\u6597", None))
        self.startDaily.setText(QCoreApplication.translate("Form", u"\u5f00\u59cb\u8fd0\u884c", None))
        self.label_2.setText(QCoreApplication.translate("Form", u"F1\u5feb\u901f\u8fd0\u884c/\u505c\u6b62", None))
        self.sageluosiButton.setText(QCoreApplication.translate("Form", u"\u81ea\u52a8\u8428\u683c\u7f57\u65af\uff08\u9c81\u65af\u738b\u9996\u53d1\uff09", None))
        self.haidaoButton.setText(QCoreApplication.translate("Form", u"\u81ea\u52a8\u6d77\u76d7\uff08\u95ea\u76ae\u9996\u53d1+\u6cf0\u745e\uff09", None))
        self.wakuangButton.setText(QCoreApplication.translate("Form", u"\u5168\u661f\u7403\u81ea\u52a8\u6316\u77ff\uff08\u5148\u8fdb\u5165\u65af\u79d1\u5c14\u661f\uff09", None))
        self.killBossButton.setText(QCoreApplication.translate("Form", u"\u77ac\u6740Boss(\u53ea\u5e26\u4e00\u53ea\u7cbe\u7075\uff0c\u9ed8\u8ba4\u4e00\u6280\u80fd)", None))
        self.autoHeChengButton.setText(QCoreApplication.translate("Form", u"\u81ea\u52a8\u5408\u6210\u6750\u6599(\u81ea\u5df1\u5148\u653e\u597d)", None))
        self.autoSettingButton.setText(QCoreApplication.translate("Form", u"\u4e00\u952e\u9759\u97f3\uff0c\u5c4f\u853d\uff0c\u5f00\u542f\u98de\u884c\u6a21\u5f0f", None))
        self.onlyHighNierCheckBox.setText(QCoreApplication.translate("Form", u"\u4e0d\u6293\u4f4e\u4e2a\u4f53\u5c3c\u5c14", None))
        self.refreshCheckBox.setText(QCoreApplication.translate("Form", u"\u81ea\u52a8\u5237\u65b0", None))
    # retranslateUi

