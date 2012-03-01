import QtQuick 1.1
import com.nokia.meego 1.1
import QtQuick 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolItem { iconId: "icon-m-toolbar-back"; onClicked: pageStack.pop();visible: pageStack.currentPage != mainPage }
        ToolIcon{
            platformIconId: "toolbar-settings"
            onClicked: (pageStack.push(Qt.resolvedUrl("settings.qml")))
            visible: pageStack.currentPage == mainPage
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
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
                //mainPage.buttonColumn.exclusive = false;
                //mainPage.buttonColumn.checkedButton.checked = false
                //page.buttonColumn.checkedButton = undefined;
                pm.setProfile(pr);
            }
        )
    }
    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Delete All Records")
                onClicked: removeAll();
            }
        }
    }
}




