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
}
