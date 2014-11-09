import QtQuick 2.0

Rectangle {

    color: "#e6e6e6";
    height: mainform.height;
    width: mainform.width;

    property int textSpacing: 10;
    property int textLeftMargin: 50; // 40;
    property int headerTopMargin: 60;
    property int pointSize: 26;
    property string fontFamily: "Calibri";
    property string fontColor: "black";

    Image {
        id: resultsMainDivot;

        anchors.left: parent.left;
        anchors.leftMargin: 10;
        anchors.top: parent.top;
        anchors.topMargin: 10;
        anchors.right: parent.right;
        anchors.rightMargin: 10;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 425;

        source: "img/ResultsTextDivot.png";
        fillMode: Image.Stretch;

        Text {
            id: headertext;
            anchors.top: parent.top;
            anchors.topMargin: headerTopMargin;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: true;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "Results:\t\t\tUnits";
        }

        Text {
            id: hcttext;
            anchors.top: headertext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "Hematocrit:\t\t" + CBCCalculator.Hct.toFixed(1) + " %";
        }

        Text {
            id: hgbtext;
            anchors.top: hcttext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "Hemoglobin:\t\t" + CBCCalculator.Hgb.toFixed(1) + " g/dL";
        }

        Text {
            id: mchctext;
            anchors.top: hgbtext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "MCHC:\t\t\t" + CBCCalculator.Mchc.toFixed(1) + " g/dL";
        }

        Text {
            id: plttext;
            anchors.top: mchctext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "Platelet:\t\t\t" + CBCCalculator.Plt.toFixed(0) + " x 10^9/L";
        }

        Text {
            id: wbctext;
            anchors.top: plttext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "WBC:\t\t\t" + CBCCalculator.Wbc.toFixed(1) + " x 10^9/L";
        }

        Text {
            id: granstext;
            anchors.top: wbctext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "GRANS:\t\t\t" + CBCCalculator.Grans.toFixed(1) + " x 10^9/L";
        }

        Text {
            id: granptext;
            anchors.top: granstext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "GRANS %:\t\t" + CBCCalculator.Pgrans.toFixed(0) + " %";
        }


        Text {
            id: lmtext;
            anchors.top: granptext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "LM:\t\t\t\t" + CBCCalculator.Lm.toFixed(1) + " x 10^9/L";
        }

        Text {
            id: lmptext;
            anchors.top: lmtext.bottom;
            anchors.topMargin: textSpacing;
            anchors.left: parent.left;
            anchors.leftMargin: textLeftMargin;
            horizontalAlignment: Text.AlignLeft
            font.bold: false;
            font.family: fontFamily;
            font.pointSize: pointSize;
            color: fontColor;

            text: "LM %:\t\t\t" + CBCCalculator.Plm.toFixed(0) + " %";
        }
    }

    Image {
        id: resultsTypewriterButton;

        anchors.top: resultsMainDivot.bottom;
        anchors.topMargin: 20;
        anchors.left: parent.left;
        anchors.leftMargin: parent.width / 2 - width/2;

        source: "img/ButtonsUp/ResultsTypewriter_Up.png";

        MouseArea {
            anchors.fill: resultsTypewriterButton;

            onPressed: {
                resultsTypewriterButton.source = "img/ButtonsDown/ResultsTypewriter_Down.png";
            }

            onReleased: {
                resultsTypewriterButton.source = "img/ButtonsUp/ResultsTypewriter_Up.png";
            }
        }
    }

    Image {
        id: processNewImageButton;

        anchors.right: resultsTypewriterButton.left;
        anchors.rightMargin: 10;
        anchors.top: resultsMainDivot.bottom;
        anchors.topMargin: 20;

        source: "img/ButtonsUp/ResultsCapture_Up.png";

        MouseArea {
            anchors.fill: processNewImageButton;

            onPressed: {
                processNewImageButton.source = "img/ButtonsDown/ResultsCapture_Down.png";
            }

            onReleased: {
                processNewImageButton.source = "img/ButtonsUp/ResultsCapture_Up.png";
            }

            onClicked: {

                natarget.target = analysispage;
                natarget.from = undefined;
                natarget.to = 0;
                naprevious.target = resultspage;
                naprevious.from = undefined;
                naprevious.to = mainform.height // - 40;
                navigateToPage.running = true;
            }
        }
    }

    Image {
        id: resultsSaveButton;

        anchors.left: resultsTypewriterButton.right;
        anchors.leftMargin: 10;
        anchors.top: resultsMainDivot.bottom;
        anchors.topMargin: 20;

        source: "img/ButtonsUp/ResultsSave_Up.png";

        MouseArea {
            anchors.fill: resultsSaveButton;

            onPressed: {
                resultsSaveButton.source = "img/ButtonsDown/ResultsSave_Down.png";
            }

            onReleased: {
                resultsSaveButton.source = "img/ButtonsUp/ResultsSave_Up.png";
            }

            onClicked: {

            }
        }
    }

    Image {
        id: doneResultsButton;

        anchors.top: resultsTypewriterButton.bottom;
        anchors.topMargin: 10
        anchors.left: parent.left;
        anchors.leftMargin: parent.width / 2 - width/2;

        source: "img/ButtonsUp/ResultsDone_Up.png";

        MouseArea {
            anchors.fill: doneResultsButton;

            onPressed: {
                doneResultsButton.source = "img/ButtonsDown/ResultsDone_Down.png";
            }

            onReleased: {
                doneResultsButton.source = "img/ButtonsUp/ResultsDone_Up.png";
            }

            onClicked: {
                natarget.target = startuppage;
                natarget.from = undefined;
                natarget.to = 0;
                naprevious.target = resultspage;
                naprevious.from = undefined;
                naprevious.to = mainform.height // - 40;
                navigateToPage.running = true;
            }
        }
    }

    Image {
        id: printResultsButton;

        anchors.right: doneResultsButton.left;
        anchors.rightMargin: 10;
        anchors.top: doneResultsButton.top;

        source: "img/ButtonsUp/ResultsPrint_Up.png";

        MouseArea {
            anchors.fill: printResultsButton;

            onPressed: {
                printResultsButton.source = "img/ButtonsDown/ResultsPrint_Down.png";
            }

            onReleased: {
                printResultsButton.source = "img/ButtonsUp/ResultsPrint_Up.png";
            }

            onClicked: {

            }
        }
    }

    Image {
        id: deleteResultsButton;

        anchors.left: doneResultsButton.right;
        anchors.leftMargin: 10;
        anchors.top: doneResultsButton.top;

        source: "img/ButtonsUp/ResultsDelete_Up.png";

        MouseArea {
            anchors.fill: deleteResultsButton;

            onPressed: {
                deleteResultsButton.source = "img/ButtonsDown/ResultsDelete_Down.png";
            }

            onReleased: {
                deleteResultsButton.source = "img/ButtonsUp/ResultsDelete_Up.png";
            }

            onClicked: {

            }
        }
    }

    Image {
        id: druckerIcon;

        source: "img/DruckerDiagnostics_Icon_128.png";

        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 5;
        anchors.left: parent.left;
        anchors.leftMargin: parent.width / 2 - width/2;

    }
}

