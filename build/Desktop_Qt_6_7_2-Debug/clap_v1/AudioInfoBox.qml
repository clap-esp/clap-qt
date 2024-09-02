import QtQuick

Item {
    id: root

    required property int songIndex
    property alias title: albumTitle.text // Propriété Alias permettent de créer un alias d'un objet déclaré plus tard dans le code
    property alias author: albumAuthorText.text
    property alias imageColor: albumImage.color

    visible: playerController.currentSongIndex === root.songIndex

    Rectangle {
        id: albumImage

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }

        width: 150
        height: 150
        radius: 20
    }

    Text {
        id: albumTitle

        anchors {
            bottom: parent.verticalCenter
            left: albumImage.right
            right: parent.right
            margins: 20
        }

        color: "#DBDBDB"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        font {
            pixelSize: 20
            bold: true
        }
    }

    Text {
        id: albumAuthorText

        anchors {
            bottom: parent.verticalCenter
            left: albumTitle.left
            right: parent.right
            topMargin: 5
        }

        color: "grey"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        font {
            pixelSize: 16
        }
    }
}
