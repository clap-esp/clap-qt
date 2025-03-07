import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import '../Elements'
import '../Utils'

Popup {
    property var colors: Constants {}

    id: quitPopup
    modal: true
    focus: true
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        color: colors.panel_background_color
        radius: 10
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillHeight: true
        }

        Text {
            text: qsTr("Êtes-vous sûr de vouloir quitter l'application ?")
            color: "white"
            font.pixelSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            ButtonCustom {
                text: qsTr("Oui")
                onButtonClicked: Qt.quit()
            }

            ButtonCustom {
                text: qsTr("Annuler")
                onButtonClicked: quitPopup.close()
            }
        }
    }
}
