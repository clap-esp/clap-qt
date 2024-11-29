import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Settings"

Dialog {
  id: root
  width: Screen.width / 2
  height: Screen.height / 2
  x: (Screen.width - width) / 2
  y: (Screen.height - height) / 2

  property string selectedMenuItem: qsTr("Paramétrage Fenêtre")

  enter: Transition {
    NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
  }

  exit: Transition {
    NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
  }

  header: Rectangle {
    color: Material.Dark
    height: 30
    width: parent.width

    Text {
      anchors.centerIn: parent
      text: qsTr("Paramétrages")
      font.bold: true
      color: "black"
    }
  }

  WindowSettingsView {
    id: settingWindow

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 10
    anchors.topMargin: 20
  }

  footer: Rectangle {
    height: 50
    color: "#2A2A2A"
    width: parent.width

    Row {
      spacing: 10
      anchors.left: parent.left
      anchors.leftMargin: 15
      anchors.verticalCenter: parent.verticalCenter

      Button {
        text: qsTr("Aide")
      }

      Button {
        text: qsTr("Réinitialiser")
      }
    }

    Row {
      spacing: 10
      anchors.right: parent.right
      anchors.rightMargin: 15
      anchors.verticalCenter: parent.verticalCenter

      Button {
        text: qsTr("Annuler")
        onClicked: root.close()
      }

      Button {
        text: qsTr("OK")
      }
    }
  }
}
