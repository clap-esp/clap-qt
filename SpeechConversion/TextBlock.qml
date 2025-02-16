import QtQuick 2.15

Rectangle {
    width: parent.width
    height: 100
    color: "#555"
    property string textToDisplay:''
    property string timeCode: ''
    radius: 5

    Text{
        text: timeCode
        color: "#fff"
        padding: 10
        font.pixelSize: 12
    }

    Text {
        anchors.centerIn: parent
        text: textToDisplay
        color: "#fff"
        font.pixelSize: 20
        wrapMode: Text.Wrap
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
    }


    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            console.log("Bloc de transcription cliqué")
        }
    }
}
