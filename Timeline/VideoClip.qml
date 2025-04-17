import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: videoClip
    property alias thumbnailListView: thumnailList
    property alias playerHead: player
    property alias centeredPlayer: centerPlayer
    property MediaPlayer timelineVideoPlayer
    property real clipDuration: 0
    property real interval: 3000
    property var jsonData: []
    property alias model: thumbnailModel
    property int currentPage:0
    property int totalThumbnails: 1
    property int thumbnailsPerPage: 15


    width: parent.width
    height: 100


    Rectangle {
        id: videoClipDisplay
        width: parent.width
        height: parent.height
        color: "transparent"
        radius: 5
        clip:true



        ListView {
            id: thumnailList
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.fill: parent
            orientation: ListView.Horizontal
            clip:true
            focus:true
            interactive: false
            currentIndex: 0
            model: ListModel { id: thumbnailModel }
            onCurrentIndexChanged: {
                thumnailList.positionViewAtIndex(currentIndex, ListView.Center)
            }
            delegate: Item {
                id: delegatedItem
                property int indexOfThisDelegate: index
                width:100
                height: 50


                ColumnLayout{
                    anchors.fill: parent
                    Rectangle {
                        Layout.preferredWidth:  parent.width
                        Layout.preferredHeight:  parent.height
                        Image {
                            width: 50
                            height: 50
                            source: model.filePath
                            fillMode: Image.Tile
                            verticalAlignment: Image.AlignLeft
                            anchors.fill: parent
                            cache: true
                        }
                    }
                }

            }
        }


        Rectangle{
            id: centerPlayer
            color: "transparent"
            width:6
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Rectangle{
            id: player

            property real minX: thumnailList.x
            property real maxX: thumnailList.x + thumnailList.width
            property real snapInterval: thumnailList.width / thumbnailsPerPage
            color: "red" //"#346beb"
            width:6
            height: 50
            x: centerPlayer.x + 20

            Behavior on x {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.Linear
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
        let file = globalVariable.currentProjectName+ "/metadata/thumbnails.json"
        const jsonPath= 'file:///'+currentProjectDirectoryPath+file
        var xhr = new XMLHttpRequest();
        xhr.open("GET", jsonPath, false);
        xhr.send();

        if (xhr.status === 200) {
            jsonData = JSON.parse(xhr.responseText);
            let jsonDataThumbnails = jsonData["thumbnails"];
            let index = 0
            totalThumbnails = jsonDataThumbnails.length
            thumbnailModel.clear()
            for (index = 0; index < jsonDataThumbnails.length; index++) {
                let imagePath = jsonDataThumbnails[index]["path"];
                thumbnailModel.append({
                                          filePath: "file:///" + imagePath
                                      })
            }
        }
    }
}
