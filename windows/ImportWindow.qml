import QtQuick
import QtCore
import QtQuick.Dialogs
import '../Utils'
import '../Utils/Notification'

/**
  * IMPORT WINDOW
**/
Rectangle {

    readonly property var constants: Constants { }
    readonly property var errors: Error {}
    property string loadedFilePath: qsTr("")

    id: root
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    color: constants.default_widget_background_color


    signal importFileEvent(string processedVideoPath)

    Canvas {
        id: dottedBorderCanvas
        width: parent.width/2
        height: parent.height/2
        anchors.centerIn: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.setLineDash([5, 5]);
            ctx.strokeStyle = "black";
            ctx.lineWidth = 5;
            ctx.strokeRect(0, 0, width, height);
        }
    }

    DropArea {
        anchors.fill: parent
        onEntered: (drag) => {
                       root.color = constants.on_drag_background_color;
                       drag.accept(Qt.LinkAction);
                   }
        onDropped: (drop) => {
                       import_file(drop.urls[0]);
                       root.color = "transparent";
                   }
        onExited: {
            root.color = "transparent";
        }
    }

    Image {
        id: cameraImage
        source: "../images/camera.png"
        anchors.top: dottedBorderCanvas.top
        anchors.horizontalCenter: dottedBorderCanvas.horizontalCenter
        anchors.topMargin: 20
        width: parent.width/8
        height: parent.height/5
    }

    Rectangle {
        id: importButton
        width: parent.width/4
        height: 45
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: cameraImage.bottom
        anchors.topMargin: 30
        color: "#dddddd"
        radius: 25

        Text {
            text: qsTr("Importez une vidéo")
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.Wrap

        }

        MouseArea {
            anchors.fill: parent
            onClicked: fileDialog.open()
            cursorShape: Qt.PointingHandCursor

            onPressed: {
                importButton.color = constants.active_button;;
            }

            onReleased: {
                importButton.color = constants.normal_button;
            }
        }

        Text {
            text: qsTr("ou glissez votre fichier ici")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: importButton.top
            anchors.topMargin: 70
            font.pixelSize: 20
            color: "white"
            MouseArea {
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent

            }
        }

        FileDialog {
            id: fileDialog
            nameFilters: constants.accepted_extension
            currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
            onAccepted: import_file(fileDialog.selectedFile)
        }
    }

    function import_file(file_path) {
        const extension=String(file_path).split('.')[1]
        if(extension && constants.valid_extension.includes(extension)){
            loadedFilePath = file_path
            console.log(`Path file : ${loadedFilePath}`)
            importFileEvent(loadedFilePath);
        }else{
            console.log('notification error')
        }
    }
}
