attribute vec4 Position;

uniform mat4 ModelViewMatrix;
uniform mat4 ProjectionMatrix;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void)
{
    gl_Position = ModelViewMatrix * ProjectionMatrix * Position;
    //gl_Position = ProjectionMatrix * Position;
    TexCoordOut = TexCoordIn;
}