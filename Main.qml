import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

Window {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#242424"
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

    Component {
        id: main_widget_component

        MainWidget {
            id: main_widget

            width: parent.width
            height: parent.height
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
        stack_view.push(mainWidget, StackView.Immediate);
    }
}
