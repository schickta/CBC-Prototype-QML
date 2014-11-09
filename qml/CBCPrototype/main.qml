import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {

    id: mainform
    objectName: "mainform";

    height: 1280;
    width: 800;   // 800 - 65 (overscan)

    color: "#e6e6e6"

    property bool horizontalLayout: (width > height ? true : false);
    property string currentAnalysisPage: Settings.VerticalLayoutUsed;
    property int knobScrollRate: Settings.KnobSensitivity;

    focus: true;
    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            Qt.quit ();
        }

        else if (event.key === Qt.Key_1) {
            analysisLoader.scrollByIncrement (50);
        }

        else if (event.key === Qt.Key_2) {
            analysisLoader.scrollByIncrement (-50);
        }
    }

    Connections {
        target: KnobEncoder;

        onKnobPositionChanged: {

            analysisLoader.scrollByIncrement(newValue * knobScrollRate);

        }
    }

    Rectangle {
        id: overscan;
        color: "black";
        anchors.right: parent.right;
        anchors.left: parent.right;
        anchors.leftMargin: -Settings.VerticalOverscan;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;

    }

    Rectangle {
        id : topstatusbar

        anchors.top: parent.top;
        anchors.bottom: parent.top;
        anchors.bottomMargin: -40;
        anchors.left: parent.left;
        anchors.right: overscan.left;

        color : "#002d70"

        Text {
            id: timeText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            font.pointSize: 16
            color: "white"
        }

        Text {
            id: appName;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            anchors.verticalCenter: parent.verticalCenter;
            font.pointSize: 16;
            color: "white"
            text: Settings.ApplicationName;
        }

//        MouseArea {
//            anchors.fill: topstatusbar

//            onClicked: {
//                Qt.quit();
//            }
//        }
    }

    Timer{
        id: currentTimeTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatTime(new Date(), "hh:mm:ss")
        }
    }

    Rectangle {

        anchors.left: parent.left;
        anchors.top: topstatusbar.bottom;
        anchors.right: overscan.left;
        anchors.bottom: parent.bottom;

        opacity: 1;

        Rectangle {
            id: startuppage;
            opacity: 1;

            width: parent.width;
            height: parent.height;

            Loader {

                width: parent.width;
                height: parent.height;

                id: startupLoader;
                source: "./startuppage.qml";
            }
        }
    }

    Rectangle {
        id: analysispage
        objectName: "analysispage";


        x: 0
        y: mainform.y + mainform.height;
        width: parent.width - overscan.width;
        height: parent.height;
        opacity: 1

        Loader {

            width: parent.width;
            height: parent.height;

            id: analysisLoader;
            source: currentAnalysisPage;

            // onSourceChanged: {
            onLoaded: {

                item.itemLoaded ();
            }



            function scrollByIncrement (numSteps) {

                item.pImageScroll.contentY = item.pImageScroll.contentY + numSteps;

                if (item.pImageScroll.contentY < -item.pImageScroll.height / 2)
                {
                    item.pImageScroll.contentY = -item.pImageScroll.height / 2;
                }

                else if (item.pImageScroll.contentY > item.pImageScroll.contentHeight -
                         item.pImageScroll.height / 2)
                {
                    item.pImageScroll.contentY = item.pImageScroll.contentHeight
                          - item.pImageScroll.height / 2;
                }

                var pvt = item.mapToPreviewThumbY(item.pImageScroll.contentY);
                item.pPreviewThumb.y = pvt;


                // This and markRefreshTimer are used
                // to support responsiveness of the
                // knob controllers. We don't want to
                // clear/refresh markers with each
                // event otherwise there's alot of lag.

                if (! markRefreshTimer.running) {
                    item.clearMarkers ();
                }

                markRefreshTimer.restart();
            }

            Timer {
                id: markRefreshTimer;
                interval: 200;
                running: false;
                repeat: false;
                onTriggered: {
                    parent.item.drawMarkers ();
                }
            }
        }
    }


    Rectangle {
        id: settingspage;
        objectName: "settingspage";

        x: 0;
        y: mainform.y + mainform.height;
        width: parent.width - overscan.width;
        height: parent.height;

        opacity: 1;

        Loader {

            width: parent.width;
            height: parent.height;

            id: settingsLoader;
            source: "./settingspage.qml";
        }
    }

    Rectangle {
        id: resultspage;
        objectName: "resultspage";

        x: 0;
        y: mainform.y + mainform.height;
        width: parent.width - overscan.width;
        height: parent.height;

        opacity: 1

        Loader {
            width: parent.width;
            height: parent.height;

            id: resultsLoader;
            source: "./results.qml"
        }
    } 

    Rectangle {
        id: splash;
        anchors.left: parent.left;
        anchors.right: overscan.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;

        color: parent.color;
        opacity: 1;

        Image {
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.verticalCenterOffset: -300;

            source: "img/drucker-diagnostics-splash2.png"

        }

        Timer {
            id: splashTimer;
            interval: 1000;
            running: true;
            repeat: false;
            onTriggered: {
                splashAway.running = true;
            }
        }
    }

    PropertyAnimation {id: splashAway; target: splash; property: "opacity";
        easing.type: Easing.InOutQuad;
        running: false;
        duration: 3000;
        to: 0
    }

    ParallelAnimation {

        id: navigateToPage;

        PropertyAnimation {id: natarget; target: analysispage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 250;
            to: 0
        }

        PropertyAnimation {id: naprevious; target: startuppage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 250;
            to: -mainform.height - 40
       }
    }

}
