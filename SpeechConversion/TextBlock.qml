import QtQuick 2.15
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: 50
    color: "transparent"
    property string textToDisplay:''
    property string timeCode: ''
    radius: 5
    // anchors.leftMargin:  200


    RowLayout{

        Layout.fillHeight: true
        Layout.fillWidth: true

        Rectangle{
            Layout.leftMargin: 20
            color: "#D593E8"
            width:3
            height: 45
            radius: 10
        }

        Text{
            text: timeCode
            color: "#fff"
            padding: 10
            font.pixelSize: 12
        }

        Text {
            topPadding: 0
            text: textToDisplay
            color: "#fff"
            font.pixelSize: 15
            wrapMode: Text.Wrap
            width: parent.width - 100
            horizontalAlignment: Qt.AlignLeft
        }
    }




    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            console.log("Bloc de transcription cliqué")
        }
    }
}
