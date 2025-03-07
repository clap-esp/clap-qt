import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: timelineView

    property MediaPlayer videoPlayer
    property bool sliderPressed: false

    anchors.fill: parent

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 10

        Rectangle {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: "#cecece"
            radius: 5
            Layout.alignment: Qt.AlignTop
            Layout.margins: 10

            Rectangle {
                id: playhead
                width: 4
                height: parent.height
                color: "red"
                x: (videoPlayer && videoPlayer.duration > 0) ?
                   (videoPlayer.position / videoPlayer.duration) * (timeline.width - playhead.width) : 0
                Behavior on x {
                    NumberAnimation { duration: 100; easing.type: Easing.Linear }
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: sliderPressed = true
                onReleased: sliderPressed = false
                onClicked: function(mouse) {
                    if (videoPlayer && videoPlayer.duration > 0) {
                        let newTime = (mouse.x / (timeline.width - playhead.width)) * videoPlayer.duration;
                        videoPlayer.position = newTime;
                        playhead.x = mouse.x;
                    }
                }
            }
        }

        ScrollableTimeline {
            id: scrollableTimeline
            Component.onCompleted: {
                scrollableTimeline.externalVideoPlayer = videoPlayer;
                if (videoPlayer) {
                    addVideoClip(videoPlayer);
                }
            }
        }
    }

    Connections {
        target: videoPlayer
        function onPositionChanged() {
            if (!sliderPressed) {
                let progress = videoPlayer.position / videoPlayer.duration;
                let newX = progress * (timeline.width - playhead.width);
                playhead.x = newX;
            }
        }
    }

    function addVideoClip(player) {
        scrollableTimeline.addClip(player);
    }

    // onVideoPlayerChanged: {
    //     if (videoPlayer) {
    //         console.log("[DEBUG] Vidéo détectée dans TimelineView :", videoPlayer.source);
    //         addVideoClip(videoPlayer);
    //     }
    // }
}
