import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root


    VideoWidget {
        id: videoDisplayer
                width: 769 // Taille fixe pour le widget
                height: 448 // Taille fixe pour le widget
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 10  // Marge de 10 pixels en haut
                anchors.rightMargin: 10 // Marge de 10 pixels à droite

    }
}
