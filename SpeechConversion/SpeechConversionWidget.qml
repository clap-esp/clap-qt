import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Notification"
import '../Utils/Notification'
import '../Utils'
import notification.type 1.0
import python.executor 1.0

Item {
    id: speech
    anchors.fill: parent
    property bool hasError: false
    property bool enableTranslation : false
    property bool enableTranscription: true
    property string textToDisplay: 'wow'
    property var transcriptionData: []
    property var translationData: []
    property int index: 0
    property bool isProcessing: false
    property int interval: 10000
    property bool stopValue:false
    property string currentLanguage: ''
    property bool translation_loading:false
    property bool translation_done:false
    readonly property var constants: Constants { }
    readonly property var errors: Error {}
    readonly property var codeIso: IsoLanguageCode { }

    NotificationWidget{
        id: notification
    }

    PythonExecutor {
        id: scriptExec
        onScriptStarted: {
            translation_loading=true
        }

        onScriptOutput: (output)=>{
                            console.log(output)
                        }


        onScriptFinished:{
            projectManager.copyFileInProject("translation")
            translation_loading=false
            translation_done=true
            readFile('translation')

        }
        onScriptError: (error)=>{
                           hasError= true
                           console.log(error)
                       }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            background: Rectangle {
                color: constants.panel_background_color
            }
            Material.theme: Material.Light
            Material.accent: Material.Purple

            TabButton {
                text: "Sous-titre"
                font.pixelSize: 14
                checkable: true
                width: 100
                Material.theme: Material.Light
                Material.foreground: 'white'
                Material.accent: Material.Purple
                background: Rectangle {
                    color: tabBar.currentIndex === 0 ? constants.default_widget_background_color : constants.default_widget_background_color
                    radius:8

                    Rectangle{
                        y: parent.height/2
                        height: parent.height/2
                        radius: 0
                        width: parent.width
                        color: tabBar.currentIndex === 0 ? constants.default_widget_background_color : constants.default_widget_background_color
                    }
                }
            }

            TabButton {
                text: "Traduction"
                font.pixelSize: 14
                checkable: true
                width: 100
                Material.theme: Material.Light
                Material.foreground: 'white'
                Material.accent: Material.Purple
                background: Rectangle {
                    color: tabBar.currentIndex === 1 ? constants.default_widget_background_color : constants.default_widget_background_color
                    radius:8

                    Rectangle{
                        y: parent.height/2
                        height: parent.height/2
                        radius: 0
                        width: parent.width
                        color: tabBar.currentIndex === 1 ? constants.default_widget_background_color: constants.default_widget_background_color
                    }
                }
            }

            TabButton {
                text: "Historique"
                font.pixelSize: 14
                checkable: true
                width: 100
                Material.theme: Material.Light
                Material.foreground: 'white'
                Material.accent: Material.Purple
                background: Rectangle {
                    color: tabBar.currentIndex === 2 ? constants.default_widget_background_color : constants.default_widget_background_color
                    radius:8

                    Rectangle{
                        y: parent.height/2
                        height: parent.height/2
                        radius: 0
                        width: parent.width
                        color: tabBar.currentIndex === 2 ? constants.default_widget_background_color: constants.default_widget_background_color
                    }
                }
            }


        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            Rectangle {
                color: constants.default_widget_background_color
                radius: 10
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: constants.default_widget_background_color
                        radius: 10
                        clip: true

                        Text{
                            text: 'SOUS-TITRE INDISPONIBLE'
                            anchors.centerIn: parent
                            visible: hasError
                            color: 'white'
                            font.pixelSize: 20
                            font.bold: true
                        }

                        ListView {
                            id: listViewTranscription
                            anchors.fill: parent
                            anchors.top: parent.top
                            anchors.topMargin: 20
                            anchors.bottomMargin: 20
                            visible: !hasError
                            clip: true
                            spacing:10
                            model: ListModel {}
                            z:2
                            delegate: Item {
                                height: 50
                                width: parent?.width
                                TextBlock{
                                    id: textBlockTranscription
                                    textToDisplay: model.text
                                    timeCode: model.timeCode
                                    onChooseBlock: {

                                    }
                                }
                            }

                            ScrollBar.vertical: ScrollBar {
                                anchors.right: parent.right
                                policy: listViewTranscription.contentHeight > listViewTranscription.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                                active: hovered || pressed
                                contentItem: Rectangle {
                                    color: constants.scrollbar_color
                                    radius: 4
                                }
                                snapMode: ScrollBar.SnapOnRelease
                            }

                        }

                    }
                }
            }


            Rectangle {
                color: constants.default_widget_background_color
                radius:10

                ColumnLayout{
                    anchors.fill: parent
                    spacing: 5
                    Row{
                        id:container
                        Layout.fillWidth: true
                        Layout.preferredHeight: 10
                        Layout.leftMargin: 20
                        Layout.topMargin: 20
                        spacing: parent.width - (choosen_language.width + settings.width +40)
                        visible: !hasError
                        Text{
                            id: choosen_language
                            color: 'white'
                            text: findLanguage(currentLanguage)
                            font.pixelSize: 12
                        }

                        Image{
                            id: settings
                            source: '../images/translate.png'
                            width:16
                            height:16

                            anchors.rightMargin: 20

                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: languageMenu.open()

                            }
                        }



                    }


                    Menu {
                        id: languageMenu
                        x: settings.x-width+10
                        y: settings.y+ settings.height
                        Material.theme: Material.Dark
                        Material.background: constants.default_widget_background_color
                        Material.foreground: 'white'
                        contentHeight: speech.height-10
                        Repeater{
                            model: codeIso.codeIso
                            MenuItem {
                                required property var modelData
                                text:modelData.lang;
                                onTriggered: setLanguage(modelData.code);
                            }

                        }

                    }

                    Rectangle{
                        Layout.fillWidth:  true
                        Layout.preferredHeight: parent.height-120
                        // Layout.preferredHeight: parent.height-10
                        color: 'transparent'

                        Text{
                            text: 'TRADUCTION INDISPONIBLE'
                            anchors.centerIn: parent
                            visible: hasError
                            color: 'white'
                            font.pixelSize: 20
                            font.bold: true
                        }

                        BusyIndicator{
                            running: translation_loading
                            anchors.centerIn: parent
                            Material.background: Material.Purple
                            Material.accent: Material.DeepPurple
                        }

                        ListView {
                            id: listViewTranslation
                            anchors.fill: parent
                            anchors.top: parent.top
                            visible: !translation_loading
                            clip: true
                            spacing:10
                            model: ListModel {
                                id: translationListModel}
                            z:2
                            delegate: Item {
                                height: 50
                                width: parent?.width
                                TextBlock{
                                    id: textBlockTranslation
                                    textToDisplay: model.text
                                    timeCode: model.timeCode
                                }
                            }

                            ScrollBar.vertical: ScrollBar {
                                anchors.right: parent.right
                                policy: listViewTranslation.contentHeight > listViewTranslation.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                                active: hovered || pressed
                                contentItem: Rectangle {
                                    color: constants.scrollbar_color
                                    radius: 4
                                }
                                snapMode: ScrollBar.SnapOnRelease
                            }
                        }
                    }
                }
            }

            Rectangle {
                color: constants.default_widget_background_color
                radius:10

                ColumnLayout{
                    anchors.fill: parent
                    spacing: 5

                    Rectangle{
                        Layout.fillWidth:  true
                        Layout.fillHeight: true
                        // Layout.preferredHeight: parent.height-120
                        // Layout.preferredHeight: parent.height-10
                        color: 'transparent'

                        ListView {
                            id: listViewHistory
                            anchors.fill: parent
                            anchors.top: parent.top
                            anchors.topMargin: 15
                            visible: !translation_loading
                            spacing:10
                            model: globalVariable.translationHistory
                            clip:true
                            z:2
                            delegate: Item {
                                required property var modelData

                                height: 50
                                width: parent?.width
                                TextBlock{
                                    id: textBlockHistory
                                    textToDisplay: findLanguage(modelData)
                                    timeCode: ""
                                    history: true
                                    onChooseBlock: loadTranslationFromHistory(modelData)
                                }
                            }

                            ScrollBar.vertical: ScrollBar {
                                anchors.right: parent.right
                                policy: listViewHistory.contentHeight > listViewHistory.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                                active: hovered || pressed
                                contentItem: Rectangle {
                                    color: constants.scrollbar_color
                                    radius: 4
                                }
                                snapMode: ScrollBar.SnapOnRelease
                            }
                        }

                        Text{
                            text: 'HISTORIQUE DE TRADUCTION VIDE'
                            anchors.centerIn: parent
                            visible: !globalVariable.translationHistory.length
                            color: 'white'
                            font.pixelSize: 20
                            font.bold: true
                        }

                    }
                }
            }
        }
    }


    /**
    * Method to read JSON file
    * fileType is transcription or tarduction
    **/
    function readFile(openingProject, fileType) {

        let file;
        let jsonPath;
        let currentProject=globalVariable.currentProjectName
        let currentDestLang= globalVariable.currentDestinationLang
        file= fileType === 'transcription' ? "/app_output_stt.json" : `/app_subtitles_${currentDestLang}.json`
        jsonPath=`file:///${currentProjectDirectoryPath}${currentProject}/metadata${file}`
        var xhr = new XMLHttpRequest();
        xhr.open("GET", jsonPath, false);
        xhr.send();

        console.log(jsonPath)
        if (xhr.status === 200) {
            hasError=false
            if(fileType==='transcription'){
                transcriptionData = JSON.parse(xhr.responseText);
                index = 0;
                isProcessing = true;


                if (transcriptionData.length > 0) {

                    for(const transcription of transcriptionData){
                        listViewTranscription.model.append({
                                                               text: transcription.text,
                                                               timeCode: formatSeconds(transcription.time_start)
                                                           });
                    }

                }
            }else{
                translationData = JSON.parse(xhr.responseText);
                if(translationData.length >0 ){
                    index = 0;
                    translationListModel.clear()
                    for(const translation of translationData){
                        listViewTranslation.model.append({
                                                             text: translation.text,
                                                             timeCode: formatSeconds(translation.time_start)
                                                         });
                    }
                }else{
                    console.log('no translation')
                }

            }


        } else {
            hasError=true
        }

    }

    /**
    * Method to format seconds
    **/
    function formatSeconds(seconds) {
        if (isNaN(seconds) || seconds < 0) return "0:00";
        const hrs = Math.floor(seconds / 3600);
        const mins = Math.floor((seconds % 3600) / 60);
        const secs = Math.floor(seconds % 60);
        const formattedMins = hrs > 0 ? String(mins).padStart(2, "0") : mins;
        const formattedSecs = String(secs).padStart(2, "0");
        return hrs > 0 ? `${hrs}:${formattedMins}:${formattedSecs}` : `${formattedMins}:${formattedSecs}`;
    }

    /**
    * Choose language for translation
    **/
    function setLanguage(lang){
        if(globalVariable.currentSourceLang===lang){
            tabBar.currentIndex=0
            return;
        }

        globalVariable.setcurrentDestinationLang(lang)
        currentLanguage=lang
        scriptExec.executeTranslation()
    }

    /**
    * Update
    **/

    function findLanguage(lang){
        if(lang===''){
            return 'Traduire'
        }else{
            const iso= codeIso.codeIso.find(iso=> iso['code']===lang)
            if(iso){
                return `Traduit en ${iso['lang']}`
            }else{
                return ''
            }
        }


    }

    function loadTranslationFromHistory(lang){
        currentLanguage=lang
        globalVariable.setcurrentDestinationLang(lang)
        tabBar.currentIndex=1
        readFile(false, "translation")
    }

}
