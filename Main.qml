import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Effects
import "windows"
import 'Utils'
import 'Utils/Notification'
import "Loading"
import notification.type 1.0
import python.executor 1.0

Window {
    readonly property var constants: Constants { }
    readonly property var messages: Success{}
    property string loadedFilePath: qsTr("")
    property string file_path: ''
    property string newProjectName:''
    property bool hasError: false
    property bool projectCreated:false
    signal importFileEvent(string processedVideoPath)

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
        onOpenParameterEvent: stack_view.push(parameter_window_component, StackView.Immediate)

        onOpenNewProjectEvent: fileDialogNewProject.open()

        onOpenProjectEvent: fileDialogExistingProject.open()

        z: 10
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

    PythonExecutor {
        id: pythonExec


        onScriptFinished:{
            projectManager.copyFileInProject("transcription")
            runDerushScript()
        }
        onScriptError: (error)=>{
                           console.log("Python Error:", error)
                       }

        onScriptOutput: (value) => {
                            console.log(value)
                        }
    }



    PythonExecutor{
        id: derushExec
        onScriptFinished:{
            projectManager.copyFileInProject("derush")
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
                               projectManager.copySubtitleJsonInTmp()

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

    FileDialog {
        id: fileDialogNewProject
        nameFilters: constants.accepted_extension
        currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
        onAccepted: {
            openProjectDialog(fileDialogNewProject.selectedFile)
        }
    }

    FileDialog {
        id: fileDialogExistingProject
        nameFilters: ["*.json"]
        currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
        onAccepted: {
            var file = fileDialogExistingProject.selectedFile
            console.log(file)
            openProjectFile(file)
        }
    }

    Dialog {
        id: projectDialog
        title: "Nom du projet"
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        modal: true
        dim: true
        visible: false
        width: parent.width / 4
        height: parent.height / 5 + 50
        closePolicy: Popup.NoAutoClose
        Material.background: constants.panel_background_color
        Material.foreground: Material.DeepPurple
        Material.accent: Material.DeepPurple

        property string selectedFilePath: ""

        TextField {
            id: projectNameInput
            width: parent.width
            height: parent.height/2 +20
            font.pixelSize: 14
            placeholderText: "Entrez un nom de projet"
            placeholderTextColor: "white"
            Material.foreground: "white"
            Material.accent: "white"
        }

        onAccepted: {
            if (selectedFilePath !== "" && selectedFilePath !== undefined) {
                let cleanedFilePath = selectedFilePath.replace("file:///", "")
                console.log(cleanedFilePath);
                cleanedFilePath = cleanedFilePath.replace(/%20/g, " ");
                newProjectName= projectNameInput.text;
                let projectPath = projectManager.createProject(cleanedFilePath, projectNameInput.text)
                if (projectPath.startsWith("Error")) {
                    console.log(projectPath)
                    if(projectPath === "Error: Project name already exists.") {
                        projectExistsDialog.open();
                    }
                } else {
                    console.log("Project créé dans : " + projectPath)
                    projectCreated = true;
                    import_file(selectedFilePath)
                    file_path = selectedFilePath;
                    globalVariable.setcurrentProjectName(projectPath);

                    runThumbnailsGenerationScript(globalVariable.currentProjectName, file_path)
                    console.log()
                }
            } else {
                console.log("Error: No file selected.");
            }
        }
    }

    Dialog {
        id: projectExistsDialog
        title: "Erreur"
        modal: true
        dim: true
        width: parent.width / 4
        height: parent.height / 5 + 50
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        closePolicy: Popup.NoAutoClose
        Material.background: constants.panel_background_color
        Material.foreground: Material.DeepPurple
        Material.accent: Material.DeepPurple

        Text {
            id: projectExistsText
            text: qsTr("Un projet avec ce nom existe déjà. \nVeuillez choisir un autre nom.")
            color: "white"
            font.pixelSize: 14
        }

        onAccepted: projectDialog.open()
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

    function runDerushScript(){
        derushExec.executeDerush();
    }


    /**
    *
    **/

    function openProjectDialog(filePath) {
        projectDialog.selectedFilePath = filePath;
        projectDialog.open();
    }

    function createMainWidget(processedVideoPath) {
        stack_view.clear()
        let mainWidget = main_widget_component.createObject(stack_view, {
                                                                "videoSourcePath": processedVideoPath,
                                                                "hasTranscriptionError": false
                                                            });
        root.color = constants.panel_background_color
        stack_view.push(mainWidget, StackView.Immediate);
    }

    function import_file(file_path) {

        const extension=String(file_path).split('.')[1]
        if(extension && constants.valid_extension.includes(extension)){
            let cleanedFilePath = file_path.replace(/%20/g, " ");
            if (Qt.platform.os === "windows") {
                cleanedFilePath = cleanedFilePath.replace("C:/", "file:///")
            }
            console.log(cleanedFilePath);
            loadedFilePath = cleanedFilePath
            importFileEvent(loadedFilePath);
        }else{
            notification.openNotification( errors.error_extension_video, NotificationTypeClass.Error)
            root.color=constants.panel_background_color
        }
    }

    function openProjectFile(fileUrl) {
        let xhr = new XMLHttpRequest();
        xhr.open("GET", fileUrl, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    console.log("Contenu du JSON :", xhr.responseText);
                    let jsonData = JSON.parse(xhr.responseText);
                    stack_view.clear()
                    globalVariable.setcurrentProjectName(jsonData.name);
                    globalVariable.setTranslationHistory(jsonData.translated_in)
                    projectManager.copySubtitleJsonInTmp()

                    let mainWidget = main_widget_component.createObject(stack_view, {
                                                                            "videoSourcePath": jsonData.videos[0].filePath,
                                                                            "openingProject": true,
                                                                        });
                    root.color = constants.panel_background_color
                    stack_view.push(mainWidget, StackView.Immediate);
                    console.log("Objet JSON :", jsonData);
                } else {
                    console.error("Erreur lors de la lecture du fichier :", xhr.status);
                }
            }
        };
        xhr.send();
    }
}
