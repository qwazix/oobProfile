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
    private:
};

#endif // PROFILEMANAGER_H
