import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7
import QtQuick.Layouts
import '../Utils'
Item {
    id: root
    property var constants: Constants{}
    property string videoSource: ""
    property string iconPlayPause:'../Utils/Icons/pause.png'
    property bool updating: false
    property  bool played:true
    signal managePlayer(bool stop)
    width: parent.width
    height: parent.height-40
    anchors.topMargin: 40
    signal managePlayerEvent(bool played)


    ColumnLayout{
        id: video_container
        width: parent.width
        height: parent.height

        Rectangle {

            Layout.preferredHeight: parent.height -50
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter

            id: background
            color: "transparent"
            radius: 20
            border.width:5
            border.color: constants.panel_background_color //"#1E1B26"
            clip:true
            z: 20



         VideoOutput {
                id: videoOutput
                anchors.margins: 5
                anchors.fill: background
                clip:true
                fillMode: VideoOutput.PreserveAspectCrop
                z:-1


            }

            AudioOutput {
                 id: audioOutput
            }



            MediaPlayer {
                id: mediaPlayer
                source: videoSource
                videoOutput: videoOutput
                audioOutput: audioOutput
                playbackRate: 1.0
                autoPlay: true
                loops: MediaPlayer.Infinite
                onPositionChanged: {
                    // progression.value = position
                }
                onDurationChanged: {
                    // progression.to = duration
                }
            }
        }
        Row{
            Layout.fillWidth: true
            Layout.leftMargin: 20
            height:15
            spacing: parent.width - (duration.width + position.width+40)
            Text{
                id: position
                text: formatSeconds(mediaPlayer.position/1000)
                color: 'white'
            }

            Text{
                id: duration
                text: formatSeconds(mediaPlayer.duration/1000)
                color: 'white'

            }
        }

            RowLayout{
                id: player_buttons
                width: 30
                height:30
                Layout.alignment: Qt.AlignHCenter

                ButtonPlayer{
                    icone: iconPlayPause
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: ()=>{
                            played= !played
                            iconPlayPause= played ?'../Utils/Icons/pause.png': '../Utils/Icons/play.png';
                            if (!played) {mediaPlayer.pause(); } else{ mediaPlayer.play()}
                            managePlayer(!played)

                        }
                    }
                }
            }

            // ColumnLayout{
            //     width: videoOutput.width
            //     anchors.bottom: videoOutput.bottom

                // VideoSlider{
                //     id: progression
                //     Layout.fillWidth: true
                //     onMoved: {
                //         updating= true
                //         mediaPlayer.pause()
                //     }
                //     onPressedChanged: {
                //         if(updating){
                //             mediaPlayer.position=value
                //             mediaPlayer.play()
                //             updating=false
                //         }
                //     }
                // }



            // }

            Component.onCompleted: {
                console.log("MediaPlayer instance created:", mediaPlayer)
            }
        }

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
