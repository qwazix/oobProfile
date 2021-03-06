TEMPLATE = subdirs




SUBDIRS += \
    oobProfileQml

symbian {
    DEFINES += Q_OS_SYMBIAN
}


contains(MEEGO_EDITION, harmattan) {
    DEFINES += Q_WS_HARMATTAN
    OTHER_FILES += \
        qtc_packaging/debian_harmattan/rules \
        qtc_packaging/debian_harmattan/README \
        qtc_packaging/debian_harmattan/manifest.aegis \
        qtc_packaging/debian_harmattan/copyright \
        qtc_packaging/debian_harmattan/control \
        qtc_packaging/debian_harmattan/compat \
        qtc_packaging/debian_harmattan/postinst \
        qtc_packaging/debian_harmattan/prerm \
        qtc_packaging/debian_harmattan/changelog
    SUBDIRS += \
        oobProfileDaemon

    mydaemon.path = /etc/init/apps
    mydaemon.files = oobProfileDaemon/oobProfileDaemon.conf



    INSTALLS += mydaemon
}

