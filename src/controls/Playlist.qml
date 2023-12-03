import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.15
import com.blackgrain.qml.quickdownload 1.0
import org.kde.novachic 1.0

Maui.Page {
    id: pagePlaylist

    objectName: "objectPagePlaylist"

    showCSDControls: true

    property int timePos
    property int duration
    property string timePosInfo
    property string durationInfo
    property string nextPageToken
    property bool visibleLabelTime: false

    Component.onCompleted: {
        currentIndex = 0
        currentPage = "playlist"
        jsonData.deleteData("/tmp/playlist.json")
        download.destination = "file:///tmp/playlist.json"
        download.url = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=" + playlistId + "&maxResults=" + playlistMaxResults + "&key=" + apiKeyYouTube
        download.running = true
    }

    Component.onDestruction: {
        renderer.setProperty("pause",true)
    }

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

    JsonData {
        id: jsonData
    }

    Download {
        id: download

        running: false

        followRedirects: true
        onRedirected: console.log('Redirected',url,'->',redirectUrl)

        onStarted: console.log('Started download',url)
        onError: console.error(errorString)
        onProgressChanged: console.log(url,'progress:',progress)
        onFinished: {
            console.info(url,'done')
            running = false
            parse()
        }
    }

    function parse() {
        jsonData.parse(download.destination);
        if(jsonData.result) {
            for(var i = 0; i < jsonData.length; i++) {
                var obj = jsonData.data[i];

                playlistModel.append({"videoId": obj.videoId,"title": obj.title,"description": obj.description,"thumbnailUrl": obj.thumbnailUrl,"channelTitle": obj.channelTitle,"channelId": obj.channelId,"videoOwnerChannelTitle": obj.videoOwnerChannelTitle,"videoOwnerChannelId": obj.videoOwnerChannelId})
            }

            nextPageToken = jsonData.nextPageToken
            bannerText.text = playlistModel.get(0).title
            var channel = playlistModel.get(0).videoOwnerChannelTitle
            buttonMore.text = channel.substr(0, 3) + "..."

        } else {
            console.warn("Any data has not found by enable status!")
        }
    }

    Connections {
        target: renderer
        onPropertyChanged: {

            if (property == "duration") {
                duration = Math.round(data)
                videoDuration = duration

                playerSlider.to = duration
                videoPlayerSlider.to = duration

                var dateObj = new Date(duration * 1000);
                var hours = dateObj.getUTCHours();
                var minutes = dateObj.getUTCMinutes();
                var seconds = dateObj.getSeconds();

                durationInfo = hours.toString().padStart(2, '0') + ':' +
                    minutes.toString().padStart(2, '0') + ':' +
                    seconds.toString().padStart(2, '0');

                videoDurationInfo = durationInfo

                visibleLabelTime = true
                videoLabelTime.visible = true
            }

            if (property == "time-pos") {
                timePos = Math.round(data)
                playerSlider.value = timePos
                videoPlayerSlider.value = timePos

                var dateObj = new Date(timePos * 1000);
                var hours = dateObj.getUTCHours();
                var minutes = dateObj.getUTCMinutes();
                var seconds = dateObj.getSeconds();

                timePosInfo = hours.toString().padStart(2, '0') + ':' +
                    minutes.toString().padStart(2, '0') + ':' +
                    seconds.toString().padStart(2, '0');

                videoTimePosInfo = timePosInfo
            }

            if (property == "idle-active" && data == true) {
                if (currentIndex < playlistModel.count - 1) {
                    currentIndex = currentIndex + 1
                    renderer.command(["loadfile", "https://www.youtube.com/watch?v=" + playlistModel.get(currentIndex).videoId])
                    playButton.icon.name = "media-playback-stop"
                    videoPlayButton.icon.name = "media-playback-stop"
                    playingPanelCover.imageSource = playlistModel.get(currentIndex).thumbnailUrl
                    playingPanelLabel.text = playlistModel.get(currentIndex).title
                    bannerText.text = playlistModel.get(currentIndex).title
                    playerPanel.visible = true
                    console.info("entra idle-active playlist")
                }
            }

            if (property == "pause") {
                if (data == false) {
                    playButton.icon.name = "media-playback-stop"
                    videoPlayButton.icon.name = "media-playback-stop"
                }
                else if (data == true) {
                    playButton.icon.name = "media-playback-start"
                    videoPlayButton.icon.name = "media-playback-start"
                }
            }
        }
    }

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
            source: mask
            maskSource: results
        }

        LinearGradient {
            id: mask
            anchors.fill: parent
            z: 1
            gradient: Gradient {
                GradientStop { position: 0.70; color: "transparent"}
                GradientStop { position: 0.80; color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Maui.Theme.backgroundColor : Qt.lighter(Maui.Theme.backgroundColor,1.65) }
            }
        }

        OpacityMask {
            source: maskBanner
            maskSource: results
        }

        LinearGradient {
            id: maskBanner
            anchors.fill: parent
            anchors.topMargin: 150
            z: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.83) : Qt.lighter(Maui.Theme.backgroundColor,1.3)}
                GradientStop { position: 0.02; color: "transparent" }
            }
        }

        Maui.ShadowedRectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            corners.topLeftRadius: 7
            height: 150
            color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.83) : Qt.lighter(Maui.Theme.backgroundColor,1.3)

            Label {
                id: bannerText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.bottomMargin: 13

                font.pixelSize: 26
            }
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

                model: playlistModel
                delegate: Maui.ShadowedRectangle {
                    id: card
                    width: parent.width
                    height: 70
                    color: currentIndex == index ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.83) : Qt.lighter(Maui.Theme.backgroundColor,1.9)) : (listMouse.hovered ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.83) : Qt.lighter(Maui.Theme.alternateBackgroundColor,1.6)) :
                    (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.alternateBackgroundColor,1.025) : Qt.lighter(Maui.Theme.backgroundColor,1.3)))
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        Rectangle {
                            height: card.height
                            Layout.fillWidth: true
                            Layout.minimumWidth: card.height
                            color: "transparent"
                            Label {
                                id: labelTitle
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 5
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                text: title
                            }
                            Label {
                                visible: true
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: labelTitle.bottom
                                anchors.leftMargin: 5
                                anchors.topMargin: 2
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                height: 15
                                text: description
                            }
                            Label {
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                anchors.margins: 5
                                font.pixelSize: 10
                                elide: Text.ElideRight
                                text: videoOwnerChannelTitle
                            }
                        }
                        Rectangle {
                            id: thumbnailRect
                            width: card.height
                            height: card.height
                            color: "transparent"
                            radius: 4
                            Layout.alignment: Qt.AlignRight
                            Maui.IconItem
                            {
                                anchors.margins: 10
                                anchors.fill: parent
                                imageSource: thumbnailUrl
                                iconSource: "emblem-music-symbolic"
                                //imageSizeHint: 110
                                maskRadius: Maui.Style.radiusV
                                fillMode: Image.PreserveAspectCrop
                                Maui.IconItem
                                {
                                    Maui.Theme.inherit: false
                                    Maui.Theme.colorSet: Maui.Theme.Complementary
                                    visible: currentIndex == index ? true : false
                                    anchors.margins: 10
                                    anchors.fill: parent
                                    iconSource: "media-playback-start"
                                    maskRadius: Maui.Style.radiusV
                                    fillMode: Image.PreserveAspectCrop
                                }
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
                                currentIndex = index
                                renderer.command(["loadfile", "https://www.youtube.com/watch?v=" + videoId])
                                renderer.setProperty("pause",false)
                                renderer.setProperty("time-pos", 0)
                                playButton.icon.name = "media-playback-stop"
                                videoPlayButton.icon.name = "media-playback-stop"
                                playingPanelCover.imageSource = thumbnailUrl
                                playingPanelLabel.text = title
                                var channel = videoOwnerChannelTitle
                                buttonMore.text = channel.substr(0, 3) + "..."
                                bannerText.text = title
                                playerPanel.visible = true
                                playingPanel.visible = true
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

    // PLAYING

    Maui.ShadowedRectangle {
        id: playingPanel
        anchors.left: parent.left
        anchors.bottom: playerPanel.top
        anchors.leftMargin: 25
        anchors.bottomMargin: 20
        visible: false
        width: playerMouse.hovered ? 210 : 115
        height: playerMouse.hovered ? 100 : 40
        color: Qt.lighter(Maui.Theme.alternateBackgroundColor,1.05)
        border.width: 2
        border.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.63) : Qt.darker("#23272A",1.0)
        shadow.size: 10
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.0) : "#2c2c2c"
        shadow.xOffset: 0
        shadow.yOffset: 0
        radius: 4

        Behavior on width {
            NumberAnimation {
                duration: 2000
                easing.type: Easing.OutExpo		// Comprobar diferencia en animación tanto con la curva
            }					// OutExpo como sin dicha curva de animación
        }

        Behavior on height {
            NumberAnimation {
                duration: 2000
                easing.type: Easing.OutExpo		// Comprobar diferencia en animación tanto con la curva
            }					// OutExpo como sin dicha curva de animación
        }

        state: visible ? "Visible" : "Invisible"
        states: [
            State{
                name: "Visible"
                PropertyChanges{target: playingPanel; opacity: 1.0}
                PropertyChanges{target: playingPanel; visible: true}
            },
            State{
                name:"Invisible"
                PropertyChanges{target: playingPanel; opacity: 0.0}
                PropertyChanges{target: playingPanel; visible: false}
            }
        ]

        transitions: [
            Transition {
                from: "Visible"
                to: "Invisible"

                SequentialAnimation{
                    NumberAnimation {
                        target: playingPanel
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: playingPanel
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
                        target: playingPanel
                        property: "visible"
                        duration: 0
                    }
                    NumberAnimation {
                        target: playingPanel
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.Linear
                    }
                }
            }
        ]

        Rectangle {
            id: playingPanelCoverRect
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.height
            height: parent.height
            color: "transparent"
            radius: 4
            visible: playingPanel.height == 100 ? true : false
            opacity: playingPanel.height == 100 ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.OutExpo
                }
            }

            Maui.IconItem
            {
                id: playingPanelCover
                anchors.fill: parent
                anchors.margins: 10
                iconSource: "emblem-music-symbolic"
                maskRadius: Maui.Style.radiusV
                fillMode: Image.PreserveAspectCrop
            }
        }
        Label {
            id: playingPanelLabel
            visible: false
            anchors.left: playingPanelCoverRect.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.leftMargin: 12
            anchors.rightMargin: 6
            anchors.bottomMargin: 6
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            elide: Text.ElideRight
            font.pixelSize: 11
        }

		ToolButton
		{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 6
			icon.name: "video-television"
            text: "Switch to video"
            font.pixelSize: 11
            flat: true
            onClicked: {
                rectRenderer.visible = true
                sidePanel.visible = false
                sidePanel.width = 0
            }
		}
    }

    // BUTTON +

    Maui.ShadowedRectangle {
        id: rectMore
        anchors.right: parent.right
        anchors.bottom: buttonNextPage.top
        anchors.margins: 20
        width: 80
        height: 40
        color: Qt.lighter(Maui.Theme.alternateBackgroundColor,1.05)
        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 10
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.0) : "#2c2c2c"
        shadow.xOffset: 0
        shadow.yOffset: 0
        radius: 4
        opacity: 0

        Component.onCompleted: {
            rectMoreOpacityAnimation.start()
        }

        PropertyAnimation {
            id: rectMoreOpacityAnimation
            target: rectMore
            properties: "opacity"
            from: 0
            to: 1.0
            duration: 1000
            easing.type: Easing.Linear
        }

        Button {
            id: buttonMore
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            flat: true
            icon.name: "list-add"
            onClicked: {
                channelVideosModel.clear()
                renderer.setProperty("pause",true)
                stackViewSidePanel.pop()
                stackView.push("qrc:/More.qml")
                stackViewSidePanel.push("qrc:/MainMenu.qml")
            }
        }
    }

    // BUTTON NEXT PAGE

    Maui.ShadowedRectangle {
        id: buttonNextPage
        anchors.right: parent.right
        anchors.bottom: playerPanel.visible ? playerPanel.top : parent.bottom
        anchors.margins: 20
        width: 80
        height: 40
        color: Qt.lighter(Maui.Theme.alternateBackgroundColor,1.05)
        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 10
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.0) : "#2c2c2c"
        shadow.xOffset: 0
        shadow.yOffset: 0
        radius: 4
        opacity: 0

        Component.onCompleted: {
            buttonNextPageOpacityAnimation.start()
        }

        PropertyAnimation {
            id: buttonNextPageOpacityAnimation
            target: buttonNextPage
            properties: "opacity"
            from: 0
            to: 1.0
            duration: 1000
            easing.type: Easing.Linear
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            flat: true
            icon.name: "go-next"
            text: "Next"
            onClicked: {
                if (nextPageToken != "") {
                    jsonData.deleteData("/tmp/playlist.json")
                    download.destination = "file:///tmp/playlist.json"
                    download.url = "https://youtube.googleapis.com/youtube/v3/playlistItems?pageToken=" + nextPageToken + "&part=snippet&playlistId=" + playlistId + "&maxResults=" + playlistMaxResults + "&key=" + apiKeyYouTube
                    download.running = true
                }
            }
        }
    }

    // PLAYER

    Maui.Page {
        id: playerPanel
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 25
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
        height: playerMouse.hovered ? 100 : 50

        headBar.visible: false

        PropertyAnimation {
            id: playerPanelOpacityAnimation
            target: playerPanel
            properties: "opacity"
            from: 0
            to: 1.0
            duration: 1000
            easing.type: Easing.Linear
        }

        Behavior on height {
            NumberAnimation {
                duration: 2000
                easing.type: Easing.OutExpo
            }
        }

        background: Maui.ShadowedRectangle {
            id: bkPlayer
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.View
            anchors.fill: parent
            color: Qt.lighter(Maui.Theme.alternateBackgroundColor,1.05)
            border.width: 2
            border.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.43) : Qt.darker("#23272A",1.0)
            shadow.size: 10
            shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.0) : "#2c2c2c"
            shadow.xOffset: 0
            shadow.yOffset: 0
            radius: 4
            opacity: 0.99
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: playerMouse.hovered ? false : true
                Layout.preferredHeight: playerMouse.hovered ? 40 : 0
                color: "transparent"

                Button {
                    id: prevVideoButton
                    anchors.right: backButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 25
                    flat: true
                    icon.name: "media-skip-backward"
                    onClicked: {
                        if (currentIndex > 0) {
                            currentIndex = currentIndex - 1
                            renderer.command(["loadfile", "https://www.youtube.com/watch?v=" + playlistModel.get(currentIndex).videoId])
                            renderer.setProperty("pause",false)
                            renderer.setProperty("time-pos", 0)
                            playButton.icon.name = "media-playback-stop"
                            playingPanelCover.imageSource = playlistModel.get(currentIndex).thumbnailUrl
                            playingPanelLabel.text = playlistModel.get(currentIndex).title
                            var channel = playlistModel.get(currentIndex).videoOwnerChannelTitle
                            buttonMore.text = channel.substr(0, 3) + "..."
                            bannerText.text = playlistModel.get(currentIndex).title
                        }
                    }
                }

                Button {
                    id: backButton
                    anchors.right: playButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 25
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
                    id: playButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    flat: true
                    icon.name: "media-playback-start"
                    onClicked: {
                        if (renderer.getProperty("pause") == true) {
                            playButton.icon.name = "media-playback-stop"
                            renderer.setProperty("pause",false)
                        }
                        else {
                            playButton.icon.name = "media-playback-start"
                            renderer.setProperty("pause",true)
                        }
                    }
                }

                Button {
                    id: nextButton
                    anchors.left: playButton.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 25
                    flat: true
                    icon.name: "media-seek-forward"
                    onClicked: {
                        var time = renderer.getProperty("time-pos")
                        if (time + 20 < duration) {
                            renderer.setProperty("time-pos", time + 20)
                        }
                        else {
                            renderer.setProperty("time-pos", duration)
                        }
                    }
                }

                Button {
                    id: nextVideoButton
                    anchors.left: nextButton.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 25
                    flat: true
                    icon.name: "media-skip-forward"
                    onClicked: {
                        if (currentIndex < playlistModel.count - 1) {
                            currentIndex = currentIndex + 1
                            renderer.command(["loadfile", "https://www.youtube.com/watch?v=" + playlistModel.get(currentIndex).videoId])
                            renderer.setProperty("pause",false)
                            renderer.setProperty("time-pos", 0)
                            playButton.icon.name = "media-playback-stop"
                            playingPanelCover.imageSource = playlistModel.get(currentIndex).thumbnailUrl
                            playingPanelLabel.text = playlistModel.get(currentIndex).title
                            var channel = playlistModel.get(currentIndex).videoOwnerChannelTitle
                            buttonMore.text = channel.substr(0, 3) + "..."
                            bannerText.text = playlistModel.get(currentIndex).title
                        }
                    }
                }
            }

            Slider {
                id: playerSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                from: 0
                value: 0
                to: 100
                visible: playerMouse.hovered ? true : false
                onMoved: {
                    renderer.setProperty("time-pos", value)
                }
            }
        }

        Label {
            id: labelTime
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10 + 20
            font.pixelSize: 11
            text: timePosInfo + " / " + durationInfo

            visible: playerPanel.height == 100 ? visibleLabelTime : false
            opacity: playerPanel.height == 100 ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.OutExpo
                }
            }
        }
        HoverHandler {
            id: playerMouse
        }
    }
}
