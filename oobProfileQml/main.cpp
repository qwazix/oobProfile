//#include <QtGui/QApplication>
#include <QtGui>
#include "qmlapplicationviewer.h"
#include <QApplication>
#include <QtDeclarative>
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#include "profilemanager.h"
#include <QDeclarativeEngine>

//harmattan profile code provided by http://meegoharmattandev.blogspot.com/2011/07/changing-and-accessing-profiles.html
#define PROFILED_SERVICE "com.nokia.profiled"
#define PROFILED_PATH "/com/nokia/profiled"
#define PROFILED_INTERFACE "com.nokia.profiled"
#define PROFILED_GET_PROFILES "get_profiles"
//#define PROFILED_SET_PROFILE "set_profile"
#define PROFILED_GET_VALUE "get_value"



Q_DECL_EXPORT int main(int argc, char *argv[])
{

 QApplication a(argc, argv);

    profilemanager pm;
    QDeclarativeView view;
    QDeclarativeEngine engine;
    QDeclarativeContext *ctxt = view.rootContext();
    ctxt->setContextProperty("pm",&pm );



//        QString customPath = "/home/user/.oobProfile/";




//        QDir dir;
//        if(dir.mkpath(QString(customPath))){
//            //qDebug() << "Default path >> "+engine.offlineStoragePath();
//            //engine.setOfflineStoragePath(QString("qml/OfflineStorage"));
//            view.engine()->setOfflineStoragePath(customPath);

//            qDebug() << "New path >> "+engine.offlineStoragePath();
//        }

//#if defined(MEEGO_EDITION_HARMATTAN)
       view.setSource(QUrl("/opt/oobProfileQml/qml/oobProfileQml/main2.qml"));
//#endif
#if defined(Q_WS_SIMULATOR)
       view.setSource(QUrl("qml/oobProfileQml/main2.qml"));
#endif
    view.showFullScreen();
    //view.show();


//exec /usr/bin/aegis-exec -s -u user /opt/oobProfileDaemon/bin/oobProfileDaemon



    return a.exec();
}


