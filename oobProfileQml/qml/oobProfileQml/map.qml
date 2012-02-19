import QtQuick 1.0
import QtMobility.location 1.2
import "parser.js" as JS

Map {
    id: map
    plugin : Plugin {name : "nokia"}
    size.width: parent.width
    size.height: 330
    zoomLevel: 20
    center: positionSource.position.coordinate
    //radius = JS.getSetting('radius')

    MapCircle {
        id: myPosition
        color: "#55ff0000"
        radius: JS.getSetting('radius')
        center: positionSource.position.coordinate
    }
}
