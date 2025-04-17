import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import '../Utils'
RowLayout{

    readonly property  var constants: Constants{}
    readonly property var derushLegend: DerushClassLegend{}
    Layout.fillWidth: true
    Layout.preferredHeight: 50
    Layout.margins:10
    spacing:20

    ToolButton {
        id: info
        icon.source: '../images/info.png'
        icon.height: 16
        icon.color: 'white'
        icon.width: 16

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:{
                popup.open()
            }
        }
    }

    Rectangle{
        id: derushBtn
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
        id: exportBtn

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


    Switch {
        id: control
        text: control.checked ? qsTr("Désactiver le découpage") : qsTr("Activer le découpage")
        indicator: Rectangle {
            implicitWidth: 48
            implicitHeight: 26
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: 13
            color: control.checked ? "#D4B5FF" : "#F3E8FF"
            border.color: control.checked ? "#A56EFF" : "#C2A2D8"

            Rectangle {
                x: control.checked ? parent.width - width : 0
                width: 26
                height: 26
                radius: 13
                color: control.down ? "#B385FF" : "#FFFFFF"
                border.color: control.checked ? (control.down ? "#8F5BFF" : "#A56EFF") : "#BFA6D8"
            }
        }

        contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.5
            color: control.down ? "#8F5BFF" : "#A56EFF"
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
    }

    Popup {
        id: popup
        x: info.x +20
        y: info.y- height
        width: 200
        height: 300
        modal: false
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        Material.background: constants.panel_background_color
        Material.foreground: Material.DeepPurple
        Material.accent: Material.DeepPurple

        ColumnLayout{
            anchors.fill: parent
            spacing: 10

            Repeater{
                model: derushLegend.value
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout{
                    required property var modelData
                    height: 20
                    spacing: 15

                    Rectangle{
                        radius:10
                        width:10
                        height: 10
                        color: modelData.color
                    }

                    Text{
                        text: modelData.text
                        color: "white"
                    }
                }

            }
        }
    }
}
