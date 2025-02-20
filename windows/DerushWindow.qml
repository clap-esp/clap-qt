import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import "../Translation"
import "../Video"
import "../Timeline"

Item {
    id: root
    property string videoSourcePath: ""

    VideoWidget {
        id: video_widget
        width: (parent.width * 0.5) - 15
        height: parent.height * 0.5
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 30
        anchors.rightMargin: 10
        videoSource: root.videoSourcePath
    }

    TranslationWidget {
        id: translation_widget
        width: (parent.width * 0.5) - 15
        height: parent.height * 0.5
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 30
        anchors.leftMargin: 10
    }

    TimelineView {
        id: video_timeline_widget
        width: parent.width - 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: (parent.height * 0.5) - 40
        videoPlayer: video_widget.videoPlayer
    }
}
