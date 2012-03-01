# Add more folders to ship with the application, here
folder_01.source = qml/oobProfileQml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01


# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

contains(MEEGO_EDITION, harmattan) {
    QT += dbus
}

symbian: TARGET.UID3 = 0xEA524E4F

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
#symbian:TARGET.CAPABILITY += NetworkServices
symbian:TARGET.CAPABILITY = ReadDeviceData
symbian:LIBS += -lprofileengine \
#   -letel3rdparty \
#   -lfeatdiscovery

symbian:TARGET.CAPABILITY += WriteDeviceData

CONFIG += mobility
MOBILITY += systeminfo
# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

contains(MEEGO_EDITION, harmattan) {
    # Speed up launching on MeeGo/Harmattan when using applauncherd daemon
    CONFIG += qdeclarative-boostable
}
# Add dependency to Symbian components
 CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    profilemanager.cpp \
    SystemDeviceInfo.cpp \
#    XQProfile.cpp \
#    XQProfile_p.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    profilemanager.h \
    profilemanager.h \
    SystemDeviceInfo.h \
#    XQProfile.h \
#    XQProfile_p.h
    CONFIG += mobility
    MOBILITY += systeminfo

QT += sql

#INCLUDEPATH +=/opt/QtSDK/Symbian/SDKs/S60_5th_Edition_SDK_v1.0/epoc32/include
INCLUDEPATH +=\S60\devices\S60_5th_Edition_SDK_v1.0\epoc32\include

