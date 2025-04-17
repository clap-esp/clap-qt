import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Controls.Material
import "./Utils"

Item {
    id: root
    readonly property var constants: Constants { }
    signal openParameterEvent()
    signal openNewProjectEvent()
    signal openProjectEvent()

    RowLayout {
        width: parent.width
        height: 40

        Button {
            Layout.preferredHeight: parent.height
            Material.background: constants.panel_background_color
            Material.foreground: "white"
            text: qsTr("File")
            onClicked: fileMenu.open()
        }

        Button {
            Layout.preferredHeight: parent.height
            Material.background: constants.panel_background_color
            Material.foreground: "white"
            text: qsTr("Help")
            onClicked: helpMenu.open()
        }

        // MenuBar {
        //     id: menuBar
        //     Material.background: constants.panel_background_color
        //     Material.foreground: "white"
        //     Layout.preferredHeight: parent.height
        // }
    }

    Menu {
        id: fileMenu
        Layout.topMargin: parent.height
        title: qsTr("Fichier")

        Action {
            text: qsTr("Nouveau...")
            onTriggered: openNewProjectEvent();
        }
        Action {
            text: qsTr("Ouvrir...")
            onTriggered: openProjectEvent();
        }
        // Action { text: qsTr("Sauvegarder") }
        // Action { text: qsTr("Sauvegarder en tant que...") }
        Action {
            text: qsTr("Paramètres...");
            onTriggered: openParameterEvent();
        }

        MenuSeparator { }

        Action {
            text: qsTr("Quit");
            onTriggered: quit_confirmation_dialog.open();
        }

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    Menu {
        id: helpMenu
        Layout.topMargin: parent.height
        title: qsTr("Help")

        Action { text: qsTr("About") }

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    MessageDialog {
        id: quit_confirmation_dialog

        title: qsTr("Quitter l'application")
        text: qsTr("Êtes-vous sûr de vouloir quitter l'application ?")
        buttons: MessageDialog.Yes | MessageDialog.Cancel
        onButtonClicked: function (button, role) {
            switch (button) {
            case MessageDialog.Yes:
                Qt.quit();
                break;
            }
        }
    }
}
