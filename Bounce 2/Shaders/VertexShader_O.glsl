/*attribute vec4 Position;

uniform mat4 ModelViewMatrix;
uniform mat4 ProjectionMatrix;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void)
{
    gl_Position = ProjectionMatrix * ModelViewMatrix * Position;
    //gl_Position = ProjectionMatrix * Position;
    TexCoordOut = TexCoordIn;
}
*/

attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void)
{
    DestinationColor = SourceColor;
    gl_Position = ProjectionMatrix * ModelViewMatrix * Position;
    TexCoordOut = TexCoordIn;
}
