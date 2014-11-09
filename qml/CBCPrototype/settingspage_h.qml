import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: settingsPage
    color: "#e6e6e6"

    Text {
        id: knobScrollRateText;

        anchors.top: parent.top;
        anchors.topMargin: 200;
        anchors.left: parent.left;
        anchors.leftMargin: ((parent.width / 2) - 200);

        font.pointSize: 16;
        font.family: "Helvetica";
        font.bold: true;

        text: "Knob Scroll Rate:";
    }

    Rectangle {
        id: knobScrollRateRectangle

        anchors.top: knobScrollRateText.top;
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

        anchors.left: knobScrollRateRectangle.right;
        anchors.leftMargin: 50;
        anchors.top: knobScrollRateRectangle.top;
        anchors.topMargin: -50;

        source: "img/ButtonsUp/ResultsDone_Up.png";

        MouseArea {
            anchors.fill: doneSettingsButton;

            onPressed: {
                doneSettingsButton.source = "img/ButtonsDown/ResultsDone_Down.png";
            }

            onReleased: {
                doneSettingsButton.source = "img/ButtonsUp/ResultsDone_Up.png";
            }

            onClicked: {

                if (knobScrollRateInputField.text.length > 0) {

                    Settings.KnobSensitivity = knobScrollRateInputField.text;
                    mainform_horizontal.knobScrollRate = knobScrollRateInputField.text;

                    natarget.target = startuppage;
                    natarget.from = undefined;
                    natarget.to = 0;
                    naprevious.target = settingspage;
                    naprevious.from = undefined;
                    naprevious.to = mainform_horizontal.height + 40;
                    navigateToPage.running = true;
                }

                else {
                    badValueDialog.visible = true;
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
