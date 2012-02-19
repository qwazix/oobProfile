#-------------------------------------------------
#
# Project created by QtCreator 2012-01-20T11:44:27
#
#-------------------------------------------------

QT       += core

QT       -= gui

QT += sql \
      dbus

TARGET = oobProfileDaemon
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
    profilemanager.cpp \
    locationwatcher.cpp \
    dbusControlDaemon.cpp

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/oobProfileDaemon/bin
    INSTALLS += target
}

OTHER_FILES += \
    config.txt

CONFIG += mobility
MOBILITY += location
MOBILITY += systeminfo

HEADERS += \
    profilemanager.h \
    locationwatcher.h \
    dbusControlDaemon.h
