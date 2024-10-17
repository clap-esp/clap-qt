import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Transcription & Traduction"

    Rectangle {
        width: 400
        height: 500
        color: "#333"
        anchors.centerIn: parent
        radius: 10

        Column {
            width: parent.width
            height: parent.height
            anchors.fill: parent
            anchors.margins: 10

            // Header avec boutons
            Header {
                id: header
                width: parent.width
                height: 50
                contentArea: contentArea // Assurez-vous que ceci est présent
            }

            // Zone de contenu avec blocs de transcription et traduction
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
