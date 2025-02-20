import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.5
import QtQuick.Layouts

Item {
    id: root
    property string videoSource: "file:///C:/Users/hadja/Videos/product_management.mp4"
    property string iconPlayPause:'../../Utils/Icons/pause.png'
    property bool updating: false
    property  bool played:true
    signal managePlayer(bool stop)

    anchors.fill: parent

    VideoOutput {
        id: videoOutput
        anchors.fill: parent

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
        onPositionChanged: {
            progression.value = position
        }

        onDurationChanged: {
            progression.to = duration
         }
    }

    ColumnLayout{
        width: videoOutput.width
        anchors.bottom: videoOutput.bottom
        VideoSliderWidget{
            id: progression
            Layout.fillWidth: true
            onMoved: {
                updating= true
                mediaPlayer.pause()
            }
            onPressedChanged: {
                if(updating){
                    mediaPlayer.position=value
                    mediaPlayer.play()
                    updating=false
                }
            }
        }


        RowLayout{
            id: player_buttons
            width: 30
            height:30
            Layout.alignment: Qt.AlignHCenter

            ButtonPlayerWidget{
                icone: '../../Utils/Icons/rewind.png'
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: ()=>{
                    }
                }
            }
            ButtonPlayerWidget{
                icone: iconPlayPause
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: ()=>{
                        played= !played
                        iconPlayPause= played ?'../../Utils/Icons/pause.png': '../../Utils/Icons/play.png';
                        if (!played) {mediaPlayer.pause(); } else{ mediaPlayer.play()}
                        managePlayer(!played)

                    }
                }
            }

            ButtonPlayerWidget{
                icone: '../../Utils/Icons/fast-forward.png'
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: ()=>{
                    }
                }
            }
        }
    }



    Component.onCompleted: {
        console.log("MediaPlayer instance created:", mediaPlayer)
    }
}
