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
    height: parent.height / 5
    closePolicy: Popup.NoAutoClose
    Material.background: constants.panel_background_color
    Material.foreground: Material.DeepPurple
    Material.accent: Material.DeepPurple
    property string projectTitle: ''

    Text{
        id: title

        text: "Êtes-vous sûr de vouloir supprimer le projet "+ projectTitle+ "?"
        color:'white'
        width: parent.width -20
        height: 50
        wrapMode: Text.Wrap
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter:  parent.verticalCenter
        font.pixelSize: 17
        horizontalAlignment: Text.AlignJustify
    }


}
