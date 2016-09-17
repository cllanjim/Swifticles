//
//  FModelDataRenderer.h
//  AugmentedReality
//
//  Created by Nick Raptis on 1/3/14.
//  Copyright (c) 2014 Chrysler Group LLC. All rights reserved.
//

#ifndef __AugmentedReality__FModelDataRenderer__
#define __AugmentedReality__FModelDataRenderer__

#include "stdafx.h"

class FModelDataRenderer
{
public:
    
    FModelDataRenderer();
    virtual ~FModelDataRenderer();
    
    void                                    SetIndex(GFX_MODEL_INDEX_TYPE *pIndex, int pCount);
    void                                    SetData(float *pXYZ, float *pUVW, float *pNormal, int pCount);
    
    bool                                    mRefreshIndex;
    bool                                    mRefreshVertex;
    
    void                                    Draw();
    
    int                                     mBindIndex;
    
    float                                   *mBufferVertex;
    int                                     mBufferVertexCountPerElement;
    int                                     mBufferVertexCountTotal;
    int                                     mBufferVertexSize;
    
    GFX_MODEL_INDEX_TYPE                    *mBufferIndex;
    int                                     mBufferIndexCount;
    int                                     mBufferIndexSize;
    
    int                                     mBufferVertexOffsetXYZ;
    int                                     mBufferVertexOffsetUVW;
    int                                     mBufferVertexOffsetNormal;
    int                                     mBufferVertexOffsetColor;
    
    unsigned int                            mBufferSlotVertex;
    unsigned int                            mBufferSlotIndex;
    
};


#endif /* defined(__AugmentedReality__FModelDataRenderer__) */
