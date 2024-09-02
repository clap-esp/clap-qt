import QtQuick

Rectangle {
  anchors.centerIn: parent
  width: 300
  height: 300
  color: "transparent"

  // Icone de la caméra
  Image {
    source: "./images/film.png"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 30
    width: 200
    height: 200
  }

  // Bouton pour importer une vidéo
  Rectangle {
    id: importButton
    width: 300
    height: 45
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 200
    color: "#dddddd"
    radius: 25

    Text {
      text: "Importez une vidéo"
      font.pixelSize: 20
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
      source: "./images/film.png"
      width: 40
      height: 40
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      anchors.rightMargin: 10
    }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        console.log("Bouton cliqué - Fonction d'importation à implémenter ici")
      }

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
      anchors.top: parent.top
      anchors.topMargin: 70
      font.pixelSize: 20
    }
  }

  function import_file() {
    // TODO
  }
}

