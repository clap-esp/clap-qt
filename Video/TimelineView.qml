import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: timelineView

    property MediaPlayer externalVideoPlayer
    property bool sliderPressed: false

    width: parent.width - 20
    height: (parent.height * 0.5) - 40
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: "#1c1c1c"
        radius: 10
    }

    MediaPlayer {
        id: player
        source: externalVideoPlayer ? externalVideoPlayer.source : ""
        onPositionChanged: {
            if(!sliderPressed) {
                playhead.x = (externalVideoPlayer.position / externalVideoPlayer.duration) * timeline.width
            }
        }
    }

    Rectangle {
        id: timeline
        width: parent.width - 20
        height: 50
        color: "#333"
        radius: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10

        Rectangle {
            id: playhead
            width: 4
            height: parent.height
            color: "red"
            x: (externalVideoPlayer && externalVideoPlayer.duration > 0) ?
                   (externalVideoPlayer.position / externalVideoPlayer.duration) * timeline.width : 0
            Behavior on x {
                NumberAnimation { duration: 100; easing.type: Easing.Linear }
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: sliderPressed = true
            onReleased: sliderPressed = false
            onClicked: (mouse) => {
                if (externalVideoPlayer) {
                    let newTime = (mouse.x / timeline.width) * externalVideoPlayer.duration;
                               if (Math.abs(newTime - externalVideoPlayer.position) > 500) { // Empêche les micro-ajustements
                                                       externalVideoPlayer.position = newTime;
                                                   }
                }
            }
        }
    }

    ScrollableTimeline {
        id: scrollableTimeline
        Component.onCompleted: scrollableTimeline.externalVideoPlayer = externalVideoPlayer
        width: parent.width - 20
        height: 70
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }

    Connections {
        target: externalVideoPlayer
        function onPositionChanged() {
            if (!sliderPressed) {
                            let newX = (externalVideoPlayer.position / externalVideoPlayer.duration) * timeline.width;
                            if (Math.abs(newX - playhead.x) > 2) {
                                playhead.x = newX;
                            }
                        }
        }
    }
}


