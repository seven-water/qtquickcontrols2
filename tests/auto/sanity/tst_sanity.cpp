/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
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

#include <QtTest>
#include <QtQml>
#include <QtCore/private/qhooks_p.h>
#include <QtQml/private/qqmljsengine_p.h>
#include <QtQml/private/qqmljslexer_p.h>
#include <QtQml/private/qqmljsparser_p.h>
#include <QtQml/private/qqmljsast_p.h>
#include <QtQml/private/qqmljsastvisitor_p.h>

Q_GLOBAL_STATIC(QObjectList, qt_qobjects)

extern "C" Q_DECL_EXPORT void qt_addQObject(QObject *object)
{
    qt_qobjects->append(object);
}

extern "C" Q_DECL_EXPORT void qt_removeQObject(QObject *object)
{
    qt_qobjects->removeAll(object);
}

class tst_Sanity : public QObject
{
    Q_OBJECT

private slots:
    void init();
    void cleanup();
    void initTestCase();

    void jsFiles();
    void functions();
    void functions_data();
    void signalHandlers();
    void signalHandlers_data();
    void anchors();
    void anchors_data();
    void attachedObjects();
    void attachedObjects_data();

private:
    QQmlEngine engine;
    QMap<QString, QString> files;
};

void tst_Sanity::init()
{
    qtHookData[QHooks::AddQObject] = reinterpret_cast<quintptr>(&qt_addQObject);
    qtHookData[QHooks::RemoveQObject] = reinterpret_cast<quintptr>(&qt_removeQObject);
}

void tst_Sanity::cleanup()
{
    qt_qobjects->clear();
    qtHookData[QHooks::AddQObject] = 0;
    qtHookData[QHooks::RemoveQObject] = 0;
}

class BaseValidator : public QQmlJS::AST::Visitor
{
public:
    QString errors() const { return m_errors.join(", "); }

    bool validate(const QString& filePath)
    {
        m_errors.clear();
        m_fileName = QFileInfo(filePath).fileName();

        QFile file(filePath);
        if (!file.open(QFile::ReadOnly)) {
            m_errors += QString("%1: failed to open (%2)").arg(m_fileName, file.errorString());
            return false;
        }

        QQmlJS::Engine engine;
        QQmlJS::Lexer lexer(&engine);
        lexer.setCode(QString::fromUtf8(file.readAll()), /*line = */ 1);

        QQmlJS::Parser parser(&engine);
        if (!parser.parse()) {
            foreach (const QQmlJS::DiagnosticMessage &msg, parser.diagnosticMessages())
                m_errors += QString("%s:%d : %s").arg(m_fileName).arg(msg.loc.startLine).arg(msg.message);
            return false;
        }

        QQmlJS::AST::UiProgram* ast = parser.ast();
        ast->accept(this);
        return m_errors.isEmpty();
    }

protected:
    void addError(const QString& error, QQmlJS::AST::Node *node)
    {
        m_errors += QString("%1:%2 : %3").arg(m_fileName).arg(node->firstSourceLocation().startLine).arg(error);
    }

private:
    QString m_fileName;
    QStringList m_errors;
};

static QMap<QString, QString> listQmlFiles(const QDir &dir)
{
    QMap<QString, QString> files;
    foreach (const QFileInfo &entry, dir.entryInfoList(QStringList() << "*.qml" << "*.js", QDir::Files))
        files.insert(entry.baseName(), entry.absoluteFilePath());
    return files;
}

void tst_Sanity::initTestCase()
{
    QQmlEngine engine;
    foreach (const QString &path, engine.importPathList()) {
        files.unite(listQmlFiles(QDir(path + "/QtQuick/Calendar.2")));
        files.unite(listQmlFiles(QDir(path + "/QtQuick/Controls.2")));
        files.unite(listQmlFiles(QDir(path + "/QtQuick/Extras.2")));
    }
}

void tst_Sanity::jsFiles()
{
    QMap<QString, QString>::const_iterator it;
    for (it = files.begin(); it != files.end(); ++it) {
        if (QFileInfo(it.value()).suffix() == QStringLiteral("js"))
            QFAIL(qPrintable(it.value() +  ": JS files are not allowed"));
    }
}

class FunctionValidator : public BaseValidator
{
protected:
    virtual bool visit(QQmlJS::AST::FunctionDeclaration *node)
    {
        addError("function declarations are not allowed", node);
        return true;
    }
};

void tst_Sanity::functions()
{
    QFETCH(QString, control);
    QFETCH(QString, filePath);

    FunctionValidator validator;
    if (!validator.validate(filePath))
        QFAIL(qPrintable(validator.errors()));
}

void tst_Sanity::functions_data()
{
    QTest::addColumn<QString>("control");
    QTest::addColumn<QString>("filePath");

    QMap<QString, QString>::const_iterator it;
    for (it = files.begin(); it != files.end(); ++it)
        QTest::newRow(qPrintable(it.key())) << it.key() << it.value();
}

class SignalHandlerValidator : public BaseValidator
{
protected:
    static bool isSignalHandler(const QStringRef &name)
    {
        return name.length() > 2 && name.startsWith("on") && name.at(2).isUpper();
    }

    virtual bool visit(QQmlJS::AST::UiScriptBinding *node)
    {
        QQmlJS::AST::UiQualifiedId* id = node->qualifiedId;
        if ((id && isSignalHandler(id->name)) || (id && id->next && isSignalHandler(id->next->name)))
            addError("signal handlers are not allowed", node);
        return true;
    }
};

void tst_Sanity::signalHandlers()
{
    QFETCH(QString, control);
    QFETCH(QString, filePath);

    SignalHandlerValidator validator;
    if (!validator.validate(filePath))
        QFAIL(qPrintable(validator.errors()));
}

void tst_Sanity::signalHandlers_data()
{
    QTest::addColumn<QString>("control");
    QTest::addColumn<QString>("filePath");

    QMap<QString, QString>::const_iterator it;
    for (it = files.begin(); it != files.end(); ++it)
        QTest::newRow(qPrintable(it.key())) << it.key() << it.value();
}

void tst_Sanity::anchors()
{
    QFETCH(QString, control);
    QFETCH(QString, filePath);

    QQmlComponent component(&engine);
    component.loadUrl(QUrl::fromLocalFile(filePath));

    QScopedPointer<QObject> object(component.create());
    QVERIFY(object.data());
    foreach (QObject *object, *qt_qobjects)
        QVERIFY2(!object->inherits("QQuickAnchors"), "Anchors are not allowed");
}

void tst_Sanity::anchors_data()
{
    QTest::addColumn<QString>("control");
    QTest::addColumn<QString>("filePath");

    QMap<QString, QString>::const_iterator it;
    for (it = files.begin(); it != files.end(); ++it)
        QTest::newRow(qPrintable(it.key())) << it.key() << it.value();
}

void tst_Sanity::attachedObjects()
{
    QFETCH(QString, control);
    QFETCH(QString, filePath);

    QQmlComponent component(&engine);
    component.loadUrl(QUrl::fromLocalFile(filePath));

    QSet<QString> classNames;
    QScopedPointer<QObject> object(component.create());
    QVERIFY(object.data());
    foreach (QObject *object, *qt_qobjects) {
        QString className = object->metaObject()->className();
        if (className.endsWith("Attached"))
            QVERIFY2(!classNames.contains(className), qPrintable(QString("Multiple instances of attached type %1").arg(className)));
        classNames.insert(className);
    }
}

void tst_Sanity::attachedObjects_data()
{
    QTest::addColumn<QString>("control");
    QTest::addColumn<QString>("filePath");

    QMap<QString, QString>::const_iterator it;
    for (it = files.begin(); it != files.end(); ++it)
        QTest::newRow(qPrintable(it.key())) << it.key() << it.value();
}

QTEST_MAIN(tst_Sanity)

#include "tst_sanity.moc"