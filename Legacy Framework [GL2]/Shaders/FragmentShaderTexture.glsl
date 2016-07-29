
/*
varying lowp vec4 DestinationColor;
attribute vec4 SourceColor;


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

uniform lowp vec4 ModulateColor;

void main(void)
{
    //gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New
    //gl_FragColor =  texture2D(Texture, TexCoordOut); // New
    
    //ModulateColor *
    
    DestinationColor = SourceColor;
    
    gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New
    
    //gl_FragColor =  DestinationColor * texture2D((Texture), TexCoordOut);// * ModulateColor; // New
    
    //gl_FragColor =  ModulateColor; // New
    //gl_FragColor = texture2D(Texture, TexCoordOut); // New
}
*/

varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void)
{
    gl_FragColor = DestinationColor *
    texture2D(Texture, TexCoordOut); // New
}
