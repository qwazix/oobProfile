// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

Rectangle {
    width: 250
    height: 230
    color:"blue"
    MouseArea{
        width: parent.width
        height: parent.height
        onClicked: spm.setSProfile("a");
    }
}
