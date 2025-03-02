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
                                         anchors.topMargin: 50
                                         visible: !hasError
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
                                         anchors.topMargin: 25
                                         visible: !translation_loading
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
            }
        }

    Timer {
                 id: processTimer
                 interval: interval
                 repeat: false
                 onTriggered: {
                     if (index < transcriptionData.length || index < translationData.length) {
                         if(!stopValue){
                             let element = transcriptionData[index];
                             // listViewTranscription.model.append({
                             //                        text: element.text,
                             //                        timeCode: formatSeconds(element.time_start)
                             //                    });
                             // listViewTranscription.currentIndex = listViewTranscription.count - 1;
                             // listViewTranscription.forceLayout()
                             // interval= (element.time_end - element.time_start) * 1000
                             // index++;

                        }
                          processTimer.start();
                     }

                     if(index < translationData.length){
                         if(!stopValue){
                             let element = translationData[index];
                             // listViewTranslation.model.append({
                             //                        text: element.text,
                             //                        timeCode: formatSeconds(element.time_start)
                             //                    });
                             // listViewTranslation.currentIndex = listViewTranslation.count - 1;
                             // 0listViewTranslation.forceLayout()
                             // interval= (element.time_end - element.time_start) * 1000
                             // index++;

                        }
                          processTimer.start();
                     }
                 }
             }


    /**
    * Method to read JSON file
    * fileType is transcription or tarduction
    **/
    function readFile(fileType) {

        let file= fileType === 'transcription' ? "/app_output_stt.json" : `/app_subtitles_${currentLanguage}.json`
        const jsonPath= 'file:///'+dataDirectoryPath+file
        var xhr = new XMLHttpRequest();
        xhr.open("GET", jsonPath, false);
        xhr.send();

        if (xhr.status === 200) {
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

                     processTimer.start();
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

                processTimer.start();
            }


        } else {
            hasError=true
            // notification.openNotification(errors.error_extension_video, NotificationTypeClass.Error)
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
        currentLanguage=lang
        // console.log("current_language")
        scriptExec.executeTranslation(lang)
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

}
