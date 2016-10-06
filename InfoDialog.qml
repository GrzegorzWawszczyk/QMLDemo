import QtQuick 2.0

Rectangle{
    id: root

    color: "transparent"
    width: parent.width
    height: parent.height
    focus: true
    state: "hidden"

    function show() {
        state = "expanded"
        forceActiveFocus()
    }

    function hide() {
        state = "hidden"
//        forceActiveFocus()
    }

    states: [
        State {
            name: "hidden"
            AnchorChanges {
                target: root
                anchors.top: parent.bottom
            }
        },
        State {
            name: "expanded"
            AnchorChanges {
                target: root
                anchors.top: parent.top
            }
        }
    ]

    transitions: [
        Transition {
            AnchorAnimation {
                targets: root
                duration: 1000
                easing.type: Easing.InOutElastic
            }
        }
    ]

    MouseArea{
        anchors.fill: parent
    }


    Rectangle {
        id: dialog

        width: 240
        height: 300

//        function show() {
//            state = "expanded"
//            forceActiveFocus()
//        }

//        function hide() {
//            state = "hidden"
//            forceActiveFocus()
//        }



        anchors.topMargin: 50
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        color: "gold"


    }
}
