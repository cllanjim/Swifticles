uniform bool EnableTexture;
uniform bool EnableModulate;

varying lowp vec4 DestinationColor;
uniform lowp vec4 ModulateColor;

varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;

void main(void)
{
    
    /*
    if (EnableTexture) {
        if (EnableModulate) {
            gl_FragColor = ModulateColor * DestinationColor * texture2D(Texture, TexCoordOut);
        } else {
            gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut);
        }
    } else {
        if (EnableModulate) {
            gl_FragColor = ModulateColor * DestinationColor;
        } else {
            gl_FragColor = DestinationColor;
        }
    }
    */
    
    gl_FragColor = ModulateColor;
    //DestinationColor * texture2D(Texture, TexCoordOut);
    
    //gl_FragColor = ModulateColor * DestinationColor * texture2D(Texture, TexCoordOut);
    //gl_FragColor = ModulateColor * DestinationColor * texture2D(Texture, TexCoordOut);
    //gl_FragColor = ModulateColor * texture2D(Texture, TexCoordOut);
    
}
