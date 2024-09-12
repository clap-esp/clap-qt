import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 1920
    height: 1080

    Button {
        id: playButton
        x: 910
        y: 520
        width: 35
        height: 35
        enabled: true
        icon.source: "images/805a12e9-b701-5dce-97b2-c47b9dd18151.png"
    }

    MouseArea {
        id: mouseArea
        x: 910
        y: 520
        width: 35
        height: 35
    }
}
