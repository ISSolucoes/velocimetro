import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtPositioning

Window {
    id: root
    visible: true
    title: qsTr("Velocímetro")
    color: "black"

    Rectangle {
        id: qtAcknowledgements
        width: (root.width * (10/100))
        height: width
        anchors.right: parent.right
        anchors.top: parent.top
        clip: true
        color: "transparent"
        Image {
            id: qtLogo
            source: `qrc:/Imagens/qt6.png`
            width: parent.width
            height: parent.height
            opacity: 1
        }
        Label {
            id: lblQtAcknowledgement
            text: qsTr("Qt 6.2.4")
            font.pixelSize: 10;
            anchors.bottom: parent.bottom
        }
    }

    function verificaErroGPS() {
        if( positionSource.sourceError === PositionSource.AccessError ) {
            lblVelocidadeKMh.text = qsTr("Permita o acesso ao GPS");
            lblVelocidadeMs.text = "";
        }
        if( positionSource.sourceError === PositionSource.ClosedError ) {
            lblVelocidadeKMh.text = qsTr("Ative o GPS e mova-se");
            lblVelocidadeMs.text = "";
        }
    }

    Component.onCompleted: function() {
        root.showFullScreen();
    }

    PositionSource {
        id: positionSource
        updateInterval: 100
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        onPositionChanged: function() {
            let vel = positionSource.position.speed;
            vel = isNaN(vel) ? 0 : vel;
            lblVelocidadeKMh.text = `${Math.floor(vel * 3.6)} KM/h`;
            lblVelocidadeMs.text = `${Math.floor(vel)} M/s`;
        }
        onSourceErrorChanged: verificaErroGPS();
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        anchors.centerIn: parent
        antialiasing: true

        Label {
            id: lblVelocidadeKMh
            color: "white"
            text: "0 KM/h"
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: (parent.width/(lblVelocidadeKMh.text.length))
            font.italic: true
            font.bold: true
        }

        Label {
            id: lblVelocidadeMs
            color: "white"
            text: "0 M/s"
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: ((parent.width/(lblVelocidadeMs.text.length))/2)
            font.italic: true
            font.bold: true
        }

    }

}
