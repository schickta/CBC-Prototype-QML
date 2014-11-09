import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: mainform_horizontal
    color: "#e6e6e6"

    width: 1280;
    height: 800;

    property int hMargin: 0; //width / 100;
    property int vMargin: 0; //height / 100;
    property int hMainImageMargin: 0; //width / 15;
    property real markerVOffset: 0; //.12;
    property bool horizontalLayout: (width > height ? true : false);
    property int knobScrollRate: Settings.KnobSensitivity;

    property alias pAnalysisPage: analysispage;
    property alias pAnalysisLoader: analysisLoader;

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

    Component.onCompleted: {
        console.log ("Horizontal Layout = ", horizontalLayout);
    }

    Rectangle {
        id: overscan;
        color: "black";
        anchors.right: parent.right;
        anchors.left: parent.left;
        anchors.top: parent.bottom;
        anchors.topMargin: -Settings.HorizontalOverscan;
        anchors.bottom: parent.bottom;

    }

    Rectangle {
        id : topstatusbar
        height: 40
        width: parent.width
        color : "#002d70"

        Text {
            id: timeText
            anchors.verticalCenter: parent.verticalCenter
            x: 10
            font.pointSize: 16
            color: "white"
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

        anchors.top: topstatusbar.bottom;
        anchors.bottom: overscan.top;
        anchors.left: parent.left;
        anchors.right: parent.right;

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
                source: "./startuppage_h.qml";
            }
        }

        Rectangle {
            id: analysispage
            objectName: "analysispage";

            x: -6
            y: mainform_horizontal.y + mainform_horizontal.height;
            width: parent.width;
            height: parent.height;
            opacity: 1

            Loader {

                width: parent.width;
                height: parent.height;

                id: analysisLoader;
                source: "./analysispageh1.qml";

                onLoaded: {

                    item.itemLoaded ();
                }

                function scrollByIncrement (numSteps) {

                    item.pImageScroll.contentX = item.pImageScroll.contentX + numSteps;

                    if (item.pImageScroll.contentX < -item.pImageScroll.width / 2)
                    {
                        item.pImageScroll.contentX = -item.pImageScroll.width / 2;
                    }

                    else if (item.pImageScroll.contentX > item.pImageScroll.contentWidth) // -
                             //item.pImageScroll.width / 2)
                    {
                        item.pImageScroll.contentX = item.pImageScroll.contentWidth; //
                              //- item.pImageScroll.width / 2;
                    }

                    var pvt = item.mapToPreviewThumbY(item.pImageScroll.contentX);
                    item.pPreviewThumb.x = pvt;

                    // This and markRefreshTimer are used
                    // to support responsiveness of the
                    // knob controllers. We don't want to
                    // clear/refresh markers with each
                    // event otherwise there's alot of lag.

                    if (! markRefreshTimer.running) {
                        clearMarkers ();
                    }

                    markRefreshTimer.restart();
                }

                Timer {
                    id: markRefreshTimer;
                    interval: 200;
                    running: false;
                    repeat: false;

                    onTriggered: {
                        parent.drawMarkers ();
                    }
                }

                function clearMarkers () {

                    if (item.pMainCanvas.available) {
                        var context = item.pMainCanvas.getContext("2d");

                        item.pMainCanvas.requestPaint();
                        context.clearRect(0, 0, item.pMainCanvas.width, item.pMainCanvas.height);
                    }
                }

                function clearPreviewMarkers () {

                    var context = item.pPreviewCanvas.getContext("2d");

                    item.pPreviewCanvas.requestPaint();
                    context.clearRect(0, 0, item.pPreviewCanvas.width, item.pPreviewCanvas.height);
                }


                function drawMarkers () {

                    var i;
                    var xLocation;

                    if (item.pMainCanvas.available) {

                        var visibleWindowLeft = item.pImageScroll.contentX;
                        var visibleWindowRight = item.pImageScroll.contentX + item.pImageScroll.width;
                        var context = item.pMainCanvas.getContext("2d");

                        item.pMainCanvas.requestPaint();

                        context.clearRect(0, 0, item.pMainCanvas.width, item.pMainCanvas.height);

                        for (i = 0; i < item.markerLocations.length; i++) {

                            if (item.markerLocations[i] >= visibleWindowLeft &&
                                    item.markerLocations[i] <= visibleWindowRight)
                            {
                                xLocation = item.markerLocations[i] - visibleWindowLeft + 5;
                                context.beginPath();
                                context.lineWidth = 2;
                                context.strokeStyle = item.markerColors[i];
                                context.moveTo(xLocation, 0);
                                context.lineTo(xLocation, item.pMainCanvas.height);
                                context.stroke();
                                context.closePath ();
                            }
                        }
                    }
                }

                function drawPreviewMarkers () {

                    var xLocation;
                    var i;

                    if (item.pPreviewCanvas.available) {
                        var context = item.pPreviewCanvas.getContext("2d");

                        item.pPreviewCanvas.requestPaint ();

                        context.clearRect(0, 0, item.pPreviewCanvas.width, item.pPreviewCanvas.height);

                        for (i = 0; i < item.markerLocations.length; i++) {
                            xLocation = item.mapToPreviewThumbY (item.markerLocations[i]);

                            context.beginPath();
                            context.lineWidth = 1;
                            context.strokeStyle = item.markerColors[i];
                            context.moveTo(xLocation, 0);
                            context.lineTo(xLocation, item.pPreviewCanvas.height);
                            context.stroke();
                            context.closePath ();
                        }
                    }
                }

                function updatePrompt (prompttextStr) {
                    if (item.markerLocations.length === 0) {
                        item.pPromptText.text = "Top of Closure";
                    }
                    else if (prompttextStr === undefined) {
                        item.pPromptText.text = item.markerNames[item.markerLocations.length];
                    }

                    else {
                        item.pPromptText.text = prompttextStr;
                    }
                }

                function transFromStart(){
                    item.pShowReport.visible = false;
                    item.pMarkInterface.visible = true;
                    clearMarkers();
                    clearPreviewMarkers();

                    if (item.markerLocations.length > 0)
                    {
                        item.markerLocations = [];
                    }

                    item.pImageScroll.contentX = 3660 * 2 - item.pImageScroll.width / 2;
                    updatePrompt();

                    var pvt = item.mapToPreviewThumbY (item.pImageScroll.contentX);
                    item.pPreviewThumb.x = pvt;
                }
            }
        }

        Rectangle {
            id: settingspage;
            objectName: "settingspage";

            x: -6
            y: mainform_horizontal.y + mainform_horizontal.height;
            width: parent.width;
            height: parent.height;
            opacity: 1

            Loader {
                width: parent.width;
                height: parent.height;

                id: settingsLoader;
                source: "./settingspage_h.qml";
            }
        }

        Rectangle {
            id: resultsPage;
            objectName: "resultsPage";

            x: -6
            y: mainform_horizontal.y + mainform_horizontal.height;
            width: parent.width;
            height: parent.height;
            opacity: 1

            Loader {
                width: parent.width;
                height: parent.height;

                id: resultsLoader;
                source: "./results_h.qml"
            }
        }

        Rectangle {
            id: cameraFlash;
            objectName: "cameraFlash";

            height: mainform_horizontal.height;
            width: mainform_horizontal.width;

            color: "black";
            opacity: 0;
            visible: true;
        }
    }

    Rectangle {
        id: splash;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: overscan.top;

        color: parent.color;
        opacity: 1;

        Image {
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.verticalCenterOffset: -100;

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
        id: navigateToAnalysis;

        PropertyAnimation {target: analysispage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            from: mainform_horizontal.y + mainform_horizontal.height;
            to: 0
        }

        PropertyAnimation {target: startuppage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: -mainform_horizontal.height - 40
       }
    }

    ParallelAnimation {
        id: navigateToResults;

        PropertyAnimation {target: resultsPage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            from: mainform_horizontal.y + mainform_horizontal.height;
            to: 0
        }

        PropertyAnimation {target: analysispage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: -mainform_horizontal.height - 40
       }
    }

    ParallelAnimation {
        id: navigateResultsToProcessSample

        PropertyAnimation {target: analysispage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            from: mainform_horizontal.y + mainform_horizontal.height;
            to: 0;
        }

        PropertyAnimation {target: resultsPage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: -mainform_horizontal.height - 40;
       }
    }

    ParallelAnimation {
        id: navigateResultsToHome;

        PropertyAnimation {target: startuppage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            from: mainform_horizontal.y + mainform_horizontal.height;
            to: 0
        }

        PropertyAnimation {target: resultsPage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: -mainform_horizontal.height - 40
       }
    }

    ParallelAnimation {
        id: navigateToStart;

        PropertyAnimation {target: analysispage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: mainform_horizontal.height + 40;
        }

        PropertyAnimation {target: startuppage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            from: mainform_horizontal.y + mainform_horizontal.height;
            to: 0
       }
    }

    SequentialAnimation {
        id: navigateToSettings;

        PropertyAnimation {
            target: settingspage;
            property: "visible";
            duration: 100;
            to: true;
        }

        PropertyAnimation {
            target: settingspage;
            property: "opacity";
            duration: 1000;
            to: 1;
        }
    }

    SequentialAnimation {
        id: cameraFlashAnimationInitial

        PropertyAnimation {
            target: cameraFlash;
            property: "opacity";
            duration: 200;
            from: 0;
            to: 1;
        }
    }

    SequentialAnimation {
        id: cameraFlashAnimationFinish

        PropertyAnimation {
            target: cameraFlash;
            property: "opacity";
            duration: 200;
            from: 1;
            to: 0;
        }
    }

    ParallelAnimation {
        id: navigateToPage;

        PropertyAnimation {id: natarget; target: analysispage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: 0
        }

        PropertyAnimation {id: naprevious; target: startuppage; property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
            to: -mainform_horizontal.height - 40
        }
    }
}
