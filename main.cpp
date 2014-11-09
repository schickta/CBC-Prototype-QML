#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include "knobencoder.h"
#include "cbccalculator.h"
#include "configuration.h"

#include <QtQuick>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickItem>

#include <QDebug>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/CBCPrototype/main.qml"));

    /**************************************************************
     * Create a Knob Encoder object and set it into the QML context.
     */
    KnobEncoder* knobEncoder = new KnobEncoder(NULL, NULL, NULL);
    knobEncoder->start();

    viewer.rootContext()->setContextProperty
            ("KnobEncoder", knobEncoder);

        // Connect the knobEncoder signal to the QML slot so that we can
        // respond to knob events.

    QObject::connect(knobEncoder, SIGNAL(knobPositionChanged(int)),
                     viewer.rootObject(), SLOT(knobPositionChanged(int)));

    /**************************************************************
     * Create a Calculator object and set it into the QML context. This
     * object performs the CBC calculations used by the Results screen.
     */
    CBCCalculator *cbcCalc = new CBCCalculator ();

    viewer.rootContext()->setContextProperty
            ("CBCCalculator", cbcCalc);

    /**************************************************************
     * Create a Configuration object and set it into the QML context. This
     * object manages the saved settings for the application.
     */
    Configuration *settings = new Configuration ();

    viewer.rootContext()->setContextProperty ("Settings", settings);

    viewer.showExpanded();

    return app.exec();
}
