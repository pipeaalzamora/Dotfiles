import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation

    property string verseText: "Jehová es mi pastor; nada me faltará. En lugares de delicados pastos me hará descansar."
    property string verseRef: "Salmos 23:1-2"
    property string homeDir: StandardPaths.writableLocation(StandardPaths.HomeLocation)

    function loadVerse() {
        var xhr = new XMLHttpRequest();
        var cachePath = homeDir + "/.cache/daily-verse.json";
        xhr.open("GET", "file://" + cachePath, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        if (data && data.text && data.reference) {
                            root.verseText = data.text;
                            root.verseRef = data.reference;
                        }
                    } catch(e) {
                        // Fallback predeterminado si el JSON aún no existe
                    }
                }
            }
        };
        xhr.send();
    }

    Component.onCompleted: {
        loadVerse();
    }

    // Temporizador para recargar el versículo cada hora
    Timer {
        interval: 3600000 // 1 hora
        running: true
        repeat: true
        onTriggered: root.loadVerse()
    }

    // Representación compacta (para cuando se ubica en el panel / barra de tareas)
    compactRepresentation: Item {
        width: Kirigami.Units.gridUnit * 2
        height: Kirigami.Units.gridUnit * 2

        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.smallMedium
            height: Kirigami.Units.iconSizes.smallMedium
            source: "bookmarks"
        }

        PlasmaComponents3.ToolTip {
            text: root.verseRef + "\n" + root.verseText
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }

    // Representación completa (para escritorio o popup al hacer clic)
    fullRepresentation: Rectangle {
        id: card
        implicitWidth: Kirigami.Units.gridUnit * 22
        implicitHeight: Kirigami.Units.gridUnit * 13
        radius: 14
        color: "#1e1e2e" // Catppuccin Mocha Base
        border.color: "#313244" // Catppuccin Surface0
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            // Cabecera con Icono y Título
            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Icon {
                    source: "bookmarks"
                    width: Kirigami.Units.iconSizes.small
                    height: Kirigami.Units.iconSizes.small
                    color: "#89b4fa" // Catppuccin Blue
                }

                PlasmaComponents3.Label {
                    text: "Reina Valera 1960"
                    font.bold: true
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize
                    color: "#89b4fa"
                    Layout.fillWidth: true
                }

                PlasmaComponents3.ToolButton {
                    icon.name: "view-refresh"
                    text: ""
                    onClicked: root.loadVerse()
                    PlasmaComponents3.ToolTip {
                        text: "Recargar Versículo"
                    }
                }
            }

            // Separador sutil
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#313244"
            }

            // Texto del Versículo
            PlasmaComponents3.Label {
                text: "«" + root.verseText + "»"
                wrapMode: Text.WordWrap
                font.italic: true
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 1
                color: "#cdd6f4" // Catppuccin Text
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
            }

            // Cita Bíblica
            PlasmaComponents3.Label {
                text: "— " + root.verseRef
                font.bold: true
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                color: "#cba6f7" // Catppuccin Mauve
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
