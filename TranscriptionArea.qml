import QtQuick

Item {
    id: root

    property color color: "grey"
    property alias text: buttonText.text

    signal clicked()

    Rectangle {
        id: background

        anchors.fill: parent

        color: if(mouseAreaButton.containsPress) {
                   return Qt.lighter(root.color)
               } else if(mouseAreaButton.containsMouse) {
                   return Qt.darker(root.color)
               } else {
                   return root.color
               }
    }

    Text {
        id: buttonText

        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseAreaButton

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.clicked()
        }
    }
}
