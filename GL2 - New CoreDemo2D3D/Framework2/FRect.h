//
//  FRect.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/12/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef FRAMEWORK_RECT_H
#define FRAMEWORK_RECT_H

class FRect
{
public:
    
    FRect(float pX, float pY, float pWidth, float pHeight);
    FRect(float pWidth, float pHeight);
    FRect(FRect &pRect){*this = pRect;}
    FRect();
    
    virtual ~FRect();
    
    float                           mX;
    float                           mY;
    
    float                           mWidth;
    float                           mHeight;
};

#endif /* defined(__CoreDemo__FRect__) */
