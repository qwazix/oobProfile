#include "SystemDeviceInfo.h"
#include <mproengengine.h>
#include <mproengprofile.h>
#include <mproengtonesettings.h>
#include <mproengprofilename.h>
#include <proengfactory.h>





SystemDeviceInfo::SystemDeviceInfo(QWidget *parent): QWidget(parent), deviceInfo(NULL)
{
    deviceInfo = new QSystemDeviceInfo;


}

QString SystemDeviceInfo::getSProfile(){

    QString reply = QString::number((QSystemDeviceInfo::Profile)deviceInfo->currentProfile());
    return reply;
}//end getSProfile


QString SystemDeviceInfo::getSAllProfiles(){

    QString  profiles= "['General', 'Silent', 'Vibrate','Loud','Offline','Custom','Powersave']";
    return profiles;
}//end getSAllProfiles

bool SystemDeviceInfo::setSProfile(QString profileName)
{

    bool result;
    // Create profile engine by using Factory:
    MProEngEngine* profileEngine = ProEngFactory::NewEngineLC();

    profileEngine->SetActiveProfileL( 1);//KProfileOfflineId );
    //if(profileName=='General'){result=profile->setActiveProfile(XQProfile::ProfileGeneral);}
     // if(profileName=='Silent'){result=profile->setActiveProfile(XQProfile::ProfileSilent);}
//        case 'Vibrate' :result=2;
//        case 'Loud' :result=3;
//        case 'Offline' :result=4;
//        case 'Custom' :result=5;
//        case 'Powersave' :result=6;




}//end setSProfile
