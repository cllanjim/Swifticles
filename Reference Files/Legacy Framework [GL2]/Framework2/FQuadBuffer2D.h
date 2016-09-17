//
//  FQuadBuffer2D.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/31/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef __CoreDemo__FQuadBuffer2D__
#define __CoreDemo__FQuadBuffer2D__

#include "core_gfx.h"

class FQuadBuffer2D
{
public:
    
    FQuadBuffer2D();
    virtual ~FQuadBuffer2D();
    
    void                            AddQuad(float pX1, float pY1, float pX2, float pY2,
                                            float pX3, float pY3, float pX4, float pY4);
    void                            AddNode(float pX, float pY, float pU, float pV);
    
    void                            Generate();
    
    void                            Reset();
    void                            Draw(int pBindIndex = -1);
    
    void                            IndexReset();
    void                            IndexAdd(GFX_MODEL_INDEX_TYPE pIndex);
    
    float                           *mBufferVertex;
    GFX_MODEL_INDEX_TYPE            *mBufferIndex;
    
    unsigned int                    mBufferSlotVertex;
    unsigned int                    mBufferSlotIndex;
    
    int                             mVertexSize;
    int                             mVertexCount;
    
    int                             mIndexSize;
    int                             mIndexCount;
    
    
};

#endif
