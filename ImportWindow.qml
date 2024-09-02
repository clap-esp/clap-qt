import QtQuick
import QtCore
import QtQuick.Dialogs

Rectangle {
  id: root
  anchors.centerIn: parent
  width: 700
  height: 415
  color: "transparent"

  property string loadedFilePath: ""

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
      ctx.radius = 10;
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
      import_file(drop.urls[0]);
      root.color = "transparent";
    }
    onExited: {
      root.color = "transparent";
    }
  }

  // Icone de la caméra
  Image {
    id: cameraImage
    source: "./images/camera.png"
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
      text: "Importez une vidéo"
      font.pixelSize: 20
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
      source: "./images/camera.png"
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
      text: "ou glissez votre fichier ici"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: importButton.top
      anchors.topMargin: 70
      font.pixelSize: 20
      color: "white"
    }

    FileDialog {
      id: fileDialog
      currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
      onAccepted: import_file(fileDialog.selectedFile)
    }
  }

  function import_file(file_path) {
    // TODO
    loadedFilePath = file_path
    console.log(`Path file : ${loadedFilePath}`)
  }
}

