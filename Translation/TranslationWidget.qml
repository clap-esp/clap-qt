import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: parent.width
    height: parent.height

    // L'ancien widget transcription/traduction reste inchangé
    Rectangle {
        id: translationScreen

        color: "#242424"
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.left: parent.left
        radius: 10

        Rectangle {
            id: timelineContainer

            // x: 8
            // y: 8
            width: parent.width
            height: parent.height
            color: "#242424"
            radius: 10
            Column {
                width: parent.width
                height: parent.height
                anchors.fill: parent
                anchors.margins: 10

                Header {
                    id: header
                    width: parent.width
                    height: 50
                    contentArea: contentArea
                }

                ContentArea {
                    id: contentArea
                    width: parent.width
                    height: parent.height - header.height - 20
                    anchors.top: header.bottom
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}
