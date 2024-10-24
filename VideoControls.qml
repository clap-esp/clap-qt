import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    id: videoControls
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 10

    Button {
        text: "CLAP"
        width: 100
        height: 40
    }

    Button {
        text: "Exporter"
        width: 100
        height: 40
    }
}
