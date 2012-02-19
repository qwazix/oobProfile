#include <QtCore/QCoreApplication>
#include <QtDebug>
#include <QtLocation/QGeoPositionInfoSource>
#include <locationwatcher.h>
#include <QtSql>
#include <QtDBus>
#include "dbusControlDaemon.h"


QTM_USE_NAMESPACE

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    LocationWatcher* myWatcher = new LocationWatcher();
    new dbusControlDaemon(myWatcher);

    QDBusConnection connection = QDBusConnection::sessionBus();
    bool ret = connection.registerService("gr.oob.startOobProfileDaemon");
    ret = connection.registerObject("/", myWatcher);

    myWatcher->enable();

    return a.exec();
}
