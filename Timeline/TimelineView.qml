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


        RowLayout{
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Layout.margins:10
            spacing:20

            Rectangle{
                radius:35
                width:150
                height: 30
                color: 'white'

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Image{
                        source: '../images/wand.png'
                        width:16
                        height: 16
                        anchors.leftMargin: 20
                    }

                    Text{
                        text: 'Dérush'

                    }
                }


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }



            }


            Rectangle{
                radius:35
                width:150
                height: 30
                color: 'white'
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Image{
                        source: '../images/exportation.png'
                        width:16
                        height: 16
                        anchors.leftMargin: 20
                    }

                    Text{
                        text: 'Exporter'

                    }
                }


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }



            }
        }

        Rectangle {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            color: "#716A80"
            radius: 5
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin:  10
            Layout.rightMargin:  10
            Layout.topMargin: 10

            Rectangle {
                id: playhead
                width: 3
                height: parent.height
                color: "#6883A5"
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

}
