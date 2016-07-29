//
//  FSpriteWrapper.h
//  CoreDemo
//
//  Created by Nick Raptis on 11/3/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef __CoreDemo__FSpriteWrapper__
#define __CoreDemo__FSpriteWrapper__

#include "MainApp.h"

class FSpriteWrapper : public FObject
{
public:
    
    FSpriteWrapper();
    virtual ~FSpriteWrapper();
    
    void                                    SetUp(FSprite *pSprite);
    
    void                                    SetRect(float pX, float pY, float pWidth, float pHeight);
    
    //void                                    SizeVertexBuffer(int pSize);
    int                                     mBufferVertexCount;
    int                                     mBufferVertexSize;
    
    //void                                    SizeIndexBuffer(int pSize);
    int                                     mBufferIndexCount;
    int                                     mBufferIndexSize;
    
    FSprite                                 *mSprite;
    
    float                                   mStartU;
    float                                   mStartV;
    float                                   mEndU;
    float                                   mEndV;
    
    float                                   mStartX;
    float                                   mStartY;
    float                                   mEndX;
    float                                   mEndY;
    
    void                                    DrawPercentHorizontal(float pStartPercent, float pEndPercent);
    void                                    Draw();
    
    
    //Eventually we want to make this dynamically size-able in the wrapper..
    float                                   *mBufferVertex;
    GFX_MODEL_INDEX_TYPE                    *mBufferIndex;
    
    int                                     mBindIndex;
    
    unsigned int                            mBufferSlotVertex;
    unsigned int                            mBufferSlotIndex;
    
};

#endif
