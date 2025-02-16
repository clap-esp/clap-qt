import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Controls.Material

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
    Material.theme: Material.Dark


    ColumnLayout{
        id: speechConversionLayout
        anchors.fill: parent
        Header{
                id: header
                z:3
                onTranscriptionEnableEvent: (enable)=>{
                    enableTranscription=enable
                    readJsonFile()
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
                         let sentences = element.words.join(" ");
                         listView.model.append({
                                                text: sentences + " ",
                                                timeCode: formatSeconds(element.start_time)
                                            });
                         listView.currentIndex = listView.count - 1;
                         listView.forceLayout()
                         interval= element.duration * 1000
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
    **/
    function readJsonFile() {
        if(!jsonData.length){
            var jsonPath = Qt.resolvedUrl("../Data/transcription.json");
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
                console.log("Erreur de chargement :", xhr.statusText);
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

    // Rectangle {
    //     id: translationScreen

    //     color: "#242424"
    //     width: parent.width
    //     height: parent.height
    //     anchors.top: parent.top
    //     anchors.left: parent.left
    //     radius: 10

    //     Rectangle {
    //         id: timelineContainer

    //         // x: 8
    //         // y: 8
    //         width: parent.width
    //         height: parent.height
    //         color: "#242424"
    //         radius: 10

}
