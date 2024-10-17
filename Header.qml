import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    width: parent.width
    height: 50
    spacing: 10
    padding: 5

    property ContentArea contentArea // Déclare la propriété ContentArea

    Button {
        id: transcriptionButton
        text: "Transcription"
        width: parent.width / 2 - 10
        height: 40
        background: Rectangle {
            color: transcriptionButton.down ? "#555" : "#333"
            radius: 10
            border.color: "#888"
            border.width: 2
        }

        onClicked: {
            if (contentArea) {
                contentArea.showTranscriptionBlocks = true; // Afficher transcription
            }
        }
    }

    Button {
        id: translationButton
        text: "Traduction"
        width: parent.width / 2 - 10
        height: 40
        background: Rectangle {
            color: translationButton.down ? "#555" : "#333"
            radius: 10
            border.color: "#888"
            border.width: 2
        }

        onClicked: {
            if (contentArea) {
                contentArea.showTranscriptionBlocks = false; // Afficher traduction
            }
        }
    }
}
