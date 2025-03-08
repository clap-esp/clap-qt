import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Dialog {
    id: projectDialog
    parent: root
    standardButtons: Dialog.Ok | Dialog.Cancel
    anchors.centerIn: parent
    modal: true
    dim: true
    visible: false
    width: parent.width / 3
    height: parent.height / 5 +50
    closePolicy: Popup.NoAutoClose
    Material.background: constants.panel_background_color
    Material.foreground: Material.DeepPurple
    Material.accent: Material.DeepPurple
    property string projectTitle: ''

    Text{
        text: "Êtes-vous sûr de vouloir supprimer le projet "+ projectTitle+ "?"
        color:'white'
        anchors.horizontalCenter : parent.horizontalCenter
        font.pixelSize: 20
        horizontalAlignment: Text.AlignJustify
    }

    Text{
        text: "Attention, cette action est irréversible !"
        color:'white'
        font.italic: true
        anchors.centerIn: parent
        font.pixelSize: 15
        horizontalAlignment: Text.AlignJustify
    }
}
