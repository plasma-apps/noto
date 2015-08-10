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
import org.kde.plasma.extras 2.0

import "db.js" as DB

ApplicationWindow {
    id: mainWindow
    width: 540
    height: 960
    visible: true
    property string appIcon: "/usr/share/icons/hicolor/64x64/apps/noto.png" //TODO: use xdg somehow
    property string appName: "Noto"
    property string version: "0.1"
    property alias mainToolbar: mainToolbar
    property alias notesModel: notesModel

    property QtObject mainPage

    function addNote(noteTitle,noteId,noteColor) {
        //console.debug("Adding Note: " + noteTitle + " with NoteId: " + noteId + " and color: " + noteColor)
	notesModel.append({"noteTitle": noteTitle, "noteId": noteId, "noteColor": noteColor})
    }
  
    PlasmaComponents.PageStack {
        id: mainStack
        anchors.fill: parent
        initialPage: Component {
        MainPage {
            id: mainPage
            Component.onCompleted: mainWindow.mainPage = mainPage
            }
        }
    }
    
    statusBar: ToolBar { // for mobile we use toolbar in status bar as it is closer to fingers of user
        //visible: mainStack.depth > 0
        visible: mainStack.currentPage != mainPage
        Row {
            id: mainToolbar
            height: parent.height
            width: parent.width
            //
            // Navigation
            //
            PlasmaComponents.ToolButton {
                iconName: "draw-arrow-back"
                //text: "Back" // We don't that do we ?
                onClicked: mainStack.pop();
            }
        }
    }
    
    Component.onCompleted: { 
        // Intitialize DB
        DB.initialize();
        DB.getNotes();
    }


   ListModel {
   	id: notesModel
   }

}
