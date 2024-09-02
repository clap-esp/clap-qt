

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

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
