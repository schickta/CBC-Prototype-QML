import QtQuick 2.0


Rectangle {
    color: "#e6e6e6"
    height: parent.height;
    width: parent.width;

    property int imageToProcess: 0;

    property int moveLeftAmmount: 1
    property int moveRightAmmount: 1

    // Markers
    property var markerLocations: [];
    property var markerNames: [];
    property var markerColors: [];
    property int markerMax: 8;
    property var markerStack: [];

    // Externally available
    property alias pMainCanvas:  mainCanvas;
    property alias pImageScroll: imageScroll;
    property alias pInterfaceLocale: markInterfaceLocation;
    property alias pMainImagePanel: mainImageDiv_h;
    property alias pMainImage: mainImage;
    property alias pPreviewCanvas: previewCanvas;
    property alias pPreviewThumb: previewThumb;
    property alias pPromptText: promptText;

    property alias pShowReport: showReportButton;
    property alias pMarkInterface: markInterfaceButton;

    Rectangle {
        color: "#e6e6e6";
        height: parent.height;
        width: 20;
        x: parent.width;
    }

    Rectangle {
        id: mainImagePanel_h;

        height: parent.height * .8;
        width: parent.width * .75;

        color: "#e6e6e6";
        radius: 14;
        border.color: "#d4d4d4";
        border.width: 4;

        anchors.left: parent.left;
        anchors.leftMargin: 10;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 10;
    }

    Rectangle {
        id: controlPanelMain;
        radius: 10;
        color: "#808080";
        border.color: "#d4d4d4";

        anchors.left: markInterfaceButton.left;
        anchors.leftMargin: -5;
        anchors.bottom: markInterfaceButton.bottom;
        anchors.bottomMargin: -5;
        anchors.right: markInterfaceButton.right;
        anchors.rightMargin: -5;
        anchors.top: moveLeftButton.top;
        anchors.topMargin: -5;
    }

    Rectangle {
        id: controlPanel;
        radius: 10;
        color: "#808080";
        border.color: "#d4d4d4";

        anchors.left: captureImageButton.left;
        anchors.leftMargin: -5;
        anchors.bottom: captureImageButton.bottom;
        anchors.bottomMargin: -5;
        anchors.right: backButton.right;
        anchors.rightMargin: -5;
        anchors.top: captureImageButton.top;
        anchors.topMargin: -5;
    }

    Item {
        id: previewDiv

        anchors.left: parent.left;
        anchors.leftMargin: 10;
        anchors.right: parent.right;
        anchors.rightMargin: 10;
        anchors.top: parent.top;
        anchors.topMargin: 10;

        Image {
            id: previewImage

            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            anchors.top: parent.top;
            anchors.topMargin: 10;

            //source: "img/Samples/SampleImage_01_Horizontal.png"
            fillMode: Image.PreserveAspectFit;
            sourceSize.width: 1240;
            sourceSize.height: 1240;

            MouseArea {
                id: regionPreviewImage;
                anchors.fill: parent;

                onClicked: {
                    var mainY = mapToMainImageY (mouse.x);

                    var pvt = mapToPreviewThumbY (mainY);

                    imageScrollMainAnimation.to = mainY;
                    imageScrollPreviewAutomation.to = pvt;
                    imageScrollAnimation.running = true;
                }
            }
        }

        Rectangle {
            id: sampleImageRoundedCorners;

            anchors.left: previewImage.left;
            anchors.leftMargin: -4;
            anchors.top: previewImage.top;
            anchors.right: previewImage.right;
            anchors.rightMargin: -4;
            height: previewImage.height + 1;
            width: previewImage.width + 8;

            color: "transparent"
            border.color: "#e6e6e6"
            border.width: 4;
            radius: 10;
        }

        Rectangle {
            id: sampleImageRoundedCornersOverlay;

            anchors.left: previewImage.left;
            anchors.leftMargin: -4;
            anchors.top: previewImage.top;
            anchors.right: previewImage.right;
            anchors.rightMargin: -4;
            height: previewImage.height + 1;
            width: previewImage.width + 8;

            color: "transparent"
            border.color: "#e6e6e6"
            border.width: 4;
        }

        Rectangle {
            id: previewThumb
            height: previewImage.height + 12;

            color: "#00000000"
            border.width: 3
            border.color: "#6AB5C5"

            anchors.top: previewImage.top;
            anchors.topMargin: -8;
        }

        Canvas {
            id: previewCanvas;

            x: previewImage.x;
            y: previewImage.y;
            width: previewImage.width;
            height: previewImage.height;
        }
    }

    Item {
        id: mainImageDiv_h

        height: mainImagePanel_h.height - 15;
        width: mainImagePanel_h.width - 15;

        anchors.left: mainImagePanel_h.left;
        anchors.bottom: mainImagePanel_h.bottom;

         Flickable {
            id: imageScroll;
            objectName: "imageScroll";

            width: mainImageDiv_h.width;
            height: mainImageDiv_h.height;

            anchors.left: mainImageDiv_h.left;
            anchors.leftMargin: 10;
            anchors.bottom: mainImageDiv_h.bottom;
            anchors.bottomMargin: 10;

            rightMargin: mainImageDiv_h.width / 2;
            leftMargin: mainImageDiv_h.width / 2;

            interactive: true;
            flickableDirection: Flickable.HorizontalFlick;

            //** Flickables dont implement anchors, so we
            //** have to position it the ol' fashion way.
            //** Make the width and height fractions of the
            //** parent and center withing the panel.

            //** Make the flickable touch-sensitive. To do so,
            //** we must set the contentHeight larger than the
            //** flickable's height.

            contentWidth: mainImage.width;
            contentHeight: mainImage.height;

            clip: true;

            onMovementStarted: {
                clearMarkers();
            }

            onMovementEnded: {
                drawMarkers ();

                var pvt = mapToPreviewThumbY (imageScroll.contentX);
                previewThumb.x = pvt;

            }

            Image {
                id: mainImage

                //** The image is 200 x 3664. We're going to set the width
                //** according to our screen dimensions, then set the
                //** hight relative to that, keeping the aspect ratio
                //** in mind.

                y: 50;

                height: 200 * 2;
                width: 3660 * 2;

                fillMode: Image.PreserveAspectFit;
                sourceSize.width: 1024
                sourceSize.height: 1024

                onSourceChanged: {
                    clearMarkers();
                }
            }
        }

         Canvas {
             id: mainCanvas;
             x: 0;
             y: -10;

             width: parent.width;
             height: parent.height;
         }
    }

    Rectangle {
        id: mainImageRoundedCorners;

        anchors.left: mainImagePanel_h.left;
        anchors.leftMargin: 10;
        anchors.right: mainImagePanel_h.right;
        anchors.rightMargin: 5;
        anchors.bottom: mainImagePanel_h.bottom;
        anchors.bottomMargin: 10;
        anchors.top: mainImagePanel_h.top;
        anchors.topMargin: 5;

        color: "transparent"
        border.color: "#e6e6e6"
        border.width: 4;
        radius: 10;
    }

    Rectangle {
        id: mainImageRoundedCornersOverlay;

        anchors.left: mainImagePanel_h.left;
        anchors.leftMargin: 10;
        anchors.right: mainImagePanel_h.right;
        anchors.rightMargin: 5;
        anchors.bottom: mainImagePanel_h.bottom;
        anchors.bottomMargin: 10;
        anchors.top: mainImagePanel_h.top;
        anchors.topMargin: 5;

        color: "transparent"
        border.color: "#e6e6e6"
        border.width: 4;
    }

    Image {
        id: markInterfaceLocation;

        anchors.top: mainImagePanel_h.top;
        anchors.left: mainImageDiv_h.left;
        anchors.leftMargin: ((mainImageDiv_h.width / 2) - (markInterfaceLocation.width / 2.5));

        height: mainImagePanel_h.height; // - 6;

        fillMode: Image.PreserveAspectFit;

        source: "img/Marker_Position_Vertical.png";
    }

    Image {
        id: showReportButton;

        anchors.left: mainImagePanel_h.right;
        anchors.leftMargin: 10;
        anchors.bottom: mainImagePanel_h.bottom;
        anchors.bottomMargin: 5;

        visible: false;

        width: parent.width * .25 - 20;

        MouseArea {
            anchors.fill: showReportButton

            onPressed: {
                showReportButton.source = "img/ButtonsDown/ShowReport_Down.png"
            }

            onReleased: {
                showReportButton.source = "img/ButtonsUp/ShowReport_Up.png"
            }

            onClicked: {
                var ret = CBCCalculator.calculate(markerLocations[0],
                                                  markerLocations[1],
                                                  markerLocations[2],
                                                  markerLocations[3],
                                                  markerLocations[4],
                                                  markerLocations[5],
                                                  markerLocations[6],
                                                  markerLocations[7]);

                // Unload, then reload the results page to refresh
                // the new calculated values.

                resultsLoader.source = "";
                resultsLoader.source = "./results_h.qml";

                natarget.target = resultsPage;
                natarget.from = mainform_horizontal.y + mainform_horizontal.height;
                natarget.to = 0;
                naprevious.target = analysispage;
                naprevious.from = undefined;
                naprevious.to = -mainform_horizontal.height - 40;
                navigateToPage.running = true;
            }
        }

        source: "img/ButtonsUp/ShowReport_Up.png";
    }

    Image {
        id: markInterfaceButton

        anchors.left: mainImagePanel_h.right;
        anchors.leftMargin: 10;
        anchors.bottom: mainImagePanel_h.bottom;
        anchors.bottomMargin: 5;

        width: parent.width * .25 - 20;

        MouseArea {
            anchors.fill: markInterfaceButton

            onPressed: {
                markInterfaceButton.source = "img/ButtonsDown/Mark_Down.png"
            }

            onReleased: {
                markInterfaceButton.source = "img/ButtonsUp/Mark_Up.png"
            }

            onClicked: {

                if (markerLocations.length < markerMax) {

                    markerLocations.push(imageScroll.contentX + imageScroll.width / 2);

                    drawMarkers();
                    drawPreviewMarkers();

                    if (markerLocations.length >= markerMax)
                    {
                        showReportButton.visible = true;
                        markInterfaceButton.visible = false;
                        updatePrompt("Mark again for report");
                    }
                    else
                    {
                        updatePrompt ();
                        //updateMarkerStack ();
                    }
                }

                else {
                    var ret = CBCCalculator.calculate(markerLocations[0],
                                                      markerLocations[1],
                                                      markerLocations[2],
                                                      markerLocations[3],
                                                      markerLocations[4],
                                                      markerLocations[5],
                                                      markerLocations[6],
                                                      markerLocations[7]);

                    // Unload, then reload the results page to refresh
                    // the new calculated values.

                    resultsLoader.source = "";
                    resultsLoader.source = "./results_h.qml";

                    natarget.target = resultsPage;
                    natarget.from = undefined;
                    natarget.to = 0;
                    naprevious.target = analysispage;
                    naprevious.from = undefined;
                    naprevious.to = -mainform_horizontal.height - 40;
                    navigateToPage.running = true;
                }
            }
        }

        source: "img/ButtonsUp/Mark_Up.png"
    }

    Image {
        id: moveLeftButton

        anchors.left: markInterfaceButton.left;
        anchors.bottom: markInterfaceButton.top;
        anchors.bottomMargin: 10;

        fillMode: Image.PreserveAspectFit;

        MouseArea {
            anchors.fill: moveLeftButton

            onPressed: {
                moveLeftButton.source = "img/ButtonsDown/MoveLeft_Down.png"
                startMoveLeftTimer.start();
            }

            onReleased: {
                moveLeftButton.source = "img/ButtonsUp/MoveLeft_Up.png"
                startMoveLeftTimer.stop();
                moveLeftTimer.stop();

                var pvt = mapToPreviewThumbY (imageScroll.contentX);
                previewThumb.x = pvt;

                drawMarkers();
            }

            onClicked: {

                if (imageScroll.contentX >= -450) {
                    imageScroll.contentX = imageScroll.contentX - 1;
                }
            }
        }

        source: "img/ButtonsUp/MoveLeft_Up.png"
    }

    Image {
        id: moveRightButton

        anchors.right: markInterfaceButton.right;
        anchors.bottom: markInterfaceButton.top;
        anchors.bottomMargin: 10;

        fillMode: Image.PreserveAspectFit;

        MouseArea {
            anchors.fill: moveRightButton

            onPressed: {
                moveRightButton.source = "img/ButtonsDown/MoveRight_Down.png"
                startMoveRightTimer.start();
            }

            onReleased: {
                moveRightButton.source = "img/ButtonsUp/MoveRight_Up.png"
                startMoveRightTimer.stop();
                moveRightTimer.stop();

                var pvt = mapToPreviewThumbY (imageScroll.contentX);
                previewThumb.x = pvt;

                drawMarkers();
            }

            onClicked: {
                if (imageScroll.contentX <= 3660 * 2 - imageScroll.width / 2) {
                    imageScroll.contentX = imageScroll.contentX + 1;
                }
            }
        }

        source: "img/ButtonsUp/MoveRight_Up.png"
    }

    Image {
        id: captureImageButton

        anchors.left: moveLeftButton.left;
        anchors.top: mainImagePanel_h.top;
        anchors.topMargin: 5;

        fillMode: Image.PreserveAspectFit;

        MouseArea {
            anchors.fill: captureImageButton

            onPressed: {
                captureImageButton.source = "img/ButtonsDown/Capture_Down.png"
            }

            onReleased: {
                captureImageButton.source = "img/ButtonsUp/Capture_Up.png"
            }

            onClicked: {
                markerLocations = [];
                clearMarkers();
                clearPreviewMarkers();
                updatePrompt();

                imageToProcess = imageToProcess + 1;

                cameraFlashAnimationInitial.running = true;
                changeSampleImage();
                cameraFlashAnimationFinish.running = true;

                showReportButton.visible = false;
                markInterfaceButton.visible = true;

                //updateMarkerStack ();
            }
        }

        source: "img/ButtonsUp/Capture_Up.png"
    }

    Image {
        id: backButton

        anchors.right: moveRightButton.right;
        anchors.top: mainImagePanel_h.top;
        anchors.topMargin: 5;

        fillMode: Image.PreserveAspectFit;

        MouseArea {
            anchors.fill: backButton

            onPressed: {
                backButton.source = "img/ButtonsDown/Back_Down.png"
            }

            onReleased: {
                backButton.source = "img/ButtonsUp/Back_Up.png"
            }

            onClicked: {

                if (markerLocations.length > 0) {

                    var lastLocation = markerLocations.pop ();

                    // Adjust to put the location into the middle of the
                    // image and preview frames.

                    lastLocation -= imageScroll.width / 2;

                    // Map the main image (mid-point) location to the
                    // preview location, then animate the scroll in both
                    // images to center on the prior marker location.

                    var pvt = mapToPreviewThumbY (lastLocation);

                    imageScrollMainAnimation.to = lastLocation;
                    imageScrollPreviewAutomation.to = pvt;
                    imageScrollAnimation.running = true;

                    // Update the preview and prompt Note, by animating
                    // the scroll, the main image markers are auto-
                    // matically updated.

                    drawPreviewMarkers();
                    //updateMarkerStack ();

                    showReportButton.visible = false;
                    markInterfaceButton.visible = true;

                    updatePrompt();
                }

                else {
                    natarget.target = startuppage;
                    natarget.from = undefined;
                    natarget.to = 0;
                    naprevious.target = analysispage;
                    naprevious.from = undefined;
                    naprevious.to = mainform_horizontal.height + 40;
                    navigateToPage.running = true;
                }
            }
        }

        source: "img/ButtonsUp/Back_Up.png"
    }

    Item {
        id: promptDivStatic;

        height: 30;

        anchors.bottom: promptDiv.top;
        anchors.bottomMargin: 10;
        anchors.horizontalCenter: markInterfaceButton.horizontalCenter;

        Text {
            id: promptTextStatic;
            text: "Select Interface:"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width;
            font.bold: true
            font.family: "Helvetica"
            font.pointSize: 16;
            color: "black"
            font.underline: true;
        }
    }

    Item {
        id: promptDiv;

        height: 30;

        anchors.verticalCenter: parent.verticalCenter;
        anchors.horizontalCenter: markInterfaceButton.horizontalCenter;

        Text {
            id: promptText;
            text: "Top of Closure"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width;
            font.bold: true
            font.family: "Helvetica"
            font.pointSize: 16;
            color: "black"
        }
    }

    function changeSampleImage () {

        var imageToShow = imageToProcess % 5;

        if (imageToShow == 0)
        {
            previewImage.source = "img/Samples/SampleImage_01_Horizontal.png";
            mainImage.source = "img/Samples/SampleImage_01_Horizontal.png";
        }
        else if (imageToShow == 1)
        {
            previewImage.source = "img/Samples/SampleImage_02_Horizontal.png";
            mainImage.source = "img/Samples/SampleImage_02_Horizontal.png";
        }
        else if (imageToShow == 2)
        {
            previewImage.source = "img/Samples/SampleImage_03_Horizontal.png";
            mainImage.source = "img/Samples/SampleImage_03_Horizontal.png";
        }
        else if (imageToShow == 3)
        {
            previewImage.source = "img/Samples/SampleImage_04_Horizontal.png";
            mainImage.source = "img/Samples/SampleImage_04_Horizontal.png";
        }
        else if (imageToShow == 4)
        {
            previewImage.source = "img/Samples/SampleImage_05_Horizontal.png";
            mainImage.source = "img/Samples/SampleImage_05_Horizontal.png";
        }

        imageScroll.contentX = 3660 * 2 - imageScroll.width / 2;
        var pvt = mapToPreviewThumbY(imageScroll.contentX);
        previewThumb.x = pvt;

        drawPreviewMarkers();
        drawMarkers();
        updatePrompt ();
    }

    function mapToPreviewThumbY (mainYPos) {
        var previewY = (mainYPos * previewImage.width) / mainImage.width;

        return (previewY);
    }

    function mapToMainImageY (previewYPos) {
        var mainY = (previewYPos * mainImage.width) / previewImage.width + mainImageDiv_h.x;

        return (mainY - (imageScroll.width / 2));
    }

    function previewThumbHeight () {
        var thumbHeight = 69;

        return (thumbHeight + 16);
    }

    function itemLoaded () {

        markerNames.push ("Top of Closure");
        markerNames.push ("Bottom of Float");
        markerNames.push ("Top of RBCs");
        markerNames.push ("Granulocytes");
        markerNames.push ("Lymph & Mono");
        markerNames.push ("Top of Platelets");
        markerNames.push ("Top of Float");
        markerNames.push ("Meniscus");

        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");
        markerColors.push ("#0791AC");

        changeSampleImage();
    }

    ParallelAnimation {

        id: imageScrollAnimation;

        PropertyAnimation {
            id: imageScrollMainAnimation;
            target: imageScroll;
            property: "contentX";
            easing.type: Easing.InOutQuad;
            duration: 1000;
        }

        PropertyAnimation {
            id: imageScrollPreviewAutomation;
            target: previewThumb;
            property: "x";
            easing.type: Easing.InOutQuad;
            duration: 1000;
       }

        onRunningChanged: {

            if (imageScrollAnimation.running) {  // started
                clearMarkers ();
            }
            else { // stopped
                drawMarkers();
            }
        }
    }

    Timer{
        id: startMoveLeftTimer
        interval: 200
        running: false
        repeat: false
        onTriggered: {

            moveLeftAmmount = 1;
            moveLeftTimer.start();
        }
    }

    Timer{
        id: startMoveRightTimer
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            moveRightAmmount = 1;
            moveRightTimer.start();
        }
    }

    Timer{
        id: moveLeftTimer
        interval: 15
        running: false
        repeat: true
        onTriggered: {

            if (imageScroll.contentX >= -450) {
                imageScroll.contentX = imageScroll.contentX - moveLeftAmmount;
                moveLeftAmmount = moveLeftAmmount + 1;
                drawMarkers();
            }
        }
    }

    Timer{
        id: moveRightTimer
        interval: 15
        running: false
        repeat: true
        onTriggered: {
            if (imageScroll.contentX <= 3660 * 2 - imageScroll.width / 2) {
                imageScroll.contentX = imageScroll.contentX + moveRightAmmount;
                moveRightAmmount = moveRightAmmount + 1;
                drawMarkers();
            }
        }
    }

    Timer{
        id: updateThumbTimer;
        interval: 1;
        running: true;
        repeat: false;

        onTriggered: {            

            imageScroll.contentX = 3660 * 2 - imageScroll.width / 2;
            var pvt = mapToPreviewThumbY(imageScroll.contentX);
            previewThumb.x = pvt;

            previewThumb.width = mainImageDiv_h.width * previewImage.width / mainImage.width;
        }
    }
}
