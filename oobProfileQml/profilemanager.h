#ifndef PROFILEMANAGER_H
#define PROFILEMANAGER_H
#include <QObject>
#include <QDebug>
#include <QList>
#include <QFile>
#include <QTextStream>
#include <QRegExp>
#include <QtDBus/QDBusInterface>


class profilemanager : public QObject
{
    Q_OBJECT
public:
     explicit profilemanager(QObject *parent = 0);
signals:

public slots:
    bool setProfile(QString profileName);
    QString getProfile();
    QString getAllProfiles();
    void sendToBackground();
#if defined(Q_WS_HARMATTAN)
    void startDaemon();
    void stopDaemon();
    void setInterval(QString time);
    void setRadius(QString radius);
    void setGps(QString gpsonoff);
#endif
    bool checkInternet();
private:

};

#endif // PROFILEMANAGER_H
