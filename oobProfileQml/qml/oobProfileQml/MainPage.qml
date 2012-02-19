import QtQuick 1.1
import com.nokia.meego 1.0
import QtQuick 1.0
import QtMobility.location 1.2
import "parser.js" as JS
//QDeclarativeExampleDB
Page {
    width:parent.width;
    tools: commonTools
    id:page

    function initialize() {
        console.log("Check iNTERNET: "+pm.checkInternet())
        if (pm.checkInternet()){
            var component = Qt.createComponent("map.qml");
            if (component.status == Component.Ready) {
                var map = component.createObject(column1);
            }
        }
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
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'active', '1' ]);
                    tx.executeSql('INSERT INTO settings VALUES(?, ?)', [ 'usegps', '1' ]);
                }
            }
        )
        console.log("getHereProfile: "+getHereProfile());

       // checkWhatToDo();
    }//end initialize


    function getHereProfile(latitude,longitude) {
        return getHereSomething(latitude, longitude, "profile")
    }//telos getHereProfile

    function getHereRecord(latitude,longitude){
        return getHereSomething(latitude, longitude, "record")
    }

    function getHereSomething(latitude, longitude, what){
        var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
        var HerePro=0;
        db.transaction(
            function(tx) {

                var rs=tx.executeSql("SELECT * FROM records");
                        console.log("rs:"+rs.rows.length)
                var r = ""
                var distance;
                var radius=parseFloat(JS.getSetting('radius'));

                for(var i = 0; i < rs.rows.length; i++) {
                    distance=JS.cut(latitude,longitude,rs.rows.item(i).latitude,rs.rows.item(i).longitude);
                    console.log("distance: "+distance)
                    console.log("radius: "+radius)
                    if(distance<radius){
                        console.log("We got a match: "+ rs.rows.item(i).profile);
                        if (what=="profile") HerePro = rs.rows.item(i).profile; else HerePro = i+1;
                        i=rs.rows.length+2;
                    }
                }//end loop

            }
        )
        return HerePro;
    }

    function buttonPressed(profile){
        console.log(profile)
        var latitude=positionSource.position.coordinate.latitude;
        var longitude=positionSource.position.coordinate.longitude;
        var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
        var HereProfile=getHereRecord(latitude,longitude);
        console.log("hererecord: "+HereProfile)
        if(HereProfile===0){
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

    function removeThisArea(latitude,longitude){
        var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
        var radius=JS.getSetting('radius');
        db.transaction(
            function(tx) {

                var rs=tx.executeSql("SELECT * FROM records");
                var r = ""
                var distance
                var radius=JS.getSetting('radius');
                for(var i = 0; i < rs.rows.length; i++) {
                    distance=JS.cut(latitude,longitude,rs.rows.item(i).latitude,rs.rows.item(i).longitude);
                    if(distance<radius){

                        tx.executeSql("DELETE FROM records WHERE latitude=? AND longitude=?",
                                      [latitude, longitude]);
                                   console.log("The profile deleted here");
                    }
                }//telos loops
                pm.setProfile(JS.getSetting('previousProfile'));

            }
           )
    }//telos removeThisArea

    function checkWhatToDo(){
        var previous;
        var hereProfile;
        var latitude=positionSource.position.coordinate.latitude;
        var longitude=positionSource.position.coordinate.longitude;

        console.log("To profile twra einai: "+pm.getProfile());
        console.log("To PREVIOUS twra einai: "+JS.getSetting('previousProfile'));

        hereProfile=getHereProfile(latitude,longitude);
        if(hereProfile==0){
            pm.setProfile(JS.getSetting('previousProfile'));
        }else{
            pm.setProfile(hereProfile);
        }

    }//telos checkWhatToDo

    function selected(){
        //console.log(singleSelectionDialog.model.get(singleSelectionDialog.selectedIndex).name)
        JS.updateSetting('previousProfile',singleSelectionDialog.model.get(singleSelectionDialog.selectedIndex).name);
    }//telos selected

    PositionSource {
        id: positionSource
        updateInterval: 1000//JS.getSetting('time');
        active: true
        onPositionChanged:{
        //    checkWhatToDo();
            column1.children[5].children[0].radius = JS.getSetting('radius')
            var profiles = eval(pm.getAllProfiles());
            console.log('onPositionChanged:'+getHereProfile(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude))
            var profileIndex = profiles.indexOf(getHereProfile(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude))
            if (profileIndex !=-1){
                buttonColumn.exclusive = true;
                buttonColumn.checkedButton = buttonColumn.children[profileIndex];
            }
        }
    }

    // Create a selection dialog with a title and list elements to choose from.
    SelectionDialog {
        id: singleSelectionDialog
        titleText: "Select Default Profile"
        selectedIndex: {
            var profiles = eval(pm.getAllProfiles());
            console.log(profiles);
            console.log(JS.getSetting("previousProfile"))
            console.log("indexof: "+ profiles.indexOf(JS.getSetting("previousProfile")))
            return profiles.indexOf(JS.getSetting("previousProfile")) + 1
        }
        model: ListModel{
            id:listModel
        }
        onAccepted: {selected();}
    }//telos SelectionDialog


    Column{
        id: column1
        width: parent.width
        anchors.fill: parent
        anchors.margins: 30
        spacing: 10
           Text {
                text: "Select profile for this area."
                font.pointSize: 23
                color: "black"
            }
           Text {
                text: "It will be activated every time you are around here"
                font.pointSize: 14
                color: "black"
            }
           ButtonColumn {
                id: buttonColumn
                width:parent.width;
                exclusive: false
                    Repeater {
                        model: eval(pm.getAllProfiles());
                        Button {
                            text: modelData
                            onClicked:{
                                var a = eval(pm.getAllProfiles());
                                buttonColumn.exclusive = true
                                //set checked again to ourselves because the previous command checks the first item
                                buttonColumn.checkedButton = buttonColumn.children[a.indexOf(modelData)]
                                buttonPressed(modelData)
                            }

                        }

                     }
            }//telos BttonColumn
            Button {
                text: "Remove this area"
                width:parent.width;
                id:rm
                onClicked:{
                   removeThisArea(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude);
                    buttonColumn.exclusive = false
                    buttonColumn.checkedButton.checked = false
                }
            }

            Button {
                width:parent.width;
                id:defaultpr
                text: "Choose Default Profile"
                onClicked:{
                   singleSelectionDialog.open();
                     JS.loaded(eval(pm.getAllProfiles()));
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

             Component.onCompleted:{
                 initialize();
             }



}


