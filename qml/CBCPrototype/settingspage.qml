import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: settingsPage
    color: "#e6e6e6"  

    Image {
        id: loading
        source: "img/loading.png"
        visible: false;

        x: parent.width / 2 - width / 2;
        y: parent.height / 2 - height / 2;
        width: 100;
        height: 100;

        NumberAnimation on rotation {
             id: loadingRotation;
             from: 0
             to: 360
             running: true;
             loops: Animation.Infinite
             duration: 1500
         }
    }

    Image {
        id: verticalLayout_v3;

        anchors.top: parent.top;
        anchors.topMargin: 50;
        anchors.horizontalCenter: parent.horizontalCenter;

        source: "img/VerticalScreen_v3.jpg";

        MouseArea {
            anchors.fill: verticalLayout_v3

            onClicked: {

                if ( ! loading.visible) {
                    loadTimer.running = true;

                    loading.visible = true;
                    loadingRotation.running = true;
                }
            }
        }

        Timer {
            id: loadTimer;
            interval: 2000;
            running: false;
            repeat: false;
            onTriggered: {

                console.log ("TRIGGERED");
                loadingRotation.running = false;
                loading.visible = false;

                currentAnalysisPage = "analysispagev3.qml";
                Settings.VerticalLayoutUsed = "analysispagev3.qml";
                analysisLoader.source = "analysispagev3.qml";

                natarget.target = analysispage;
                natarget.from = undefined;
                natarget.to = 0;
                naprevious.target = settingspage;
                naprevious.from = undefined;
                naprevious.to = -mainform.height - 40;
                navigateToPage.running = true;
            }
        }
    }


    Image {
        id: verticalLayout_v2;

        anchors.top: parent.top;
        anchors.topMargin: 50;
        anchors.right: verticalLayout_v3.left;
        anchors.rightMargin: 40;

        source: "img/VerticalScreen_v2.jpg";

        MouseArea {
            anchors.fill: verticalLayout_v2

            onClicked: {  
                if ( ! loading.visible) {
                    loadTimer2.running = true;

                    loading.visible = true;
                    loadingRotation.running = true;
                }
            }
        }

        Timer {
            id: loadTimer2;
            interval: 2000;
            running: false;
            repeat: false;
            onTriggered: {

                loadingRotation.running = false;
                loading.visible = false;

                currentAnalysisPage = "analysispagev2.qml";
                Settings.VerticalLayoutUsed = "analysispagev2.qml";
                analysisLoader.source = "analysispagev2.qml";

                natarget.target = analysispage;
                natarget.from = undefined;
                natarget.to = 0;
                naprevious.target = settingspage;
                naprevious.from = undefined;
                naprevious.to = -mainform.height - 40;
                navigateToPage.running = true;
            }
        }
    }

    Image {
        id: verticalLayout_v4;

        anchors.top: parent.top;
        anchors.topMargin: 50;
        anchors.left: verticalLayout_v3.right;
        anchors.leftMargin: 40;

        source: "img/VerticalScreen_v4.jpg";

        MouseArea {
            anchors.fill: verticalLayout_v4

            onClicked: {
                if ( ! loading.visible) {
                    loadTimer3.running = true;

                    loading.visible = true;
                    loadingRotation.running = true;
                }
            }
        }

        Timer {
            id: loadTimer3;
            interval: 2000;
            running: false;
            repeat: false;
            onTriggered: {

                loadingRotation.running = false;
                loading.visible = false;

                currentAnalysisPage = "analysispagev4.qml";
                Settings.VerticalLayoutUsed = "analysispagev4.qml";
                analysisLoader.source = "analysispagev4.qml";

                natarget.target = analysispage;
                natarget.from = undefined;
                natarget.to = 0;
                naprevious.target = settingspage;
                naprevious.from = undefined;
                naprevious.to = -mainform.height - 40;
                navigateToPage.running = true;
            }
        }
    }

    Text {
        id: knobScrollRateText;

        anchors.top: verticalLayout_v2.bottom;
        anchors.topMargin: 100;
        anchors.left: verticalLayout_v2.left;
        anchors.leftMargin: 0;

        font.pointSize: 16;
        font.family: "Helvetica";
        font.bold: true;

        text: "Knob Scroll Rate:";
    }

    Rectangle {
        anchors.top: verticalLayout_v2.bottom;
        anchors.topMargin: 100;
        anchors.left: knobScrollRateText.right;
        anchors.leftMargin: 25;

        height: 25;
        width: 100;

        border.color: "black";
        border.width: 2;

        color: "white";

        TextInput {
            id: knobScrollRateInputField;

            anchors.centerIn: parent;

            font.pixelSize: 16;
            maximumLength: 3;

            color: "black";
            cursorVisible: true;

            focus: true;
            validator: IntValidator { bottom:1; top: 200}
        }
   }

    Binding {
        target: knobScrollRateInputField;
        property: "text";
        value: (Settings.KnobSensitivity);
    }

    Image {
        id: doneSettingsButton;

        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 40;
        anchors.horizontalCenter: parent.horizontalCenter;

        source: "img/ButtonsUp/ResultsDone_Up.png";

        MouseArea {
            anchors.fill: doneSettingsButton;

            onPressed: {
                doneResultsButton.source = "img/ButtonsDown/ResultsDone_Down.png";
            }

            onReleased: {
                doneResultsButton.source = "img/ButtonsUp/ResultsDone_Up.png";
            }

            onClicked: {

                if ( ! loading.visible) {
                    if (knobScrollRateInputField.text.length > 0) {

                        Settings.KnobSensitivity = knobScrollRateInputField.text;
                        mainform.knobScrollRate = knobScrollRateInputField.text;

                        natarget.target = startuppage;
                        natarget.from = undefined;
                        natarget.to = 0;
                        naprevious.target = settingspage;
                        naprevious.from = undefined;
                        naprevious.to = mainform.height + 40;
                        navigateToPage.running = true;
                    }

                    else {
                        badValueDialog.visible = true;
                    }
                }
            }
        }
    }

    MessageDialog {
        id: badValueDialog;

        title: "Enter a Valid Value"
        icon: StandardIcon.Warning;
        text: "Enter a valid value between 1 and 200";
        standardButtons: StandardButton.Ok;
        visible: false;
        onAccepted: console.log("copied")
    }
}
