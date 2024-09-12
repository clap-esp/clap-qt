import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

Window {
  id: root

  width: 1920
  height: 1080
  visible: true
  title: qsTr("Clap - Main Window")
  color: "#484848"

  BarMenu {
    id: bar_menu
    onOpenParameterEvent: stack_view.push(parameter_window_component, StackView.Immediate)
  }

  StackView {
    id: stack_view
    initialItem: import_window_component
    anchors.fill: parent
  }

  Component {
    id: import_window_component

    ImportWindow {
      id: import_window
      onImportFileEvent: {
        stack_view.push(derush_window_component.createObject(stack_view, { "filePath": import_window.loadedFilePath }), StackView.Immediate)
      }
    }
  }

  Component {
    id: derush_window_component

    DerushWindow {
      id: derush_window
    }
  }

  Component {
    id: parameter_window_component

    ParameterWindow {
      id: parameter_window
    }
  }
}
