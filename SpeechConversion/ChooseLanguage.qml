import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Controls.Material

ComboBox {
    id: comboBox
    width: parent.width/2
    height: 40
    editable: true
    model: ListModel {
        id: model
        ListElement { text: "Français"; iconSource: "../images/flag/france.png" }
        ListElement { text: "Anglais"; iconSource: "../images/flag/england.png" }
        ListElement { text: "Espagnol"; iconSource: "../images/flag/spain.png" }
        ListElement { text: "Allemand"; iconSource: "../images/flag/german.png" }
        ListElement { text: "Japonais"; iconSource: "../images/flag/japan.png" }
    }
    background: Rectangle {
               color: "transparent"
               border.width: 1
               border.color: '#CECECE'
               radius:10
            }

    delegate: ItemDelegate {
                width: comboBox.width/2
                onClicked: comboBox.currentIndex = index
                contentItem: Row {
                    spacing:20
                    Image {
                        source: model.iconSource
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: model.text
                        font.pixelSize: 14
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                background: Rectangle {
                           color: "#363242"
                          }
            }

    contentItem: Row {
                spacing: 20
                padding:10
                width: comboBox.width/2
                Image {
                    source: comboBox.currentIndex !== -1 ? comboBox.model.get(comboBox.currentIndex).iconSource : ""
                    width: 20
                    height: 20
                    fillMode: Image.PreserveAspectFit
                    visible: source !== ""
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: comboBox.model.get(comboBox.currentIndex).text
                    color: "white"
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter

                }
            }


    popup: Popup {
        id: popup
        y: comboBox.height
        width: comboBox.width
        padding:10
        implicitHeight: contentItem.implicitHeight
        background: Rectangle {
            color: "#4D4662"
            border.width: 0
            radius:10
            MultiEffect {
                           anchors.fill: parent
                           source: parent
                           shadowEnabled: true
                           shadowBlur: 0.5
                           shadowColor: "#80000000"
                           shadowHorizontalOffset: -3
                           shadowVerticalOffset: -3

                       }
        }



        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: comboBox.model
            delegate: ItemDelegate {
                width: comboBox.width-10
                onClicked: comboBox.currentIndex = index
                contentItem: Row {
                    spacing: 10
                    Image {
                        source: model.iconSource
                        width: 20
                        height: 20
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: model.text
                        font.pixelSize: 14
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                background: Rectangle {
                    color: "#4D4662"
                    border.width: 0
                }
            }
        }
    }

    onAccepted: {
        if (find(editText) === -1)
            model.append({text: editText})
    }

}
