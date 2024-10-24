import QtQuick 2.15

Rectangle {
    id: videoBar
    width: parent.width
    height: parent.height
    color: "#b37fbe" // Couleur de la barre principale

    // Vous pouvez ajouter plus de barres ou visualisations ici
    Rectangle {
        width: parent.width * 0.5
        height: parent.height * 0.5
        color: "#6b3b7e" // Une deuxième bande à l'intérieur
    }
}
