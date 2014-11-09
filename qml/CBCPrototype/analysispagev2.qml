import QtQuick 2.0

Rectangle {

    // General Layout
    property int hMargin: mainform.width / 100;
    property int vMargin: mainform.height / 100;
    property int hMainImageMargin: mainform.width / 15;
    property real markerVOffset: .12;
    property real markerGuideVerticalOffset: 6;
    property int markerStackHeightPlusMargin: 22;

    // Markers
    property var markerLocations: [];
    property var markerNames: [];
    property var markerColors: [];
    property int markerMax: 8;
    property var markerStack: [];

    // Externally available
    property alias pMainCanvas:  mainCanvas;
    property alias pMainImage: mainImage;
    property alias pImageScroll: imageScroll;
    property alias pPromptText: promptText;
    property alias pPreviewCanvas: previewCanvas;
    property alias pPreviewThumb: previewThumb;

    // Used to cycle through sample images
    property int imageToProcess: Settings.SampleImageUsed;

    Rectangle {
        id: controlPanel;
        radius: 10;

        anchors.left: previewDiv.right;
        anchors.leftMargin: 70;
        anchors.top: parent.bottom;
        anchors.topMargin: -cameraButton.height * 2.4;
        anchors.right: parent.right;
        anchors.rightMargin: hMargin;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: vMargin;

        color: "#808080";
    }

    Rectangle {
        id: markerStackPanel;

        width: 150;
        height: markerStackHeightPlusMargin * 8;
        color: "transparent";

        anchors.verticalCenter: controlPanel.verticalCenter;
        anchors.horizontalCenter: controlPanel.horizontalCenter;
        anchors.horizontalCenterOffset: -parent.width / 100 * 5
        anchors.leftMargin: hMargin * 2;
    }

    BorderImage {
        id: cameraButton;

        anchors.top: controlPanel.top;
        anchors.topMargin: vMargin;
        anchors.left: controlPanel.left;
        anchors.leftMargin: hMargin;

        MouseArea {
            id: regionCameraButton; anchors.fill: parent;

            onPressed: {
                cameraButton.source = "img/ButtonsDown/Capture_Down.png";
            }

            onReleased: {
                cameraButton.source = "img/ButtonsUp/Capture_Up.png";
            }

            onClicked: {

                showReportButton.visible = false;
                markButton.visible = true;
Bo
                imageToProcess = imageToProcess + 1;

                changeSampleImage();
            }
        }

        source: "img/ButtonsUp/Capture_Up.png";
    }

    BorderImage {
        id: undoMarkButton;

        anchors.bottom: controlPanel.bottom;
        anchors.bottomMargin: vMargin;
        anchors.left: controlPanel.left;
        anchors.leftMargin: hMargin;

        MouseArea {
            id: regionUndoMark; anchors.fill: parent;

            onPressed: {
                undoMarkButton.source = "img/ButtonsDown/Back_Down.png";
            }

            onReleased: {
                undoMarkButton.source = "img/ButtonsUp/Back_Up.png";
            }

            onClicked: {

                if (markerLocations.length > 0) {

                    showReportButton.visible = false;
                    markButton.visible = true;

                    var lastLocation = markerLocations.pop ();

                    // Adjust to put the location into the middle of the
                    // image and preview frames.

                    lastLocation -= imageScroll.height / 2;

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
                    updatePrompt ();
                    updateMarkerStack ();
                }

                else {

                    natarget.target = startuppage;
                    natarget.from = undefined;
                    natarget.to = 0;
                    naprevious.target = analysispage;
                    naprevious.from = undefined;
                    naprevious.to = mainform.height;
                    navigateToPage.running = true;
                }
            }
        }

        source: "img/ButtonsUp/Back_Up.png";
    }

    Image {
        id: showReportButton;

        anchors.verticalCenter: controlPanel.verticalCenter;
        anchors.right: controlPanel.right;
        anchors.rightMargin: hMargin;

        visible: false;

        MouseArea {
            anchors.fill: showReportButton

            onPressed: {
                showReportButton.source = "img/ButtonsDown/ShowReport_Large_Down.png"
            }

            onReleased: {
                showReportButton.source = "img/ButtonsUp/ShowReport_Large_Up.png"
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
                resultsLoader.source = "./results.qml";

                natarget.target = resultspage;
                natarget.from = undefined;
                natarget.to = 0;
                naprevious.target = analysispage;
                naprevious.from = undefined;
                naprevious.to = -mainform.height - 40;
                navigateToPage.running = true;

            }
        }

        source: "img/ButtonsUp/ShowReport_Large_Up.png";
    }

    BorderImage {
        id: markButton;

        anchors.verticalCenter: controlPanel.verticalCenter;
        anchors.right: controlPanel.right;
        anchors.rightMargin: hMargin;

        visible: true;

        MouseArea {
            id: regionMark; anchors.fill: parent;

            onPressed: {
                markButton.source = "img/ButtonsDown/MarkInterfaceButton_Large_Down.png";
            }

            onReleased: {
                markButton.source = "img/ButtonsUp/MarkInterfaceButton_Large_Up.png";
            }

            onClicked: {
                if (markerLocations.length < markerMax) {

                    markerLocations.push
                            (imageScroll.contentY + mainCanvas.height / 2 - vMargin);

                    updateMarkerStack ();
                    drawPreviewMarkers();
                    drawMarkers();

                    if (markerLocations.length < markerMax) {
                        updatePrompt ();

                    }
                    else {
                        updatePrompt("Mark again for report");
                        showReportButton.visible = true;
                        markButton.visible = false;
                    }
                }
            }
        }

        source: "img/ButtonsUp/MarkInterfaceButton_Large_Up.png";
    }

    Rectangle {

        id: mainImagePanel;

        color: "#a29696";
        radius: 14;
        border.color: "#f0f0f0";
        border.width: 4;

        anchors.left: controlPanel.left;
        anchors.right: controlPanel.right;
        anchors.top: parent.top;
        anchors.bottom: promptDiv.top;

        Rectangle {
            color: "black";
            anchors.left: parent.left;
            anchors.leftMargin: 50;
            anchors.right: parent.right;
            anchors.rightMargin: 50;
            anchors.top: parent.top;
            anchors.topMargin: 20;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 20;
            radius: 14;
        }
    }

    Item {

        id: mainImageDiv

         Flickable {
            id: imageScroll;
            objectName: "imageScroll";

            interactive: true;

            //** Flickables dont implement anchors, so we
            //** have to position it the ol' fashion way.
            //** Make the width and height fractions of the
            //** parent and center withing the panel.

            width: analysispage.width / 4 * 3;
            height: analysispage.height / 1000 * 655;

            x: mainImagePanel.x + 120;
            y: (mainImagePanel.height - height) / 2;

            topMargin: mainImagePanel.height / 2;
            bottomMargin: mainImagePanel.height / 2;

            //** Make the flickable touch-sensitive. To do so,
            //** we must set the contentHeight larger than the
            //** flickable's height.

           contentWidth: mainImage.width;
           contentHeight: mainImage.height;

           flickableDirection: Flickable.VerticalFlick;

            clip: true;

            onMovementStarted: {

                clearMarkers();
            }

            onMovementEnded: {

                var pvt = mapToPreviewThumbY (imageScroll.contentY);
                previewThumb.y = pvt;

                drawMarkers ();
            }

            Image {
                id: mainImage

                //** The image is 200 x 3664. We're going to set the width
                //** according to our screen dimensions, then set the
                //** hight relative to that, keeping the aspect ratio
                //** in mind.

                width: 200 * 2;
                height: 3660 * 2;

                fillMode: Image.PreserveAspectCrop;
                sourceSize.width: 1024
                sourceSize.height: 1024

                onStatusChanged: {

                    if (mainImage.status == Image.Ready) {

                        previewThumb.height = previewThumbHeight();

                        imageScroll.contentY = 0;

                        var pvt = mapToPreviewThumbY
                                (imageScroll.contentY);

                        previewThumb.y = pvt;
                    }
                    else {
                        console.log('Close Up Image Load Error');
                    }
                }
            }
        }

         Canvas {
             id: mainCanvas;

             x: mainImagePanel.x + hMainImageMargin;
             y: mainImagePanel.y + vMargin;
             width: mainImagePanel.width - hMainImageMargin * 2;
             height: mainImagePanel.height - vMargin * 2;
         }
    }

    Item {
        id: previewDiv

        anchors.left: parent.left;
        anchors.leftMargin: 15;
        anchors.top: parent.top;
        anchors.topMargin: 100;

        Image {
            id: previewImage;

            fillMode: Image.PreserveAspectCrop;

            sourceSize.width: 1024;
            sourceSize.height: 1024;

            MouseArea {
                id: regionPreviewImage; anchors.fill: parent;

                onClicked: {

                    var mainY = mapToMainImageY (mouse.y);

                    var pvt = mapToPreviewThumbY (mainY);

                    imageScrollMainAnimation.to = mainY;
                    imageScrollPreviewAutomation.to = pvt;
                    imageScrollAnimation.running = true;

                }
            }
        }

        Rectangle {
            id: previewThumb
            x: -10
            width: previewImage.width + 16;

            color: "#00000000"
            border.width: 5
            border.color: "#6AB5C5"

            anchors.left: previewImage.left;
            anchors.leftMargin: -8;
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
        id: markerGuideDiv

        anchors.verticalCenter: mainImagePanel.verticalCenter;

        anchors.verticalCenterOffset: - mainImagePanel.height / 100 *
                                 markerGuideVerticalOffset;

        anchors.left: mainImagePanel.left;

        Image {
            source: "img/Marker_Position.png";
            fillMode: Image.PreserveAspectFit;

            width: mainImagePanel.width;

            height: (sourceSize.height * (mainImagePanel.width) /
                    sourceSize.width);
        }
    }

    Item {
        id: promptDiv;

        height: 30;

        anchors.left: controlPanel.left;
        anchors.bottom: controlPanel.top;
        anchors.bottomMargin: vMargin;
        anchors.right: controlPanel.right;

        Text {
            id: promptText;
            text: "Select Interface: Hematocrit"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width;
            font.bold: true
            font.family: "Helvetica"
            font.pointSize: vMargin * 2;
            color: "black"
        }
    }

    function mapToPreviewThumbY (mainYPos) {
        var previewY = (mainYPos * previewImage.height) /
                mainImage.height;

        return (previewY - 6);
    }

    function mapToMainImageY (previewYPos) {
        var mainY = (previewYPos * mainImage.height) /
                previewImage.height - mainImageDiv.y; // + mainImageDiv.y;

        return (mainY - (imageScroll.height / 2));
    }

    function previewThumbHeight () {

        var thumbHeight = (imageScroll.height * previewImage.paintedWidth) /
                imageScroll.width;

        return (thumbHeight + 50);
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

        var markerStackRectDef =
                "import QtQuick 2.0;" +
                    "Rectangle{" +
                        "width:parent.width-10;" +
                        "height:20;" +
                        "color:'red';" +
                        "border.color: 'black';" +
                        "radius: 3;" +
                        "anchors.horizontalCenter: parent.horizontalCenter;";

        var markerStackTextDef =
                        "Text{" +
                            "anchors.horizontalCenter: parent.horizontalCenter;" +
                            "font.pointSize: 9;"


        var markerStackHeightPlusMargin = 22;

        function markerStackDef (sParent, y, textStr) {

            return (Qt.createQmlObject (
                      markerStackRectDef + "y: " + y + ";" +
                      markerStackTextDef + "text: '" + textStr + "';" + "}" +
                       "}", sParent, 'logObject'));
        }

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 7,
                                          markerNames[0]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 6,
                                          markerNames[1]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 5,
                                          markerNames[2]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 4,
                                          markerNames[3]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 3,
                                          markerNames[4]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 2,
                                          markerNames[5]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 1,
                                          markerNames[6]));

        markerStack.push (markerStackDef (markerStackPanel,
                                          markerStackHeightPlusMargin * 0,
                                          markerNames[7]));
        changeSampleImage();
    }

    function clearMarkers () {

        var context = pMainCanvas.getContext("2d");

        pMainCanvas.requestPaint();

        context.clearRect(0, 0, pMainCanvas.width, pMainCanvas.height);
    }


    function drawMarkers () {

        var i;
        var yLocation;

        if (pMainCanvas.available) {

            var visibleWindowTop = pImageScroll.contentY;
            var visibleWindowBottom = pImageScroll.contentY + pImageScroll.y + pImageScroll.height;
            var context = pMainCanvas.getContext("2d");

            pMainCanvas.requestPaint();

            context.clearRect(0, 0, pMainCanvas.width, pMainCanvas.height);

            for (i = 0; i < markerLocations.length; i++) {

                if (markerLocations[i] >= visibleWindowTop &&
                        markerLocations[i] <= visibleWindowBottom)
                {

                    yLocation = markerLocations[i] - visibleWindowTop;

                    context.beginPath();
                    context.lineWidth = 2;
                    context.strokeStyle = markerColors[i];
                    context.moveTo(0, yLocation);
                    context.lineTo(pMainCanvas.width, yLocation);
                    context.stroke();
                    context.closePath ();
                }
            }
        }
    }

    function drawPreviewMarkers () {

        var yLocation;
        var i;

        if (pPreviewCanvas.available) {

            var context = pPreviewCanvas.getContext("2d");

            pPreviewCanvas.requestPaint ();

            context.clearRect(0, 0, pPreviewCanvas.width, pPreviewCanvas.height);

            for (i = 0; i < markerLocations.length; i++) {
                yLocation = mapToPreviewThumbY (item.markerLocations[i]);

                context.beginPath();
                context.lineWidth = 2;
                context.strokeStyle = markerColors[i];
                context.moveTo(0, yLocation);
                context.lineTo(pPreviewCanvas.width, yLocation);
                context.stroke();
                context.closePath ();
            }
        }
    }

    function clearMarkerStack () {
        var i;

        for (i = 0; i < markerStack.length; i++) {

            markerStack[i].color = "Red";
        }        

        markerStack[0].color = "#e6e6e6";
    }

    function updateMarkerStack () {

        var i;

        clearMarkerStack ();

        for (i = 0; i < markerLocations.length; i++ ) {

            markerStack[i].color = "Green";
        }

        if (markerLocations.length < markerMax) {
            markerStack[markerLocations.length].color = "#e6e6e6";
        }
    }

    function updatePrompt (prompttextStr) {

        if (prompttextStr === undefined) {

            pPromptText.text = "Select Interface: " +
                    markerNames[markerLocations.length];
        }

        else {
            pPromptText.text = prompttextStr;
        }
    }

    function initializePreviewLocation (mainY) {

        var pvt = mapToPreviewThumbY (mainY);

        previewThumb.y = pvt;

    }

    function changeSampleImage () {
        var imageToShow = imageToProcess % 5;

        Settings.SampleImageUsed = imageToShow;

        if (imageToShow == 0)
        {
            previewImage.source = "img/Samples/SampleImage_01_Vertical.png";
            mainImage.source = "img/Samples/SampleImage_01_Vertical.png";
        }
        else if (imageToShow == 1)
        {
            previewImage.source = "img/Samples/SampleImage_02_Vertical.png";
            mainImage.source = "img/Samples/SampleImage_02_Vertical.png";
        }
        else if (imageToShow == 2)
        {
            previewImage.source = "img/Samples/SampleImage_03_Vertical.png";
            mainImage.source = "img/Samples/SampleImage_03_Vertical.png";
        }
        else if (imageToShow == 3)
        {
            previewImage.source = "img/Samples/SampleImage_04_Vertical.png";
            mainImage.source = "img/Samples/SampleImage_04_Vertical.png";
        }
        else if (imageToShow == 4)
        {
            previewImage.source = "img/Samples/SampleImage_05_Vertical.png";
            mainImage.source = "img/Samples/SampleImage_05_Vertical.png";
        }

        imageScroll.contentY = mainImage.height - imageScroll.height / 2;
        initializePreviewLocation (imageScroll.contentY);

        // Ensure that the Mark button is displayed, and the
        // Report button is not (they take up the same space).

        showReportButton.visible = false;
        markButton.visible = true;

        markerLocations = [];
        updateMarkerStack ();
        drawPreviewMarkers();
        drawMarkers();
        updatePrompt ();

    }

    ParallelAnimation {

        id: imageScrollAnimation;

        PropertyAnimation {
            id: imageScrollMainAnimation;
            target: imageScroll;
            property: "contentY";
            easing.type: Easing.InOutQuad;
            duration: 1000;
        }

        PropertyAnimation {
            id: imageScrollPreviewAutomation;
            target: previewThumb;
            property: "y";
            easing.type: Easing.InOutQuad;
            duration: 1000;
       }

        onRunningChanged: {

            if (imageScrollAnimation.running) {  // started
                clearMarkers ();

            } else { // stopped
                drawMarkers();
            }
        }
    }
}

