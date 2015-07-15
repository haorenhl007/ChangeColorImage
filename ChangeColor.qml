import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

Rectangle {
    width: 1000; height: 400;
    color: "#1e1e1e"
    property color textColor: "yellow"

    Column {
        Row {
            id: originals
            property alias sourceImage: privateSourceImage
            property alias textureImage: privateTextureImage
            Label {
                text: "Original Image:"
                font.pixelSize: 16
                color: textColor
            }
            Image {
                id: privateSourceImage
                source: "./SOFA_Leather-Red.png"
                width: 300
                height: 300
            }
            Label {
                text: "Original Texture:"
                font.pixelSize: 16
                color: textColor
            }
            Image {
                id: privateTextureImage
                source: "./wood-floorboards-texture.jpg"
                width: 300
                height: 300
            }
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
                    id: effect1
                    width: 300; height: 300
                    property color defaultColor: "#FFFFFF"
                    property color sensivityColor: colorSelector.selectedColor
                    property variant src: originals.sourceImage
                    property variant texture: originals.textureImage
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
                        uniform sampler2D texture;
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
//                            fragHSV.yz *= vHSV.yz;
//                            fragHSV.xyz = mod(fragHSV.xyz, 1.0);
                            fragRGB = hsv2rgb(fragHSV);
                            gl_FragColor = vec4(fragRGB, textureColor.a);
                        }"
                  }

                Row {
                Label {
                    text: "Color(example: aabbff)"
                    color: textColor
                    anchors.verticalCenter: colorSelector.verticalCenter
                }
                Rectangle {
                    id:colorSelector
                    width: textInput.width + 10
                    height: textInput.height + 10
                    property string selectedColor:"#" + textInput.text
                    color: "white"
                    TextInput {
                        id: textInput
                        anchors.centerIn: parent
                        text: "000000"
                        inputMask: "HHHHHH"
                    }
                }
            }                        
            }
            Column {
                ShaderEffect {
                    id: effect2
                    width: 300; height: 300
                    property color defaultColor: "#a3303a"
                    property color newColor: "#444400"
                    property color sensivityColor: colorSelector.selectedColor
                    property variant src: originals.sourceImage
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
                ShaderEffect {
                    id: effect3
                    width: 300; height: 300
                    property color defaultColor: "#FFFFFF"
                    property color sensivityColor: colorSelector.selectedColor
                    property variant src: originals.sourceImage
                    property variant texture: originals.textureImage
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
                        uniform sampler2D texture;
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
//                            fragHSV.yz *= vHSV.yz;
//                            fragHSV.xyz = mod(fragHSV.xyz, 1.0);
                            fragRGB = hsv2rgb(fragHSV) * texture2D(texture, qt_TexCoord0);
                            gl_FragColor = vec4(fragRGB, textureColor.a);
                        }"
                  }
            }
            Column {
                ShaderEffect {
                    id: effect4
                    width: 300; height: 300
                    property color defaultColor: "#FFFFFF"
                    property color sensivityColor: colorSelector.selectedColor
                    property variant src: originals.sourceImage
                    property variant texture: originals.textureImage
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
                        uniform sampler2D texture;
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
                            vec3 fragRGB = textureColor * texture2D(texture, qt_TexCoord0);
                            gl_FragColor = vec4(fragRGB, textureColor.a);
                        }"
                  }
            }
        }
    }
}
