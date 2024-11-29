import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

MenuBar {
  id: root
  contentWidth: parent.width
  focus: true

  signal openParameterEvent()

  Keys.onReleased: function(event) {
    if (event.key === Qt.Key_Escape) {
      fichierMenu.open()
    }
  }

  Menu {
    id: fichierMenu
    title: qsTr("Fichier")

    Action { text: qsTr("Nouveau...") }
    Action { text: qsTr("Ouvrir...") }
    Action { text: qsTr("Sauvegarder") }
    Action { text: qsTr("Sauvegarder en tant que...") }
    Action {
      text: qsTr("Paramètres...");
      onTriggered: openParameterEvent();
    }

    MenuSeparator { }

    Action {
      text: qsTr("Quit");
      onTriggered: quit_confirmation_dialog.open();
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
  }

  Menu {
    title: qsTr("Help")

    Action {
      text: qsTr("About")
      onTriggered: Qt.openUrlExternally("https://github.com/clap-esp/clap-qt");
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
  }

  MessageDialog {
    id: quit_confirmation_dialog

    title: qsTr("Quitter l'application")
    text: qsTr("Êtes-vous sûr de vouloir quitter l'application ?")
    buttons: MessageDialog.Yes | MessageDialog.Cancel
    onButtonClicked: function (button, role) {
      switch (button) {
      case MessageDialog.Yes:
        Qt.quit();
        break;
      }
    }
  }
}
