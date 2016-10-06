import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    StackView{
        id: stack
        initialItem: fileList
        anchors.fill: parent
        focus: true

        delegate: StackViewDelegate {

            function transitionFinished(properties)
            {
                properties.exitItem.x = 0
                properties.exitItem.rotation = 0
            }

            pushTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script:{
                            enterItem.rotation = 90
                            enterItem.z = exitItem.z + 1
                        }
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: enterItem.width
                        to: 0
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "rotation"
                        from: 90
                        to: 0
                    }
                }
                //                    PropertyAnimation {
                //                        target: exitItem
                //                        property: "x"
                //                        from: 0
                //                        to: -exitItem.width
                //                    }
            }

            popTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script:{
                            enterItem.rotation = -90
                            enterItem.z = exitItem.z + 1
                        }

                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: -enterItem.width
                        to: 0
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "rotation"
                        from: -90
                        to: 0
                    }
                }
                //                    PropertyAnimation {
                //                        target: exitItem
                //                        property: "x"
                //                        from: 0
                //                        to: exitItem.width
                //                    }
            }
        }


        Component {
            id: fileList

            Rectangle{
                id: rect
                color: "cornsilk"

                Label{
                    id:label
                    text: "Directory path: "
                    font.pixelSize: 20
                }
                TextField{
                    anchors.left: label.right
                    anchors.right: button.left
                    anchors.rightMargin: 10
                }
                Button {
                    id: button
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    text: "Take files"
                }

                Column{
                    width: parent.width
                    anchors.top: label.bottom
                    anchors.bottom: parent.bottom

                MouseArea{
                    id: fileListMouse

                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: {
                        if (mouse.button === Qt.LeftButton)
                        {
                            console.debug("Left Button")
                            stack.push(fileInfo)
                            stack.forceActiveFocus()
                        }
                        else if (mouse.button === Qt.RightButton){
                            console.debug("Right button")
                            infoDialog.show()

                        }
                    }
                }
                }




            }
        }

        Component{
            id: fileInfo



            Rectangle{
                color: "moccasin"

                focus: true
                Keys.onPressed: {
                    if (event.key == Qt.Key_Backspace || event.key == Qt.Key_Escape || event.key == Qt.Key_Back) {
                        event.accepted = true
                        stack.pop()
                    }
                }
            }
        }



        Component.onCompleted: forceActiveFocus()


    }
    InfoDialog{
        id: infoDialog

        focus:true

        Keys.onPressed: {
            if (event.key == Qt.Key_Backspace || event.key == Qt.Key_Escape || event.key == Qt.Key_Back) {
                event.accepted = true
                console.debug("HIDE")
                infoDialog.hide()
            }
        }
    }
}
