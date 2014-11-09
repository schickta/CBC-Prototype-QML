import QtQuick 2.0

Rectangle {
    color: "#e6e6e6"

    Image {
        id: analysisButton;

        width: (1280 / 5) * 4;

        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.topMargin: 10;

        fillMode: Image.PreserveAspectFit

        MouseArea {
            id: regionAnalysisButton;
            anchors.fill: parent;

            onPressed: {
                analysisButton.source = "img/ButtonsDown/ProcessSample_Down.png"
            }

            onReleased: {
                analysisButton.source = "img/ButtonsUp/ProcessSample_Up.png"
            }

            onClicked: {
                natarget.target = analysispage;
                natarget.from = mainform_horizontal.y + mainform_horizontal.height;
                natarget.to = 0;
                naprevious.target = startuppage;
                naprevious.from = undefined;
                naprevious.to = -mainform_horizontal.height - 40;
                navigateToPage.running = true;

                pAnalysisLoader.transFromStart();

//                navigateToAnalysis.running = true;
            }
        }

        source: "img/ButtonsUp/ProcessSample_Up.png";
    }


    Image {
        id: infoButton;

        width: parent.width / 5;
        height: parent.width / 5;

        anchors.top: analysisButton.bottom;
        anchors.topMargin: parent.height / 20;
        anchors.left: parent.left;
        anchors.leftMargin: parent.width / 40;

        MouseArea {
            id: regionInfoButton; anchors.fill: parent;

            onPressed: {
                infoButton.source = "img/ButtonsDown/Instructions_Down.png"
            }

            onReleased: {
                infoButton.source = "img/ButtonsUp/Instructions_Up.png"
            }
        }

        source: "img/ButtonsUp/Instructions_Up.png";
    }

    Image {
        id:settingsButton

        width: parent.width / 5;
        height: parent.width / 5;

        anchors.top: infoButton.top;
        anchors.left: infoButton.right;
        anchors.leftMargin: parent.width / 20;

        MouseArea {
            id: regionSettingsButton;
            anchors.fill: parent;

            onPressed: {
                settingsButton.source = "img/ButtonsDown/Settings_Down.png"
            }

            onReleased: {
                settingsButton.source = "img/ButtonsUp/Settings_Up.png"
            }

//            onClicked: {
//                natarget.target = settingspage;
//                natarget.from = mainform_horizontal.y + mainform_horizontal.height;
//                natarget.to = 0;
//                naprevious.target = startuppage;
//                naprevious.from = undefined;
//                naprevious.to = -mainform_horizontal.height - 40;
//                navigateToPage.running = true;
//            }
        }

        source: "img/ButtonsUp/Settings_Up.png";
    }

    Image {
        id: browseButton;

        width: parent.width / 5;
        height: parent.width / 5;

        anchors.top: infoButton.top;
        anchors.left: settingsButton.right;
        anchors.leftMargin: parent.width / 20;

        MouseArea {
            id: regionBrowseButton; anchors.fill: parent;

            onPressed: {
                browseButton.source = "img/ButtonsDown/BrowseSamples_Down.png";
            }

            onReleased: {
                browseButton.source = "img/ButtonsUp/BrowseSamples_Up.png"
            }
        }

        source: "img/ButtonsUp/BrowseSamples_Up.png";
    }

    Image {
        id: calibrateButton

        width: parent.width / 5;
        height: parent.width / 5;

        anchors.top: infoButton.top;
        anchors.left: browseButton.right;
        anchors.leftMargin: parent.width / 20;

        MouseArea {
            id: regionCalibrateButton; anchors.fill: parent;

            onPressed: {
                calibrateButton.source = "img/ButtonsDown/Service_Down.png";
            }

            onReleased: {
                calibrateButton.source = "img/ButtonsUp/Service_Up.png"
            }
        }

        source: "img/ButtonsUp/Service_Up.png";
    }

    Image {
        id: logoImage;

        width: parent.width / 3;

        height: (sourceSize.height * (parent.width / 3)) /
                                sourceSize.width;

        anchors.bottom: parent.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottomMargin: 10;

        source: "img/drucker-diagnostics-splash2.png"
    }
}
