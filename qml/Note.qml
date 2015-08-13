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
import "helper.js" as HELPER

PlasmaComponents.Page {
    id: notePage

    property string noteColor
    property string noteText
    property string noteTitle
    property string noteId

    ColorChooser {
	id: colorRec
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: units.smallSpacing
        anchors.topMargin: units.smallSpacing
        width: height
        height: titleInput.height
        color: noteColor
        z: 3
    }
    PlasmaComponents.TextField {
	id: titleInput
        anchors.left: colorRec.right
	anchors.leftMargin: units.smallSpacing
        anchors.verticalCenter: colorRec.verticalCenter
        text: noteTitle
        placeholderText: qsTr("Title of Note")
        width: parent.width - (colorRec.width + (3*units.smallSpacing))
        z: 2
    }
    PlasmaComponents.TextArea {
    	id: textInput
        anchors.top: titleInput.bottom
        anchors.topMargin: units.smallSpacing
        width: parent.width - (2*units.smallSpacing)
	anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height - titleInput.height - (2*units.smallSpacing)
        text: noteText
        focus: true
        z: 2
    }
    // Add Save Button to mainToolbar
    PlasmaComponents.ToolButton {
        id: saveBtn
        parent: mainWindow.mainToolbar.parent
        anchors.horizontalCenter: parent.horizontalCenter
    	iconName: "document-save"
        // Syntax Help:  setNote(uid,title,txt,color,datetime)
    	onClicked: { 
                if (titleInput.text == "") titleInput.text = HELPER.getCurrentDate();
		DB.setNote(noteId,titleInput.text,textInput.text,colorRec.color,HELPER.getCurrentDate());
                // Syntax Help: addNote(noteTitle,noteId,noteColor)
		mainWindow.addNote(titleInput.text,noteId,String(colorRec.color));
                noteTitle = titleInput.text
		noteColor = String(colorRec.color)
	}
    }
    PlasmaComponents.ToolButton {
	id: removeBtn
	parent: mainWindow.mainToolbar.parent
	anchors.right: parent.right
        iconName: "trash-empty"
	onClicked: {
                mainWindow.remorsePopup.execute("Delete " + noteTitle, function() { mainWindow.removeNote(noteTitle,noteId) }, 10000 )
        }
	visible: mainWindow.notesModel.containsTitle(noteTitle)
    } 
}
