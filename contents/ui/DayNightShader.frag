
varying highp vec2 coord;
uniform float effectStrength;
uniform sampler2D dayNightTex;
uniform sampler2D src;
uniform lowp float qt_Opacity;
void main() {
    lowp vec4 tex = texture2D(src, coord);
    lowp vec4 coloringEffect = texture2D(dayNightTex, timePos);
    gl_FragColor = tex.rgba * coloringEffect * qt_Opacity;
}
