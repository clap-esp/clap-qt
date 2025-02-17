import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "../SpeechConversion"
import "../Video"
import "../Utils"

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

            height:2
            Rectangle{
                color:constants.background_color
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
                color: constants.background_color
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
            color: constants.default_widget_background_color
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius:10
            VideoTimeline{}
        }
    }
}

