import QtQuick 2.11
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.0

Item {
    id: backgroundRoot

    property bool blurEnabled: wallpaper.configuration.Blur
    property var bkColor: wallpaper.configuration.Color
    property var blurRadius: wallpaper.configuration.BlurRadius
    property var fillMode: wallpaper.configuration.FillMode
    property bool dayNightEnabled: wallpaper.configuration.DayNightColoring
    property real dayNightEffect: wallpaper.configuration.DayNightEffect
    property int dayNightOffset: wallpaper.configuration.DayNightOffset
    property real timeoffestForDayNight : (Date.now()+(dayNightOffset*1000)+(new Date()).getTimezoneOffset())%86400000/86400000
    property var imagesMapping: wallpaper.configuration.ImagesList
    property var transitionMapping: wallpaper.configuration.TransitionList

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
            cache: true

            source: backgroundRoot.mapOffestToImage(timeoffestForDayNight);
            fillMode: backgroundRoot.fillMode

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
        fragmentShader: "DayNightShader.frag"
    }
    
    function mapOffestToImage(offset) {
        var retImage = null;
        for(var idx in backgroundRoot.TransitionList) {
            if(backgroundRoot.TransitionList[idx] > offset) {
                break;
            }
            retImage = backgroundRoot.imagesMapping[idx];
        }
        
        return  retImage;
    }
}
