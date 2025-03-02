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
                color: constants.default_widget_background_color//'#383149'
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


                // Rectangle{
                //     radius:35
                //     width:150
                //     height: 30
                //     color: 'white'
                //     anchors.topMargin: 20
                //     anchors.bottomMargin: 20
                //     anchors.right: parent.right


                //     Row{
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         anchors.verticalCenter: parent.verticalCenter
                //         spacing: 10

                //         Image{
                //             source: '../images/exportation.png'
                //             width:16
                //             height: 16
                //             anchors.leftMargin: 20
                //         }

                //         Text{
                //             text: 'Exporter'

                //         }
                //     }


                //     MouseArea{
                //         anchors.fill: parent
                //         cursorShape: Qt.PointingHandCursor
                //     }



                // }

                VideoWidget{
                    id: video_widget
                    anchors.top:video_container.top
                    videoSource: root.videoSourcePath
                    onManagePlayer: (value)=>{
                                        translation_widget.stopValue=value
                                    }

                }
            }


        }

        Rectangle {
            color: constants.default_widget_background_color
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius:10
            // VideoTimeline{}
        }
    }
}

