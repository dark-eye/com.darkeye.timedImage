import QtQuick 2.11
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.0

Item {
    id: backgroundRoot

    property alias source: wallImage.source
    property bool blurEnabled: wallpaper.configuration.Blur
    property var bkColor: wallpaper.configuration.Color
    property var blurRadius: wallpaper.configuration.BlurRadius
    property var fillMode: wallpaper.configuration.FillMode
    property bool dayNightEnabled: wallpaper.configuration.DayNightColoring
    property real dayNightEffect: wallpaper.configuration.DayNightEffect
    property int dayNightOffset: wallpaper.configuration.DayNightOffset
    property real timeoffestForDayNight : (Date.now()+(dayNightOffset*1000)+(new Date()).getTimezoneOffset())%86400000/86400000

    anchors.fill:parent
    Rectangle {
        id:bkRect
        anchors.fill:parent
        color: backgroundRoot.bkColor

        Image {
            id: wallImage
            anchors.fill:parent
            asynchronous:true

            smooth: true
            cache: false

            source: wallpaper.configuration.Image
            fillMode: backgroundRoot.fillMode

            onStatusChanged: playing = (status == AnimatedImage.Ready)
        }
    }
    FastBlur {
        id: blur

        visible: backgroundRoot.blurEnabled
        enabled: visible

        anchors.fill: bkRect

        source: bkRect
        radius: backgroundRoot.blurRadius
    }
    layer.enabled:  backgroundRoot.dayNightEnabled
    layer.effect: ShaderEffect {        
        property variant effectStrength: backgroundRoot.dayNightEffect
        property variant dayNightTex : Image {  source: "day_night_gradient.png" }
        property variant timePos :Qt.point(backgroundRoot.timeoffestForDayNight,1)
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform float effectStrength;
            uniform vec2 timePos;
            uniform sampler2D dayNightTex;
           uniform lowp sampler2D source;
            uniform lowp float qt_Opacity;
            void main() {
                lowp vec4 tex = texture2D(source, qt_TexCoord0);
                lowp vec4 coloringEffect = texture2D(dayNightTex, timePos);
                gl_FragColor = ( tex.rgba + (( coloringEffect.rgba - vec4(0.33, 0.33, 0.33,1) ) * effectStrength) ) * qt_Opacity;
            }"
    }
}
