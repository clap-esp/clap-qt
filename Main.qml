import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
  id: root

  width: 1920
  height: 1080
  visible: true
  title: "Clap - Main Window"
  color: "#484848"

  ImportWindow {
    id: import_window
  }
}
