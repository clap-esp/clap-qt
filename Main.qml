import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import "windows"

Window {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#484848"
    visibility: Window.Maximized
    visible: true
    title: qsTr("Clap - Main Window")

    BarMenu {
        id: bar_menu
        onOpenParameterEvent: stack_view.push(parameter_window_component, StackView.Immediate)
    }

    StackView {
        id: stack_view
        initialItem: import_window_component
        anchors.fill: parent
        clip: true
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

        DerushWindow {
            id: main_widget

            width: stack_view.width
            height: stack_view.height

            anchors.fill: undefined
        }
    }

    function createMainWidget(processedVideoPath) {
        // Créez le VideoWidget et passez le chemin de la vidéo traitée
        let mainWidget = main_widget_component.createObject(stack_view, {
                                                                "videoSourcePath": processedVideoPath,
                                                                "width": stack_view.width,
                                                                "height": stack_view.height
                                                            });
        console.log("Loading video from: " + processedVideoPath);
        root.color = "#000000";
        stack_view.clear()
        stack_view.push(mainWidget, StackView.Immediate);
    }
}
