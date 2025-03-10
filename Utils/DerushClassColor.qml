import QtQuick

QtObject {

    // STU (Bégaiement)
  readonly property color _STU: Qt.rgba(1, 0.39, 0.28, 0.6)

    // FIL (Mots de remplissage)
   readonly property color _FIL:  Qt.rgba(1, 0.84, 0, 0.6)

    // REP (Répétitions)
    readonly property color _REP:  Qt.rgba(0.49, 0.99, 0, 0.6)

    // RED (Phrases redondantes)
    readonly property color _RED:  Qt.rgba(0.25, 0.88, 0.82, 0.6)

    // NOI (Bruits de fond)
    readonly property color _NOI:  Qt.rgba(0.5, 0.5, 0.5, 0.6)

    // INT (Interjections)
    readonly property color _INT:  Qt.rgba(1, 0.41, 0.71, 0.6)

    // BRE (Respirations audibles)
     readonly property color _BRE: Qt.rgba(0.53, 0.81, 0.98, 0.6)

    // CLI (Clics de bouche)
    readonly property color _CLI:  Qt.rgba(0.55, 0.27, 0.1, 0.6)

    // SIL (Silences prolongés)
     readonly property color _SIL: Qt.rgba(0, 0, 0, 0.6)

}
