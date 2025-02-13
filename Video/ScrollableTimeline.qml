import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: scrollableTimeline

    property MediaPlayer externalVideoPlayer
    property real interval: 1000

    width: parent.width
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
        width: scrollableTimeline.width
        height: parent.height - 200
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
                width: videoStrip.width / (thumbnailModel.count > 0 ? thumbnailModel.count : 1)
                height: parent.height

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#000000"

                    Image {
                        width: parent.width
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
        height: parent.height - 200
        color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections {
        target: externalVideoPlayer
        function onPositionChanged() {
            if (externalVideoPlayer && externalVideoPlayer.duration > 0) {
                let progressRatio = externalVideoPlayer.position / externalVideoPlayer.duration;
                let maxScroll = videoStrip.width - scrollableTimeline.width;

                if (maxScroll > 0) {
                    videoStrip.x = -progressRatio * maxScroll;
                }
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

        let interval = 3000;
        let duration = externalVideoPlayer.duration;
        let numThumbnails = Math.ceil(duration / interval);
        let thumbnailWidth = scrollableTimeline.width / Math.min(numThumbnails, 10);

        let totalWidth = numThumbnails * thumbnailWidth;

        videoStrip.width = Math.max(scrollableTimeline.width, totalWidth);

        console.log("[DEBUG] videoStrip.width =", videoStrip.width);

        let currentFrame = 0;

        function captureNextFrame() {
            let captureTime = currentFrame * interval;

            if (captureTime >= duration) {
                console.log("[DEBUG] Toutes les miniatures ont été générées.");
                externalVideoPlayer.position = 0;
                return;
            }

            console.log("[DEBUG] Capture de l'image à " + captureTime + "ms");

            externalVideoPlayer.position = captureTime;

            Qt.callLater(() => {
                externalVideoPlayer.videoOutput.grabToImage((result) => {
                    let imagePath = Qt.platform.os === "windows"
                        ? "C:/Users/Jay/AppData/Local/Temp/thumb_" + currentFrame + ".png"
                        : "/tmp/thumb_" + currentFrame + ".png";

                    let success = result.saveToFile(imagePath);
                    console.log("[DEBUG] Miniature enregistrée : " + imagePath + " | Succès : " + success);

                    if (success) {
                        Qt.callLater(() => {
                            thumbnailModel.append({
                                filePath: "file:///" + imagePath
                            });
                        });
                    } else {
                        console.warn("[WARNING] Impossible d'enregistrer l'image : " + imagePath);
                    }

                    currentFrame++;
                    Qt.callLater(captureNextFrame);
                });
            });
        }

        captureNextFrame();
    }

}
