import QtQuick 2.15

Rectangle {
    width: parent.width
    height: 100
    color: "#444"

    Text {
        anchors.centerIn: parent
        text: "Bloc de transcription"
        color: "#fff"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Bloc de transcription cliqué")
        }
    }
}
