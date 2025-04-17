import QtQuick
import QtQuick.Layouts

ColumnLayout{
    id: playhead
    anchors.fill: parent
    spacing:0
    Rectangle {
        width: 6
        height: parent.height
        color: "yellow"
    }
    Rectangle{
        width:3
        height: parent.height
        color: "yellow"
    }
}
