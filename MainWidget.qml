import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import "Translation"
import "Video"

Item {
    id: root
    property string videoSourcePath: ""


    VideoWidget {
        id: video_widget

        width: (parent.width * 0.5) - 15 // Taille fixe pour le widget
        height: parent.height * 0.5 // Taille fixe pour le widget
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 30  // Marge de 10 pixels en haut
        anchors.rightMargin: 10 // Marge de 10 pixels à droite

        videoSource: root.videoSourcePath
    }

    TranslationWidget {
        id: translation_widget

        width: (parent.width * 0.5) - 15// Taille fixe pour le widget
        height: parent.height * 0.5 // Taille fixe pour le widget
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 30  // Marge de 10 pixels en haut
        anchors.leftMargin: 10 // Marge de 10 pixels à gauche
    }

    // Nouvelle zone pour la bande de visualisation vidéo qui occupe toute la moitié basse
    VideoTimeline {
        id: video_timeline_widget
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: (parent.height * 0.5) - 40 // Prend la moitié inférieure de la page
    }
}
