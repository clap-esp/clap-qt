import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    width: 200
    height: 50

    // La valeur de la checkbox
    property bool checked: false
    property string boxText: "Cochez-moi !"

    // Conteneur de la checkbox et du texte
    RowLayout {
        anchors.centerIn: parent
        spacing: 10

        // Case à cocher
        Rectangle {
            id: checkbox
            width: 24
            height: 24
            radius: 4
            color: checked ? "#878787" : "#ecf0f1"
            border.color: "#7f8c8d"
            border.width: 2

            // Animation pour l'effet de changement
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

            // Icône pour le "check"
            Item {
                anchors.centerIn: parent
                visible: checked

                Rectangle {
                    width: 12
                    height: 6
                    color: "white"
                    anchors.centerIn: parent
                    rotation: 45
                    radius: 2
                }
            }

            // Action au clic pour changer l'état de la checkbox
            MouseArea {
                anchors.fill: parent
                onClicked: checked = !checked
            }
        }

        // Texte à côté de la checkbox
        Text {
            text: boxText
            font.pixelSize: 16
            color: "#FFFFFF"
            verticalAlignment: Text.AlignVCenter
        }
    }
}
