import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    width: 100
    height: 40

    property alias text: buttonText.text
    property color normalColor: "#3498db"
    property color hoverColor: "#2980b9"
    property color pressedColor: "#1f618d"

    // Etat du survol et du clic
    property bool hovered: false
    property bool isPressed: false

    // Signal pour le clic
    signal buttonClicked()

    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        radius: 8
        color: isPressed ? pressedColor : (hovered ? hoverColor : normalColor)

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        MouseArea {
            id: buttonArea
            anchors.fill: parent
            onClicked: {
                isPressed = false
                buttonClicked();
            }

            onPressed: isPressed = true
            onReleased: isPressed = false

            onEntered: hovered = true
            onExited: hovered = false
        }

        // Texte du bouton
        Text {
            id: buttonText
            anchors.centerIn: parent
            color: "#ffffff"
            font.pixelSize: 16
            text: qsTr("Button")
        }
    }
}
