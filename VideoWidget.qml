import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7

Item {
    id: root
    property string videoSource: ""  // Propriété pour le chemin de la vidéo

    width: parent.width
    height: parent.height

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
            width: parent.width - 18
            height: parent.height - 76
            color: "#242424"
            border.color: "#878787"

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                smooth: true
                width: parent.width
                height: parent.height
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
            value: videoDurationBar.position / mediaPlayer.duration // Keep slider in sync with video position
            maximum: mediaPlayer.duration // Maximum set to media duration
            onValueChanged: {
                mediaPlayer.position = value; // Seek the video when slider is dragged
            }
        }

        MediaPlayer {
            id: mediaPlayer
            source: videoSource  // Le chemin de la vidéo est passé ici
            videoOutput: videoOutput  // Liaison entre MediaPlayer et VideoOutput
            playbackRate: 1.0
            autoPlay: true
        }
    }
}
