import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Row {
  width: parent.width
  height: parent.height

  Rectangle {
    width: parent.width / 4
    height: parent.height - 20
    color: "#2A2A2A"
    border.width: 2
    border.color: "#226BD7"

    ListView {
      id: listView

      width: parent.width - 4
      height: parent.height - 4
      anchors.centerIn: parent

      model: ListModel {
        ListElement { name: qsTr("Sous-titrage") }
        ListElement { name: qsTr("Langue et traduction") }
        ListElement { name: qsTr("Option de sauvegarde") }
        ListElement { name: qsTr("Paramétrage Fenêtre") }
      }

      currentIndex: -1

      delegate: ItemDelegate {
        width: listView.width
        height: 40

        onClicked: {
          listView.currentIndex = index;
        }

        Rectangle {
          width: parent.width
          height: parent.height

          color: index === listView.currentIndex ? "#226BD7" : "transparent"

          Text {
            anchors.centerIn: parent
            text: model.name
            color: "white"
            font.bold: index === listView.currentIndex
            font.pixelSize: 18
          }
        }
      }
    }
  }

  Rectangle {
    width: (parent.width * (3 / 4)) - 4
    height: parent.height - 20
    color: "#2A2A2A"
  }
}

