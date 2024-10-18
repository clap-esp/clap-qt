import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7

Item {
    id: root
    property string videoSource: ""

    width: 769
    height: 448

    Rectangle {
        id: screenContainer
        width: parent.width
        height: parent.height
        color: "#484848"
        border.color: "#878787"

        PlayButton {
            id: playButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: 25
            height: 25
            onClicked: {
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                } else {
                    mediaPlayer.play()
                }
            }
        }

        Rectangle {
            id: videoContainer
            x: 8
            y: 8
            width: 753
            height: 354
            color: "#242424"
            border.color: "#878787"

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                smooth: true
            }
        }

        VideoSlider {
            id: videoDurationBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            width: parent.width
            height: 15
            value: mediaPlayer.position
            maximum: mediaPlayer.duration
            onValueChanged: {
                mediaPlayer.position = value;
            }
        }

        MediaPlayer {
            id: mediaPlayer
            source: videoSource
            videoOutput: videoOutput
            autoPlay: true
            playbackRate: 1.0

            onSourceChanged: {
                console.log("Video source changed to: " + source);
            }

            onPositionChanged: {
                videoDurationBar.value = position;
            }
        }
    }
}
