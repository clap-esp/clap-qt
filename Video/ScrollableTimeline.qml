import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: scrollableTimeline

    property MediaPlayer externalVideoPlayer

    width: parent.width - 20
    height: 100
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    clip: true

    Rectangle {
        id: timelineBackground
        width: parent.width
        height: parent.height
        color: "#222"
        radius: 5
    }

    Flickable {
        id: flickableContent
        width: parent.width
        height: parent.height
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        contentWidth: videoStrip.width
        clip: true
        interactive: false

        Rectangle {
            id: videoStrip
            width: 3000 // Largeur fixe pour simuler le défilement long
            height: parent.height - 20
            color: "#444" // Couleur de la frise vidéo
            radius: 5
            x: 0

            Behavior on x {
                NumberAnimation { duration: 100; easing.type: Easing.Linear }
            }
        }
    }

    Rectangle {
        id: centerPlayhead
        width: 4
        height: parent.height
        color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections {
        target: externalVideoPlayer
        function onPositionChanged() {
            if (externalVideoPlayer && externalVideoPlayer.duration > 0) {
                let progressRatio = externalVideoPlayer.position / externalVideoPlayer.duration;
                let maxScroll = videoStrip.width - flickableContent.width;

                videoStrip.x = -progressRatio * maxScroll; // Défilement fluide
            }
        }
    }
}
