/*attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 WorldView;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void)
{
    DestinationColor = SourceColor;
    //gl_Position = Projection * WorldView * Position;
    gl_Position = WorldView * Position;
    
    //gl_Position = WorldView * Position;
    TexCoordOut = TexCoordIn; // New
}
*/

/*
attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 WorldView;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Projection * WorldView * Position;
    TexCoordOut = TexCoordIn; // New
}
*/

attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 WorldMatrix;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void)
{
    DestinationColor = SourceColor;
    gl_Position = WorldMatrix * Position;
    TexCoordOut = TexCoordIn; // New
}

