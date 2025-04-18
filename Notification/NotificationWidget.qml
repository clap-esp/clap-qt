import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import notification.type 1.0
import '../Utils'

Popup {
    id: popup
    Material.background: constants.panel_background_color
    padding: 0
    anchors.centerIn: parent
    width: parent.width < Screen.width ? parent.width/2 : parent.width/4
    height: parent.width < Screen.width ? parent.height/2 : parent.height/4
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent


    readonly property string successIcon: './Icons/success.png'
    readonly property string warningIcon: './Icons/warning.png'
    readonly property string errorIcon: './Icons/error.png'

    property string icon: successIcon

       ColumnLayout{
        anchors.fill: parent
        width: parent.width
        height: parent.height
           Rectangle{
                id: header
                Layout.fillWidth: true
                color: 'transparent'
                height: 30
                Layout.margins: 10



                RowLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10
                    Image {
                        source: icon
                        width: parent.width/8
                        height: parent.height/5

                    }

                    Text{
                        color: 'white'
                        id: title_text
                        text: 'Title'
                        font.pixelSize: 20
                        font.bold: true

                    }
                }
           }


        Text{
               id: content_text
               text: 'content text'
               color: 'white'
               font.pixelSize: 16
               Layout.fillWidth: true
               Layout.alignment: Qt.AlignHCenter
               wrapMode: Text.Wrap
               horizontalAlignment: Text.AlignJustify
               Layout.margins: 15

           }

           RowLayout{
               Layout.alignment: Qt.AlignHCenter
               spacing: 10
               Layout.fillWidth: true
               Button {
                     text: "OK"
                     onClicked: popup.close()
                     Material.background: constants.active_button


                }
               Button {
                     visible: false
                     text: "Cancel"
                     onClicked: popup.close()
                     Material.background: constants.normal_button

                 }
           }

       }


       /**
        *Method to open notification
        **/
       function openNotification(content, type){
           popup.open()
           setContent(content)
           setIcon(type)
       }





       /**
        * Set Notification text content
        **/

       function setContent(contentText){
           content_text.text=contentText
       }



       /**
        * Set notification icon
        **/
       function setIcon(message_type){
           switch(message_type){
           case NotificationTypeClass.Error:
               icon= errorIcon
               title_text.text='Erreur'

               break;
           case NotificationTypeClass.Success:
               title_text.text='Succès'
               icon= successIcon
               break;
           case NotificationTypeClass.Warning:
               title_text.text='Attention'
               icon= warningIcon
               break;
           }
       }

   }


