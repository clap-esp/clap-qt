import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#242424"
    visibility: "Maximized"
    visible: true
    title: "Clap - Main Window"

    VideoWidget {
        id: videoDisplayer

        width: parent.width * 0.5 // Taille fixe pour le widget
        height: parent.height * 0.5 // Taille fixe pour le widget
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10  // Marge de 10 pixels en haut
        anchors.rightMargin: 10 // Marge de 10 pixels à droite
    }
}
