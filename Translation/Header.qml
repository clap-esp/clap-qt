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
        text: qsTr("Transcription")
        width: parent.width / 3 - 10
        height: 40

        normalColor: "#878787"
        hoverColor: "#767676"
        pressedColor: "#484848"

        onButtonClicked: {
            if (contentArea) {
                contentArea.displayMode = "transcription"; // Affiche transcription
            }
        }
    }

    ButtonCustom {
        id: translationButton
        text: qsTr("Traduction")
        width: parent.width / 3 - 10
        height: 40

        normalColor: "#878787"
        hoverColor: "#767676"
        pressedColor: "#484848"

        onButtonClicked: {
            if (contentArea) {
                contentArea.displayMode = "translation"; // Affiche traduction
            }
        }
    }

    ButtonCustom {
        id: bothButton
        text: qsTr("Les deux")
        width: parent.width / 3 - 10
        height: 40

        normalColor: "#878787"
        hoverColor: "#767676"
        pressedColor: "#484848"

        onButtonClicked: {
            if (contentArea) {
                contentArea.displayMode = "both"; // Affiche les deux
            }
        }
    }
}
