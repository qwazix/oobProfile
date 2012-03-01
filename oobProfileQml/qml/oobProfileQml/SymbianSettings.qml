import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import QtMobility.location 1.2
import "parser.js" as JS

Page {
    width:parent.width;
    id:symbianSettings
     Column {
         id: rect
         anchors.fill: parent
         anchors.margins: 30
         spacing: 20
         width:parent.width;

         Rectangle{
             height: 20
             width: parent.width
             color: "transparent"
         }

            Rectangle{
                height: 30;
                width: parent.width
                color: "transparent"
            }

            Text{
                id: meters
                font.pixelSize: 22
                color: "white"
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
                    font.pixelSize: 22
                    color: "white"
                    text:"Update interval (in minutes)";
                }
                Text{
                    id: time
                    font.pixelSize: 16
                    color: "white"
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
                    JS.updateSetting('time',timeSlider.value);
                    pageStack.pop();
                }//telos onclciked submit
            }


     }//telos Rectangle
}
