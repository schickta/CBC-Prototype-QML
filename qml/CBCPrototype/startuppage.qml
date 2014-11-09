import QtQuick 2.0

Rectangle {
    color: "#e6e6e6"

    BorderImage {
        id: analysisButton;

        height: (262 * (parent.width - 50) /
                541);

        width: parent.width - 50;

        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.topMargin: 40;

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

                analysisLoader.item.changeSampleImage ();

                natarget.target = analysispage;
                natarget.from = mainform.height - 40;
                natarget.to = 0;
                naprevious.target = startuppage;
                naprevious.from = undefined;
                naprevious.to = -mainform.height - 40;
                navigateToPage.running = true;
            }
        }

        source: "img/ButtonsUp/ProcessSample_Up.png";
    }


    BorderImage {
        id: infoButton;

        height: (sourceSize.height * (parent.width / 3) /
                sourceSize.width);

        width: parent.width / 3;

        anchors.top: analysisButton.bottom;
        anchors.topMargin: 40;
        anchors.right: analysisButton.horizontalCenter;
        anchors.rightMargin: 20;

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

    BorderImage {
        id:settingsButton

        height: (sourceSize.height * (parent.width / 3) /
                sourceSize.width);

        width: parent.width / 3;

        anchors.top: analysisButton.bottom;
        anchors.topMargin: 40;
        anchors.left: analysisButton.horizontalCenter;
        anchors.leftMargin: 20;

        MouseArea {
            id: regionSettingsButton;
            anchors.fill: parent;

            onPressed: {
                settingsButton.source = "img/ButtonsDown/Settings_Down.png"
            }

            onReleased: {
                settingsButton.source = "img/ButtonsUp/Settings_Up.png"
            }

            onClicked: {

                natarget.target = settingspage;
                natarget.from = mainform.y + mainform.height;
                natarget.to = 0;
                naprevious.target = startuppage;
                naprevious.from = undefined;
                naprevious.to = -mainform.height - 40;
                navigateToPage.running = true;
            }
        }

        source: "img/ButtonsUp/Settings_Up.png";
    }

    BorderImage {
        id: browseButton;

        height: (sourceSize.height * (parent.width / 3) /
                sourceSize.width);

        width: parent.width / 3;

        anchors.top: infoButton.bottom;
        anchors.topMargin: 40;
        anchors.left: infoButton.left;

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

    BorderImage {
        id: calibrateButton

        height: (sourceSize.height * (parent.width / 3) /
                sourceSize.width);

        width: parent.width / 3;

        anchors.top: settingsButton.bottom;
        anchors.topMargin: 40;
        anchors.right: settingsButton.right;

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

        width: parent.width - 10;

        height: (sourceSize.height * (parent.width - 10)) /
                                sourceSize.width;

        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 5;

        source: "img/drucker-diagnostics-splash2.png"
    }
}
