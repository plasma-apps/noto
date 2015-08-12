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

Row{
    id: circle

    property int loadtimer: 4000
    property color circleColor: "transparent"
    property color borderColor: theme.highlightColor
    property int borderWidth: parent.height / 13
    property alias running: initCircle.running
    property bool finished: false;
    property bool inverted: false;
    property int initCircleTarget: inverted ? 180 : 360

    width: height
    height: parent.height

    function start(){
        if (!inverted) {
		part1.rotation = 180
		part2.rotation = 180
        }
        else {
        	part1.rotation = 360
        	part2.rotation = 360
        }
        initCircle.start()
       
    }

    function stop(){
        initCircle.stop()
    }

    Item{
        width: parent.width/2
        height: parent.height
        clip: true

        Item{
            id: part1
            width: parent.width
            height: parent.height
            clip: true
            rotation: 180
            transformOrigin: Item.Right

            Rectangle{
                width: circle.width-(borderWidth*2)
                height: circle.height-(borderWidth*2)
                radius: width/2
                x:borderWidth
                y:borderWidth
                color: circleColor
                border.color: borderColor
                border.width: borderWidth
                smooth: true
            }
        }
    }

    Item{
        width: parent.width/2
        height: parent.height
        clip: true

        Item{
            id: part2
            width: parent.width
            height: parent.height
            clip: true

            rotation: 180
            transformOrigin: Item.Left

            Rectangle{
                width: circle.width-(borderWidth*2)
                height: circle.height-(borderWidth*2)
                radius: width/2
                x: -width/2
                y: borderWidth
                color: circleColor
                border.color: borderColor
                border.width: borderWidth
                smooth: true
            }
        }
    }
    SequentialAnimation{
        id: initCircle
        PropertyAnimation{ target: part2; property: "rotation"; to:initCircleTarget; duration:loadtimer/2 }
        PropertyAnimation{ target: part1; property: "rotation"; to:initCircleTarget; duration:loadtimer/2 }
        ScriptAction { script: finished = true; }
    }
} 
