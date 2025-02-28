import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material
import "../Notification"
import '../Utils/Notification'
import '../Utils'
import notification.type 1.0

Item {
    anchors.fill: parent
    property bool hasError: false
    property bool enableTranslation : false
    property bool enableTranscription: true
    property string textToDisplay: 'wow'
    property var jsonData: []
    property int index: 0
    property bool isProcessing: false
    property int interval: 10000
    property bool stopValue:false
    property string currentLanguage: 'en'
    property bool translation_loading:false

    readonly property var constants: Constants { }
    readonly property var errors: Error {}
    readonly property var codeIso: IsoLanguageCode { }

    NotificationWidget{
        id: notification
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
                        color: tabBar.currentIndex === 1 ? constants.default_widget_background_color : constants.default_widget_background_color
                        radius:8

                        Rectangle{
                            y: parent.height/2
                            height: parent.height/2
                            radius: 0
                            width: parent.width
                            color: tabBar.currentIndex === 1 ? constants.default_widget_background_color : constants.default_widget_background_color
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
                        color: tabBar.currentIndex === 0 ? constants.default_widget_background_color : constants.default_widget_background_color
                        radius:8

                        Rectangle{
                            y: parent.height/2
                            height: parent.height/2
                            radius: 0
                            width: parent.width
                            color: tabBar.currentIndex === 0 ? constants.default_widget_background_color: constants.default_widget_background_color
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
                                         id: listView
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
                                                   id: textBlock
                                                   textToDisplay: model.text
                                                   timeCode: model.timeCode
                                               }
                                           }

                                           ScrollBar.vertical: ScrollBar {
                                               anchors.right: parent.right
                                               policy: listView.contentHeight > listView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                                               active: hovered || pressed
                                               contentItem: Rectangle {
                                                          color: "white"
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
                                source: '../images/settings.png'
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
                            Material.background: constants.default_widget_background_color //'#E7DDFF'//
                            Material.foreground: 'white' //Material.DeepPurple


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
                            Layout.fillWidth:  parent
                            Layout.preferredHeight: 100
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
                     if (index < jsonData.length) {
                         if(!stopValue){
                             let element = jsonData[index];
                             listView.model.append({
                                                    text: element.text,
                                                    timeCode: formatSeconds(element.time_start)
                                                });
                             listView.currentIndex = listView.count - 1;
                             listView.forceLayout()
                             interval= (element.time_end - element.time_start) * 1000
                             index++;

                        }
                          processTimer.start();
                     } else {
                         console.log("done !");
                         isProcessing = false;
                     }
                 }
             }


    /**
    * Method to display correct test in TextBlockWidget
    **/
    function displayText(){
        if(enableTranscription && enableTranslation){
            text.textToDisplay='Bloc de traduction'

        }else if(enableTranscription){
            text.textToDisplay='Bloc de transcription'

        }else if(enableTranslation){
            text.textToDisplay='Bloc de traduction'
        }else{
            text.textToDisplay='Bloc'

        }
    }


    /**
    * Method to read JSON file
    * fileType is transcription or tarduction
    **/
    function readFile(fileType) {
        if(!jsonData.length){
            let file= fileType === 'transcription' ? "/app_stt_output.json" : '/app_subtitle_fr.srt'
            const jsonPath= 'file:///'+dataDirectoryPath+file
            var xhr = new XMLHttpRequest();
            xhr.open("GET", jsonPath, false);
            xhr.send();

            if (xhr.status === 200) {
                jsonData = JSON.parse(xhr.responseText);
                index = 0;
                isProcessing = true;
                if (jsonData.length > 0) {
                     processTimer.start();
                }
            } else {
                notification.openNotification(errors.error_extension_video, NotificationTypeClass.Error)
            }
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
        translation_loading=true
    }

    /**
    * Update
    **/

    function findLanguage(lang){
       const iso= codeIso.codeIso.find(iso=> iso['code']===lang)
        if(iso){
            return `Traduit en ${iso['lang']}`
        }else{
            return ''
        }
    }

}
