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

PlasmaComponents.Page {
    id: mainPage

    PlasmaComponents.TabBar {
        id: tabBar
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        PlasmaComponents.TabButton {
             text: qsTr("Notes")
             tab: notesTab
        }
        PlasmaComponents.TabButton {
             text: qsTr("Todos")
             //tab: todosTab
        }
    }

    PlasmaComponents.TabGroup {
        id: tabGroup
        anchors {
		left: parent.left
		right: parent.right
		top: parent.top
		bottom: tabBar.top
	}
        // TODO: Add Notes and Todo Tabs
        NotesTab {
        	id: notesTab
        }
    }
    Component.onCompleted: {
    	tabGroup.currentTab = notesTab;
    }

}
