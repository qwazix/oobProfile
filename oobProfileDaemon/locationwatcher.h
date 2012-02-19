#ifndef LOCATIONWATCHER_H
#define LOCATIONWATCHER_H
#include <QtSql>
#include <QObject>
#include <QGeoPositionInfoSource>
using namespace QtMobility;

class LocationWatcher : public QObject
{
    Q_OBJECT

public:
    explicit LocationWatcher(QObject *parent = 0);
    void enable();
    void disable();

public Q_SLOTS:
    void setinterval(const QString &in0);
    void setgpsmode(const QString &in0);
    void setradius(const QString &in0);
    void stop();
    void start();

private slots:
    void positionUpdated(const QGeoPositionInfo &info);

private:
    double convertToRadians(double);
    double cut(double,double,double,double);
    QSqlDatabase db;
    QSqlDatabase openDB();
    QString getSetting(QString key);
    QGeoPositionInfoSource *source;
    double radius;
};

#endif // LOCATIONWATCHER_H
