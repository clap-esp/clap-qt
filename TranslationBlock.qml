import QtQuick 2.15

Rectangle {
    width: parent.width
    height: 100
    color: "#555"

    Text {
        anchors.centerIn: parent
        text: "Bloc de traduction"
        color: "#fff"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Bloc de traduction cliqué")
        }
    }
}
