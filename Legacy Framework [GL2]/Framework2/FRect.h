//
//  FRect.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/12/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_RECT_H
#define FRAMEWORK_RECT_H

class FRect
{
public:
    
    FRect(float pX, float pY, float pWidth, float pHeight);
    FRect(float pWidth, float pHeight);
    FRect(const FRect &pRect){*this = pRect;}
    FRect();
    
    virtual ~FRect();
    
    inline FRect &operator = (const FRect &pRect){if(this!=&pRect){mX=pRect.mX;mY=pRect.mY;mWidth=pRect.mWidth;mHeight=pRect.mHeight;}return *this;}
    
    float                           mX;
    float                           mY;
    
    float                           mWidth;
    float                           mHeight;
};

#endif /* defined(__CoreDemo__FRect__) */
