#include "knobencoder.h"
#include <phidget21.h>
#include <QDebug>
#include <QQuickItem>
#include <QtGui/QGuiApplication>




int CCONV CAttachHandler(CPhidgetHandle IFK, void *userptr)
{
    ((KnobEncoder *)userptr)->AttachHandler(IFK);
    return 0;
}
int CCONV CDetachHandler(CPhidgetHandle IFK, void *userptr)
{
    ((KnobEncoder *)userptr)->DetachHandler(IFK);
    return 0;
}

int CCONV CErrorHandler(CPhidgetHandle IFK, void *userptr, int ErrorCode, const char *unknown)
{
    ((KnobEncoder *)userptr)->ErrorHandler(IFK,ErrorCode,unknown);
    return 0;
}

int CCONV PositionChangeHandler(CPhidgetEncoderHandle ENC, void *userptr, int Index, int Time, int RelativePosition)
{
    int Position;
    CPhidgetEncoder_getPosition(ENC, Index, &Position);
    ((KnobEncoder *)userptr)->UpdatePosition(Position, Time, RelativePosition);
    //printf("Encoder #%i - Position: %5d -- Relative Change %2d -- Elapsed Time: %5d \n", Index, Position, RelativePosition, Time);

    return 0;
}


KnobEncoder::KnobEncoder(QObject *parent, QObject* qmlRoot, QtQuick2ApplicationViewer* viewer ) :
    QObject(parent)
{
    m_qmlRoot = qmlRoot;
    m_viewer = viewer;

    if (!qmlRoot) {
        printf ("mqlRoot is null\n");
    }

}



int KnobEncoder::UpdatePosition(int Index, int Time, int RelativePosition)
{
    //this->ui->lineEdit->setText(QString("%1").arg(Index));
    //this->ui->lineEdit_2->setText(QString("%1").arg(RelativePosition));
    //this->ui->lineEdit_3->setText(QString("%1").arg(Time));


    // Working Code *******
//    m_viewer->setCursor(QCursor(Qt::WaitCursor));

//    QQuickItem *img = qobject_cast<QQuickItem*>(m_qmlRoot);
//    img->setY(RelativePosition + img->y());
//    int newPosition = RelativePosition + img->property("contentY").value<int>();
//    img->setProperty("contentY", newPosition);

//    m_viewer->setCursor(QCursor(Qt::ArrowCursor));
    //******* End Working Code

    //QDeclarativeProperty::(img, "contentY").write(newPosition);


    //img->setFlag(QQuickItem::ItemHasContents, true);
    //img->update();

    emit knobPositionChanged (RelativePosition);

    qDebug("Here %d\n", RelativePosition);
    return 0;
}


void KnobEncoder::start()
{
    int val = CPhidgetEncoder_create(&encoderID);
    qDebug() << "Val:  " << val;
    CPhidget_set_OnAttach_Handler((CPhidgetHandle)encoderID, CAttachHandler, this);
    CPhidget_set_OnDetach_Handler((CPhidgetHandle)encoderID, CDetachHandler, this);
    CPhidget_set_OnError_Handler((CPhidgetHandle)encoderID, CErrorHandler, this);
    //Registers a callback that will run if the encoder changes.
    //Requires the handle for the Encoder, the function that will be called, and an arbitrary pointer that will be supplied to the callback function (may be NULL).
    CPhidgetEncoder_set_OnPositionChange_Handler(encoderID, PositionChangeHandler, this);
    CPhidget_open((CPhidgetHandle)encoderID, -1);
    qDebug("Done");
}

int KnobEncoder::AttachHandler(CPhidgetHandle IFK)
{
    int serialNo;
    const char *name;

    CPhidget_getDeviceName(IFK, &name);
    CPhidget_getSerialNumber(IFK, &serialNo);

    qDebug("%s %10d attached!\n", name, serialNo);

    return 0;
}

int KnobEncoder::DetachHandler(CPhidgetHandle IFK)
{
    int serialNo;
    const char *name;

    CPhidget_getDeviceName (IFK, &name);
    CPhidget_getSerialNumber(IFK, &serialNo);

    qDebug("%s %10d detached!\n", name, serialNo);

    return 0;
}

int KnobEncoder::ErrorHandler(CPhidgetHandle IFK, int ErrorCode, const char *unknown)
{
    qDebug("Error handled. %d - %s", ErrorCode, unknown);

    return 0;
}
