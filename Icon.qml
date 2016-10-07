import QtQuick 2.5
import "."

Item {
   id: root

   property alias size: icon.font.pixelSize
   property alias name: icon.text
   property alias color: icon.color
   property bool  lightBackground: true

   width: size
   height: size

   Text {
      id: icon

      FontLoader {
         id: materialIcons
         source: Qt.resolvedUrl("MaterialIcons-Regular.ttf")
      }

      anchors.centerIn: parent

      font.family: materialIcons.name
      font.pixelSize: 24

      color: lightBackground
             ? Theme.onLightBackground.secondary
             : Theme.onDarkBackground.primary

      Behavior on color { ColorAnimation { duration: 200 } }
   }
}
