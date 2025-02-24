import QtQuick 2.15

Rectangle {
    width: parent.width
    height: 50
    color: "transparent"
    property string textToDisplay:''
    property string timeCode: ''
    radius: 5
    anchors.leftMargin:  50
    anchors.rightMargin:  50

    Row{
        width: parent.width
        height: parent.height
        // leftPadding: 15
        // rightPadding: 30
        Text{
            text: timeCode
            color: "#fff"
            padding: 10
            font.pixelSize: 12
        }

        Text {
            topPadding: 8
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
