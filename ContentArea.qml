import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    id: flickable
    width: parent.width
    height: parent.height
    contentHeight: contentColumn.height
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    property bool showTranscriptionBlocks: true // Contrôle l'affichage

    Column {
        id: contentColumn
        width: flickable.width - 20
        spacing: 10
        padding: 10

        // Ajouter des paires de blocs de transcription et de traduction
        Repeater {
            model: 5
            Column {
                width: parent.width
                spacing: 5
                TranscriptionBlock {
                    width: parent.width
                    height: 100
                    visible: flickable.showTranscriptionBlocks // Afficher si la propriété est vraie
                }
                TranslationBlock {
                    width: parent.width
                    height: 100
                    visible: !flickable.showTranscriptionBlocks // Afficher si la propriété est fausse
                }
            }
        }
    }

    ScrollBar.vertical: ScrollBar {
        anchors.right: parent.right
        policy: ScrollBar.AlwaysOn
    }
}
