#ifndef KNOBENCODER_H
#define KNOBENCODER_H

#include <QObject>
#include "phidget21.h"
#include <qtquick2applicationviewer.h>

class KnobEncoder : public QObject
{
    Q_OBJECT
public:
    explicit KnobEncoder(QObject *parent,
                         QObject* qmlRoot,
                         QtQuick2ApplicationViewer* viewer );

    void start();
    int AttachHandler(CPhidgetHandle IFK);
    int DetachHandler(CPhidgetHandle IFK);
    int ErrorHandler(CPhidgetHandle IFK, int ErrorCode, const char *unknown);

    int UpdatePosition(int Index, int Time, int RelativePosition);

private:

    QObject* m_qmlRoot;
    QtQuick2ApplicationViewer* m_viewer;
    CPhidgetEncoderHandle encoderID;
    CPhidgetInterfaceKitHandle ifKit;

signals:
    void knobPositionChanged (int newValue);

};

#endif // KNOBENCODER_H
