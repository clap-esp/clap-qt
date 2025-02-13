import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: scrollableTimeline

    property MediaPlayer externalVideoPlayer
    property real interval: 1000

    width: parent.width - 20
    height: 100
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    clip: true

    Rectangle {
        id: timelineBackground
        width: parent.width
        height: parent.height
        color: "#1c1c1c"
        radius: 5
    }

    Rectangle {
        id: videoStrip
        width: parent.width * (externalVideoPlayer.duration / (interval * 10))
        height: parent.height - 20
        color: "#666"
        radius: 5
        x: 0

        ListView {
            id: thumnailList

            width: parent.width
            height: parent.height
            orientation: ListView.Horizontal
            model: ListModel { id: thumbnailModel }
            delegate: Item {
                width: (videoStrip.width / (thumbnailModel.count > 0 ? thumbnailModel.count : 1)) * 0.6
                height: parent.height
                Rectangle {
                    width: parent.width - 4
                    height: parent.height
                    color: "#000000"
                    Image {
                        width: videoStrip.width / (thumbnailModel.count > 0 ? thumbnailModel.count : 1)
                        height: parent.height
                        source: model.filePath
                        fillMode: Image.PreserveAspectCrop
                        anchors.fill: parent
                        anchors.margins: 2
                        cache: true
                    }
                }
            }
        }

        Behavior on x {
            NumberAnimation { duration: 100; easing.type: Easing.Linear }
        }
    }

    Rectangle {
        id: centerPlayhead
        width: 4
        height: parent.height
        color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections {
        target: externalVideoPlayer
        function onPositionChanged() {
            console.log("[DEBUG] Position changed: " + (externalVideoPlayer ? externalVideoPlayer.position : "NULL"));
            if (externalVideoPlayer && externalVideoPlayer.duration > 0) {
                let progressRatio = externalVideoPlayer.position / externalVideoPlayer.duration;
                let maxScroll = videoStrip.width - scrollableTimeline.width;
                videoStrip.x = -progressRatio * maxScroll;
            }
        }
    }

    Connections {
        target: externalVideoPlayer
        function onDurationChanged() {
            console.log("[DEBUG] Duration changed: " + (externalVideoPlayer ? externalVideoPlayer.duration : "NULL"));
            if (externalVideoPlayer && externalVideoPlayer.duration > 0) {
                generateThumbnails();
            }
        }
    }

    function generateThumbnails() {
        if (!externalVideoPlayer || !externalVideoPlayer.videoOutput || externalVideoPlayer.duration <= 0) {
            console.warn("Pas de vidéo chargée !");
            return;
        }

        thumbnailModel.clear();

        let numThumbnails = 10;
        let duration = externalVideoPlayer.duration;
        let interval = duration / (numThumbnails - 1);

        let videoOutput = externalVideoPlayer.videoOutput;
        let currentFrame = 0;

        function captureNextFrame() {
            if (currentFrame >= numThumbnails) {
                console.log("[DEBUG] Toutes les miniatures ont été générées.");
                externalVideoPlayer.position = 0;
                return;
            }

            let captureTime = Math.floor(currentFrame * interval);
            externalVideoPlayer.position = captureTime;

            Qt.callLater(() => {
                             videoOutput.grabToImage((result) => {
                                                         let imagePath = Qt.platform.os === "windows" ?
                                                             "C:/Users/Jay/AppData/Local/Temp/thumb_" + currentFrame + ".png" :
                                                             "/tmp/thumb_" + currentFrame + ".png";

                                                         let success = result.saveToFile(imagePath);
                                                         console.log("[DEBUG] Miniature enregistrée : " + imagePath + " | Succès : " + success);

                                                         if (success) {
                                                             Qt.callLater(() => {
                                                                              thumbnailModel.append({ filePath: "file:///" + imagePath });
                                                                          });
                                                         } else {
                                                             console.warn("[WARNING] Impossible d'enregistrer l'image : " + imagePath);
                                                         }

                                                         currentFrame++;
                                                         captureNextFrame();
                                                     });
                         });
        }

        captureNextFrame();
    }
}
