import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: videoClip

    property string videoSource
    property real clipDuration: 0
    property real interval: 3000
    property alias model: thumbnailModel

    Layout.fillWidth: true
    Layout.preferredHeight: parent ? parent.height : 100

    width: clipDuration / 100
    height: parent.height

    ListView {
        id: thumnailList
        width: parent.width
        height: parent.height
        orientation: ListView.Horizontal
        model: ListModel { id: thumbnailModel }

        delegate: Item {
            width: 100
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

    MediaPlayer {
        id: player
        source: videoSource
        videoOutput: videoOutput

        onDurationChanged: {
            console.log("[DEBUG] Durée détectée :", player.duration);
            clipDuration = player.duration;
            generateThumbnails();
        }
    }

    VideoOutput {
            id: videoOutput
            anchors.fill: parent
            width: 200
            height: 100
            visible: false
        }

    function generateThumbnails() {
            if (clipDuration === 0) {
                console.warn("[ERROR] La durée de la vidéo est 0 !");
                return;
            }

            thumbnailModel.clear();
            let numThumbnails = Math.ceil(clipDuration / interval);
            let currentFrame = 0;

            function captureFrame() {
                if (currentFrame >= numThumbnails) {
                    console.log("[DEBUG] Toutes les miniatures ont été générées !");
                    return;
                }

                let captureTime = currentFrame * interval;
                console.log("[DEBUG] Capture de la miniature à :", captureTime, "ms");

                player.position = captureTime;

                Qt.callLater(() => {
                    videoOutput.grabToImage(function (result) {
                        if (!result) {
                            console.warn("[WARNING] Impossible de capturer l'image !");
                            return;
                        }

                        let imagePath = Qt.platform.os === "windows"
                            ? "C:/Users/Jay/AppData/Local/Temp/thumb_" + currentFrame + ".png"
                            : "/tmp/thumb_" + currentFrame + ".png";

                        let success = result.saveToFile(imagePath);
                        if (success) {
                            thumbnailModel.append({ filePath: "file:///" + imagePath });
                            console.log("[DEBUG] Miniature enregistrée :", imagePath);
                        } else {
                            console.warn("[WARNING] Échec de l'enregistrement de :", imagePath);
                        }

                        currentFrame++;
                        Qt.callLater(captureFrame);  // Capture la suivante
                    });
                });
            }

            captureFrame();
        }

        Component.onCompleted: {
            console.log("[DEBUG] VideoClip ajouté avec largeur :", width, " et hauteur :", height);
        }
}
