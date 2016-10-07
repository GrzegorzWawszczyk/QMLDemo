import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    id: root

    property string fileName: ""
    property string filePath: ""
    property string size: "<DIR>"
    property string lastModified: ""

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
            from: "hidden"
            to: "expanded"
            AnchorAnimation {
                targets: root
                duration: 1000
                easing.type: Easing.OutBack
            }
        },
        Transition {
            from: "expanded"
            to: "hidden"
            AnchorAnimation {
                targets: root
                duration: 1000
                easing.type: Easing.InBack
            }
        }
    ]

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
    }


    Rectangle {
        id: dialog

        width: 400
        height: 300

        anchors.topMargin: 50
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        color: "gold"

        Label{
            id: fileNameLabel
            anchors.top: parent.top
            anchors.topMargin: 15
            font.pixelSize: 20
            width: parent.width
            text: "File Name: \n" + root.fileName
        }
        Label{
            id: filePathLabel
            anchors.top: fileNameLabel.bottom
            font.pixelSize: 20
            width: parent.width
            text: "Path: \n" + root.filePath
            wrapMode: Text.WrapAnywhere
        }
        Label{
            id: size
            anchors.top: filePathLabel.bottom
            font.pixelSize: 20
            width: parent.width
            text: "Size: \n" + root.size
        }
        Label{
            id: lastModifiedLabel
            anchors.top: size.bottom
            font.pixelSize: 20
            width: parent.width
            text: "Last modified: \n" + root.lastModified
        }

    }
}
