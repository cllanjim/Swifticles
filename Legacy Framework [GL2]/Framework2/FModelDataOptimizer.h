//
//  FModelDataOptimizer.h
//  DoomKnights
//
//  Created by Nick Raptis on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef MODEL_DATA_OPTIMIZER_H
#define MODEL_DATA_OPTIMIZER_H

class FModelDataIndexed;
class FModelData;
class FList;

class FModelDataOptimizerNode
{
public:
    
    float                       mX, mY, mZ;
    float                       mU, mV, mW;
    float                       mNormX, mNormY, mNormZ;
    
    int                         mCount;
    
    int                         mIndex;
    int                         mMapIndex;
    
    FModelDataOptimizerNode      *mNextNode;
};

class FModelDataOptimizer
{
public:
    
    FModelDataOptimizer();
    ~FModelDataOptimizer();
    
    bool                        mIgnoreXYZ;
    bool                        mIgnoreUVW;
    bool                        mIgnoreNormal;
    
    unsigned int                *mIndex;
    int                         mIndexCount;
    int                         mIndexSize;
    
    unsigned int                *mCypher;
    int                         mCypherCount;
    
    float                       *mUVW;
    
    unsigned int                HashFloat(unsigned int pRunningSum, float pFloat);
    
    int                         Hash(float pX, float pY, float pZ,
                                     float pU, float pV, float pW,
                                     float pNormX, float pNormY, float pNormZ);
    
    int                         PushNode(int pMapToIndex, float pX, float pY, float pZ,
                                         float pU, float pV, float pW,
                                         float pNormX, float pNormY, float pNormZ, FList *pList);
    
    void                        Push(FModelData *pData, FList *pList);
    
    void                        Generate(FModelData *pData);
    void                        Convert(FModelData *pData, FModelDataIndexed *pTarget);
    FModelDataIndexed            *Convert(FModelData *pData);
    
    
    void                        SolveXYZ(FModelData *pReference, FModelData *pTarget);
    void                        SolveUVW(FModelData *pData, FModelData *pTarget);
    void                        SolveNormal(FModelData *pData, FModelData *pTarget);
    
    void                        Print();
    void                        PrintOverview();
    
    void                        SizeHashTable(int pSize, FList *pList);
    int                         mHashTableSize;
    
    FModelDataOptimizerNode      **mHashTable;
};

#endif
