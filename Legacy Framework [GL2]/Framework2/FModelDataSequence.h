//
//  FModelDataSequence.h
//  DoomKnights
//
//  Created by Nick Raptis on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "stdafx.h"
#include "FModelDataRenderer.h"

#ifndef MODEL_DATA_SEQUENCE_H
#define MODEL_DATA_SEQUENCE_H

class FModelDataIndexed;
class FModelDataOptimizer;
class FModelData;

class FModelDataSequence
{
public:
    
    FModelDataSequence();
    virtual ~FModelDataSequence();
    
    void                            Free();
    
    FModelDataIndexed                *mParent;
    
    int                             mSize;
    int                             mCount;
    FModelDataIndexed                **mData;
    
    void                            Add(FModelDataIndexed *pData);
    
    //void                            SetSprite(Sprite *pSprite, bool pFixUVW=true);
    
    bool                            mDisableNormal;
    bool                            mDisableUVW;
    bool                            mDisableIndeces;
    
    bool                            mUsesBaseXYZ;
    bool                            mUsesBaseUVW;
    bool                            mUsesBaseNormal;
    int                             mBindIndex;
    
    virtual void                    GetCentroid(int pFrame, float &pCentroidX, float &pCentroidY, float &pCentroidZ);
    
    void                            FlipXY();
    void                            FlipYZ();
    void                            FlipZX();
    
    void                            NegateX();
    void                            NegateY();
    void                            NegateZ();
    
    void                            Draw(float pFrame);
    FModelDataRenderer              mDrawRenderer;
    
    void                            Load(const char *pFileBase, int pStartIndex, int pEndIndex=-1, const char *pFileReferenceName=0);
    
    void                            Save(const char *pFile);
    void                            Load(const char *pFile);
};

#endif
