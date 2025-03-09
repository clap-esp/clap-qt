import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
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
    property bool hasError: false

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
            projectManager.copyFileInProject("transcription")
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
                file_path = import_window.loadedFilePath;
                runThumbnailsGenerationScript(globalVariable.currentProjectName ,file_path)
            }

            onOpenProject: (name_value)=>{
                               stack_view.clear()
                               globalVariable.setcurrentProjectName(name_value.name);
                               globalVariable.setTranslationHistory(name_value.translated_in)
                               console.log('flobal variable ', globalVariable.translationHistory)
                               let mainWidget = main_widget_component.createObject(stack_view, {
                                                                                       "videoSourcePath": name_value.videos[0].filePath,
                                                                                       "openingProject": true,
                                                                                   });
                               root.color = constants.panel_background_color
                               stack_view.push(mainWidget, StackView.Immediate);
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

    function runThumbnailsGenerationScript(projectName, filePath) {
        thumbnailExec.executeThumbnailsGeneration(projectName, [filePath])
    }



    /**
    *
    **/

    function createMainWidget(processedVideoPath) {
        stack_view.clear()
        let mainWidget = main_widget_component.createObject(stack_view, {
                                                                "videoSourcePath": processedVideoPath,
                                                                "hasTranscriptionError": false
                                                            });
        root.color = constants.panel_background_color
        stack_view.push(mainWidget, StackView.Immediate);
    }
}
