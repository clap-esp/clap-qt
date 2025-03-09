import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material
import '../Utils'
Item{
    width: parent.width
    height: parent.height
    anchors.top: parent.bottom
    property var constants: Constants{}
    property var projects: []
    signal openingProject(var selected_project)


    function deleteProject(projectName){
        const list=projectManager.deleteProject(projectName)
        projects=list['projects']
    }



    ColumnLayout{
        anchors.fill: parent
        spacing:2


        ListView {
            id: view
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height
            Layout.topMargin: 30
            clip: true
            orientation: ListView.Horizontal
            spacing:10
            model: projects

            delegate: Rectangle {
                required property var modelData
                clip: true
                width: view.width / 3
                height: view.height
                layer.enabled: true
                color: 'transparent'

                SuppressConfirmation{
                    id: confirmSuppr
                    onAccepted: deleteProject(modelData.name)
                }

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: openingProject(modelData)
                }

                MultiEffect {
                    id: multiEffect
                    source: image
                    maskEnabled: true
                    maskSource: mask
                    width: view.width / 4
                    height: view.height/2
                }

                Image {
                    id: image
                    width: parent.width/2
                    height: parent.height/2
                    source: "file:///" + modelData.thumbnail_project
                    visible: false
                }

                Item {
                    id: mask
                    anchors.fill: image
                    layer.enabled: true
                    visible: false
                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                    }
                }

                RowLayout{
                    id: title
                    width: parent.width/2
                    y: mask.height + mask.y-5
                    spacing: projectTitle.width/2

                    Text {
                        id: projectTitle
                        Layout.preferredWidth:  parent.width -16
                        color: 'white'
                        text: modelData.name.toUpperCase()
                        Layout.alignment: Qt.AlignLeft
                        font.bold:true
                    }

                    ToolButton {
                        id: menuIcon
                        z:22
                        icon.source: '../images/dots.png'
                        icon.height: 16
                        icon.color: 'white'
                        icon.width: 16
                        onClicked: contextMenu.open()
                        Layout.alignment: Qt.AlignRight

                    }

                    Menu {
                        id: contextMenu
                        Material.theme: Material.Dark
                        Material.background: constants.default_widget_background_color
                        Material.foreground: 'white'
                        x: menuIcon.x +40


                        MenuItem {
                            text: "Supprimer"
                            height: 25
                            onTriggered:{
                                confirmSuppr.projectTitle=modelData.name
                                confirmSuppr.open()
                            }

                        }

                    }


                }

                Text {
                    id: projectSubtitle
                    y: title.y +35
                    Layout.preferredWidth:  parent.width /2
                    color: 'white'
                    text: getDate(modelData.updated_at)
                    Layout.alignment: Qt.AlignLeft
                    font.italic: true
                    font.pixelSize: 10
                    wrapMode: Text.Wrap
                }

            }




        }




    }

    function getDate(date){
        const d=(new Date(date))

        const mois = ["janvier", "février", "mars", "avril", "mai", "juin",
                      "juillet", "août", "septembre", "octobre", "novembre", "décembre"];
        const jour = d.getDate();
        const moisNom = mois[d.getMonth()];
        const annee = d.getFullYear();
        const dateFormatee = `${jour} ${moisNom} ${annee}`;

        const hours= d.getHours();
        const min= d.getMinutes();
        const time=`${hours}h${min}`
        return `Mis à jour le ${dateFormatee} à ${time}`
    }

}
