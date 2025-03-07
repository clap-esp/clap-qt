import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7
import QtQuick.Layouts

Item {
    id: root
    property string videoSource: ""
    property string iconPlayPause:'../Utils/Icons/pause.png'
    property bool updating: false
    property  bool played:true
    property alias mediaPlayer: mediaPlayer
    signal managePlayer(bool stop)
    width: parent.width
    height: parent.height
    signal managePlayerEvent(bool played)

    ColumnLayout{
        id: video_container
        width: parent.width
        height: parent.height

        Rectangle{

            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
            color: 'transparent'


            Item {
                id: video_player


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

                    VideoSlider{
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

                        ButtonPlayer{
                            icone: '../Utils/Icons/rewind.png'
                            MouseArea {
                                cursorShape: Qt.PointingHandCursor
                                anchors.fill: parent
                                onClicked: ()=>{
                                }
                            }
                        }
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

                        ButtonPlayer{
                            icone: '../Utils/Icons/fast-forward.png'
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
        }
    }

}
