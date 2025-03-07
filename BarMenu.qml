import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import 'Utils'
import 'Settings'

MenuBar {
  readonly property var constants: Constants { }

  id: root
  contentWidth: parent.width
  focus: true
  font.pixelSize: 18
  background: Rectangle {
    color: constants.panel_background_color

    Rectangle {
      anchors.bottom: parent.bottom
      width: parent.width
      height: 1
      color: "white"
    }
  }

  signal openParameterEvent()

  Keys.onReleased: function(event) {
    if (event.key === Qt.Key_Escape) {
      fichierMenu.open()
    }
  }

  Menu {
    id: fichierMenu
    title: qsTr("Fichier")
    Action {
      text: qsTr("Nouveau...")
      icon.name: "document-new"
    }
    Action {
      text: qsTr("Ouvrir...")
      icon.name: "document-open"
    }
    Action {
      text: qsTr("Sauvegarder")
      icon.name: "document-save"
    }
    Action {
      text: qsTr("Sauvegarder en tant que...")
      icon.name: "document-save-as"
    }
    Action {
      text: qsTr("Paramètres...")
      icon.name: "emblem-system"
      onTriggered: openParameterEvent()
    }

    MenuSeparator { }

    Action {
      text: qsTr("Quit")
      icon.name: "application-exit"
      onTriggered: quit_confirmation_popup.open()
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
  }

  Menu {
    title: qsTr("Help")

    Action {
      text: qsTr("About")
      icon.name: "help-about"
      onTriggered: Qt.openUrlExternally("https://github.com/clap-esp/clap-qt")
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
  }

  QuitWidget {
    id: quit_confirmation_popup
    width: root.parent.width/4
    height: root.parent.height/4
  }
}
