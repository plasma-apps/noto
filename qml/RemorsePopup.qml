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

Column {

    id: remorse

    /**
     * This property defines the default countdown time in msec.
     */
    property int timer

    /**
     * This property defines the text of the remors popup.
     */
    property string text

    /**
     * This property defines if yes or no dialog or timer should be used.
     */
    property bool dialog: false

    /**
     * This property defines the function that gets executed on trigger
     */
    property var callback

    /**
     * This property defines the remaining msec of the countdowntimer
     */
    property int msecRemaining

    signal triggered
    signal canceled

    height: theme.mSize(theme.defaultFont).height * 2
    width: parent.width - units.largeSpacing
    anchors.horizontalCenter: parent.horizontalCenter
    opacity: 0.0
    visible: false

    function execute(title, callback, timeout) {
        remorse.text = title
        remorse.callback = callback
        remorse.timer = timeout === undefined ? 5000 : timeout
        countdownTimer.restart()
        state = "active"
    }

    function trigger() {
        triggered();
        if (remorse.callback !== undefined) {
                remorse.callback.call()
            }
    }
 
    function cancel() {
	close();
	canceled();
    }

    function close() {
        countdownTimer.stop();
        state = ""
    }

    states: State {
        name: "active"
        PropertyChanges { target: remorse; opacity: 1.0; visible: true }
    }
    transitions: [
        Transition {
            to: "active"
            SequentialAnimation {
                PropertyAction { properties: "visible" }
		NumberAnimation {
			duration: 200
			easing.type: Easing.InOutQuad
			property: "opacity"
		} 
            }
        },
        Transition {
            SequentialAnimation {
		NumberAnimation {
			duration: 200
			easing.type: Easing.InOutQuad
			property: "opacity"
		} 
                PropertyAction { properties: "visible" }
            }
        }
    ]

    NumberAnimation {
        id: countdownTimer
        target: remorse
        property: "msecRemaining"
        from: timer
        to: 0
        duration: timer
        onRunningChanged: {
                if (!running && msecRemaining == 0) {
			remorse.trigger();
                        remorse.close();
                }
        }
    }
    Rectangle {
        implicitHeight: parent.height
        implicitWidth: parent.width
        color: theme.backgroundColor
        border.color: theme.viewFocusColor
        border.width: 1
        radius: 4
    
	    Item {
		id: remorseItem
		clip: true
		height: parent.height
                width: parent.width
		PlasmaComponents.Label {
			id: timerLbl
			font.pointSize: parent.height / 2
                        font.bold: true
                        anchors.left: parent.left
			text: remorse.timer
		}
		PlasmaComponents.Label {
			id: lbl
			font.pointSize: parent.height / 3
                        anchors.left: timerLbl.right
                        anchors.leftMargin: units.largeSpacing
                        anchors.verticalCenter: parent.verticalCenter
			text: "Remove xyz ?" //remorse.text
		}
                Row {
                anchors.right: parent.right
                anchors.rightMargin: units.smallSpacing
                anchors.verticalCenter: parent.verticalCenter
                spacing: units.smallSpacing
			PlasmaComponents.Button {
				id: yesBtn
				visible: remorse.dialog
				text: qsTr("Yes")
				onClicked: { remorse.trigger(); remorse.close(); }
			}
			PlasmaComponents.Button {
				id: cancelBtn
				text: remorse.dialog ? qsTr("No") : qsTr("Cancel")
				onClicked: remorse.cancel()
			}
                }
	     }
  }
} 
