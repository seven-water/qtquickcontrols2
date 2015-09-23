/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QQUICKTEXTAREA_P_P_H
#define QQUICKTEXTAREA_P_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include <QtQuick/private/qquicktextedit_p_p.h>
#include <QtQuickTemplates/private/qquickpressandholdhelper_p.h>

#include "qquicktextarea_p.h"

QT_BEGIN_NAMESPACE

class QQuickAccessibleAttached;

class QQuickTextAreaPrivate : public QQuickTextEditPrivate
{
    Q_DECLARE_PUBLIC(QQuickTextArea)

public:
    QQuickTextAreaPrivate() : background(Q_NULLPTR), placeholder(Q_NULLPTR), accessibleAttached(Q_NULLPTR) { }

    static QQuickTextAreaPrivate *get(QQuickTextArea *item) {
        return static_cast<QQuickTextAreaPrivate *>(QObjectPrivate::get(item)); }

    void resizeBackground();
    void resolveFont();

    void _q_readOnlyChanged(bool isReadOnly);
    void _q_placeholderTextChanged(const QString &text);

    QQuickItem *background;
    QQuickText *placeholder;
    QQuickPressAndHoldHelper pressAndHoldHelper;
    QQuickAccessibleAttached *accessibleAttached;
};

Q_DECLARE_TYPEINFO(QQuickTextAreaPrivate, Q_COMPLEX_TYPE);

QT_END_NAMESPACE

#endif // QQUICKTEXTAREA_P_P_H