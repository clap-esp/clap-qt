import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Elements"

Row {
    width: parent.width
    height: 50
    spacing: 10
    padding: 5

    property ContentArea contentArea // Déclare la propriété ContentArea

    ButtonCustom {
        id: transcriptionButton
        text: "Transcription"
        width: parent.width / 3 - 10
        height: 40

        onClicked: {
            if (contentArea) {
                contentArea.displayMode = "transcription"; // Affiche transcription
            }
        }
    }

    Button {
        id: translationButton
        text: "Traduction"
        width: parent.width / 3 - 10
        height: 40
        background: Rectangle {
            color: translationButton.down ? "#555" : "#333"
            radius: 10
            border.color: "#888"
            border.width: 2
        }

        onClicked: {
            if (contentArea) {
                contentArea.displayMode = "translation"; // Affiche traduction
            }
        }
    }

    Button {
        id: bothButton
        text: qsTr("Les deux")
        width: parent.width / 3 - 10
        height: 40
        background: Rectangle {
            color: bothButton.down ? "#555" : "#333"
            radius: 10
            border.color: "#888"
            border.width: 2
        }

        onClicked: {
            if (contentArea) {
                contentArea.displayMode = "both"; // Affiche les deux
            }
        }
    }
}
