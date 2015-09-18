/*
 * Copyright (C) 2014-2015 Leszek Lesner <leszek@zevenos.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) version 3, or any
 * later version accepted by the membership of KDE e.V. (or its
 * successor approved by the membership of KDE e.V.), which shall
 * act as a proxy defined in Section 6 of version 3 of the license.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.1

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0

import "db.js" as DB

PlasmaComponents.Page {
    id: notesTab

    ListModel {
        id: notesModel
        //ListElement {
        //	noteTitle: "Test2"
        //        noteId: "2113e"
        //        noteColor: "green"
        //        noteText: "Ein TestModel Test das nicht die DB nutzt"
        //}

    }

    ListView {
        id: noteList
        anchors.fill: parent
        model: mainWindow.notesModel
        delegate: Item {
            id: myListItem
            property QtObject contextMenu
            property int myIndex: index
            property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem

            width: parent.width - (parent.width / 32)
            height: menuOpen ? contextMenu.height + contentItem.height : contentItem.height
            anchors.horizontalCenter: parent.horizontalCenter

            function remove() {
                var removal = removalComponent.createObject(myListItem)
                ListView.remove.connect(removal.deleteAnimation.start)
                removal.parent = contentItem
                removal.height = contentItem.height
                removal.execute("Delete " + noteTitle, function() { mainWindow.removeNote(noteTitle,noteId) }, 10000 )
            }

            PlasmaComponents.ListItem {
                id: contentItem
                enabled: true
                width: parent.width

                onPressAndHold: {
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(myListItem)
                    contextMenu.open()
                }

                onClicked: {
                    //console.debug("Clicked " + noteTitle + " with text: " + DB.getText(noteTitle,noteId))
                    mainWindow.mainStack.push(Qt.resolvedUrl("Note.qml"), {noteTitle:noteTitle , noteText: DB.getText(noteTitle,noteId), noteId: noteId, noteColor: noteColor} )
                }

                Rectangle {
                    id: colorRec
                    width: parent.width / 24
                    anchors.left: parent.left
                    height: parent.height
                    color: noteColor
                }
                PlasmaComponents.Label {
                    height: implicitHeight
                    anchors.left: colorRec.right
                    anchors.leftMargin: units.smallSpacing

                    elide: Text.ElideRight
                    text: noteTitle
                }
            }

            Component {
                id: removalComponent
                RemorsePopup {
                    property QtObject deleteAnimation: SequentialAnimation {
                        PropertyAction { target: myListItem; property: "ListView.delayRemove"; value: true }
                        NumberAnimation {
                            target: myListItem
                            properties: "height,opacity"; to: 0; duration: 300
                            easing.type: Easing.InOutQuad
                        }
                        PropertyAction { target: myListItem; property: "ListView.delayRemove"; value: false }
                    }
                    onCanceled: destroy()
                }
            }

            Component {
                id: contextMenuComponent
                PlasmaComponents.ContextMenu {
                    id: menu
                    PlasmaComponents.MenuItem {
                        text: "Delete"
                        onClicked: {
                            myListItem.remove();
                        }
                    }
                }
            } //Contextmenu

        }
    }

}
