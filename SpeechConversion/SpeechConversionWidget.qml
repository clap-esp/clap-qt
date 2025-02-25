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
    anchors.margins: 10
    property bool enableTranslation : false
    property bool enableTranscription: true
    property string textToDisplay: 'wow'
    property var jsonData: []
    property int index: 0
    property bool isProcessing: false
    property int interval: 10000
    property bool stopValue:false

    readonly property var constants: Constants { }
    readonly property var errors: Error {}
    Material.theme: Material.Dark

    NotificationWidget{
        id: notification
    }
    ColumnLayout{
        id: speechConversionLayout
        anchors.fill: parent
        Header{
                id: header
                z:3
                onTranscriptionEnableEvent: (enable)=>{
                    enableTranscription=enable
                    readFile()
                }

                onTranslationEnableEvent: (enable)=>{
                    enableTranslation=enable
                }
            }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 50
            spacing:10
              model: ListModel {}
              z:2
              delegate: Item {
                  height: 100
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
}
