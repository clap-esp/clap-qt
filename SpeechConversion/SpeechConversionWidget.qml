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
    property bool enableTranslation : false
    property bool enableTranscription: true
    property string textToDisplay: 'wow'
    property var jsonData: []
    property int index: 0
    property bool isProcessing: false
    property int interval: 10000
    property bool stopValue:false
    property string currentLanguage: 'en'
    property var translation: {
        'fr': 'français',
        'en': 'anglais',
        'es': 'espagnol'
    }
    property bool translation_loading:false

    readonly property var constants: Constants { }
    readonly property var errors: Error {}

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
                    color: "#1E1B26"
                }
                TabButton {
                    text: "Sous-titre"
                    font.pixelSize: 14
                    checkable: true
                    width: 100
                    Material.foreground: 'white'
                    background: Rectangle {
                        color: tabBar.currentIndex === 1 ?  "#383149" :  "#3A3245"
                        radius:8

                        Rectangle{
                            y: parent.height/2
                            height: parent.height/2
                            radius: 0
                            width: parent.width
                            color: tabBar.currentIndex === 1 ?  "#383149":  "#3A3245"
                        }
                    }
                }

                TabButton {
                    text: "Traduction"
                    font.pixelSize: 14
                    checkable: true
                    width: 100
                    Material.foreground: 'white'
                    background: Rectangle {
                        color: tabBar.currentIndex === 0 ?  "#383149": "#3A3245"
                        radius:8

                        Rectangle{
                            y: parent.height/2
                            height: parent.height/2
                            radius: 0
                            width: parent.width
                            color: tabBar.currentIndex ===0 ?  "#383149"  :"#3A3245"
                        }
                    }
                }

            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: tabBar.currentIndex
                Rectangle {
                    color: "#383149"
                    radius: 10
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#383149"
                            radius: 10
                            clip: true

                            ListView {
                                         id: listView
                                         anchors.fill: parent
                                         anchors.top: parent.top
                                         anchors.topMargin: 50
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
                    color: "#383149"
                    radius:10
                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 5
                        Row{
                            id:container
                            Layout.fillWidth: true
                            Layout.preferredHeight: 10
                            Layout.leftMargin: 20
                            spacing: parent.width/2

                            Text{
                                color: 'white'
                                text: 'Traduit en '+ translation[currentLanguage]
                                font.pixelSize: 12
                                width:50
                            }

                            Image{
                                id: settings
                                source: '../images/settings.png'
                                width:16
                                height:16
                                anchors.right: parent.right
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
                            Material.background: '#E7DDFF'//
                            Material.foreground: Material.DeepPurple
                            MenuItem {
                                text: "Français";
                                onTriggered: setLanguage("fr");
                                icon.source: '../images/flag/france.png'
                                icon.color: 'transparent'
                            }

                            MenuItem {
                                text: "Anglais";
                                onTriggered: setLanguage("en");
                                icon.source: '../images/flag/england.png'
                                icon.color: 'transparent'}
                            MenuItem {
                                text: "Espagnol";
                                onTriggered: setLanguage("es");
                                icon.source: '../images/flag/spain.png'
                                icon.color: 'transparent'}
                        }

                        Rectangle{
                            Layout.fillWidth:  parent
                            Layout.preferredHeight: 100
                            color: 'transparent'

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

            console.log(jsonPath)
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
                //@TODO ouvrir popup notification error
                notification.openNotification(errors.error_extension_video, NotificationTypeClass.Error)
                console.log("Erreur de chargement :", xhr.status);
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

    function setLanguage(lang){
        currentLanguage=lang
        translation_loading=true
    }
}
