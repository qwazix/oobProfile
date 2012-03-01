#ifndef SYSTEMDEVICEINFO_H
#define SYSTEMDEVICEINFO_H

#include <QtGui/QWidget>
#include <qsysteminfo.h>

using namespace QtMobility;
class SystemDeviceInfo : public QWidget
{
    Q_OBJECT

public:
    SystemDeviceInfo(QWidget *parent = 0);

public slots:
    QString getSProfile();
    QString getSAllProfiles();
    bool setSProfile(QString profileName);

private:
    QSystemDeviceInfo* deviceInfo;
};

#endif // SYSTEMDEVICEINFO_H
