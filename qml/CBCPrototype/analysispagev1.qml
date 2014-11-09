import QtQuick 2.0

Rectangle {
    color: "#e6e6e6"

    property alias pMainCanvas:  mainCanvas;
    property alias pImageScroll: imageScroll;
    property alias pPromptText: promptText;
    property alias pPreviewCanvas: previewCanvas;
    property alias pPreviewThumb: previewThumb;

    Rectangle {
        id: controlPanel;
        radius: 10;

        anchors.left: cameraButton.left;
        anchors.leftMargin: - (mainform.hMargin / 2);
        anchors.top: cameraButton.top;
        anchors.topMargin: -(mainform.vMargin / 2);
        anchors.right: typewriterButton.right;
        anchors.rightMargin: -(mainform.hMargin / 2);
        anchors.bottom: typewriterButton.bottom;
        anchors.bottomMargin: -(mainform.vMargin / 2);

        color: "#808080";
    }


    Rectangle {
        id: markerStack;

        width: 100;
        height: controlPanel.height - 20;
        color: "transparent";

        anchors.top: controlPanel.top;
        anchors.topMargin: 10;
        anchors.left: controlPanel.left;
        anchors.leftMargin: 10;
        anchors.verticalCenter: controlPanel.verticalCenter;

        Rectangle {
            id: markerStackElt1;
            color: "green";
            border.color: "black";
            radius: 3;

            width: parent.width - 10;
            height: 20;

            anchors.top: parent.top;
            anchors.topMargin: 2;
            anchors.horizontalCenter: parent.horizontalCenter;
        }

        Rectangle {
            id: markerStackElt2;
            color: "green";
            border.color: "black";
            radius: 3;

            width: parent.width - 10;
            height: 20;

            anchors.top: markerStackElt1.bottom;
            anchors.topMargin: 2;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }


    BorderImage {
        id: cameraButton;
        opacity: 0;

        height: (sourceSize.height * (parent.width / 5) /
                sourceSize.width);

        width: parent.width / 5;

        anchors.bottom: settings2Button.top;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: slowUpButton.left;
        anchors.rightMargin: mainform.hMargin;

        MouseArea {
            id: regionCameraButton; anchors.fill: parent;

            onPressed: {
                cameraButton.source = "img/ButtonsDown/Capture_Down.png";
            }

            onReleased: {
                cameraButton.source = "img/ButtonsUp/Capture_Up.png";
            }
        }

        source: "img/ButtonsUp/Capture_Up.png";
    }

    BorderImage {
        id: slowUpButton;

        height: (sourceSize.height * (parent.width / 5) /
                sourceSize.width);

        width: parent.width / 5;

        anchors.bottom: markButton.top;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: slowDownButton.left;
        anchors.rightMargin: mainform.hMargin;

        MouseArea {
            id: regionSlowUpButton; anchors.fill: parent;

            onPressed: {
                slowUpButton.source = "img/ButtonsDown/MoveUp_Down.png";
            }

            onReleased: {
                slowUpButton.source = "img/ButtonsUp/MoveUp_Up.png";
            }

            onClicked: {
                imageScroll.contentY = imageScroll.contentY - 50;

                var pvt = mapToPreviewThumbY(imageScroll.contentY);
                previewThumb.y = pvt;

                drawMarkers ();
            }
        }

        source: "img/ButtonsUp/MoveUp_Up.png";
    }

    BorderImage {
        id: slowDownButton;

        height: (sourceSize.height * (parent.width / 5) /
                sourceSize.width);

        width: parent.width / 5;

        anchors.bottom: markButton.top;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: markButton.right;

        MouseArea {
            id: regionSlowDownButton; anchors.fill: parent;

            onPressed: {
                slowDownButton.source = "img/ButtonsDown/MoveDown_Down.png";
            }

            onReleased: {
                slowDownButton.source = "img/ButtonsUp/MoveDown_Up.png";
            }

            onClicked: {
                imageScroll.contentY = imageScroll.contentY + 50;

                var pvt = mapToPreviewThumbY (imageScroll.contentY);
                previewThumb.y = pvt;

                drawMarkers ();
            }
        }

        source: "img/ButtonsUp/MoveDown_Up.png";
    }

    BorderImage {
        id: undoMarkButton;

        height: (sourceSize.height * (parent.width / 5) /
                sourceSize.width);

        width: parent.width / 5;

        anchors.bottom: typewriterButton.top;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: typewriterButton.right;

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
                }

                else {
                     navigateToStart.running = true;
                }
            }
        }

        source: "img/ButtonsUp/Back_Up.png";
    }

    BorderImage {
        id: settings2Button;
        opacity: 0;

        height: (sourceSize.height * (parent.width / 5) /
                sourceSize.width);

        width: parent.width / 5;

        anchors.bottom: parent.bottom;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: markButton.left;
        anchors.rightMargin: mainform.hMargin;

        MouseArea {
            id: regionSettings2; anchors.fill: parent;

            onPressed: {
                settings2Button.source = "img/ButtonsDown/Settings_Down.png";
            }

            onReleased: {
                settings2Button.source = "img/ButtonsUp/Settings_Up.png";
            }
        }

        source: "img/ButtonsUp/Settings_Up.png";
    }

    BorderImage {
        id: markButton;

        height: typewriterButton.height;
        width: parent.width / 5 * 2 + mainform.hMargin;

        anchors.bottom: parent.bottom;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: typewriterButton.left;
        anchors.rightMargin: mainform.hMargin;

        MouseArea {
            id: regionMark; anchors.fill: parent;

            onPressed: {
                markButton.source = "img/ButtonsDown/Mark_Down.png";
            }

            onReleased: {
                markButton.source = "img/ButtonsUp/Mark_Up.png";
            }

            onClicked: {
                if (markerLocations.length < markerMax) {
                    markerLocations.push
                            (imageScroll.contentY + mainCanvas.height / 2 - mainform.vMargin);

                    drawMarkers();
                    drawPreviewMarkers();
                    updatePrompt ();
                }

                else {
                    updatePrompt("Mark again for report");
                }
            }
        }

        source: "img/ButtonsUp/Mark_Up.png";
    }

    BorderImage {
        id: typewriterButton;

        height: (sourceSize.height * (parent.width / 5) /
                sourceSize.width);

        width: parent.width / 5;

        anchors.bottom: parent.bottom;
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: parent.right;
        anchors.rightMargin: mainform.hMargin;

        MouseArea {
            id: regionTypewriter; anchors.fill: parent;

            onPressed: {
                typewriterButton.source = "img/ButtonsDown/Typewriter_Down.png";
            }

            onReleased: {
                typewriterButton.source = "img/ButtonsUp/Typewriter_Up.png";
            }
        }

        source: "img/ButtonsUp/Typewriter_Up.png";
    }

    Rectangle {

        id: mainImagePanel;

        color: "#a29696"
        radius: 14
        border.color: "#f0f0f0"
        border.width: 4

        anchors.left: controlPanel.left;
        anchors.right: controlPanel.right;
        anchors.top: parent.top;
        anchors.bottom: promptDiv.top;
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

            x: mainImagePanel.x + mainform.hMainImageMargin;
            y: (mainImagePanel.height - height) / 2;

            //** Make the flickable touch-sensitive. To do so,
            //** we must set the contentHeight larger than the
            //** flickable's height.

            contentHeight: 3664 * 2;
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

                width: mainImagePanel.width - mainform.hMainImageMargin * 2;
                height: 3664 * ((mainImagePanel.width - mainform.hMainImageMargin * 2) / 200);

                source: "img/123456789-2014-09-22-135139-Donor 1-normal Hct-LED30.jpg";
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

             x: mainImagePanel.x + mainform.hMainImageMargin;
             y: mainImagePanel.y + mainform.vMargin;
             width: mainImagePanel.width - mainform.hMainImageMargin * 2;
             height: mainImagePanel.height - mainform.vMargin * 2;
         }
    }

    Item {
        id: previewDiv

        anchors.left: parent.left;
        anchors.leftMargin: 15;
        anchors.top: parent.top;
        anchors.topMargin: 15;

        Image {
            id: previewImage;

            height: analysispage.height - 30;
            width: height * mainImage.width / mainImage.height;

            source: "img/123456789-2014-09-22-135139-Donor 1-normal Hct-LED30.jpg";
            fillMode: Image.PreserveAspectCrop;

            sourceSize.width: 1024;
            sourceSize.height: 1024;

            onStatusChanged: {
                if (previewImage.status == Image.Ready) {

                    console.log('Preview Loaded Todd');
                }
                else {
                    console.log('Preview Load Error');
                }
            }

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
        anchors.verticalCenterOffset: -(mainImagePanel.height * markerVOffset);
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
        anchors.bottomMargin: mainform.vMargin;
        anchors.right: controlPanel.right;

        Text {
            id: promptText;
            text: "Select Interface: Hematocrit"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width;
            font.bold: true
            font.family: "Helvetica"
            font.pointSize: mainform.vMargin * 2;
            color: "#7F0000"
        }
    }

    function mapToPreviewThumbY (mainYPos) {
        var previewY = (mainYPos * previewImage.height) /
                mainImage.height;

        return (previewY);
    }

    function mapToMainImageY (previewYPos) {
        var mainY = (previewYPos * mainImage.height) /
                previewImage.height + mainImageDiv.y;

        return (mainY - (imageScroll.height / 2));
    }

    function previewThumbHeight () {

        var thumbHeight = (imageScroll.height * previewImage.paintedWidth) /
                imageScroll.width;

        return (thumbHeight + 16);
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

