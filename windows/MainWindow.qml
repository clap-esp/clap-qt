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
    property bool hasTranscriptionError: false
    readonly property var constants: Constants{}
    Layout.fillWidth: true
    Layout.fillHeight: true


    ColumnLayout {
        Layout.margins: 10
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 15

        RowLayout{
            height:2.5
            Layout.leftMargin:  15
            Layout.rightMargin: 15
            spacing: 15
            Rectangle{
                color: constants.default_widget_background_color
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius:10

                SpeechConversionWidget {
                    id: translation_widget
                    hasError: hasTranscriptionError
                    Component.onCompleted: {
                        translation_widget.readFile('transcription')
                    }
                }

            }

            Rectangle{
                id: video_container
                color: 'transparent'
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius:10


                VideoWidget{
                    id: video_widget
                    anchors.top:video_container.top
                    videoSource: root.videoSourcePath

                }
            }


        }

        Rectangle {
            color: constants.default_widget_background_color
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

