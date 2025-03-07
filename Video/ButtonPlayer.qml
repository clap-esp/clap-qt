import QtQuick
import QtQuick.Controls
/**
* Button Player widget
**/
ToolButton {
     id: buttonPlayer
     property alias icone: buttonPlayer.icon.source

     width: 80
     height: 80
     background: Rectangle {
         color: "transparent"
     }

     icon {
         width: buttonPlayer.parent.width
         height: buttonPlayer.parent.height
         color: "white"
     }

}
