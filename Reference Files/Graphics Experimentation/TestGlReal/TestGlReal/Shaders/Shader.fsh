//
//  Shader.fsh
//  TestGlReal
//
//  Created by Raptis, Nicholas on 8/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
