import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: videoClip

    property MediaPlayer timelineVideoPlayer
    property real clipDuration: 0
    property real interval: 3000
    property var jsonData: []
    property int index: 0
    property alias model: thumbnailModel
    property int totalThumbnails: 1

    width: Math.max(clipDuration / 10, parent.width * 1.2)
    height: Math.max(parent.height, 100)

    Rectangle {
        id: videoClipDisplay
        width: parent.width
        height: parent.height
        color: "#1c1c1c"
        radius: 5
        Layout.topMargin: 10

        ListView {
            id: thumnailList
            width: parent.width
            height: parent.height
            orientation: ListView.Horizontal
            model: ListModel { id: thumbnailModel }

            delegate: Item {
                width: videoClipDisplay.width / totalThumbnails
                height: parent.height

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "#1c1c1c"

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
    }

    Behavior on x {
        NumberAnimation {
            duration: 100
            easing.type: Easing.Linear
        }
    }

    Component.onCompleted: {
        readFile();
    }

    function readFile() {
        let file = "/thumbnails.json"
        const jsonPath= 'file:///'+thumbnailsDirectoryPath+file

        console.log(jsonPath)
        var xhr = new XMLHttpRequest();
        xhr.open("GET", jsonPath, false);
        xhr.send();

        if (xhr.status === 200) {
            jsonData = JSON.parse(xhr.responseText);
            let jsonDataThumbnails = jsonData["thumbnails"];
            index = 0
            totalThumbnails = jsonDataThumbnails.length  // Mise à jour du total des miniatures
            thumbnailModel.clear()
            for (index = 0; index < jsonDataThumbnails.length; index++) {
                let imagePath = jsonDataThumbnails[index]["path"];
                thumbnailModel.append({
                                          filePath: "file:///" + imagePath
                                      })
            }

            if (index < jsonDataThumbnails.length) {

            }
            console.log(jsonData);
        }
    }
}
