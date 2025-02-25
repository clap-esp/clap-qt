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
           onScriptStarted: {
               loadingPopup.open()
           }

           onScriptFinished:{
               loadingPopup.close();
               createMainWidget(file_path)

           }
           onScriptError: (error)=>{
              console.log("Python Error:", error)
            }
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
                file_path= filePath
                runTranscriptionScript(filePath)
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
        }
    }


    /**
    * Run transcription script
    **/
    function runTranscriptionScript(filePath){
        pythonExec.executeTranscription([filePath])
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
        stack_view.push(mainWidget, StackView.Immediate);
    }
}
