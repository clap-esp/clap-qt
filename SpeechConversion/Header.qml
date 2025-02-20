import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

/**
* Header to activate or deactivate Transcription/ Traduction block
**/

RowLayout{
    id: header_container
    Material.theme: Material.Dark
    Material.accent: Material.Material.Teal
    signal translationEnableEvent(bool enabled)
    signal transcriptionEnableEvent(bool enabled)


    CheckBox  {
       id: subtitle
       text: qsTr("Sous-titre")
       checked: true
       onClicked:()=>{
            if(!subtitle.checkState && !translation.checkState){
                translation.checked=true
            }

            transcriptionEnableEvent(subtitle.checkState)

            translationEnableEvent(translation.checkState)
        }
    }


    CheckBox  {
       id: translation
       text: qsTr("Traduction")
       onClicked:()=>{
             if(!subtitle.checkState && !translation.checkState){
                 subtitle.checked=true
             }
            translationEnableEvent(translation.checkState)
            transcriptionEnableEvent(subtitle.checkState)

        }
    }


}
