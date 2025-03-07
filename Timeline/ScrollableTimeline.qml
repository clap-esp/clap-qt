import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: scrollableTimeline

    property alias contentWidth: trackContainer.width
    property MediaPlayer externalVideoPlayer
    property var videoClipInstance: null

    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        id: timelineBackground
        anchors.fill: parent
        color: "#cecece"
        radius: 5
        anchors.margins: 10

        Flickable {
            id: trackContainer
            anchors.fill: parent
            contentWidth: trackLayout.width

            RowLayout {
                id: trackLayout
                anchors.fill: parent
                Layout.rightMargin: 20
                Layout.leftMargin: 20
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Rectangle {
            id: centerPlayhead
            width: 4
            height: timelineBackground.height
            color: "red"
            anchors.horizontalCenter: parent.horizontalCenter
            z: 10
        }
    }

    function addClip(player) {
        let component = Qt.createComponent("VideoClip.qml");
        if (component.status === Component.Ready) {
            videoClipInstance = component.createObject(trackLayout, {
                                                           timelineVideoPlayer: player,
                                                           clipDuration: player.duration,
                                                           parent: trackLayout
                                                       });

            if (videoClipInstance !== null) {
                videoClipInstance.Layout.alignment = Qt.AlignVCenter;
                videoClipInstance.x = centerPlayhead.x - (videoClipInstance.width / 2);
            } else {
                console.warn("[ERROR] Impossible de créer le clip vidéo !");
            }
        } else {
            console.warn("[ERROR] Problème de chargement du composant VideoClip.qml !");
        }
    }

    Connections {
        target: externalVideoPlayer
        function onPositionChanged() {
            if (externalVideoPlayer && externalVideoPlayer.duration > 0 && videoClipInstance) {
                let progressRatio = externalVideoPlayer.position / externalVideoPlayer.duration;
                let maxOffset = videoClipInstance.width;

                videoClipInstance.x = centerPlayhead.x - (progressRatio * maxOffset);
            }
        }
    }

    Connections {
        target: externalVideoPlayer
        enabled: true
        function onDurationChanged() {
            addClip(externalVideoPlayer);
            enabled = false;
        }
    }
}
