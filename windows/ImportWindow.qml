import notification.type 1.0
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Effects
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
    readonly property var codeIso: IsoLanguageCode { }
    property string selectedLanguageCode: "fr"

    id: root
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    color: '#1E1B26'


    signal importFileEvent(string processedVideoPath, string lang)

    NotificationWidget{
        id: notification
    }



    RowLayout{
        id:container
        width: parent.width/2
        height: 50

        y:100
        x: dottedBorderCanvas.x
        spacing: 10

        Image{
            id: settings_icon
            source: '../images/translate.png'
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: selectMenu.open()

            }
        }

        Text{
            id: select_language
            color: 'white'
            text: displayLanguage()
            font.pixelSize: 18
        }





    }


    Menu {
        id: selectMenu
        x: dottedBorderCanvas.x+5
        topMargin: container.y+35
        Material.theme: Material.Dark
        Material.background: constants.default_widget_background_color
        Material.foreground: 'white'
        contentHeight: 300
        Repeater{
            model: codeIso.codeIso
            MenuItem {
                required property var modelData
                text:modelData.lang;
                onTriggered:{
                    selectedLanguageCode=modelData.code
                }
            }

        }

    }

    Canvas {
        id: dottedBorderCanvas
        width: parent.width/2
        height: parent.height/2
        anchors.horizontalCenter: parent.horizontalCenter
        y: 165
        onPaint: {
            var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    var radius = 35;
                    ctx.setLineDash([1, 1]);
                    ctx.strokeStyle = "#CECECE";
                    ctx.lineWidth = 5;
                    ctx.beginPath();
                    ctx.moveTo(radius, 0);
                    ctx.lineTo(width - radius, 0);
                    ctx.quadraticCurveTo(width, 0, width, radius);
                    ctx.lineTo(width, height - radius);
                    ctx.quadraticCurveTo(width, height, width - radius, height);
                    ctx.lineTo(radius, height);
                    ctx.quadraticCurveTo(0, height, 0, height - radius);
                    ctx.lineTo(0, radius);
                    ctx.quadraticCurveTo(0, 0, radius, 0);
                    ctx.closePath();
                    ctx.stroke();
                }


        Rectangle {
            id: importButton
            width: root.width <= Screen.width/2 ? parent.width/2 : parent.width/3 +30
            height: 45
            anchors.centerIn: parent
            color:"#dddddd"
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
                id: text_drag
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



            Text {
                text: qsTr("Extensions de fichier supportés: mp4, m4a, mov, avi")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: text_drag.top
                anchors.topMargin: 70
                font.pixelSize: 15
                font.italic: true
                color: "#CECECE"
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent

                }
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
        source: "../images/video.png"
        anchors.top: dottedBorderCanvas.top
        anchors.horizontalCenter: dottedBorderCanvas.horizontalCenter
        anchors.topMargin: 20
        width: 100
        height: 100
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



    function displayLanguage(){
        const iso= codeIso.codeIso.find(iso=> iso['code']===selectedLanguageCode)
        return 'Langue parlée dans la vidéo: '+ iso['lang']
    }

    function import_file(file_path) {
        const extension=String(file_path).split('.')[1]
        if(extension && constants.valid_extension.includes(extension)){
            loadedFilePath = file_path
            importFileEvent(loadedFilePath, selectedLanguageCode);
        }else{
            notification.openNotification( errors.error_extension_video, NotificationTypeClass.Error)
            root.color=constants.default_widget_background_color
        }
    }
}
