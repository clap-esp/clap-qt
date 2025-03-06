import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Elements"

Rectangle {
    id: videoTimeline
    anchors.fill: parent
    color: "transparent"
    radius: 10
    anchors.top: parent.top

    property real cursorPositionStart: -1  // Position du premier clic (-1 signifie non défini)
    property real cursorPositionEnd: -1  // Position du deuxième clic
    property real totalDuration: 100  // Durée totale simulée de la vidéo
    property bool isSelecting: false  // État de la sélection (entre le premier et deuxième clic)
    property bool selectionEnabled: false  // Activer ou désactiver la sélection de zone

    Rectangle {
        id: timelineContainer

        anchors.top: parent.top
        width: parent.width
        height: parent.height
        color: "#242424"
        radius: 10

        Column {

            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.bottomMargin: 20
            spacing: 20

            // Case à cocher pour activer/désactiver la sélection de zone
            Row {
                width: parent.width - 60
                height: 30
                // spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBoxCustom {
                    id: selectionCheckBox
                    boxText: "Activer la sélection de zone"
                    checked: false
                    onCheckedChanged: selectionEnabled = checked  // Activer/désactiver la sélection
                }
            }

            // Première bande vidéo avec curseur
            Rectangle {
                id: firstVideoProcessingArea
                width: parent.width - 60
                height: 45
                color: "#484848"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter

                // Curseur dans la bande vidéo
                Rectangle {
                    id: videoCursor
                    width: 3
                    height: parent.height
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                    x: cursorPositionStart >= 0 ? cursorPositionStart / totalDuration * firstVideoProcessingArea.width : 0
                }

                // Zone grisée sélectionnée dans la première bande
                Rectangle {
                    id: selectedZone1
                    width: Math.abs((cursorPositionEnd - cursorPositionStart) / totalDuration) * firstVideoProcessingArea.width
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.5)
                    visible: cursorPositionEnd > cursorPositionStart && cursorPositionStart >= 0 && selectionEnabled
                    x: Math.min(cursorPositionStart, cursorPositionEnd) / totalDuration * firstVideoProcessingArea.width
                }
            }

            // Deuxième bande vidéo (continuation de la première)
            Rectangle {
                id: secondVideoProcessingArea
                width: parent.width - 60
                height: 45
                color: "#93a0e6"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter

                // Zone grisée sélectionnée dans la deuxième bande (continuité de la première)
                Rectangle {
                    id: selectedZone2
                    width: Math.abs((cursorPositionEnd - cursorPositionStart) / totalDuration) * secondVideoProcessingArea.width
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.5)
                    visible: cursorPositionEnd > cursorPositionStart && cursorPositionStart >= 0 && selectionEnabled
                    x: Math.min(cursorPositionStart, cursorPositionEnd) / totalDuration * secondVideoProcessingArea.width
                }

                // Interaction pour sélectionner la zone dans la bande si la case est cochée
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    enabled: selectionEnabled  // Activer seulement si la case est cochée
                    onClicked: {
                        if (!isSelecting) {
                            cursorPositionStart = (mouse.x / secondVideoProcessingArea.width) * totalDuration;
                            cursorPositionEnd = cursorPositionStart;  // Initialiser à la même position
                            isSelecting = true;  // Passer à l'état de sélection
                        } else {
                            cursorPositionEnd = (mouse.x / secondVideoProcessingArea.width) * totalDuration;
                            isSelecting = false;  // Terminer la sélection après le deuxième clic
                        }
                    }
                }
            }

            // Boutons d'action (placés en bas)
            Row {
                width: parent.width - 60
                height: 40
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "Couper"
                    width: 100
                    height: 40
                    onClicked: {
                        console.log("Action couper déclenchée");
                    }
                }

                Button {
                    text: "Exporter"
                    width: 100
                    height: 40
                    onClicked: {
                        console.log("Action exporter déclenchée");
                    }
                }
            }
        }
    }
}
