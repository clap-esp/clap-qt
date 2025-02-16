import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import "windows"
import 'Utils'

Window {
    readonly property var constants: Constants { }

    id: root

    width: Screen.width
    height: Screen.height
    color:  constants.default_background_color
    visibility: Window.Maximized
    minimumWidth: Screen.width/2
    visible: true
    title: qsTr("Clap")

    // BarMenu {
    //     id: bar_menu
    //     onOpenParameterEvent: stack_view.push(parameter_window_component, StackView.Immediate)
    // }

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
                let filePath = import_window.loadedFilePath;
                console.log("before create Main Widget");
                createMainWidget(filePath);
            }
        }
    }

    Component {
        id: parameter_window_component

        ParameterWindow {
            id: parameter_window
        }
    }

    Component {
        id: main_widget_component

        MainWindow {
            id: main_widget
        }
    }

    function createMainWidget(processedVideoPath) {
        stack_view.clear()
        let mainWidget = main_widget_component.createObject(stack_view, {
                                                                "videoSourcePath": processedVideoPath

                                                            });
        root.color = "#000000";
        stack_view.push(mainWidget, StackView.Immediate);
    }
}
