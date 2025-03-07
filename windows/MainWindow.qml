import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "../SpeechConversion"
import "../Video"
import "../Utils"
import "../Timeline"

RowLayout{
    id: root
    property string videoSourcePath: ""
    readonly property var constants: Constants{}
    Layout.fillWidth: true
    Layout.fillHeight: true


    ColumnLayout {
        Layout.margins: 10
        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout{

            height:3
            Rectangle{
                color: "#383149"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius:10

                SpeechConversionWidget {
                    id: translation_widget
                    Component.onCompleted: {
                        translation_widget.readFile('transcription')
                    }
                }

            }

            Rectangle{
                color: "#383149"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius:10


                VideoWidget{
                    id: video_widget
                    videoSource: root.videoSourcePath

                }
            }


        }

        Rectangle {
            color: "#383149"
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius:10
            TimelineView {
                id: timeline_widget
                videoPlayer: video_widget.mediaPlayer
            }
        }
    }
}

