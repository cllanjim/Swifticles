attribute vec4 Position;
//attribute vec4 SourceColor;

//varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 ModelView;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void)
{
    //DestinationColor = SourceColor;
    gl_Position = Projection * ModelView * Position;
    //gl_Position = Modelview * Position;
    TexCoordOut = TexCoordIn; // New
}