varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

uniform lowp vec4 ModulateColor;

void main(void)
{
    //gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New
    //gl_FragColor =  texture2D(Texture, TexCoordOut); // New
    
    //ModulateColor *
    gl_FragColor =  ModulateColor * texture2D(Texture, TexCoordOut); // New
    //gl_FragColor =  ModulateColor; // New
    //gl_FragColor = texture2D(Texture, TexCoordOut); // New
}