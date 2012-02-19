import QtQuick 1.1
import com.nokia.meego 1.0
import QtQuick 1.0
import QtMobility.location 1.2
import "parser.js" as JS

Page {
    width:parent.width;
    tools: commonTools
    id:page2
     Column {
         id: rect
         anchors.fill: parent
         anchors.margins: 30
         spacing: 20
         width:parent.width;
         Row {
                 id: rowRow
                 spacing: 10
                 height: 30
                 Switch {
                     id: activeSwitch
                     checked: JS.getBoolSetting('active')
                     onCheckedChanged:{
                          var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
                         if(activeSwitch.checked){
                             JS.updateSetting('active',"1")
                             pm.startDaemon();
                         }else{
                             JS.updateSetting('active',"0")
                             pm.stopDaemon();
                         }
                     }//telos onclicked
                 }
                 Text {
                     //width: rowRow.width - rowRow.spacing - activeSwitch.width
                     height: activeSwitch.height
                     verticalAlignment: Text.AlignVCenter
                     text: activeSwitch.checked ? "Profile changes automatically" : "Application is disabled"
                     font.pixelSize: 27;
                 }
             }
         Rectangle{
             height: 20
             width: parent.width
             color: "transparent"
         }
         Row {
                 id: rowRow2
                 spacing: 10
                 height: 30
                 Switch {
                     id: gpsSwitch
                     checked: JS.getBoolSetting('usegps')
                     onCheckedChanged: {
                         if(gpsSwitch.checked){
                             JS.updateSetting("usegps","1");
                             pm.setGps("1");
                         }else{
                             JS.updateSetting("usegps","0");
                             pm.setGps("0");
                         }
                     }//telos onclicked
                 }
                 Text {
                     width: rowRow.width - rowRow.spacing - activeSwitch.width
                     height: gpsSwitch.height
                     verticalAlignment: Text.AlignVCenter
                     text: gpsSwitch.checked ? "Using Gps Positioning" : "Using Wifi/Cell positioning"
                     font.pixelSize: 27;
                 }
             }
            Rectangle{
                height: 30;
                width: parent.width
                color: "transparent"
            }
            Column{
                width: parent.width
                Rectangle{
                    height: 1;
                    color: "#eeeeee"
                    width: parent.width
                }
                Rectangle{
                    height: 1;
                    color: "#aaaaaa"
                    width: parent.width
                }
            }

            Text{
                id: meters
                font.pixelSize: 28
                color: "black"
                text:"Accuracy in meters (approximate) ";
            }
            Slider {
                id: radiusSlider
                maximumValue: 120
                minimumValue: 1
                value: parseFloat(JS.getSetting('radius'));
                stepSize: 10
                valueIndicatorVisible: true
            }
            Column{
                width: parent.width
                Text{
                    id: batteryWarning
                    font.family: "Helvetica"
                    font.pixelSize: 28
                    color: "black"
                    text:"Update interval (in minutes)";
                }
                Text{
                    id: time
                    font.pixelSize: 20
                    color: "black"
                    text:"Set this to a higher number to save battery";
                }
            }
            Slider {
                id: timeSlider
                maximumValue: 120
                minimumValue: 1
                value: parseFloat(JS.getSetting('time'))
                stepSize: 10
                valueIndicatorVisible: true
            }
            Button {
                text: "Save"
                width:200;
                id:submit
                onClicked:{
                    JS.updateSetting('radius',radiusSlider.value);
                    pm.setRadius(radiusSlider.value);
                    JS.updateSetting('time',timeSlider.value);
                    pm.setInterval(timeSlider.value)
                    pageStack.pop();
                }//telos onclciked submit
            }


     }//telos Rectangle
}
