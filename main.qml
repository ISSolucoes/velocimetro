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
        width: (root.width * (30/100))
        height: width/4
        z: 1
        anchors.right: parent.right
        anchors.top: parent.top
        clip: true
        color: "transparent"

        Label {
            id: lblQtAcknowledgement
            z: 1
            text: qsTr("Feito com Qt 6.4.0")
            font.pixelSize: 14;
            color: "white"
            anchors.centerIn: parent
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

    Column {
        id: coluna
        anchors {
            fill: parent
        }
        readonly property string color: "black"

        Rectangle {
            id: rect1
            color: coluna.color
            width: coluna.width
            height: coluna.height/2

            Label {
                id: lblVelocidadeKMh
                color: "white"
                text: "0 KM/h"
                anchors {
                    bottom: rect1.bottom
                    horizontalCenter: rect1.horizontalCenter
                    bottomMargin: 10
                }
                font.pixelSize: (parent.width/(lblVelocidadeKMh.text.length))
                font.italic: true
                font.bold: true
            }

        }
        Rectangle {
            id: rect2
            color: coluna.color
            width: coluna.width
            height: coluna.height/2

            Label {
                id: lblVelocidadeMs
                color: "white"
                text: "0 M/s"
                anchors {
                    top: rect2.top
                    horizontalCenter: rect2.horizontalCenter
                    topMargin: 10
                }
                font.pixelSize: ((parent.width/(lblVelocidadeMs.text.length))/2)
                font.italic: true
                font.bold: true
            }
        }

    }

}
