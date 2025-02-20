import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: scrollableTimeline

    property alias contentWidth: trackContainer.width
    property MediaPlayer externalVideoPlayer

    width: prent.width
    height: 100
    anchors.bottom: parent.bottom
    clip: true

    Rectangle {
        id: timelineBackground
        width: parent.width
        height: parent.height - 200
        color: "#1c1c1c"
        radius: 5
    }

    Flickable {
        id: trackContainer
        width: parent.width
        height: parent.height
        contentWidth: trackLayout.width
        clip: true

        RowLayout {
            id: trackLayout
            width: trackContainer.contentWidth
            height: parent.height
            spacing: 5
        }
    }

    Rectangle {
        id: centerPlayhead
        width: 4
        height: parent.height - 200
        color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function addClip(videoSource) {
        console.log("[DEBUG] addClip appelé avec :", videoSource);

        let component = Qt.createComponent("VideoClip.qml");

        console.log("[DEBUG] Statut du composant VideoClip :", component.status);

        if (component.status === Component.Ready) {
            console.log("[DEBUG] Création de l'objet VideoClip...");
            let clip = component.createObject(trackLayout, { videoSource: videoSource });

            if (clip !== null) {
                console.log("[DEBUG] Clip vidéo ajouté !");
            } else {
                console.warn("[ERROR] Impossible de créer le clip vidéo !");
            }
        } else {
            console.warn("[ERROR] Problème de chargement du composant VideoClip.qml !");
            console.warn("[ERROR] Statut du composant :", component.status, " (0 = Null, 1 = Ready, 2 = Loading, 3 = Error)");
        }
    }

    Connections {
        target: externalVideoPlayer
        function onPositionChanged() {
            if (externalVideoPlayer && externalVideoPlayer.duration > 0) {
                let progressRatio = externalVideoPlayer.position / externalVideoPlayer.duration;
                let maxScroll = trackContainer.contentWidth - scrollableTimeline.width;

                if (maxScroll > 0) {
                    trackContainer.contentX = progressRation * maxScroll;
                }
            }
        }
    }
}
