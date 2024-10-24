import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: playPauseButton
    width: 50
    height: 50

    property color color: "#6a6a6a"
    property alias text: buttonText.text
    property alias image: buttonImage.source

    // Propriété pour gérer l'état (lecture ou pause)
    property bool isPlaying: false

    signal clicked()

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        border.color: "#2e2e2e"
        anchors.fill: parent

        // Correction : utilisation de playPauseButton.color au lieu de root.color
        color: mouseAreaButton.pressed ? Qt.lighter(playPauseButton.color) :
                                         mouseAreaButton.containsMouse ? Qt.darker(playPauseButton.color) :
                                                                         playPauseButton.color
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
    }

    Image {
        id: buttonImage
        width: 35
        height: 35
        anchors.centerIn: parent

        // Change l'image en fonction de l'état isPlaying
        // source: playPauseButton.isPlaying ? "pause_icon.png" : "play_icon.png"
    }

    MouseArea {
        id: mouseAreaButton
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            // Inverse l'état isPlaying à chaque clic
            playPauseButton.isPlaying = !playPauseButton.isPlaying
            playPauseButton.clicked()
        }
    }
}
