import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import QtMobility.location 1.2
import "parser.js" as JS
//QDeclarativeExampleDB

Page {
    width:parent.width;
    id:symbianMainPage

    function initialize() {

        //        console.log("Check iNTERNET: "+pm.checkInternet())
        //        if (pm.checkInternet()){
        //            var component = Qt.createComponent("map.qml");
        //            if (component.status == Component.Ready) {
        //                var map = component.createObject(column1);
        //            }
        //        }
     var profiles = eval(pm.getAllProfiles());
        var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);

        db.transaction(
            function(tx) {

                tx.executeSql('CREATE TABLE IF NOT EXISTS records(latitude FLOAT, longitude FLOAT, profile TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT, value TEXT)');

                //Mono tin prwti fora dimiourgei ta previousProfile,radius,time
                var results = tx.executeSql('SELECT * FROM settings');
                if(results.rows.length==0){
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'previousProfile', 'silent' ]);
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'radius', '200' ]);//in meters
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'time', '1' ]);//in minutes
                }
            }
        )
        console.log("JS.getHereProfile: "+JS.getHereProfile());

        checkWhatToDo();
    }//end initialize


    function buttonPressed(profile){
        console.log(profile)
        var latitude=positionSource.position.coordinate.latitude;
        var longitude=positionSource.position.coordinate.longitude;
        var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
        var HereProfile=JS.getHereRecord(latitude,longitude);
        console.log("hererecord: "+HereProfile)
        if(HereProfile===-1){
            db.transaction(
                function(tx) {
                    console.log('before insert: '+ latitude + longitude + profile)
                            tx.executeSql("INSERT INTO records VALUES("+latitude+","+longitude+",'"+profile+"')");
                    pm.setProfile(profile);
                }
            )
        }else{
            db.transaction(
                function(tx) {
                    tx.executeSql("UPDATE records set latitude=?, longitude=?, profile=? WHERE OID=?", [latitude, longitude, profile, HereProfile ]);
                    pm.setProfile(profile);
                }
            )
        }
   }//telos buttonPressed

    function checkWhatToDo(){
        var previous;
        var hereProfile;
        var latitude=positionSource.position.coordinate.latitude;
        var longitude=positionSource.position.coordinate.longitude;

        console.log("To profile twra einai: "+pm.getProfile());
        console.log("To PREVIOUS twra einai: "+JS.getSetting('previousProfile'));

        hereProfile=JS.getHereProfile(latitude,longitude);
        if(hereProfile==-1){
            pm.setProfile(JS.getSetting('previousProfile'));
        }else{
            pm.setProfile(hereProfile);
        }

    }//telos checkWhatToDo

    PositionSource {
        id: positionSource
        updateInterval: parseInt(JS.getSetting('time'));
        active: true
        onPositionChanged:{
        //    checkWhatToDo();
            //kyklos tou xarti
            //column1.children[5].children[0].radius = JS.getSetting('radius')
            var profiles = eval(pm.getAllProfiles());
            //console.log('onPositionChanged:'+parseInt(JS.getHereProfile(positionSource_s.position.coordinate.latitude,positionSource_s.position.coordinate.longitude)))
            var profileIndex = parseInt(JS.getHereProfile(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude))
            console.log("profileHere: "+profileIndex)
            for (var i=0; i<buttonColumn.children.length-1; i++) {
                if (profileIndex!=i)
                buttonColumn.children[i].checked = false;
            }
            if (profileIndex !=-1){
                buttonColumn.children[profileIndex].checked=true;

            }
        }
    }

    ScrollDecorator {
        flickableItem: container
    }
    Flickable {
        id: container

        x: 0 // we need to set the width and height
        y: 0
        z: 1
        width: symbianMainPage.width
        height: symbianMainPage.height-commonToolBar.height
        contentWidth: symbianMainPage.width
        contentHeight: symbianMainPage.height

        flickableDirection: Flickable.VerticalFlick
        pressDelay: 100
    // Create a selection dialog with a title and list elements to choose from.
    SelectionDialog {
        id: singleSelectionDialog
        height: 300
        titleText: "Select Default Profile"
        selectedIndex: parseInt(JS.getSetting("previousProfile"))
        model: eval(pm.getAllProfiles());
        onAccepted: {JS.updateSetting("previousProfile",selectedIndex)}
    }//telos SelectionDialog


    Column{
        id: column1
        width: parent.width
        anchors.fill: parent
        anchors.margins: 30
        spacing: 5
           Text {
               text: "Select profile for this area."
               font.pointSize: 8
               color: "white"

            }
           Text {
                text: "It will be activated every time you are here"
                font.pointSize: 6
                color: "white"
            }

           Column {
                id: buttonColumn
                width:parent.width/2;
                //exclusive: false

                    Repeater {
                        model: eval(pm.getAllProfiles());
                        RadioButton {
                            text: modelData
                            onClicked:{
                                if (!checked) {checked = true; return}
                                for (var i=0; i<buttonColumn.children.length-1; i++) {
                                    if (index!=i)
                                    buttonColumn.children[i].checked = false;
                                }

                                console.log("aeeeeeeeeeeeeeee"+modelData);
                                buttonPressed(index);
                            }

                        }


                     }

            }//telos BttonColumn
            Button {
                text: "Remove this area"
                width:240;
                id:rm
                onClicked:{
                    JS.removeThisArea(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude);
                    for (var i=0; i<buttonColumn.children.length-1; i++) {
                        buttonColumn.children[i].checked = false;
                    }

                }
            }

            Button {
                width:240;
                id:defaultpr
                text: "Default Profile"
                onClicked:{
                   singleSelectionDialog.open();
                }
            }
            Button {
                width:240;
                id:setPro
                text: "Change Profile to 1"
                onClicked:{
                    spm.setSProfile("a");
                }
            }

//            Map {
//                id: map
//                plugin : Plugin {name : "nokia"}
//                size.width: parent.width
//                size.height: 300
//                zoomLevel: 20
//                center: positionSource.position.coordinate
//                //radius = JS.getSetting('radius')

//                MapCircle {
//                    id: myPosition
//                    color: "#55ff0000"
//                    radius: JS.getSetting('radius')
//                    center: positionSource.position.coordinate
//                }
//            }
//                Text{
//                    font.pointSize: 20
//                    color: "black"
//                    text:"My postion: "
//                }
//                Text{
//                    font.pointSize: 20
//                    color: "black"
//                    text:"lat :"+positionSource.position.coordinate.latitude
//                }

//                Text{
//                    font.pointSize: 20
//                    color: "black"
//                    text:"lon :"+positionSource.position.coordinate.longitude
//                }
    }
    }

             Component.onCompleted:{

                 initialize();
             }



}


