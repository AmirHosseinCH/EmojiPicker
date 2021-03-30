import QtQuick 2.15
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import EmojiModel 1.0

ApplicationWindow {
    width: 700
    height: 600
    visible: true
    title: 'Emoji Picker'
    EmojiModel {
        id: emojiModel
        iconsPath: 'emojiSvgs/'
        iconsType: '.svg'
    }
    Rectangle {
        id: body
        width: 400
        height: 420
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        EmojiPicker {
            id: emojiPicker
            model: emojiModel
            editor: txtEdit
            anchors.fill: parent
        }
    }
    Rectangle {
        width: 400
        height: 100
        radius: 10
        border.color: Qt.rgba(0, 0, 0, 0.2)
        anchors.top: body.bottom
        anchors.topMargin: 25
        anchors.horizontalCenter: body.horizontalCenter
        Flickable {
            id: flick
            contentWidth: txtEdit.paintedWidth
            contentHeight: txtEdit.paintedHeight
            clip: true
            anchors.fill: parent
            function ensureVisible(r) {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX + width <= r.x + r.width)
                    contentX = r.x + r.width - width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY + height <= r.y + r.height)
                    contentY = r.y + r.height - height;
            }
            TextEdit {
                id: txtEdit
                width: flick.width
                focus: true
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.RichText
                topPadding: 5
                leftPadding: 7
                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            }
        }
    }
    DropShadow {
        anchors.fill: body
        horizontalOffset: 12
        verticalOffset: 12
        radius: 16
        samples: radius * 2 + 1
        color: Qt.rgba(0, 0, 0, 0.1)
        source: body
    }
    DropShadow {
        anchors.fill: body
        horizontalOffset: -8
        verticalOffset: -8
        radius: 16
        samples: radius * 2 + 1
        color: Qt.rgba(0, 0, 0, 0.1)
        source: body
    }
}
