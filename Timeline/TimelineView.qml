import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "../Utils"

Item {
    id: timelineView

    property var derushColor: DerushClassColor{}
    property MediaPlayer videoPlayer
    property bool sliderPressed: false
    property var derushData: []

    anchors.fill: parent

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 10


        RowLayout{
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Layout.margins:10
            spacing:20

            Rectangle{
                radius:35
                width:150
                height: 30
                color: 'white'

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Image{
                        source: '../images/wand.png'
                        width:16
                        height: 16
                        anchors.leftMargin: 20
                    }

                    Text{
                        text: 'Dérush'

                    }
                }


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }



            }


            Rectangle{
                radius:35
                width:150
                height: 30
                color: 'white'
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Image{
                        source: '../images/exportation.png'
                        width:16
                        height: 16
                        anchors.leftMargin: 20
                    }

                    Text{
                        text: 'Exporter'

                    }
                }


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }



            }
        }

        Rectangle {
            id: timeline
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            color: "#716A80"
            radius: 5
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin:  10
            Layout.rightMargin:  10
            Layout.topMargin: 10

            ListModel {
                id: listModel
            }

            Repeater{
                id: derushedZone
                model:listModel
                Rectangle {
                    required property var modelData
                    width: (modelData.duration *1000/ videoPlayer.duration) * (timeline.width - playhead.width)
                    height: 10
                    color: modelData.color
                    x: (modelData.start_time *1000/ videoPlayer.duration) * (timeline.width - playhead.width)

                }


            }

            Rectangle {
                id: playhead
                width: 3
                height: parent.height
                color: "#CC6CE7" //"#6883A5"
                x: (videoPlayer && videoPlayer.duration > 0) ?
                       (videoPlayer.position / videoPlayer.duration) * (timeline.width - playhead.width) : 0
                Behavior on x {
                    NumberAnimation { duration: 100; easing.type: Easing.Linear }
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: sliderPressed = true
                onReleased: sliderPressed = false
                onClicked: function(mouse) {
                    if (videoPlayer && videoPlayer.duration > 0) {
                        let newTime = (mouse.x / (timeline.width - playhead.width)) * videoPlayer.duration;
                        videoPlayer.position = newTime;
                        playhead.x = mouse.x;
                    }
                }
            }
        }

        ScrollableTimeline {
            id: scrollableTimeline
            Component.onCompleted: {
                scrollableTimeline.externalVideoPlayer = videoPlayer;
                if (videoPlayer) {
                    addVideoClip(videoPlayer);
                }
            }
        }
    }

    Connections {
        target: videoPlayer
        function onPositionChanged() {
            if (!sliderPressed) {
                let progress = videoPlayer.position / videoPlayer.duration;
                let newX = progress * (timeline.width - playhead.width);
                playhead.x = newX;
            }
        }
    }

    function addVideoClip(player) {
        scrollableTimeline.addClip(player);
    }

    Component.onCompleted: {
        readFile();
    }

    function readFile() {
        let file = globalVariable.currentProjectName+ "/metadata/app_derush.json"
        const jsonPath= 'file:///'+currentProjectDirectoryPath+file
        var xhr = new XMLHttpRequest();
        xhr.open("GET", jsonPath, false);
        xhr.send();

        if (xhr.status === 200) {
            const data=JSON.parse(xhr.responseText);
            for(const elemn of data){
                if(elemn.event !== "O"){
                    switch(elemn.event) {
                    case "STU":
                        elemn.color = derushColor._STU;
                        break;
                    case "FIL":
                        elemn.color = derushColor._FIL;
                        break;
                    case "REP":
                        elemn.color = derushColor._REP;
                        break;
                    case "RED":
                        elemn.color = derushColor._RED;
                        break;
                    case "NOI":
                        elemn.color = derushColor._NOI;
                        break;
                    case "INT":
                        elemn.color = derushColor._INT;
                        break;
                    case "BRE":
                        elemn.color = derushColor._BRE;
                        break;
                    case "CLI":
                        elemn.color = derushColor._CLI;
                        break;
                    case "SIL":
                        elemn.color = derushColor._SIL;
                        break;
                    default:
                        elemn.color = "transparent";
                    }


                    listModel.append(elemn)
                }
            }

            console.log(listModel.count)

        }
    }

}
