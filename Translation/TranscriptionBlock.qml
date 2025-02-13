import QtQuick 2.15

Rectangle {
    id: root
    width: parent.width
    height: 100
    color: "#444"

    property string transcriptionText: ""

    Text {
        anchors.centerIn: parent
        text: root.transcriptionText
        color: "#fff"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Bloc de transcription cliqué")
        }
    }
}
