import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

Window {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#242424"
    visibility: "Maximized"
    visible: true
    title: "Clap - Main Window"

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
                createVideoWidget(import_window.loadedFilePath);  // Appeler la fonction avec le chemin
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
        id: video_widget_component

        VideoWidget {
            id: video_widget

            width: parent.width * 0.5 // Taille fixe pour le widget
            height: parent.height * 0.5 // Taille fixe pour le widget
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 10  // Marge de 10 pixels en haut
            anchors.rightMargin: 10 // Marge de 10 pixels à droite
        }
    }

    function createVideoWidget(processedVideoPath) {
        // Créez le VideoWidget et passez le chemin de la vidéo traitée
        let videoWidget = video_widget_component.createObject(stack_view, { "videoSource": processedVideoPath });
        console.log(processedVideoPath)
        stack_view.push(videoWidget, StackView.Immediate);
    }
}
