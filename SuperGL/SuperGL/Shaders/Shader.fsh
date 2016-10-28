//
//  Shader.fsh
//  SuperGL
//
//  Created by Raptis, Nicholas on 10/27/16.
//  Copyright © 2016 company_name_goes_here. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
