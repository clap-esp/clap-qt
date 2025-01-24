import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7

Item {
    id: root
    property string videoSource: ""  // Propriété pour le chemin de la vidéo
    property real startTime: 0
    property real endTime: 0

    width: parent.width
    height: parent.height

    Rectangle {
        id: screenContainer
        width: parent.width
        height: parent.height
        color: "#242424"
        radius: 10

        PlayButton {
            id: playButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: 25
            height: 25
            onClicked: {
                togglePlayback();
            }
        }

        Rectangle {
            id: videoContainer
            x: 8
            y: 8
            width: parent.width - 18
            height: parent.height - 76
            color: "#242424"
            radius: 10
            clip: true

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                anchors.margins: 3
                smooth: true
            }
        }

        VideoSlider {
            id: videoDurationBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            width: parent.width
            height: 15
            value: videoDurationBar.position / mediaPlayer.duration // Keep slider in sync with video position
            maximum: mediaPlayer.duration // Maximum set to media duration
            onValueChanged: handleSliderValueChanged(value)
        }

        MediaPlayer {
            id: mediaPlayer
            source: videoSource  // Le chemin de la vidéo est passé ici
            videoOutput: videoOutput  // Liaison entre MediaPlayer et VideoOutput
            playbackRate: 1.0
            autoPlay: true

            onPositionChanged: stopVideoAtEndTime();

            onDurationChanged: printDuration();
        }
    }

    function handleSliderValueChanged(newValue) {
        mediaPlayer.position = newValue;
    }

    function togglePlayback() {
        if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
            mediaPlayer.pause();
        } else {
            mediaPlayer.play();
        }
    }

    function stopVideoAtEndTime() {
        if (mediaPlayer.position >= endTime) {
            mediaPlayer.pause();  // Arrête la lecture à la fin de l'intervalle
        }
    }

    function printDuration() {
        console.log("Duration loaded :", mediaPlayer.duration);
    }
}
