import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: customSlider
    width: 300
    height: 30
    property real value: 0
    property real minimum: 0
    property real maximum: 100

    Rectangle {
        id: groove
        width: parent.width
        height: 5
        color: "#333333"
        radius: 3

        // Partie de progression
        Rectangle {
            id: progressBar
            width: (value - minimum) / (maximum - minimum) * groove.width
            height: groove.height
            color: "#FFFFFF"
            radius: groove.radius
        }

        // MouseArea pour les clics directs et le glissement
        MouseArea {
            id: grooveMouseArea
            anchors.fill: parent
            drag.target: handle

            onClicked: {
                let newX = Math.max(0, Math.min(mouse.x - handle.width / 2, groove.width - handle.width));
                handle.x = newX;
                value = (newX / (groove.width - handle.width)) * (maximum - minimum) + minimum;
                // Mettre à jour la barre de progression en temps réel
                progressBar.width = (value - minimum) / (maximum - minimum) * groove.width;
            }

            onPositionChanged: {
                if (drag.active) {
                    let newX = Math.max(0, Math.min(mouse.x - handle.width / 2, groove.width - handle.width));
                    handle.x = newX;
                    value = (newX / (groove.width - handle.width)) * (maximum - minimum) + minimum;
                    // Mettre à jour la barre de progression en temps réel
                    progressBar.width = (value - minimum) / (maximum - minimum) * groove.width;
                }
            }

            onPressed: {
                let newX = Math.max(0, Math.min(mouse.x - handle.width / 2, groove.width - handle.width));
                handle.x = newX;
                value = (newX / (groove.width - handle.width)) * (maximum - minimum) + minimum;
                drag.active = true;
                // Mettre à jour la barre de progression en temps réel
                progressBar.width = (value - minimum) / (maximum - minimum) * groove.width;
            }

            onReleased: {
                drag.active = false
            }
        }
    }

    Rectangle {
        id: handle
        width: 15
        height: 15
        color: "#FFFFFF"
        radius: 10
        border.color: "#DCDCDC"
        border.width: 2
        anchors.verticalCenter: groove.verticalCenter

        // Positionner le handle en fonction de la valeur
        x: (value - minimum) / (maximum - minimum) * (groove.width - width)
    }

    // Mise à jour de la position du handle et de la barre de progression lors de la modification de la valeur
    onValueChanged: {
        handle.x = Math.max(0, Math.min((value - minimum) / (maximum - minimum) * (groove.width - handle.width), groove.width - handle.width));
        progressBar.width = (value - minimum) / (maximum - minimum) * groove.width;
    }
}
