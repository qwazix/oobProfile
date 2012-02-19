#include "profilemanager.h"
#include <QDebug>
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
//harmattan profile code provided by http://meegoharmattandev.blogspot.com/2011/07/changing-and-accessing-profiles.html
#define PROFILED_SERVICE "com.nokia.profiled"
#define PROFILED_PATH "/com/nokia/profiled"
#define PROFILED_INTERFACE "com.nokia.profiled"
#define PROFILED_GET_PROFILES "get_profiles"
#define PROFILED_SET_PROFILE "set_profile"
#define PROFILED_GET_VALUE "get_value"
#define PROFILED_GET_PROFILE "get_profile"
#define PROFILED_PROFILE_CHANGED "profile_changed"
//// The key for accessing Harmattan's profile type under profile
#define PROFILED_TYPE_VALUE "ringing.alert.type"
 #include <QStringList>


profilemanager::profilemanager(QObject *parent) : QObject(parent)
{
    QDBusConnection::sessionBus().connect("", "",
        PROFILED_INTERFACE,
        PROFILED_PROFILE_CHANGED,
        this,
        SLOT(profileChanged(bool, bool, QString)));
}


static QDBusInterface profiledConnectionInterface("com.nokia.profiled",
                                                  "/com/nokia/profiled",
                                                  "com.nokia.profiled",
                                                  QDBusConnection::sessionBus());

bool profilemanager::setProfile(QString profileName)
{
    if (profileName=="beep") profileName = "meeting";
    if (profileName=="ringing") profileName = "general";
    profiledConnectionInterface.call("set_profile", profileName);
    qDebug() << "To profile allakse se "+ profileName << endl;
    return true;

}

QString profilemanager::getProfile()
{

    QDBusInterface dbus_iface(PROFILED_SERVICE, PROFILED_PATH,PROFILED_INTERFACE);
    QDBusReply<QString> reply =  dbus_iface.call(PROFILED_GET_PROFILE);
    return reply;

}
QString profilemanager::getAllProfiles()
{

    QDBusInterface dbus_iface(PROFILED_SERVICE, PROFILED_PATH,PROFILED_INTERFACE);
    QDBusReply<QStringList> reply = dbus_iface.call(PROFILED_GET_PROFILES);
    QString jsonProfiles= "[";
    foreach (const QString &plugin, reply.value()) {
        jsonProfiles.append("'");
        jsonProfiles.append(plugin);
        jsonProfiles.append("',");


   }
   jsonProfiles.append("]");
   return jsonProfiles;

}



