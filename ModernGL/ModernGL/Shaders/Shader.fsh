//
//  Shader.fsh
//  ModernGL
//
//  Created by Nicholas Raptis on 7/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
