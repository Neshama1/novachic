import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import Qt.labs.settings 1.0

Maui.SettingsDialog
{
    headBar.background: Maui.ShadowedRectangle {
        anchors.fill: parent

        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View

        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 15
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.1) : "#2c2c2c"
        shadow.xOffset: -1
        shadow.yOffset: 0

        color: Maui.Theme.backgroundColor
        corners.topLeftRadius: 6
        corners.topRightRadius: 6
    }

    background: Maui.ShadowedRectangle {
        anchors.fill: parent

        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View

        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 15
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.1) : "#2c2c2c"
        shadow.xOffset: -1
        shadow.yOffset: 0

        color: Maui.Theme.backgroundColor
        corners.topLeftRadius: 6
        corners.topRightRadius: 6
        corners.bottomLeftRadius: 6
        corners.bottomRightRadius: 6
    }

    Maui.SectionGroup
    {
        title: i18n("Results")
        description: i18n("Configure the editor behaviour.")

        Maui.SectionItem
        {
            label1.text:  i18n("Search results")
            label2.text: i18n("Results per page")
            SpinBox {
                from: 5
                to: 50
                value: maxResultsOnSearch

                onValueModified: {
                    maxResultsOnSearch = value
                }
            }
        }

        Maui.SectionItem
        {
            label1.text:  i18n("Latest additions")
            label2.text: i18n("Configure home page")
            SpinBox {
                from: 5
                to: 500
                value: maxResultsOnNewSongs

                onValueModified: {
                    maxResultsOnNewSongs = value
                }
            }
        }
    }

    Maui.SectionGroup
    {
        title: i18n("")
        description: i18n("General")

        Maui.SectionItem
        {
            label1.text:  i18n("Opacity")
            label2.text: i18n("Translucent to opaque")
            SpinBox {
                from: 0
                to: 100
                value: appOpacity * 100

                onValueModified: {
                    appOpacity = value / 100
                }
            }
        }
    }

    Maui.SectionGroup
    {
        title: i18n("")
        description: i18n("YouTube")

        Maui.SectionItem
        {
            label1.text:  i18n("YouTube API Key")
            label2.text: i18n("Provides access to YouTube")
            TextField {
                placeholderText: qsTr("Enter YouTube API Key v3")
                text: apiKeyYouTube
                onEditingFinished: {
                    apiKeyYouTube = text
                }
            }
        }
    }
}
