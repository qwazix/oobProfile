import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1


Window{
    PageStack {
        id:pageStack
        initialPage: symbianMainPage

        SymbianMainPage {
            id: symbianMainPage
        }


        ToolBar {
            id: commonToolBar
            z: 2
            anchors.bottom: parent.bottom
            visible: true
            ToolButton {
                id:back
                iconSource: "toolbar-back"
                visible: true;//pageStack.currentPage.toString().indexOf("SymbianMainPage") === -1;
                onClicked: {
                    if(!pageStack.currentPage.toString().indexOf("SymbianMainPage") === -1)
                        pm.sendToBackground();
                    else
                        pageStack.pop();
                }

            }
            ToolButton{
                iconSource: "toolbar-settings"
                onClicked: (pageStack.push(Qt.resolvedUrl("SymbianSettings.qml")))
                anchors {
                bottom: commonToolBar.bottom
                centerIn: commonToolBar
                }

                visible: pageStack.currentPage.toString().indexOf("SymbianMainPage") !== -1;
            }
            ToolButton {
                id:menu
                        iconSource: "toolbar-menu"
                        anchors.right: (parent === undefined) ? undefined : parent.right
                        onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
                    }
//            ToolButton {
//                text: "next page"; onClicked: pageStack.push(secondPage)
//            }

        }
    }
    function removeAll(){
        var db = openDatabaseSync("oobProfileDatabase", "1.0", "", 1000000);
        var pr;
        db.transaction(
            function(tx) {
                var previousProfile = tx.executeSql("SELECT value FROM settings WHERE key='previousProfile'");
                pr=previousProfile.rows.item(0).value;
                tx.executeSql("DELETE FROM `records`");
                console.log("All records deleted");
                pm.setProfile(pr);
            }
        )
        for (var i=0; i<buttonColumn.children.length-1; i++) {
            buttonColumn.children[i].checked = false;
        }
    }
    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Delete All Records")
                onClicked: removeAll();
            }
            MenuItem { text: qsTr("Hide")
                onClicked: pm.sendToBackground();
            }
            MenuItem { text: qsTr("Exit")
                onClicked: Qt.quit();
            }
        }
    }

}






