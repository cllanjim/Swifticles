/*varying lowp vec4 DestinationColor;
varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;
uniform lowp vec4 ModulateColor;
void main(void)
{
    gl_FragColor =  ModulateColor * texture2D(Texture, TexCoordOut);
    //gl_FragColor =  DestinationColor * texture2D(Texture, TexCoordOut);
}
*/

varying lowp vec4 DestinationColor;
varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;
uniform lowp vec4 ModulateColor;

void main(void)
{
    gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut);
}
