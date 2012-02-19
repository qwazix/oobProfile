#include <QDebug>
#include "profilemanager.h"
#include <QtSql>
#include "locationwatcher.h"

LocationWatcher::LocationWatcher(QObject *parent)
    : QObject(parent)
{
   openDB();
   source = QGeoPositionInfoSource::createDefaultSource(this);
   setinterval(getSetting("time"));
   setgpsmode(getSetting("usegps"));
}

QSqlDatabase LocationWatcher::openDB(){
    if (!db.open()){
        db = QSqlDatabase::addDatabase("QSQLITE");
        QString path(QDir::home().path());
        path.append(QDir::separator()).append(".local/share/data/QML/OfflineStorage/Databases/3e6ed8d4e46837c47b903b1e4ae85712.sqlite");
        path = QDir::toNativeSeparators(path);
        db.setDatabaseName(path);
    }
    return db;
}

QString LocationWatcher::getSetting(QString key){
    //QSqlDatabase db = openDB();
    if( db.open() ){
        QSqlQuery query(db);
        query.exec("SELECT value FROM settings WHERE key='"+key+"'");
        query.first();
        QString a = query.value(0).toString();
        return a;
    }//telos db open
    return "failed connection";
}

void LocationWatcher::start(){
    qDebug()<<"start";
    LocationWatcher::enable();
}

void LocationWatcher::stop(){
    qDebug()<<"stop";
    db.close();
    LocationWatcher::disable();
}

void LocationWatcher::setgpsmode(const QString &in0)
{
    if (source) {
        if(in0=="1")
            source->setPreferredPositioningMethods(QGeoPositionInfoSource::AllPositioningMethods);
        else
            source->setPreferredPositioningMethods(QGeoPositionInfoSource::NonSatellitePositioningMethods);
    }
    qDebug()<<in0;
}

void LocationWatcher::setinterval(const QString &in0)
{
    double time = in0.toDouble();
    time= time*60000;
    if(source) source->setUpdateInterval(time);
    qDebug()<<time;
}

void LocationWatcher::setradius(const QString &in0)
{
    radius = in0.toDouble();
    qDebug()<<radius;
}

void LocationWatcher::enable()
{
    if (getSetting("active")=="1"){
        if (source) {
            connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),this, SLOT(positionUpdated(QGeoPositionInfo)));
            source->startUpdates();
        }
    }
}

void LocationWatcher::disable()
{
    if (source) {
        source->stopUpdates();
        disconnect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                   this, SLOT(positionUpdated(QGeoPositionInfo)));
    }
}


double LocationWatcher::convertToRadians(double val) {
    const double PIx = 3.141592653589793;
   return val * PIx / 180;
}

double LocationWatcher::cut(double lat1,double lon1,double lat2,double lon2){

    const double RADIO = 6371; // Mean radius of Earth in Km

        double dlon = convertToRadians(lon1 - lon2);
        double dlat = convertToRadians(lat1 - lat2);

        double a = ( pow(sin(dlat / 2), 2) + cos(convertToRadians(lat1))) * cos(convertToRadians(lat2)) * pow(sin(dlon / 2), 2);

        double angle = 2 * asin(sqrt(a));
        double distance=angle * RADIO;
        distance=distance*1000;
        return distance;
}

void LocationWatcher::positionUpdated(const QGeoPositionInfo &info)
{
    if (info.isValid()) {

        double latitude=info.coordinate().latitude();
        double longitude=info.coordinate().longitude();

        //QSqlDatabase db = openDB();
        profilemanager pm;
        // QSqlDatabase db = QSqlDatabase::database("/home/user/.local/share/data/QML/OfflineStorage/Databases/3e6ed8d4e46837c47b903b1e4ae85712.sqlite");

      if( !db.open() )
      {
        qFatal( "Failed to connect." );
      }
      if( db.open() )
      {      
          QSqlQuery query(db);
          double radius = getSetting("radius").toDouble();

          QString HereProfile="";
          //start looping through all areas
          query.exec("SELECT * FROM records");
          while(query.next()) {
              QString lat = query.value(0).toString();
              QString lon = query.value(1).toString();
              QString profile = query.value(2).toString();
              double lat1 = lat.toDouble();
              double lon1 = lon.toDouble();
              double distance=cut(lat1,lon1,latitude,longitude);
              if(distance<radius){
                    qDebug() << "to vrikame: " << lat<<lon<<profile<<distance<<radius;
                    HereProfile=profile;
                    break;
              }else{
                  HereProfile="";
              }
          }//telos loop perioxes
          if(HereProfile!="")
              pm.setProfile(HereProfile);
          else {
              query.exec("SELECT value FROM settings WHERE key='previousProfile'");
              query.first();
              QString previous=query.value(0).toString();
              qDebug()<<previous;
              pm.setProfile(previous);
          }
      }
    }//telos isvalid

}
