import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.15
import Qt.labs.settings 1.0
import QtQuick.Window 2.2
import org.kde.novachic 1.0

Maui.ApplicationWindow
{
    id: root
    title: qsTr("")

    property string query
    property string playlistId
    property int currentIndex
    property string currentPage
    property int videoTimePos
    property string videoDuration
    property string videoDurationInfo
    property string videoTimePosInfo
    property int menuCurrentIndex: 0

    width: Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 45 / 100
    height: Screen.desktopAvailableHeight - Screen.desktopAvailableHeight * 25 / 100

    // Settings
    property int maxResultsOnSearch: 50         // Search Page
    property int maxResultsOnNewSongs: 5        // Home Page
    property double appOpacity: 0.90
    property string apiKeyYouTube: ""

    Settings {
        property alias maxResultsOnSearch: root.maxResultsOnSearch
        property alias maxResultsOnNewSongs: root.maxResultsOnNewSongs
        property alias appOpacity: root.appOpacity
        property alias apiKeyYouTube: root.apiKeyYouTube
    }

    SettingsDialog
    {
        id: settingsDialog
    }

    Component.onCompleted: {
        stackViewSidePanel.push("qrc:/MainMenu.qml")
        stackView.push("qrc:/Home.qml")

        if (apiKeyYouTube == "") {
            getAPIKeyDialog.open()
        }
    }

    Maui.InfoDialog
    {
        id: getAPIKeyDialog

        title: i18n("Get Youtube API Key")
        message: i18n("Provide your own API key. Follow the steps indicated and copy the key generated on the Settings menu")

        template.iconSource: "settings-configure"

        onAccepted: close()
        onRejected: close()

        Rectangle
        {
            Layout.fillWidth: true
            implicitHeight: 30
            radius: 4
            color: buttonGetAPIMouse.hovered ? Qt.lighter("mediumspringgreen",1.3) : "mediumspringgreen"
            Text {
                anchors.centerIn: parent
                text: "Get API Key"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://github.com/headsetapp/headset-electron/wiki/Get-Youtube-API-Key")
                        }
                    }
            }
            HoverHandler {
                id: buttonGetAPIMouse
            }
        }
    }

    Loader
    {
        active: true // !Maui.Settings.isMobile && Maui.Handy.isLinux
        asynchronous: true
        sourceComponent: Maui.WindowBlur
        {
            view: root
            geometry: Qt.rect(root.x, root.y, root.width, root.height)
            //windowRadius: root.background.radius
            enabled: true
        }
    }

    ListModel { id: searchModel }
    ListModel { id: playlistModel }
    ListModel { id: channelVideosModel }
    ListModel { id: newSongsModel }

    ListModel { id: genreModel }

    ListModel {
        id: albumModel
        ListElement { artist: "Tina Turner" ; album: "What's Love Got To Do With It" ; cover: "https://i.discogs.com/RxXcxuIT-JjRkpOnQVHwnUWg2JsRTyI9JZwWPvIWULQ/rs:fit/g:sm/q:90/h:600/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTEyNDE5/MTAtMTU1MjU3NTE1/NS0yNzMyLmpwZWc.jpeg" }
        ListElement { artist: "Grover Washington Jr" ; album: "Inside Moves" ; cover: "https://i.discogs.com/kEK56Kwl6Mom9-Md8oX6ycsJpSqAF0ZrWdMvyxAo-iM/rs:fit/g:sm/q:90/h:597/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTQyNDE0/MjYtMTQzMjA2Mjk5/MS0yNzY1LmpwZWc.jpeg" }
        ListElement { artist: "Larry Dunn Orchestra" ; album: "Lover's Silhouette" ; cover: "https://i.discogs.com/liEudVynZL81ADuNme-wn8iDcpbu7Y5fGbY_xH7qArA/rs:fit/g:sm/q:90/h:550/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTMxMzQ1/NDgtMTMxNzM3MDUw/OC5qcGVn.jpeg" }
    }

    ListModel {
        id: genresModel
        ListElement { genre: "80s" ; colour: "#8400E7" ; cover: "" }
        ListElement { genre: "90s" ; colour: "#FF8201" ; cover: "" }
        ListElement { genre: "Pop" ; colour: "#E13300" ; cover: "" }
        ListElement { genre: "Christian" ; colour: "#1E3264" ; cover: "" }
        ListElement { genre: "Soul" ; colour: "#E8125C" ; cover: "" }
        ListElement { genre: "Funky" ; colour: "#158A08" ; cover: "" }
        ListElement { genre: "Smooth Jazz" ; colour: "#0C73EC" ; cover: "" }
        ListElement { genre: "World Music" ; colour: "#E1118B" ; cover: "" }
        ListElement { genre: "Reggae" ; colour: "#158A08" ; cover: "" }
        ListElement { genre: "African" ; colour: "#7358FF" ; cover: "" }
        ListElement { genre: "New Age" ; colour: "#E1118B" ; cover: "" }
    }

    Maui.Page {
        id: sidePanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 350

        headBar.visible: false

        background: Rectangle {
            anchors.fill: parent
            visible: false
        }

        StackView {
            id: stackViewSidePanel
            anchors.fill: parent

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 1000
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 1000
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 1000
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 1000
                }
            }
        }
    }

    Maui.Page {
        id: viewPanel
        anchors.left: sidePanel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        headBar.visible: false

        background: Rectangle {
            anchors.fill: parent
            visible: false
        }

        StackView {
            id: stackView
            anchors.fill: parent

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 1000
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 1000
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 1000
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 1000
                }
            }
        }
    }

    // VIDEO PLAYER

    Rectangle {
        id: rectRenderer
        anchors.fill: viewPanel

        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.Window
        color: "transparent"
        opacity: 1 // 0.90
        visible: false
        z: 1

        state: visible ? "Visible" : "Invisible"
        states: [
            State{
                name: "Visible"
                PropertyChanges{target: rectRenderer; opacity: 1.0}
                PropertyChanges{target: rectRenderer; visible: true}
            },
            State{
                name:"Invisible"
                PropertyChanges{target: rectRenderer; opacity: 0.0}
                PropertyChanges{target: rectRenderer; visible: false}
            }
        ]

        transitions: [
            Transition {
                from: "Visible"
                to: "Invisible"

                SequentialAnimation{
                    NumberAnimation {
                        target: rectRenderer
                        property: "opacity"
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: rectRenderer
                        property: "visible"
                        duration: 0
                    }
                }
            },

            Transition {
                from: "Invisible"
                to: "Visible"
                SequentialAnimation{
                    NumberAnimation {
                        target: rectRenderer
                        property: "visible"
                        duration: 0
                    }
                    NumberAnimation {
                        target: rectRenderer
                        property: "opacity"
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]

        Maui.ShadowedRectangle {
            id: renderShadow
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            x: 0 // 10
            width: 0 // 5
            color: Qt.lighter("#111111",1.0)
            border.width: 2
            border.color: color
            shadow.size: 3
            shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.5) : Qt.lighter("#2c2c2c",1.0)
            shadow.xOffset: -2
            shadow.yOffset: 0
        }

        MpvObject {
            id: renderer
            anchors.left: renderShadow.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Maui.IconItem
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 20
                Maui.Theme.inherit: false
                Maui.Theme.colorSet: Maui.Theme.Complementary
                iconSource: "draw-arrow-back"
                width: 32
                height: width
                maskRadius: Maui.Style.radiusV
                fillMode: Image.PreserveAspectCrop
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rectRenderer.visible = false
                        sidePanel.visible = true
                        sidePanel.width = 350
                    }
                }
            }

            Maui.Page {
                id: videoPlayerPanel
                anchors.left: renderer.left
                anchors.right: renderer.right
                anchors.bottom: renderer.bottom
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.bottomMargin: 20
                height: 100

                headBar.visible: false

                background: Maui.ShadowedRectangle {
                    id: videoBkPlayer
                    anchors.fill: parent
                    color: Qt.darker("#455A64",1.5)
                    border.width: 2
                    border.color: Qt.darker(color,1.0)
                    shadow.size: 10
                    shadow.color: Qt.darker("#2c2c2c",1.2)
                    shadow.xOffset: 0
                    shadow.yOffset: 0
                    radius: 3
                    opacity: 0.99
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillHeight: true

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        color: "transparent"

                        Button {
                            id: videoBackwardButton
                            anchors.right: videoPlayButton.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 15
                            Maui.Theme.inherit: false
                            Maui.Theme.colorSet: Maui.Theme.Complementary
                            flat: true
                            icon.name: "media-seek-backward"
                            onClicked: {
                                var time = renderer.getProperty("time-pos")
                                if (time - 20 > 0) {
                                    renderer.setProperty("time-pos", time - 20)
                                }
                                else {
                                    renderer.setProperty("time-pos", 0)
                                }
                            }
                        }

                        Button {
                            id: videoPlayButton
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            Maui.Theme.inherit: false
                            Maui.Theme.colorSet: Maui.Theme.Complementary
                            flat: true
                            icon.name: "media-playback-start"
                            onClicked: {
                                if (renderer.getProperty("pause") == true) {
                                    videoPlayButton.icon.name = "media-playback-stop"
                                    renderer.setProperty("pause",false)
                                }
                                else {
                                    videoPlayButton.icon.name = "media-playback-start"
                                    renderer.setProperty("pause",true)
                                }
                            }
                        }

                        Button {
                            id: videoFordwardButton
                            anchors.left: videoPlayButton.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 15
                            Maui.Theme.inherit: false
                            Maui.Theme.colorSet: Maui.Theme.Complementary
                            flat: true
                            icon.name: "media-seek-forward"
                            onClicked: {
                                var time = renderer.getProperty("time-pos")
                                if (time + 20 < videoDuration) {
                                    renderer.setProperty("time-pos", time + 20)
                                }
                                else {
                                    renderer.setProperty("time-pos", videoDuration)
                                }
                            }
                        }
                    }

                    Slider {
                        id: videoPlayerSlider
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        from: 0
                        value: 0
                        to: 100
                        onMoved: {
                            renderer.setProperty("time-pos", value)
                        }
                    }
                }

                Label {
                    id: videoLabelTime
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10 + 20
                    Maui.Theme.inherit: false
                    Maui.Theme.colorSet: Maui.Theme.Complementary
                    font.pixelSize: 11
                    visible: false
                    text: videoTimePosInfo + " / " + videoDurationInfo
                }
            }
        }
    }

    /*
    // PLAYER

    Maui.Page {
        id: playerPanel
        visible: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100

        headBar.visible: false

        background: Maui.ShadowedRectangle {
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.View
            anchors.fill: parent
            color: Maui.Theme.backgroundColor
            border.width: 1
            border.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter("#dadada",1.08) : "#2c2c2c"
            shadow.size: 10
            shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter("#dadada",1.11) : "#2c2c2c"
            shadow.xOffset: 0
            shadow.yOffset: -1
            radius: 6
            opacity: 0.98
        }
    }
    */
}
