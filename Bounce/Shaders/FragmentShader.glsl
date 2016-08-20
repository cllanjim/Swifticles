varying lowp vec4 DestinationColor;
uniform lowp vec4 ModulateColor;

varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;

void main(void)
{
    gl_FragColor = ModulateColor * DestinationColor * texture2D(Texture, TexCoordOut);
}
