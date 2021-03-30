import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import EmojiModel 1.0

Item {
    id: container
    property var editor
    property EmojiModel model
    property var categories: ['Smileys & Emotion', 'People & Body', 'Animals & Nature',
        'Food & Drink', 'Activities', 'Travel & Places', 'Objects', 'Symbols', 'Flags']
    property var searchModel: ListModel {}
    property bool searchMode: false
    property int skinColor: -1
    function changeSkinColor(index) {
        if (index !== skinColors.current) {
            skinColors.itemAt(skinColors.current + 1).scale = 0.6
            skinColors.itemAt(index + 1).scale = 1
            skinColors.current = index
            container.skinColor = index
        }
    }
    function refreshSearchModel() {
        searchModel.clear()
        var searchResult = model.search(searchField.text, skinColor)
        for (var i = 0; i < searchResult.length; ++i) {
            searchModel.append({path: searchResult[i]})
        }
    }
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            id: categoriesRow
            Layout.preferredWidth: parent.width - 15
            Layout.preferredHeight: 35
            Layout.leftMargin: 5
            Layout.alignment: Qt.AlignCenter
            spacing: searchField.widthSize > 0 ? 7 : 17
            clip: true
            Image {
                id: searchIcon
                source: 'icons/search.svg'
                sourceSize: Qt.size(21, 21)
                visible: !container.searchMode
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        container.searchMode = true
                        searchField.widthSize = categoriesRow.width - 25
                        list.model = 1
                        searchField.focus = true
                    }
                }
            }
            Image {
                id: closeIcon
                source: 'icons/close.svg'
                sourceSize: Qt.size(21, 21)
                visible: container.searchMode
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        container.searchMode = false
                        searchField.widthSize = 0
                        list.model = container.categories
                        searchField.clear()
                    }
                }
            }
            TextField {
                id: searchField
                property int widthSize: 0
                Layout.preferredWidth: widthSize
                Layout.preferredHeight: 28
                visible: widthSize > 0 ? true : false
                placeholderText: 'Search Emoji'
                Behavior on widthSize {
                    NumberAnimation {
                        duration: 400
                    }
                }
                background: Rectangle {
                    radius: 10
                    border.color: '#68c8ed'
                }
                onTextChanged: {
                    text.length > 0 ? container.refreshSearchModel() : container.searchModel.clear()
                }
            }
            Repeater {
                id: cateIcons
                property var blackSvg: ['emoji-smiley.svg', 'emoji-people.svg', 'emoji-animal.svg', 'emoji-food.svg',
                    'emoji-activity.svg', 'emoji-travel.svg', 'emoji-object.svg', 'emoji-symbol.svg', 'emoji-flag.svg']
                property var blueSvg: ['emoji-smiley-blue.svg', 'emoji-people-blue.svg', 'emoji-animal-blue.svg',
                    'emoji-food-blue.svg', 'emoji-activity-blue.svg', 'emoji-travel-blue.svg', 'emoji-object-blue.svg',
                    'emoji-symbol-blue.svg', 'emoji-flag-blue.svg']
                property int current: 0
                model: 9
                delegate: Image {
                    id: icon
                    source: 'icons/' + cateIcons.blackSvg[index]
                    sourceSize: Qt.size(20, 20)
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (cateIcons.current !== index) {
                                icon.source = 'icons/' + cateIcons.blueSvg[index]
                                cateIcons.itemAt(cateIcons.current).source = 'icons/' + cateIcons.blackSvg[cateIcons.current]
                                cateIcons.current = index
                            }
                            list.positionViewAtIndex(index, ListView.Beginning)
                        }
                    }
                }
                Component.onCompleted: {
                    itemAt(0).source = 'icons/' + cateIcons.blueSvg[0]
                }
            }
        }
        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: container.categories
            spacing: 30
            topMargin: 7
            bottomMargin: 7
            leftMargin: 12
            clip: true
            delegate: GridLayout {
                id: grid
                property string category: container.searchMode ? 'Search Result' : modelData
                property int columnCount: list.width / 50
                property int sc: grid.category === 'People & Body' ? container.skinColor : -1
                columns: columnCount
                columnSpacing: 8
                Text {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    text: grid.category
                    color: Qt.rgba(0, 0, 0, 0.5)
                    font.pixelSize: 15
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 6
                    Layout.columnSpan: grid.columnCount != 0 ? grid.columnCount : 1
                    Layout.bottomMargin: 8
                }
                Repeater {
                    model: container.searchMode ? container.searchModel : container.model.count(grid.category)
                    delegate: Rectangle  {
                        property alias es: emojiSvg
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 40
                        color: mouseArea.containsMouse ? '#e6e6e6' : '#ffffff'
                        Image {
                            id: emojiSvg
                            source: container.searchMode ? path : container.model.path(grid.category, index, grid.sc)
                            sourceSize: Qt.size(30, 30)
                            anchors.centerIn: parent
                            asynchronous: true
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var tag = "<img src = '%1' width = '20' height = '20' align = 'top'>"
                                container.editor.insert(container.editor.cursorPosition, tag.arg(emojiSvg.source))
                            }
                        }
                    }
                }
            }
            onContentYChanged: {
                var index = list.indexAt(0, contentY + 15)
                if (index !== -1 && index !== cateIcons.current) {
                    cateIcons.itemAt(index).source = 'icons/' + cateIcons.blueSvg[index]
                    cateIcons.itemAt(cateIcons.current).source = 'icons/' + cateIcons.blackSvg[cateIcons.current]
                    cateIcons.current = index
                }
            }
        }
        RowLayout {
            Layout.preferredHeight: 35
            Layout.alignment: Qt.AlignCenter
            spacing: 10
            Repeater {
                id: skinColors
                property var colors: ['#ffb84d', '#ffdab3', '#d2a479', '#ac7139', '#734b26', '#26190d']
                property int current: -1
                model: 6
                delegate: Rectangle {
                    id: colorRect
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    Layout.bottomMargin: 3
                    radius: 30
                    scale: 0.65
                    color: skinColors.colors[index]
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            container.changeSkinColor(index - 1)
                            if (container.searchMode) {
                                container.refreshSearchModel();
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    itemAt(0).scale = 1
                }
            }
        }
    }
}
