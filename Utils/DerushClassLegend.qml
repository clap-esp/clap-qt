import QtQuick

QtObject{
    readonly property var derushColor: DerushClassColor{}
    readonly property var value:[
        {
            id: "_STU",
            color: derushColor._STU,
            text: "Bégaiement"
        },{
            id: "_FIL",
            color: derushColor._FIL,
            text: "Mots de remplissage"
        },{
            id: "_REP",
            color: derushColor._REP,
            text: "Répétitions"
        },{
            id: "_NOI",
            color: derushColor._NOI,
            text: "Bruits de fond"
        },{
            id: "_INT",
            color: derushColor._INT,
            text: "Interjection"
        },{
            id: "_SIL",
            color: derushColor._SIL,
            text: "Silences prolongés"
        },
    ]
}
