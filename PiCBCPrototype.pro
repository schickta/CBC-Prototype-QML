# Copyright Drucker Diagnostics 2014

QT += gui

TARGET = CBCPrototype
INCLUDEPATH += usr/local/qt5pi/include/ \
               /mnt/rasp

target.path = /home/pi/$${TARGET}
INSTALLS += target
installPrefix = /home/pi/$${TARGET}

TEMPLATE = app


folder_01.source = qml
folder_01.target = /
DEPLOYMENTFOLDERS += folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH = usr/local/qt5pi/qml

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    knobencoder.cpp \
    cbccalculator.cpp \
    configuration.cpp




# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    knobencoder.h \
    cbccalculator.h \
    configuration.h


#LIBS += -L$$PWD/usr/lib/ -lphidget21


#####LIBS += -L$$PWD/mnt/rasp-pi-rootfs/usr/lib/
#-lphidget21

#INCLUDEPATH += $$PWD/mnt/rasp-pi-rootfs/usr/include
#DEPENDPATH += $$PWD/mnt/rasp-pi-rootfs/usr/include

OTHER_FILES += \
    qml/CBCPrototype/startuppage.qml



unix:!macx: LIBS += -L/mnt/rasp-pi-rootfs/usr/lib/ -lphidget21

INCLUDEPATH += /mnt/rasp-pi-rootfs/usr/include
DEPENDPATH += /mnt/rasp-pi-rootfs/usr/include
