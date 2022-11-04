import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtPositioning

Window {
    id: root
    visible: true
    title: qsTr("Velocímetro")
    color: "black"

    Image {
        id: qtLogo
        source: `qrc:/Imagens/qt6.png`
        width: (parent.width * (1/4))
        height: (parent.height * (1/15));
        anchors.right: parent.right
        anchors.top: parent.top
        opacity: 0.5
    }

    function verificaErroGPS() {
        if( positionSource.sourceError === PositionSource.AccessError ) {
            lblVelocidade.text = qsTr("Dê permissão de GPS ao App");
        }
        if( positionSource.sourceError === PositionSource.ClosedError ) {
            lblVelocidade.text = qsTr("GPS Inativo");
        }
    }

    Component.onCompleted: function() {
        root.showFullScreen();
    }

    MouseArea {
        id: mouseArea
        property bool flagMPH: false;

        anchors.fill: parent
        onClicked: function() {
            flagMPH = !flagMPH;
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 0 // o GPS atualiza com seu próprio intervalo
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        onPositionChanged: function() {
            let velocidade = 0;

            let flagMPH = mouseArea.flagMPH;
            let multiplicador = flagMPH ? 1 : 3.6;

            let vel = positionSource.position.speed;
            let velMS = isNaN(vel) ? 0 : vel;
            velocidade = `${Math.floor(velMS * multiplicador)} ${flagMPH ? "M/s" : "KM/h"}`;
            lblVelocidade.text = velocidade;
        }
        onSourceErrorChanged: verificaErroGPS();
    }

    Label {
        id: lblVelocidade
        color: "white"
        text: "0 KM/h"
        anchors.centerIn: parent
        font.pixelSize: parent.width/(lblVelocidade.text.length);
        font.italic: true
        font.bold: true
    }

}
