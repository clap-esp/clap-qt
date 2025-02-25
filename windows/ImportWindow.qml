import notification.type 1.0
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

import '../Utils'
import '../Utils/Notification'
import "../Notification"
import python.executor 1.0
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

    NotificationWidget{
        id: notification
    }
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
                       if (drop.urls.length > 0 && drop.urls[0] !== undefined) {
                           let filePath = drop.urls[0].toString();

                           if(!filePath.match(/\.(mp4|avi|mov|m4a|mkv)$/i)) {
                               fileNotAVideoDialog.open();
                               console.log("Error: Le fichier sélectionné n'est pas une vidéo.");
                               root.color = "transparent";
                               return;
                           }

                           root.color = "transparent";
                           fileDialog.close();
                           openProjectDialog(filePath)
                       }
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
        width: parent.width/9
        height: parent.height/7
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

    // Dialog {
    //     id: projectExistsDialog
    //     title: "Erreur"
    //     parent: root
    //     modal: true
    //     dim: true
    //     standardButtons: Dialog.Ok
    //     anchors.centerIn: parent
    //     closePolicy: Popup.NoAutoClose

    //     Text {
    //         id: projectExistsText
    //         text: qsTr("Un projet avec ce nom existe déjà. Veuillez choisir un autre nom.")
    //     }
    // }

    // Dialog {
    //     id: projectDialog
    //     title: "Nom du projet"
    //     parent: root
    //     standardButtons: Dialog.Ok | Dialog.Cancel
    //     anchors.centerIn: parent
    //     modal: true
    //     dim: true
    //     visible: false
    //     width: 300
    //     height: 150
    //     closePolicy: Popup.NoAutoClose

    //     property string selectedFilePath: ""

    //     Column {
    //         spacing: 10
    //         anchors.centerIn: parent

    //         TextField {
    //             id: projectNameInput
    //             placeholderText: "Entrez un nom de projet"
    //         }
    //     }

    //     onAccepted: {
    //         if (selectedFilePath !== "" && selectedFilePath !== undefined) {
    //             let cleanedFilePath = selectedFilePath.replace("file:///", "");
    //             cleanedFilePath = cleanedFilePath.replace(/%20/g, " ");

    //             let projectPath = projectManager.createProject(cleanedFilePath, projectNameInput.text)
    //             if (projectPath.startsWith("Error")) {
    //                 console.log(projectPath)

    //                 if(projectPath === "Error: Project name already exists.") {
    //                     projectExistsDialog.open();
    //                 }
    //             } else {
    //                 console.log("Project créé dans : " + projectPath)
    //                 createMainWidget(selectedFilePath)
    //             }
    //         } else {
    //             console.log("Error: No file selected.");
    //         }
    //     }
    // }

    // function openProjectDialog(filePath) {
    //     projectDialog.selectedFilePath = filePath;
    //     projectDialog.open();

    function import_file(file_path) {
        const extension=String(file_path).split('.')[1]
        if(extension && constants.valid_extension.includes(extension)){
            loadedFilePath = file_path
            importFileEvent(loadedFilePath);
        }else{
            notification.openNotification( errors.error_extension_video, NotificationTypeClass.Error)
            root.color=constants.default_widget_background_color
        }
    }
}
