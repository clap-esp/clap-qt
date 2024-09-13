import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: settingsDialog
    title: qsTr("Paramétrages")
    modal: true
    standardButtons: Dialog.StandardButton.None
    width: 800
    height: 600
    background: Rectangle {
            color: "#262525"
        }


    property string selectedMenuItem: "Paramétrage Fenêtre"

    MouseArea {
            id: moveArea
            anchors.fill: parent
            drag.target: settingsDialog
            cursorShape: Qt.OpenHandCursor
        }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            height: 500
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ScrollView {
                background: Rectangle {
                        color: "#262525"

                    }
                width: 200
                Layout.fillHeight: true

                ListView {
                    width: parent.width
                    height: parent.height
                    model: ListModel {
                        ListElement { name: "Sous-titrage" }
                        ListElement { name: "Langue et traduction" }
                        ListElement { name: "Option de sauvegarde" }
                        ListElement { name: "Paramétrage Fenêtre" }
                    }

                    delegate: ItemDelegate {
                        background: Rectangle {
                                color: "#262525"
                            }
                        text: model.name
                        width: parent.width
                        onClicked: {
                            selectedMenuItem = model.name;
                        }
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "white"
                opacity: 0.2
            }

            ScrollView {
                // background: Rectangle {
                //         color: "#262525"  // Définit la couleur de fond du bouton
                //     }
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    ColumnLayout {
                        visible: selectedMenuItem === "Paramétrage Fenêtre"
                        spacing: 20

                        Label {
                            color: "white"
                            text: qsTr("Paramétrage de la fenêtre")
                            font.pixelSize: 20
                        }

                        RowLayout {
                            Label {
                                color: "white"
                                text: qsTr("Thème")
                                Layout.alignment: Qt.AlignLeft
                            }
                            ComboBox {
                                Layout.fillWidth: true
                                model: ["Dark", "Light"]
                            }
                        }

                        RowLayout {
                            Label {
                                color: "white"
                                text: qsTr("Zoom")
                                Layout.alignment: Qt.AlignLeft
                            }
                            TextField {
                                Layout.fillWidth: true
                                text: "100%"
                            }
                        }

                        RowLayout {
                            Label {
                                color: "white"
                                text: qsTr("Police")
                                Layout.alignment: Qt.AlignLeft
                            }
                            ComboBox {
                                id: fontSelector
                                Layout.fillWidth: true
                                model: ["Dongle", "Roboto", "Arial", "Times New Roman"]
                                enabled: false
                            }
                        }

                        RowLayout {
                            Label {
                                color: "white"
                                text: qsTr("Taille de police")
                                Layout.alignment: Qt.AlignLeft
                            }
                            SpinBox {
                                id: fontSizeSelector
                                Layout.fillWidth: true
                                from: 8
                                to: 32
                                value: 13
                                enabled: false
                            }
                        }

                        // CheckBox {
                        //     text: qsTr("Modifier la police")
                        //     onCheckedChanged: {
                        //         fontSelector.enabled = checked;
                        //         fontSizeSelector.enabled = checked;
                        //     }
                        // }
                        CheckBox {
                            text: qsTr("Modifier la police")
                            font.pointSize: 12
                            palette.text: "white"
                            onCheckedChanged: {
                                fontSelector.enabled = checked;
                                fontSizeSelector.enabled = checked;
                            }
                        }

                    }

                    // Affichage conditionné pour Sous-titrage
                    ColumnLayout {
                        visible: selectedMenuItem === "Sous-titrage"
                        spacing: 20

                        Label {
                            color: "white"
                            text: qsTr("Paramétrages de Sous-titrage")
                            font.pixelSize: 20
                        }

                        CheckBox {
                            text: qsTr("Activer les sous-titres")
                            palette.text: "white"
                            icon.color : "white"
                        }
                    }

                    // Affichage conditionné pour Langue et traduction
                    ColumnLayout {
                        visible: selectedMenuItem === "Langue et traduction"
                        spacing: 20

                        Label {
                            color: "white"
                            text: qsTr("Paramétrages de Langue et Traduction")
                            font.pixelSize: 20
                        }

                        ComboBox {
                            Layout.fillWidth: true
                            model: ["Français", "Anglais", "Espagnol", "Allemand"]
                        }
                    }

                    // Affichage conditionné pour Option de sauvegarde
                    ColumnLayout {
                        visible: selectedMenuItem === "Option de sauvegarde"
                        spacing: 20

                        Label {
                            color: "white"
                            text: qsTr("Options de sauvegarde")
                            font.pixelSize: 20
                        }

                        CheckBox {
                            text: qsTr("Sauvegarde automatique")
                        }
                    }
                }
            }
        }

        RowLayout {
            height: 500
            // Layout.fillWidth: true
            spacing: 20

            RowLayout {
                spacing: 10
                Button {
                    // background: Rectangle {
                    //         color: "#262525"  // Définit la couleur de fond du bouton
                    //     }
                    text: qsTr("Aide")
                    onClicked: {
                        console.log("Aide clicked");
                    }
                }

                Button {
                    text: qsTr("Réinitialiser")
                    onClicked: {
                        console.log("Réinitialiser clicked");
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 10
                Button {
                    text: qsTr("Annuler")
                    onClicked: settingsDialog.close()
                }

                Button {
                    text: qsTr("OK")
                    onClicked: {
                        console.log("OK clicked");
                        settingsDialog.accept();
                    }
                }
            }
        }
    }

}
