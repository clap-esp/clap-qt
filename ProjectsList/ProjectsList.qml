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


    function deleteProject(projectName){
        const list=projectManager.deleteProject(projectName)
        projects=list['projects']
    }



    ColumnLayout{
        anchors.fill: parent
        spacing:2


        ListView {
            id: view
            // currentIndex: indicator.currentIndex
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
                }

                MultiEffect {
                    id: multiEffect
                    source: image
                    maskEnabled: true
                    maskSource: mask
                    width: view.width / 4
                    height: view.height/4*3-20
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
                        radius: 5
                    }
                }



                RowLayout{
                    id: title
                    width: parent.width/2
                    y: mask.height + mask.y +40
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



            }




        }




    }

}
