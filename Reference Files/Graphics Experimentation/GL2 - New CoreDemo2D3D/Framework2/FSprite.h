//
//  FSprite.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/2/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef CoreDemo_FSprite_h
#define CoreDemo_FSprite_h

#include "core_gfx.h"

class FImage;

class FSprite
{
public:
    
    FSprite();
    virtual ~FSprite();
    
    void                            Kill();
    
    void                            Load(const char *pFileName);
    void                            Load(FImage *pImage);
    
    float                           mBufferVertex[16];
    GFX_MODEL_INDEX_TYPE            mBufferIndex[6];
    
    float                           mWidth;
    float                           mHeight;
    
    float                           mWidth2;
    float                           mHeight2;
    
    int                             mBindIndex;
    
    unsigned int                    mBufferSlotVertex;
    unsigned int                    mBufferSlotIndex;
    
    void                            Center(float pX, float pY);
    
    void                            Draw();
    void                            Draw(float pX, float pY);
    void                            DrawScaled(float pX, float pY, float pScale);
    void                            DrawRotated(float pX, float pY, float pRotation);
    void                            Draw(float pX, float pY, float pRotation, float pScale=1.0f);
    
    
};

#endif
