import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

Window {
  id: root

  width: 1920
  height: 1080
  visible: true
  title: "Clap - Main Window"
  color: "#484848"

  StackView {
    id: stackView
    initialItem: import_window
    anchors.fill: parent
  }

  ImportWindow {
    id: import_window
  }

  ParameterWindow {
    id: parameter_window
  }
}
