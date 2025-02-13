import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: timelineView

    property MediaPlayer videoPlayer
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
            x: (videoPlayer && videoPlayer.duration > 0) ?
                   (videoPlayer.position / videoPlayer.duration) * timeline.width : 0
            Behavior on x {
                NumberAnimation { duration: 100; easing.type: Easing.Linear }
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: sliderPressed = true
            onReleased: sliderPressed = false
            onClicked: (mouse) => {
                           if (videoPlayer) {
                               let newTime = (mouse.x / timeline.width) * videoPlayer.duration;
                               if (Math.abs(newTime - videoPlayer.position) > 500) {
                                   videoPlayer.position = newTime;
                               }
                           }
                       }
        }
    }

    ScrollableTimeline {
        id: scrollableTimeline
        width: parent.width
        height: parent.height
        anchors.top: timeline.bottom
        anchors.topMargin: 10
        clip: true
        Component.onCompleted: {
            console.log("[DEBUG] Assigning externalVideoPlayer in ScrollableTimeline...");
            scrollableTimeline.externalVideoPlayer = videoPlayer;
            console.log("[DEBUG] ScrollableTimeline.externalVideoPlayer: " + scrollableTimeline.externalVideoPlayer);
        }
    }

    Connections {
        target: videoPlayer
        function onPositionChanged() {
            if (!sliderPressed) {
                let newX = (videoPlayer.position / videoPlayer.duration) * timeline.width;
                if (Math.abs(newX - playhead.x) > 2) {
                    playhead.x = newX;
                }
            }
        }
    }
}
