import QtQuick 2.15
import QtQuick.Layouts

Rectangle {
    id: textBlockContainer
    width: parent.width
    height: 50
    color: "transparent"
    property string textToDisplay:''
    property string timeCode: ''
    property bool history: false
    signal chooseBlock()
    radius: 5

    RowLayout{

        width: parent.width
        height: parent.height

        Rectangle{
            id: borderElem
            Layout.leftMargin: 20
            color: "#D593E8"
            width:3
            height: 45
            radius: 10
        }

        Text{
            id: timeCodeText
            text: timeCode
            visible: !history
            color: "#fff"
            padding: 10
            font.pixelSize: 12
        }


        Text {
            topPadding: 0
            text: textToDisplay
            color: "#fff"
            font.pixelSize: 15
            wrapMode: Text.Wrap
            Layout.preferredWidth: parent.width/3*2
            horizontalAlignment: Qt.AlignLeft


        }
    }




    MouseArea {
        hoverEnabled: history
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            chooseBlock()
        }
        onEntered: {
            textBlockContainer.color="#81789b"
        }

        onExited: {
            textBlockContainer.color="transparent"
        }
    }
}
