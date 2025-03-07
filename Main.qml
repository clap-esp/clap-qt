import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import "windows"
import 'Utils'
import 'Utils/Notification'
import "Loading"
import python.executor 1.0

Window {
    readonly property var constants: Constants { }
    readonly property var messages: Success{}
    property string file_path: ''

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

    PythonExecutor {
        id: pythonExec


        onScriptFinished:{
            loadingPopup.close();
            createMainWidget(file_path)

        }
        onScriptError: (error)=>{
                           console.log("Python Error:", error)
                       }

        onScriptOutput: (value) => {
                            console.log(value)
                        }
    }

    PythonExecutor{
        id: thumbnailExec
        onScriptStarted: {
            loadingPopup.open()
        }
        onScriptFinished:{
            runTranscriptionScript(file_path)
            // loadingPopup.close();
            // createMainWidget(file_path)

        }
        onScriptError: (error)=>{
                           console.log("Python Error:", error)
                       }

        onScriptOutput: (value) => {
                            console.log(value)
                        }

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
                file_path= filePath
                // runTranscriptionScript(filePath)
                runThumbnailsGenerationScript(filePath)
            }
        }
    }

    LoadingWidget{
        id:loadingPopup
        textToDisplay: messages.video_importation
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

            width: stack_view.width
            height: stack_view.height

            anchors.fill: undefined
        }
    }


    /**
    * Run transcription script
    **/
    function runTranscriptionScript(filePath){
        pythonExec.executeTranscription([filePath])
    }

    function runThumbnailsGenerationScript(filePath) {
        thumbnailExec.executeThumbnailsGeneration([filePath])
    }

    /**
    *
    **/

    function createMainWidget(processedVideoPath) {
        stack_view.clear()
        let mainWidget = main_widget_component.createObject(stack_view, {
                                                                "videoSourcePath": processedVideoPath
                                                            });
        root.color = "#000000";
        stack_view.clear()
        stack_view.push(mainWidget, StackView.Immediate);
    }
}
