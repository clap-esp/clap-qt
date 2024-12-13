import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
  property string theme: themeComboBox.currentText

  Text {
    text: qsTr("Paramétrage de la fenêtre")
    color: "white"
    font.bold: true
    font.pixelSize: 22
    anchors.left: parent.left
    anchors.leftMargin: 20
  }

  ColumnLayout {
    anchors.top: parent.top
    anchors.topMargin: 60
    anchors.left: parent.left
    anchors.leftMargin: 40
    spacing: 20

    RowLayout {
      spacing: 33

      Label {
        text: qsTr("Thème")
        color: "white"
      }

      ComboBox {
        id: themeComboBox
        model: [qsTr("Clair"), qsTr("Sombre")]
      }
    }

    RowLayout {
      spacing: 40

      Label {
        text: qsTr("Zoom")
        color: "white"
      }

      ComboBox {
        id: zoomComboBox
        model: ["100%", "125%", "150%", "200%"]
      }
    }

    RowLayout {
      spacing: 39

      Label {
        text: qsTr("Police")
        color: "white"
      }

      ComboBox {
        id: fontComboBox
        model: ["Arial", "Roboto", "Times New Roman", "Verdana"]
        enabled: modifyFontCheckbox.checked
      }

      Label {
        text: qsTr("Taille")
        color: "white"
      }

      ComboBox {
        id: fontSizeComboBox
        model: ["12", "14", "16", "18", "20"]
        enabled: modifyFontCheckbox.checked
      }
    }

    CheckBox {
      id: modifyFontCheckbox
      text: qsTr("Modifier la police")
    }
  }
}
