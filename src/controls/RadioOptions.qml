import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.15

Maui.Page {
    id: pageRadioOptions

    showCSDControls: true

    objectName: "objectPageRadioOptions"

    headBar.background: Rectangle {
        anchors.fill: parent
        color: Maui.Theme.backgroundColor
        opacity: 0
    }

    background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.Window
        color: Maui.Theme.backgroundColor
        opacity: appOpacity
    }

    Component.onCompleted: {
        includedOnRadioModel.clear()
        for (var i = 0; i < channelPlaylistsModel.count; i++) {
            includedOnRadioModel.append({"playlist": channelPlaylistsModel.get(i).title, "included": false})
        }
    }

    // RADIO OPTIONS RECTANGLE

    Maui.ShadowedRectangle {
        id: viewRect
        anchors.fill: parent
        anchors.leftMargin: 6
        corners.topLeftRadius: 7
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Maui.Theme.backgroundColor : Qt.lighter(Maui.Theme.backgroundColor,1.65)
        clip: false

        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 0 // 15
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.1) : "#2c2c2c"
        shadow.xOffset: -1
        shadow.yOffset: 0

        OpacityMask {
            source: maskBanner
            maskSource: viewRect
        }

        LinearGradient {
            id: maskBanner
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: banner.height + 100
            z: 1
            gradient: Gradient {
                GradientStop { position: 0.45; color: "transparent"}
                GradientStop { position: 0.60; color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Maui.Theme.backgroundColor : Qt.lighter(Maui.Theme.backgroundColor,1.65) }
                GradientStop { position: 0.73; color: "transparent" }
            }
        }

        Image {
            id: banner

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 150
            fillMode: Image.PreserveAspectCrop

            property bool adapt: true

            opacity: 0.07

            source: "qrc:/assets/radio-options-anthony-roberts-82wJ10pX1Fw-unsplash.jpg"

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: banner.width
                    height: banner.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: banner.adapt ? banner.width : Math.min(banner.width, banner.height)
                        height: banner.adapt ? banner.height : width
                        radius: 7
                    }
                }
            }
        }

        Label {
            id: bannerText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: banner.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 40

            text: "Select your playlists"

            font.pixelSize: 26
        }

        Rectangle {
            id: rectList
            anchors.fill: parent
            anchors.topMargin: 150
            color: "transparent"
            clip: true

            ListView {
                id: results
                anchors.fill: parent
                anchors.margins: 20

                spacing: 10

                model: channelPlaylistsModel
                delegate: Maui.ShadowedRectangle {
                    id: card
                    width: parent.width
                    height: 75
                    color: listMouse.hovered ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.83) : Qt.lighter(Maui.Theme.alternateBackgroundColor,1.6)) :
                    (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.alternateBackgroundColor,1.025) : Qt.lighter(Maui.Theme.backgroundColor,1.3))
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        Rectangle {
                            height: card.height
                            Layout.fillWidth: true
                            Layout.minimumWidth: card.height
                            color: "transparent"
                            Label {
                                id: labelPlaylist
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.leftMargin: 5
                                anchors.topMargin: 5
                                font.pixelSize: 20
                                elide: Text.ElideRight
                                text: title
                            }
                            Label {
                                id: labelDescription
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 5
                                anchors.bottomMargin: 5
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                height: 15
                                text: description
                            }
                        }
                        Rectangle {
                            width: card.height
                            height: card.height
                            color: "transparent"
                            radius: 4
                            Layout.alignment: Qt.AlignRight
                            Maui.Badge
                            {
                                id: badge
                                anchors.centerIn: parent
                                text: "+"
                            }
                        }
                    }
                    HoverHandler {
                        id: listMouse
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            if (mouse.button == Qt.LeftButton)
                            {
                                badge.text == "+" ? includedOnRadioModel.setProperty(index, "included", true) : includedOnRadioModel.setProperty(index, "included", false)
                                badge.text == "+" ? badge.text = "✓" : badge.text = "+"
                            }
                            if (mouse.button == Qt.RightButton)
                            {
                            }
                        }
                    }
                }
            }
        }
    }

    Maui.FloatingButton
    {
        id: acceptButton

        icon.name: "dialog-ok-apply"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        onClicked: {
            stackView.pop()
            stackViewSidePanel.pop()
            stackView.push("qrc:/Radio.qml")
            stackViewSidePanel.push("qrc:/MainMenu.qml")
        }
    }
}
