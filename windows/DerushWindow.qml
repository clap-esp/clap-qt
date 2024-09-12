import QtQuick
import QtQuick.Controls

Rectangle {
  id: root
  anchors.centerIn: parent
  width: 700
  height: 415
  color: "transparent"

  property string filePath: qsTr("")

  Text {
    text: qsTr("Fichier importé : " + filePath)
    anchors.centerIn: parent
    font.pixelSize: 20
    color: "black"
  }

  Rectangle {
    width: 100
    height: 40
    color: "lightgray"
    radius: 10
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50

    Text {
      text: qsTr("Retour")
      anchors.centerIn: parent
    }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        stack_view.pop(StackView.Immediate);
      }
    }
  }
}
