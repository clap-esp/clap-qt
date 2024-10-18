import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Transcription, Traduction & Bande de Visualisation"

    // L'ancien widget transcription/traduction reste inchangé
    Rectangle {
        width: parent.width / 2
        height: parent.height / 2
        color: "#333"
        anchors.top: parent.top
        anchors.left: parent.left
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

    // Nouvelle zone pour la bande de visualisation vidéo qui occupe toute la moitié basse
    VideoTimeline {
        id: videoTimeline
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height / 2 // Prend la moitié inférieure de la page
    }
}
