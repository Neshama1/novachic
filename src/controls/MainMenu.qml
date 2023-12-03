import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import com.blackgrain.qml.quickdownload 1.0
import org.mauikit.controls 1.3 as Maui
import org.kde.novachic 1.0

Maui.Page {
    id: pageMainMenu

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
                    if (index == 0) {
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
                    }
                    else if (index == 1)
                    {
                        menuView.currentIndex = index
                        menuCurrentIndex = index

                        if (stackView.currentItem.objectName != "objectPageRadioOptions") {
                            renderer.setProperty("pause",true)
                            rectRenderer.visible = false
                            stackView.pop()
                            stackViewSidePanel.pop()
                            stackView.push("qrc:/RadioOptions.qml")
                            stackViewSidePanel.push("qrc:/MainMenu.qml")
                            sidePanel.width = 350
                        }
                    }
                    else if (index > 1) {
                        menuView.currentIndex = index
                        menuCurrentIndex = index

                        console.info("menuCurrentIndex: " + menuCurrentIndex)

                        var clickedPlaylistIndex = mainMenuModel.get(index).playlistIndex

                        if (stackView.currentItem.objectName != "objectPagePlaylist" || (stackView.currentItem.objectName == "objectPagePlaylist" && playlistId != channelPlaylistsModel.get(clickedPlaylistIndex).playlistId)) {
                            renderer.setProperty("pause",true)
                            rectRenderer.visible = false
                            playlistId = channelPlaylistsModel.get(clickedPlaylistIndex).playlistId
                            playlistModel.clear()
                            stackView.pop()
                            stackViewSidePanel.pop()
                            stackView.push("qrc:/Playlist.qml")
                            stackViewSidePanel.push("qrc:/MainMenu.qml")
                            sidePanel.width = 350
                        }
                    }
                }
            }
        }
    }
}
