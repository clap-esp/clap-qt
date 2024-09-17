import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
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
            anchors.bottomMargin: 30
            width: 25
            height: 25
        }

        Rectangle {
            id: videoContainer
            x: 8
            y: 8
            width: 753
            height: 354
            color: "#242424"
            border.color: "#878787"
        }

        VideoSlider {
            id: videoDurationBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 60
            width: parent.width
            height: 15
            value: 0
        }
    }
}
