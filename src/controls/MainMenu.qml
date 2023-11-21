import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui

Maui.Page {

    headBar.background: Rectangle {
        anchors.fill: parent
        color: Maui.Theme.backgroundColor
        opacity: 0
    }

    headBar.farLeftContent: [
        Maui.ToolButtonMenu
        {
            icon.name: "application-menu"

            MenuItem
            {
                text: i18n("Settings")
                icon.name: "settings-configure"
                onTriggered: {
                    settingsDialog.open()
                }
            }

            MenuItem
            {
                text: i18n("About")
                icon.name: "documentinfo"
                onTriggered: {
                    root.about()
                }
            }
        }
    ]

    /*
    headBar.farLeftContent: Maui.IconItem
    {
        anchors.verticalCenter: parent.verticalCenter
        iconSource: "folder-music-symbolic"
        //imageSizeHint: 50
        maskRadius: Maui.Style.radiusV
        fillMode: Image.PreserveAspectCrop
    }

    headBar.leftContent: [
        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: "Nova Chic"
            font.pixelSize: 18
        }
    ]
    */

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Window

    background: Rectangle {
        anchors.fill: parent
        color: Maui.Theme.backgroundColor
        opacity: appOpacity
    }

    Component.onCompleted: {
        menuView.currentIndex = menuCurrentIndex
    }
    ListModel {
    id: mainMenuModel
        ListElement { name: "Home" ; description: "Home" ; icon: "go-home" }
        ListElement { name: "Soul" ; description: "Soul" ; icon: "draw-circle" }
        ListElement { name: "Christian" ; description: "Christian" ; icon: "draw-circle" }
        // ListElement { name: "Funky Soul" ; description: "Funky Soul" ; icon: "draw-circle" }
    }

    ListView {
        id: menuView
        anchors.fill: parent
        anchors.margins: 10

        spacing: 5

        model: mainMenuModel
        delegate: Maui.ListBrowserDelegate
        {
            id: list1
            implicitWidth: parent.width
            implicitHeight: 35
            iconSource: icon
            label1.text: name

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    switch (index) {
                        case 0: {
                            menuView.currentIndex = index
                            menuCurrentIndex = index
                            if (stackView.currentItem.objectName != "objectPageHome") {
                                renderer.setProperty("pause",true)
                                rectRenderer.visible = false
                                stackView.pop()
                                stackViewSidePanel.pop()
                                stackView.push("qrc:/Home.qml")
                                stackViewSidePanel.push("qrc:/MainMenu.qml")
                                sidePanel.width = 350

                                // Evita múltiples señales idle-active provocando salto en
                                // más de un paso en la reproducción, asegurando sólo
                                // elemento inicial en el stackView. Anteriores pop y push
                                // permiten sincronizar cambio de opacidad en stackView
                                // y stackViewSidePanel, ya que se produce al efectuar cambio
                                // de página un cambio en dicha opacidad de forma parece
                                // automática. Animar cambio de opacidad permite transición suave.
                                stackView.pop()
                            }
                            return
                        }
                        case 1: {
                            // PLAYLIST SOUL
                            menuView.currentIndex = index
                            menuCurrentIndex = index
                            if (stackView.currentItem.objectName != "objectPagePlaylist" || (stackView.currentItem.objectName == "objectPagePlaylist" && playlistId != "PLJREw8UDEE5Vl9mdKuozsriWEcx2NvPeU")) {
                                renderer.setProperty("pause",true)
                                rectRenderer.visible = false
                                playlistId = "PLJREw8UDEE5Vl9mdKuozsriWEcx2NvPeU"
                                playlistModel.clear()
                                stackView.pop()
                                stackViewSidePanel.pop()
                                stackView.push("qrc:/Playlist.qml")
                                stackViewSidePanel.push("qrc:/MainMenu.qml")
                                sidePanel.width = 350
                            }
                            return
                        }
                        case 2: {
                            // PLAYLIST CHRISTIAN
                            menuView.currentIndex = index
                            menuCurrentIndex = index
                            if (stackView.currentItem.objectName != "objectPagePlaylist" || (stackView.currentItem.objectName == "objectPagePlaylist" && playlistId != "PLJREw8UDEE5W3u14n5rof7_ibdiS2q5DY")) {
                                renderer.setProperty("pause",true)
                                rectRenderer.visible = false
                                playlistId = "PLJREw8UDEE5W3u14n5rof7_ibdiS2q5DY"
                                playlistModel.clear()
                                stackView.pop()
                                stackViewSidePanel.pop()
                                stackView.push("qrc:/Playlist.qml")
                                stackViewSidePanel.push("qrc:/MainMenu.qml")
                                sidePanel.width = 350
                            }
                            return
                        }
                        case 3: {
                            menuView.currentIndex = index
                            menuCurrentIndex = index
                            return
                        }
                    }
                }
            }
        }
    }
}
