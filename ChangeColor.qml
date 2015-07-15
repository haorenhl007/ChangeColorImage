import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

Rectangle {
    width: 1000; height: 400;
    color: "#1e1e1e"
    property color textColor: "yellow"
    Column {
        Label {
            text: "Original Image:"
            font.pixelSize: 16
            color: textColor
        }

        Image {
            id: sourceImage
            source: "./SOFA_Leather-Red.png"
            width: 300
            height: 300
        }
        Label {
            text: "Modified Images:"
            font.pixelSize: 16
            color: textColor
        }
        Row {
            spacing: 20
            Column {

            ShaderEffect {
                id: effect4
                width: 300; height: 300
                property color defaultColor: "#FFFFFF"
                property color sensivityColor: Qt.rgba(sliderOfRed.value, sliderOfGreen.value, sliderOfBlue.value,1)
                property variant src: sourceImage
                vertexShader: "
                   uniform highp mat4 qt_Matrix;
                   attribute highp vec4 qt_Vertex;
                   attribute highp vec2 qt_MultiTexCoord0;
                   varying highp vec2 coord;
                   varying highp vec2 qt_TexCoord0;
                   void main() {
                       coord = qt_MultiTexCoord0;
                       qt_TexCoord0 = qt_MultiTexCoord0;
                       gl_Position = qt_Matrix * qt_Vertex;
                   }"
                fragmentShader: "
                    uniform sampler2D src; // this item
                    uniform lowp vec4 defaultColor; // this item
                    uniform lowp vec4 sensivityColor; // this item
                    uniform lowp float qt_Opacity; // inherited opacity of this item
                    varying highp vec2 qt_TexCoord0;
                    vec3 rgb2hsv(vec3 c)
                    {
                        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
                        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

                        float d = q.x - min(q.w, q.y);
                        float e = 1.0e-10;
                        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
                    }

                    vec3 hsv2rgb(vec3 c)
                    {
                        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
                        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
                        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
                    }

                    void main() {
                        vec4 textureColor = texture2D(src, qt_TexCoord0);
                        vec3 fragRGB = textureColor.rgb;
                        vec3 fragHSV = rgb2hsv(fragRGB);
                        vec3 vHSV = rgb2hsv(sensivityColor.rgb);
                        float h = vHSV.x;
                        fragHSV.x = h;
                        fragHSV.yz *= vHSV.yz;
                        fragHSV.xyz = mod(fragHSV.xyz, 1.0);
                        fragRGB = hsv2rgb(fragHSV);
                        gl_FragColor = vec4(fragRGB, textureColor.a);
                    }"
              }
            Row {
                Label {
                    text: "Red"
                    color: textColor
                }
                Slider {
                    id: sliderOfRed
                    minimumValue: 0.0
                    maximumValue: 1.0
                    stepSize: 0.01
                    value: 1
                }
                Label {
                    text: sliderOfRed.value
                    color: textColor
                }
            }
            Row {
                Label {
                    text: "Green"
                    color: textColor
                }
                Slider {
                    id: sliderOfGreen
                    minimumValue: 0.0
                    maximumValue: 1.0
                    stepSize: 0.01
                    value: 1
                }
                Label {
                    text: sliderOfGreen.value
                    color: textColor
                }
            }
            Row {
                Label {
                    text: "Blue"
                    color: textColor
                }
                Slider {
                    id: sliderOfBlue
                    minimumValue: 0.0
                    maximumValue: 1.0
                    stepSize: 0.01
                    value: 1
                }
                Label {
                    text: sliderOfBlue.value
                    color: textColor
                }
            }
            }
            Column {
                ShaderEffect {
                    id: effect3
                    width: 300; height: 300
                    property color defaultColor: "#a3303a"
                    property color newColor: "#444400"
                    property color sensivityColor: Qt.rgba(sliderOfRed.value, sliderOfGreen.value, sliderOfBlue.value,1.0)
                    property variant src: sourceImage
                    vertexShader: "
                       uniform highp mat4 qt_Matrix;
                       attribute highp vec4 qt_Vertex;
                       attribute highp vec2 qt_MultiTexCoord0;
                       varying highp vec2 coord;
                       varying highp vec2 qt_TexCoord0;
                       void main() {
                           coord = qt_MultiTexCoord0;
                           qt_TexCoord0 = qt_MultiTexCoord0;
                           gl_Position = qt_Matrix * qt_Vertex;
                       }"
                    fragmentShader: "
                        uniform sampler2D src; // this item
                        uniform lowp vec4 defaultColor; // this item
                        uniform lowp vec4 newColor; // this item
                        uniform lowp vec4 sensivityColor; // this item
                        uniform lowp float qt_Opacity; // inherited opacity of this item
                        varying highp vec2 qt_TexCoord0;
                        void main() {
                            lowp vec4 p = texture2D(src, qt_TexCoord0);
                            if(p.w != 0)
                            {
                                p.xyz = p.xyz * sensivityColor.xyz;
                                p.xyz = mod(p.xyz, 1.0);
                            }
                            gl_FragColor = p;
                        }"
                }
            }
            Column {
                HueSaturation {
                    width: 300
                    height: 300
                    source: sourceImage
                    hue: -1 + 2 * sliderOfHue.value
                    lightness: -1 +  sliderOfLightness.value
                    saturation: -1 + sliderOfSaturation.value
                }
                Row {
                    Label {
                        text: "Hue"
                        color: textColor
                    }
                    Slider {
                        id: sliderOfHue
                        minimumValue: 0.0
                        maximumValue: 2.0
                        stepSize: 0.01
                        value: 1
                    }
                    Label {
                        text: sliderOfHue.value
                        color: textColor
                    }
                }
                Row {
                    Label {
                        text: "Lightness"
                        color: textColor
                    }
                    Slider {
                        id: sliderOfLightness
                        minimumValue: 0.0
                        maximumValue: 2.0
                        stepSize: 0.01
                        value: 1
                    }
                    Label {
                        text: sliderOfLightness.value
                        color: textColor
                    }
                }
                Row {
                    Label {
                        text: "Saturation"
                        color: textColor
                    }
                    Slider {
                        id: sliderOfSaturation
                        minimumValue: 0.0
                        maximumValue: 2.0
                        stepSize: 0.01
                        value: 1
                    }
                    Label {
                        text: sliderOfSaturation.value
                        color: textColor
                    }
                }
            }

        }
    }
}
