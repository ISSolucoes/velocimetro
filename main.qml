import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtPositioning

Window {
    id: root
    visible: true
    title: qsTr("Velocímetro")
    color: "black"

    //Component.onCompleted: root.showFullScreen();

    Rectangle {
        id: qtAcknowledgements
        width: (root.width * (30/100))
        height: width/4
        z: 1
        anchors.right: parent.right
        anchors.top: parent.top
        clip: true
        color: "transparent"

        Text {
            id: reconhecimentosQtCompany
            z: 1
            width: parent.width
            height: parent.height
            text: qsTr("Feito com Qt 6.4")
            minimumPixelSize: 10
            font.pixelSize: 15;
            fontSizeMode: Text.Fit
            color: "white"
            anchors.centerIn: parent
        }
    }

    function verificaErroGPS() {
        if( positionSource.sourceError === PositionSource.AccessError ) {
            lblVelocidadeKMh.text = qsTr("Permita o acesso ao GPS");
            lblVelocidadeMs.text = "";
        } else if( positionSource.sourceError === PositionSource.ClosedError ) {
            lblVelocidadeKMh.text = qsTr("Ative o GPS e mova-se");
            lblVelocidadeMs.text = "";
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods
        property int velocidadeMaximaSalva: 0
        property double distanciaPercorridaSalva: 0

        onPositionChanged: function() {
            let vel = positionSource.position.speed;
            vel = isNaN(vel) ? 0 : vel;
            lblVelocidadeKMh.text = `${Math.floor(vel * 3.6)} KM/h`;
            lblVelocidadeMs.text = `${Math.floor(vel)} M/s`;

            let velocidadeEmKMH = Math.floor(vel * 3.6);
            if( velocidadeEmKMH >= velocidadeMaximaSalva ) {
                velocidadeMaximaSalva = velocidadeEmKMH;
                velMaxValor.text = `${velocidadeMaximaSalva} KM/h`;
            }

            let velMS = vel < 0.8 ? 0 : parseFloat(vel.toFixed(3)); // velocidade minima de 0,8 m/s para começar a somar, o GPS do meu celular é louco
            distanciaPercorridaSalva += velMS;
            let distanciaPercorridaEmM = parseInt(distanciaPercorridaSalva);
            let distanciaPercorridaEmKM = parseFloat((distanciaPercorridaSalva/1000).toFixed(2));
            if( distanciaPercorridaSalva < 1000 ) {
                distanciaPercorridaValor.text = `${distanciaPercorridaEmM} M`;
            } else if ( distanciaPercorridaSalva >= 1000 ) {
                distanciaPercorridaValor.text = `${distanciaPercorridaEmKM} KM`;
            }

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
            id: retanguloSuperior
            color: coluna.color
            width: coluna.width
            height: coluna.height/2

            Column {
                id: colunaSuperior
                anchors.fill: parent

                Rectangle {
                    id: rect1
                    color: retanguloSuperior.color
                    width: retanguloSuperior.width
                    height: retanguloSuperior.height/2

                    Text {
                        id: lblVelocidadeKMh
                        color: "white"
                        text: "0 KM/h"
                        width: parent.width
                        height: parent.height
                        minimumPixelSize: 10
                        font.pixelSize: 400
                        fontSizeMode: Text.Fit
                        font.italic: true
                        font.bold: true
                        verticalAlignment: Text.AlignBottom
                        horizontalAlignment: Text.AlignHCenter
                        padding: 15
                    }

                }

                Rectangle {
                    id: rect2
                    color: retanguloSuperior.color
                    width: retanguloSuperior.width
                    height: retanguloSuperior.height/2

                    Text {
                        id: lblVelocidadeMs
                        width: parent.width
                        height: parent.height
                        minimumPixelSize: 10
                        font.pixelSize: 400
                        fontSizeMode: Text.Fit
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        text: "0 M/s"
                        font.italic: true
                        font.bold: true
                        padding: 15
                    }
                }

            }


        }

        Rectangle {
            id: retanguloInferior
            color: "black"
            width: coluna.width
            height: coluna.height/2

            Row {
                anchors.fill: retanguloInferior
                Rectangle {
                    id: retanguloInferiorEsquerdo
                    width: retanguloInferior.width/2
                    height: retanguloInferior.height
                    anchors.left: parent.left
                    color: "black"

                    Column {
                        id: colunaDistanciaPercorrida
                        anchors.fill: retanguloInferiorEsquerdo
                        Rectangle {
                            id: retanguloDistanciaPercorridaNome
                            width: parent.width
                            height: parent.height/3
                            color: "black"
                            Text {
                                id: distanciaPercorridalbl
                                color: "white"
                                text: "Distância percorrida"
                                width: parent.width
                                height: parent.height
                                minimumPixelSize: 10
                                font.pixelSize: 100
                                fontSizeMode: Text.Fit
                                verticalAlignment: Text.AlignBottom
                                horizontalAlignment: Text.AlignHCenter
                                padding: 10
                            }
                        }

                        Rectangle {
                            id: retanguloDistanciaPercorridaValor
                            width: parent.width
                            height: parent.height/3
                            color: "black"
                            Text {
                                id: distanciaPercorridaValor
                                color: "white"
                                text: "0 M"
                                width: parent.width
                                height: parent.height
                                minimumPixelSize: 10
                                font.pixelSize: 400
                                fontSizeMode: Text.Fit
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                padding: 10
                            }
                        }

                        Button {
                            id: botaoZerarDistanciaPercorrida
                            width: parent.width * 70/100
                            text: "ZERAR"
                            anchors.top: distanciaPercorridaValor.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            onClicked: function() {
                                positionSource.distanciaPercorridaSalva = 0;
                                distanciaPercorridaValor.text = "0 M";
                            }
                        }
                    }

                }
                Rectangle {
                    id: retanguloInferiorDireito
                    width: retanguloInferior.width/2
                    height: retanguloInferior.height
                    anchors.right: parent.right
                    color: "black"

                    Column {
                        id: colunaVelMax
                        anchors.fill: retanguloInferiorDireito
                        Rectangle {
                            id: retanguloVelMaxNome
                            width: parent.width
                            height: parent.height/3
                            color: "black"
                            Text {
                                id: velMaxlbl
                                color: "white"
                                text: "Velocidade máxima"
                                width: parent.width
                                height: parent.height
                                minimumPixelSize: 10
                                font.pixelSize: 400
                                fontSizeMode: Text.Fit
                                verticalAlignment: Text.AlignBottom
                                horizontalAlignment: Text.AlignHCenter
                                padding: 10
                            }
                        }

                        Rectangle {
                            id: retanguloVelMaxValor
                            width: parent.width
                            height: parent.height/3
                            color: "black"
                            Text {
                                id: velMaxValor
                                color: "white"
                                text: "0 KM/h"
                                width: parent.width
                                height: parent.height
                                minimumPixelSize: 10
                                font.pixelSize: 400
                                fontSizeMode: Text.Fit
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                padding: 10
                            }
                        }

                        Button {
                            id: botaoZerarVelMax
                            width: parent.width * 70/100
                            text: "ZERAR"
                            anchors.top: velMaxValor.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            onClicked: function() {
                                positionSource.velocidadeMaximaSalva = 0;
                                velMaxValor.text = "0 KM/h";
                            }
                        }
                    }

                }
            }

        }


    }

}
