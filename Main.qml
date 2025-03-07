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

    BarMenu {
        id: bar_menu
        z: 1
        onOpenParameterEvent: settings_window.open()
    }



    PythonExecutor {
           id: pythonExec
           onScriptStarted: {
               loadingPopup.open()
           }

           onScriptOutput: (output)=>{
                               console.log(output)
                }

           onScriptFinished:{
               loadingPopup.close();
               createMainWidget(file_path)

           }
           onScriptError: (error)=>{
                // console.log('error')
                hasError= true
                console.log(error)
            }
    }



    StackView {
        id: stack_view
        initialItem: import_window_component
        anchors.fill: parent
    }

    SettingsWindow {
        id: settings_window
    }

    Component {
        id: import_window_component


        ImportWindow {
            id: import_window
            onImportFileEvent: {
                let filePath = import_window.loadedFilePath;
                file_path= filePath
                let lang= import_window.selectedLanguageCode
                runTranscriptionScript(filePath, lang)
            }
        }
    }

    LoadingWidget{
        id:loadingPopup
        textToDisplay: messages.video_importation
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
    function runTranscriptionScript(filePath, spokenLang){
        pythonExec.executeTranscription([filePath, spokenLang])
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