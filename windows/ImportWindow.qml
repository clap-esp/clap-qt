import QtQuick
import QtCore
import QtQuick.Dialogs
import QtQuick.Controls

Rectangle {
    id: root
    anchors.centerIn: parent
    width: 700
    height: 415
    color: "#484848"

    property string loadedFilePath: qsTr("")
    signal importFileEvent(string processedVideoPath)

    // Permet d'avoir la zone de drag and drop en pointillet
    Canvas {
        id: dottedBorderCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height); // Effacer le canvas
            ctx.setLineDash([5, 5]); // Définit le motif des pointillés : 5px trait, 5px espace
            ctx.strokeStyle = "black"; // Couleur de la bordure
            ctx.lineWidth = 5; // Largeur de la bordure
            ctx.strokeRect(0, 0, width, height); // Dessine le rectangle avec une bordure en pointillé
        }
    }

    // Zone de drag and drop
    DropArea {
        anchors.fill: parent
        onEntered: (drag) => {
                       root.color = "#cccccc";
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

    // Icone de la caméra
    Image {
        id: cameraImage
        source: "../images/camera.png"
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 255
        width: 200
        height: 170
    }

    // Bouton pour importer une vidéo
    Rectangle {
        id: importButton
        width: 300
        height: 45
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: cameraImage.top
        anchors.topMargin: 195
        color: "#dddddd"
        radius: 25

        Text {
            text: qsTr("Importez une vidéo")
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            source: "../images/camera.png"
            width: 25
            height: 25
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
        }

        MouseArea {
            anchors.fill: parent
            onClicked: fileDialog.open()

            onPressed: {
                importButton.color = "#bbbbbb";
            }

            onReleased: {
                importButton.color = "#dddddd";
            }
        }

        // Texte pour glisser le fichier
        Text {
            text: qsTr("ou glissez votre fichier ici")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: importButton.top
            anchors.topMargin: 70
            font.pixelSize: 20
            color: "white"
        }

        FileDialog {
            id: fileDialog
            nameFilters: ["Fichiers vidéo (*.mp4 *.avi *.mov *.m4a *.mkv)"]
            currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
            onAccepted: {
                fileDialog.close();
                openProjectDialog(fileDialog.currentFile)
            }

            onRejected: {
                fileDialog.close();
            }
        }
    }

    Dialog {
        id: projectExistsDialog
        title: "Erreur"
        parent: root
        modal: true
        dim: true
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        closePolicy: Popup.NoAutoClose

        Text {
            id: projectExistsText
            text: qsTr("Un projet avec ce nom existe déjà. Veuillez choisir un autre nom.")
        }
    }

    Dialog {
        id: fileNotAVideoDialog
        title: "Erreur"
        parent: root
        modal: true
        dim: true
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        closePolicy: Popup.NoAutoClose

        Text {
            id: fileNotAVideoText
            text: qsTr("Ce fichier n'est pas dans format valable. Veuillez choisir un fichier vidéo.")
        }
    }

    Dialog {
        id: projectDialog
        title: "Nom du projet"
        parent: root
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        modal: true
        dim: true
        visible: false
        width: 300
        height: 150
        closePolicy: Popup.NoAutoClose

        property string selectedFilePath: ""

        Column {
            spacing: 10
            anchors.centerIn: parent

            TextField {
                id: projectNameInput
                placeholderText: "Entrez un nom de projet"
            }
        }

        onAccepted: {
            if (selectedFilePath !== "" && selectedFilePath !== undefined) {
                let cleanedFilePath = selectedFilePath.replace("file:///", "");
                cleanedFilePath = cleanedFilePath.replace(/%20/g, " ");

                let projectPath = projectManager.createProject(cleanedFilePath, projectNameInput.text)
                if (projectPath.startsWith("Error")) {
                    console.log(projectPath)

                    if(projectPath === "Error: Project name already exists.") {
                        projectExistsDialog.open();
                    }
                } else {
                    console.log("Project créé dans : " + projectPath)
                    createMainWidget(selectedFilePath)
                }
            } else {
                console.log("Error: No file selected.");
            }
        }
    }

    function openProjectDialog(filePath) {
        projectDialog.selectedFilePath = filePath;
        projectDialog.open();
    }
}
