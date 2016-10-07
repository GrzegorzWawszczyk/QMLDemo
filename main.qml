import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtMultimedia 5.6

Window {
    //    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Directory Inspector")

    Rectangle{
        id: root
        anchors.fill: parent

        StackView{
            id: stack
            initialItem: fileList
            anchors.fill: parent
            focus: true

            Keys.onPressed: {
                if ((event.key == Qt.Key_Backspace || event.key == Qt.Key_Escape || event.key == Qt.Key_Back)) {

                    event.accepted = true
                    stack.pop()
                }
            }

            Component.onCompleted: currentItem.path = "C:/"

            delegate: StackViewDelegate {

                function transitionFinished(properties)
                {
                    properties.exitItem.x = 0
                    properties.exitItem.rotation = 0
                    properties.exitItem.opacity = 0
                }

                pushTransition: StackViewTransition {
                    SequentialAnimation {
                        ScriptAction {
                            script:{
                                enterItem.rotation = 90
                                enterItem.z = exitItem.z + 1
                                enterItem.opacity = 0.5
                                enterItem.forceActiveFocus()
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
                        PropertyAnimation {
                            target: enterItem
                            property: "opacity"
                            from: 0.5
                            to: 1
                            //                            duration: 3000
                        }
                    }
                }

                popTransition: StackViewTransition {
                    SequentialAnimation {
                        ScriptAction {
                            script:{
                                enterItem.rotation = -90
                                enterItem.z = exitItem.z + 1
                                enterItem.opacity = 0.5
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
                        PropertyAnimation {
                            target: enterItem
                            property: "opacity"
                            from: 0.5
                            to: 1
                            //                            duration: 100
                        }
                    }
                }
            }


            Component {
                id: fileList


                Rectangle{
                    id: rect
                    color: "cornsilk"
                    focus: true

                    property string path: ""
                    property var fileListVar: inspector.getFilesByPath(path)

                    //                    Component.onCompleted: {
                    //                        fileListVar = inspector.getFilesByPath(path)
                    //                        console.debug(fileListVar)
                    //                    }


                    Icon {
                        id: icon
                        name: "keyboard_backspace"
                        anchors.left:  parent.left
                        MouseArea{
                            anchors.fill: parent
                            onClicked: console.debug("asdas")
                        }
                    }
                    Label{
                        id: currentPathLabel
                        text: "Current path: " + rect.path
                        font.pixelSize: 18
//                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.left: icon.right
                    }

                    //                    ScrollView{
                    ScrollView {
                        id: sview
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: currentPathLabel.bottom
                        anchors.bottom: parent.bottom


                        Column{
                            width: sview.width


                            Repeater{
                                model: fileListVar.length

                                Rectangle{
                                    id: fileRectangle
                                    width: parent.width
                                    height: 30
                                    color: index % 2 == 0 ? "beige" : "blanchedalmond"
                                    state: "normal"



                                    function toHovered(){
                                        state = "hovered"
                                    }

                                    function toNormal(){
                                        state = "normal"
                                    }
                                    Icon {
                                        id: icon
                                        name: ""
                                        anchors.left:  parent.left
                                        Component.onCompleted: { name = fileListVar[index].isDir ? "folder" : ""}
                                    }
                                    Label{
                                        id: fileNameLabel
                                        anchors.left: icon.right
                                        text: fileListVar[index].fileName


                                    }

                                    MouseArea{
                                        id: fileListMouse

                                        hoverEnabled: infoDialog.state == "hidden"

                                        anchors.fill: parent
                                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                                        onEntered:{
                                            parent.toHovered()
                                        }

                                        onExited: {
                                            parent.toNormal()
                                        }

                                        onClicked: {
                                            if (mouse.button === Qt.LeftButton)
                                            {
                                                console.debug("Left Button")
                                                if (rect.fileListVar[index].isDir)
                                                {
                                                    stack.push(fileList)
                                                    stack.currentItem.path = rect.fileListVar[index].directoryPath
                                                }
                                                else if (rect.fileListVar[index].fileName.indexOf(".jpg") > 0 || rect.fileListVar[index].fileName.indexOf(".png") > 0)
                                                {
//                                                    console.debug(rect.fileListVar[index].fileName.indexOf(".jpg"))
                                                    stack.push(imageView)
                                                    stack.currentItem.imageSource = "file:///" + rect.fileListVar[index].directoryPath
                                                }
                                                else if (rect.fileListVar[index].fileName.indexOf(".mp3") > 0 || rect.fileListVar[index].fileName.indexOf(".wav") > 0)
                                                {
//                                                    console.debug(rect.fileListVar[index].fileName.indexOf(".jpg"))
                                                    stack.push(musicPlay)
                                                    stack.currentItem.audioSource = "file:///" + rect.fileListVar[index].directoryPath
                                                }
                                                else
                                                {
                                                    stack.push(fileContent)
                                                    stack.currentItem.content = inspector.getFileContent(rect.fileListVar[index].directoryPath)
                                                }

                                                stack.forceActiveFocus()
                                            }
                                            else if (mouse.button === Qt.RightButton){
                                                console.debug("Right button")
                                                console.debug(inspector.fileDescriptors[index].isDir)
                                                infoDialog.fileName = rect.fileListVar[index].fileName
                                                infoDialog.filePath = rect.fileListVar[index].directoryPath
                                                if (!rect.fileListVar[index].isDir)
                                                    infoDialog.size = rect.fileListVar[index].size
                                                infoDialog.lastModified = rect.fileListVar[index].modificationDate.toLocaleString(Qt.locale(), "dd-MM-yyyy")
                                                infoDialog.show()

                                            }
                                        }
                                    }

                                    states: [
                                        State {
                                            name: "normal"
                                            PropertyChanges {
                                                target: fileRectangle
                                                height: 30

                                            }
                                            PropertyChanges {
                                                target: fileNameLabel
                                                font.pixelSize: 20
                                            }
                                        },
                                        State {
                                            name: "hovered"
                                            PropertyChanges {
                                                target: fileRectangle
                                                height: 40
                                                color: "darksalmon"
                                            }
                                            PropertyChanges {
                                                target: fileNameLabel
                                                font.pixelSize: 30
                                            }
                                        }
                                    ]

                                    transitions:
                                        [
                                        Transition {
                                            PropertyAnimation{
                                                target: fileRectangle
                                                property: "height"
                                                duration: 500
                                            }
                                            PropertyAnimation{
                                                target: fileNameLabel
                                                property: "font.pixelSize"
                                                duration: 500
                                            }
                                            PropertyAnimation{
                                                target: fileRectangle
                                                property: "color"
                                                duration: 500
                                            }
                                        }
                                    ]
                                }
                            }
                        }

                    }
                }
            }

            Component{
                id: fileContent


                Rectangle{
                    id: fileContentRect
//                    anchors.fill: parent

                    width: parent.width
//                    height: parent.height
                    color: "moccasin"

                    Component.onCompleted: console.debug(width + " " + height)

                    focus: true

                    property string content: ""
                    ScrollView{
                        anchors.fill: parent

//                        width: fileContentRect.width
//                        height: fileContentRect.height
                        Component.onCompleted: console.debug(width + " " + height)
                    Label{
                        width: fileContentRect.width
//                        height: fileContentRect.height
                        text: fileContentRect.content
                        wrapMode: Text.WrapAnywhere
                        Component.onCompleted: console.debug(width + " " + height)
                    }

                }
            }
            }

            Component{
                id: imageView
                Rectangle{
                    color:  "black"
                    property string imageSource: ""
                    Image {
                        //                    anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: parent.imageSource

                    }
                }
            }

            Component{
                id: musicPlay
                Rectangle{
                    id: audioRectangle
                    color:  "black"
                    property string audioSource: ""
                    Image {
                        //                    anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "file:///C:/projects/nuta.jpg"

                    }

                    Audio{
                        id: playMusic
                        source: audioRectangle.audioSource
                    }
                    MouseArea {
                            anchors.fill: parent
                            onPressed:  { playMusic.play()}
                        }
                }
            }
        }


        InfoDialog{
            id: infoDialog


            focus:true

            Keys.onPressed: {
                if (event.key == Qt.Key_Backspace || event.key == Qt.Key_Escape || event.key == Qt.Key_Back) {
                    event.accepted = true
                    console.debug("HIDE")
                    infoDialog.hide()
                    stack.forceActiveFocus()
                }
            }
        }
    }
}

