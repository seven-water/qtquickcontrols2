/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.4
import QtTest 1.0
import Qt.labs.controls 1.0
import Qt.labs.templates 1.0 as T

TestCase {
    id: testCase
    width: 480
    height: 360
    visible: true
    when: windowShown
    name: "Popup"

    Component {
        id: popupTemplate
        T.Popup { }
    }

    Component {
        id: popupControl
        Popup { }
    }

    Component {
        id: rect
        Rectangle { }
    }

    SignalSpy {
        id: availableWidthSpy
        signalName: "availableWidthChanged"
    }

    SignalSpy {
        id: availableHeightSpy
        signalName: "availableHeightChanged"
    }

    SignalSpy {
        id: paddingSpy
        signalName: "paddingChanged"
    }

    SignalSpy {
        id: topPaddingSpy
        signalName: "topPaddingChanged"
    }

    SignalSpy {
        id: leftPaddingSpy
        signalName: "leftPaddingChanged"
    }

    SignalSpy {
        id: rightPaddingSpy
        signalName: "rightPaddingChanged"
    }

    SignalSpy {
        id: bottomPaddingSpy
        signalName: "bottomPaddingChanged"
    }

    function test_padding() {
        var control = popupTemplate.createObject(testCase)
        verify(control)

        paddingSpy.target = control
        topPaddingSpy.target = control
        leftPaddingSpy.target = control
        rightPaddingSpy.target = control
        bottomPaddingSpy.target = control

        verify(paddingSpy.valid)
        verify(topPaddingSpy.valid)
        verify(leftPaddingSpy.valid)
        verify(rightPaddingSpy.valid)
        verify(bottomPaddingSpy.valid)

        var paddingChanges = 0
        var topPaddingChanges = 0
        var leftPaddingChanges = 0
        var rightPaddingChanges = 0
        var bottomPaddingChanges = 0

        compare(control.padding, 0)
        compare(control.topPadding, 0)
        compare(control.leftPadding, 0)
        compare(control.rightPadding, 0)
        compare(control.bottomPadding, 0)
        compare(control.availableWidth, 0)
        compare(control.availableHeight, 0)

        control.width = 100
        control.height = 100

        control.padding = 10
        compare(control.padding, 10)
        compare(control.topPadding, 10)
        compare(control.leftPadding, 10)
        compare(control.rightPadding, 10)
        compare(control.bottomPadding, 10)
        compare(paddingSpy.count, ++paddingChanges)
        compare(topPaddingSpy.count, ++topPaddingChanges)
        compare(leftPaddingSpy.count, ++leftPaddingChanges)
        compare(rightPaddingSpy.count, ++rightPaddingChanges)
        compare(bottomPaddingSpy.count, ++bottomPaddingChanges)

        control.topPadding = 20
        compare(control.padding, 10)
        compare(control.topPadding, 20)
        compare(control.leftPadding, 10)
        compare(control.rightPadding, 10)
        compare(control.bottomPadding, 10)
        compare(paddingSpy.count, paddingChanges)
        compare(topPaddingSpy.count, ++topPaddingChanges)
        compare(leftPaddingSpy.count, leftPaddingChanges)
        compare(rightPaddingSpy.count, rightPaddingChanges)
        compare(bottomPaddingSpy.count, bottomPaddingChanges)

        control.leftPadding = 30
        compare(control.padding, 10)
        compare(control.topPadding, 20)
        compare(control.leftPadding, 30)
        compare(control.rightPadding, 10)
        compare(control.bottomPadding, 10)
        compare(paddingSpy.count, paddingChanges)
        compare(topPaddingSpy.count, topPaddingChanges)
        compare(leftPaddingSpy.count, ++leftPaddingChanges)
        compare(rightPaddingSpy.count, rightPaddingChanges)
        compare(bottomPaddingSpy.count, bottomPaddingChanges)

        control.rightPadding = 40
        compare(control.padding, 10)
        compare(control.topPadding, 20)
        compare(control.leftPadding, 30)
        compare(control.rightPadding, 40)
        compare(control.bottomPadding, 10)
        compare(paddingSpy.count, paddingChanges)
        compare(topPaddingSpy.count, topPaddingChanges)
        compare(leftPaddingSpy.count, leftPaddingChanges)
        compare(rightPaddingSpy.count, ++rightPaddingChanges)
        compare(bottomPaddingSpy.count, bottomPaddingChanges)

        control.bottomPadding = 50
        compare(control.padding, 10)
        compare(control.topPadding, 20)
        compare(control.leftPadding, 30)
        compare(control.rightPadding, 40)
        compare(control.bottomPadding, 50)
        compare(paddingSpy.count, paddingChanges)
        compare(topPaddingSpy.count, topPaddingChanges)
        compare(leftPaddingSpy.count, leftPaddingChanges)
        compare(rightPaddingSpy.count, rightPaddingChanges)
        compare(bottomPaddingSpy.count, ++bottomPaddingChanges)

        control.padding = 60
        compare(control.padding, 60)
        compare(control.topPadding, 20)
        compare(control.leftPadding, 30)
        compare(control.rightPadding, 40)
        compare(control.bottomPadding, 50)
        compare(paddingSpy.count, ++paddingChanges)
        compare(topPaddingSpy.count, topPaddingChanges)
        compare(leftPaddingSpy.count, leftPaddingChanges)
        compare(rightPaddingSpy.count, rightPaddingChanges)
        compare(bottomPaddingSpy.count, bottomPaddingChanges)

        control.destroy()
    }

    function test_availableSize() {
        var control = popupTemplate.createObject(testCase)
        verify(control)

        availableWidthSpy.target = control
        availableHeightSpy.target = control

        verify(availableWidthSpy.valid)
        verify(availableHeightSpy.valid)

        var availableWidthChanges = 0
        var availableHeightChanges = 0

        control.width = 100
        compare(control.availableWidth, 100)
        compare(availableWidthSpy.count, ++availableWidthChanges)
        compare(availableHeightSpy.count, availableHeightChanges)

        control.height = 100
        compare(control.availableHeight, 100)
        compare(availableWidthSpy.count, availableWidthChanges)
        compare(availableHeightSpy.count, ++availableHeightChanges)

        control.padding = 10
        compare(control.availableWidth, 80)
        compare(control.availableHeight, 80)
        compare(availableWidthSpy.count, ++availableWidthChanges)
        compare(availableHeightSpy.count, ++availableHeightChanges)

        control.topPadding = 20
        compare(control.availableWidth, 80)
        compare(control.availableHeight, 70)
        compare(availableWidthSpy.count, availableWidthChanges)
        compare(availableHeightSpy.count, ++availableHeightChanges)

        control.leftPadding = 30
        compare(control.availableWidth, 60)
        compare(control.availableHeight, 70)
        compare(availableWidthSpy.count, ++availableWidthChanges)
        compare(availableHeightSpy.count, availableHeightChanges)

        control.rightPadding = 40
        compare(control.availableWidth, 30)
        compare(control.availableHeight, 70)
        compare(availableWidthSpy.count, ++availableWidthChanges)
        compare(availableHeightSpy.count, availableHeightChanges)

        control.bottomPadding = 50
        compare(control.availableWidth, 30)
        compare(control.availableHeight, 30)
        compare(availableWidthSpy.count, availableWidthChanges)
        compare(availableHeightSpy.count, ++availableHeightChanges)

        control.padding = 60
        compare(control.availableWidth, 30)
        compare(control.availableHeight, 30)
        compare(availableWidthSpy.count, availableWidthChanges)
        compare(availableHeightSpy.count, availableHeightChanges)

        control.width = 0
        compare(control.availableWidth, 0)
        compare(availableWidthSpy.count, ++availableWidthChanges)
        compare(availableHeightSpy.count, availableHeightChanges)

        control.height = 0
        compare(control.availableHeight, 0)
        compare(availableWidthSpy.count, availableWidthChanges)
        compare(availableHeightSpy.count, ++availableHeightChanges)

        control.destroy()
    }

    function test_background() {
        var control = popupTemplate.createObject(testCase)
        verify(control)

        control.background = rect.createObject(testCase)

        // background has no x or width set, so its width follows control's width
        control.width = 320
        compare(control.background.width, control.width)

        // background has no y or height set, so its height follows control's height
        compare(control.background.height, control.height)
        control.height = 240

        // has width => width does not follow
        control.background.width /= 2
        control.width += 20
        verify(control.background.width !== control.width)

        // reset width => width follows again
        control.background.width = undefined
        control.width += 20
        compare(control.background.width, control.width)

        // has x => width does not follow
        control.background.x = 10
        control.width += 20
        verify(control.background.width !== control.width)

        // has height => height does not follow
        control.background.height /= 2
        control.height -= 20
        verify(control.background.height !== control.height)

        // reset height => height follows again
        control.background.height = undefined
        control.height -= 20
        compare(control.background.height, control.height)

        // has y => height does not follow
        control.background.y = 10
        control.height -= 20
        verify(control.background.height !== control.height)

        control.destroy()
    }

    function getChild(control, objname, idx) {
        var index = idx
        for (var i = index+1; i < control.children.length; i++)
        {
            if (control.children[i].objectName === objname) {
                index = i
                break
            }
        }
        return index
    }

    Component {
        id: component
        Pane {
            id: panel
            property alias button: _button;
            property alias popup: _popup;
            property alias listview: _listview
            font.pixelSize: 30
            Column {
                Button {
                    id: _button
                    text: "Button"
                    font.pixelSize: 20

                    Popup {
                        id: _popup
                        y: button.height
                        implicitHeight: Math.min(396, _listview.contentHeight)
                        contentItem: ListView {
                            id: _listview
                            height: _button.height * 20
                            model: 2
                            delegate: Button {
                                objectName: "delegate"
                                width: _button.width
                                height: _button.height
                                text: "N: " + index
                                checkable: true
                                autoExclusive: true
                            }
                        }
                    }
                }
            }
        }
    }

    function test_font() { // QTBUG_50984
        var control = component.createObject(testCase)
        verify(control)
        verify(control.button)
        verify(control.popup)
        verify(control.listview)

        waitForRendering(control)

        control.forceActiveFocus()
        verify(control.activeFocus)

        compare(control.font.pixelSize, 30)
        compare(control.button.font.pixelSize, 20)

        var popup = control.popup
        popup.open()

        verify(popup.contentItem)

        var listview = popup.contentItem
        verify(listview.contentItem)
        waitForRendering(listview)

        var idx1 = getChild(listview.contentItem, "delegate", -1)
        compare(listview.contentItem.children[idx1].font.pixelSize, 20)
        var idx2 = getChild(listview.contentItem, "delegate", idx1)
        compare(listview.contentItem.children[idx2].font.pixelSize, 20)

        control.button.font.pixelSize = control.button.font.pixelSize + 10
        compare(control.button.font.pixelSize, 30)
        waitForRendering(listview)
        compare(listview.contentItem.children[idx1].font.pixelSize, 30)
        compare(listview.contentItem.children[idx2].font.pixelSize, 30)

        control.destroy()
    }

    Component {
        id: localeComponent
        Pane {
            id: panel
            property alias button: _button;
            property alias popup: _popup;
            property alias button1: _button1;
            property alias button2: _button2;
            locale: Qt.locale("en_US")
            Column {
                Button {
                    id: _button
                    text: "Button"
                    locale: Qt.locale("nb_NO")
                    Popup {
                        id: _popup
                        y: _button.height
                        implicitHeight: Math.min(396, _column.contentHeight)
                        contentItem: Column {
                            id: _column
                            Button {
                                id: _button1
                                text: "Button 1"
                            }
                            Button {
                                id: _button2
                                text: "Button 2"
                            }
                        }
                    }
                }
            }
        }
    }

    function test_locale() { // QTBUG_50984
        // test looking up natural locale from ancestors
        var control = localeComponent.createObject(testCase)
        verify(control)
        verify(control.button)
        verify(control.popup)
        verify(control.button1)
        verify(control.button2)

        waitForRendering(control)

        control.forceActiveFocus()
        verify(control.activeFocus)

        var popup = control.popup
        popup.open()

        compare(control.locale.name, "en_US")
        compare(control.button.locale.name, "nb_NO")
        compare(control.button1.locale.name, "nb_NO")
        compare(control.button2.locale.name, "nb_NO")

        control.destroy()
    }

    Component {
        id: localeComponent2
        Pane {
            id: panel
            property alias button: _button;
            property alias popup: _popup;
            property alias button1: _button1;
            property alias button2: _button2;
            property alias localespy: _lspy;
            property alias mirroredspy: _mspy;
            property alias localespy_1: _lspy_1;
            property alias mirroredspy_1: _mspy_1;
            property alias localespy_2: _lspy_2;
            property alias mirroredspy_2: _mspy_2;
            Column {
                Button {
                    id: _button
                    text: "Button"
                    Popup {
                        id: _popup
                        y: _button.height
                        implicitHeight: Math.min(396, _column.contentHeight)
                        contentItem: Column {
                            id: _column
                            Button {
                                id: _button1
                                text: "Button 1"
                                SignalSpy {
                                    id: _lspy_1
                                    target: _button1
                                    signalName: "localeChanged"
                                }
                                SignalSpy {
                                    id: _mspy_1
                                    target: _button1
                                    signalName: "mirroredChanged"
                                }
                            }
                            Button {
                                id: _button2
                                text: "Button 2"
                                SignalSpy {
                                    id: _lspy_2
                                    target: _button2
                                    signalName: "localeChanged"
                                }
                                SignalSpy {
                                    id: _mspy_2
                                    target: _button2
                                    signalName: "mirroredChanged"
                                }
                            }
                        }
                    }
                    SignalSpy {
                        id: _lspy
                        target: _button
                        signalName: "localeChanged"
                    }
                    SignalSpy {
                        id: _mspy
                        target: _button
                        signalName: "mirroredChanged"
                    }
                }
            }
        }
    }

    function test_locale_2() { // QTBUG_50984
        // test default locale and locale inheritance
        var control = localeComponent2.createObject(testCase)
        verify(control)
        verify(control.button)
        verify(control.popup)
        verify(control.button1)
        verify(control.button2)

        waitForRendering(control)

        control.forceActiveFocus()
        verify(control.activeFocus)

        var popup = control.popup
        popup.open()

        var defaultLocale = Qt.locale()

        compare(control.locale.name, defaultLocale.name)
        compare(control.button.locale.name, defaultLocale.name)
        compare(control.button1.locale.name, defaultLocale.name)
        compare(control.button2.locale.name, defaultLocale.name)

        control.locale = Qt.locale("nb_NO")
        control.localespy.wait()
        compare(control.localespy.count, 1)
        compare(control.mirroredspy.count, 0)
        compare(control.locale.name, "nb_NO")
        compare(control.button.locale.name, "nb_NO")
        compare(control.button1.locale.name, "nb_NO")
        compare(control.button2.locale.name, "nb_NO")
        compare(control.localespy_1.count, 1)
        compare(control.mirroredspy_1.count, 0)
        compare(control.localespy_2.count, 1)
        compare(control.mirroredspy_2.count, 0)

        control.locale = Qt.locale("ar_EG")
        control.localespy.wait()
        compare(control.localespy.count, 2)
        compare(control.mirroredspy.count, 1)
        compare(control.locale.name, "ar_EG")
        compare(control.button.locale.name, "ar_EG")
        compare(control.button1.locale.name, "ar_EG")
        compare(control.button2.locale.name, "ar_EG")
        compare(control.localespy_1.count, 2)
        compare(control.mirroredspy_1.count, 1)
        compare(control.localespy_2.count, 2)
        compare(control.mirroredspy_2.count, 1)

        control.destroy()
    }

    function test_size() {
        var control = popupControl.createObject(testCase)
        verify(control)

        control.width = 200
        control.height = 200

        control.open()
        waitForRendering(control.contentItem)

        compare(control.width, 200)
        compare(control.height, 200)

        control.destroy()
    }
}
