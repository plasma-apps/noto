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
    id: todosTab

    ListModel {
        id: todosModel
        //ListElement {
        //	todoListTitle: "Test2"
        //        lId: "2113e"
        //        todoListColor: "green"
        //}

    }

    ListView {
        id: todoList
        anchors.fill: parent
        model: mainWindow.todoListModel
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
                removal.execute("Delete " + todoListTitle, function() { mainWindow.removeTodoList(todoListTitle,lId) }, 10000 )
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
                    //console.debug("Clicked " + todoListTitle + " with text: " + DB.getText(todoListTitle,lId))
                    mainWindow.todosModel.clear();
                    DB.getTodos(lId);
                    mainWindow.mainStack.push(Qt.resolvedUrl("Todo.qml"), {todoListTitle:todoListTitle ,lId: lId, todoListColor: todoListColor} )
                }

                Rectangle {
                    id: colorRec
                    width: 8
                    anchors.left: parent.left
                    height: parent.height
                    border.color: todoListColor
                    border.width: 1
                }
                PlasmaComponents.Label {
                    height: implicitHeight
                    anchors.left: colorRec.right
                    anchors.leftMargin: units.smallSpacing

                    elide: Text.ElideRight
                    text: { 
                        if (todoListClearCount != 0 && todoListTodosCount != 0)
				todoListTitle + "(" + todoListClearCount + "/" + todoListTodosCount + ")"
                        else
				todoListTitle
                    }
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
