import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    id: flickable
    width: parent.width
    height: parent.height
    contentHeight: contentColumn.height
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    property string displayMode: "both" // Peut être "transcription", "translation", ou "both"
    property var transcriptionList: []

    Column {
        id: contentColumn
        width: flickable.width - 20
        spacing: 10
        padding: 10

        // Ajouter des paires de blocs de transcription et de traduction
        Repeater {
            model: flickable.transcriptionList
            Column {
                width: parent.width
                spacing: 5
                TranscriptionBlock {
                    width: parent.width
                    height: 100
                    visible: flickable.displayMode === "transcription" || flickable.displayMode === "both"
                    transcriptionText: (modelData && modelData.words) ? modelData.words.join(" ") : ""
                }
                TranslationBlock {
                    width: parent.width
                    height: 100
                    visible: flickable.displayMode === "translation" || flickable.displayMode === "both"
                }
            }
        }
    }

    ScrollBar.vertical: ScrollBar {
        anchors.right: parent.right
        policy: ScrollBar.AlwaysOn
    }
}
