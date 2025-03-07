import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import '../Utils'


Popup {
   id: loadingPopup
   property string textToDisplay: 'Chargement en cours...'
   property var colors: Constants{}
   modal: true
   focus: true
   width: parent.width/3
   height: parent.height/4
   anchors.centerIn: parent
   closePolicy: Popup.NoAutoClose

   background: Rectangle {
       color: colors.panel_background_color
       radius: 10
   }

   ColumnLayout {
       anchors.fill: parent
       spacing: 5

       Text {
           Layout.alignment: Qt.AlignHCenter
           text: textToDisplay
           color: "white"
           font.pixelSize: 18
           font.bold: true
           horizontalAlignment: Text.AlignHCenter
           Layout.fillWidth: true
           wrapMode: Text.Wrap

       }

       ProgressBar{
           Material.theme: Material.Light
           indeterminate: true
           Layout.alignment: Qt.AlignHCenter
           Material.background: Material.Purple
           Material.accent: Material.DeepPurple
           Layout.fillWidth: true
           height: 50
       }
   }
}
