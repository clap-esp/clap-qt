import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Controls.Material
import "./Utils"

Item {
    id: root
    signal openParameterEvent()
    signal openNewProjectEvent()
    signal openProjectEvent()

    RowLayout {
        height: parent.height
        width: 20
        spacing: 10

        MenuBar {
            id: menuBar
            Material.foreground: "white"
            Layout.preferredHeight: parent.height

            Menu {
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
                title: qsTr("Help")

                Action { text: qsTr("About") }

                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            }
        }
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
