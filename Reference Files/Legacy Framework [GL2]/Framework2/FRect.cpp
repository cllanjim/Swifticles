//
//  FRect.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/12/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FRect.h"

FRect::FRect(float pX, float pY, float pWidth, float pHeight)
{
    mX = pX;
    mY = pY;
    
    mWidth = pWidth;
    mHeight = pHeight;
}

FRect::FRect(float pWidth, float pHeight)
{
    mX = 0.0f;
    mY = 0.0f;
    
    mWidth = pWidth;
    mHeight = pHeight;
}

FRect::FRect()
{
    mX = 0.0f;
    mY = 0.0f;
    
    mWidth = 0.0f;
    mHeight = 0.0f;
}

FRect::~FRect()
{
    
}



