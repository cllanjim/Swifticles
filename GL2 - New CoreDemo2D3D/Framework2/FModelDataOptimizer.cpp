//
//  FModelDataOptimizer.cpp
//  BerryChopper
//
//  Created by Nick Raptis on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "FModelDataOptimizer.h"
#include "FModelData.h"
#include "FList.h"

FModelDataOptimizer::FModelDataOptimizer()
{
    mUVW=0;
    
    mIndex=0;
    mIndexCount=0;
    
    mCypher=0;
    mCypherCount=0;
    
    mHashTable=0;
    mHashTableSize=0;
    
    mIgnoreXYZ=false;
    mIgnoreUVW=false;
    mIgnoreNormal=false;
}

FModelDataOptimizer::~FModelDataOptimizer()
{
    delete[]mIndex;
    mIndex=0;
    
    delete[]mCypher;
    mCypher=0;
    
    mIndexCount=0;
    delete[]mHashTable;
    
    mHashTable=0;
    mHashTableSize=0;
}

unsigned int FModelDataOptimizer::HashFloat(unsigned int pRunningSum, float pFloat)
{
    unsigned int aReturn = pRunningSum;
    float aFloat = pFloat;
    char *aChar = ((char*)(&aFloat));
    for(int i=0;i<4;i++)
    {
        aReturn=((aReturn << 5) + aReturn) ^ ((int)(aChar[i]));
    }
    return aReturn;
}

int FModelDataOptimizer::Hash(float pX, float pY, float pZ,
                     float pU, float pV, float pW,
                     float pNormX, float pNormY, float pNormZ)
{
    unsigned int aHash = 5381;
    
    if(mIgnoreXYZ==false)
    {
        aHash = HashFloat(aHash, pX);
        aHash = HashFloat(aHash, pY);
        aHash = HashFloat(aHash, pZ);
    }
    
    if(mIgnoreUVW==false)
    {
        aHash = HashFloat(aHash, pU);
        aHash = HashFloat(aHash, pV);
        aHash = HashFloat(aHash, pW);
    }
    
    if(mIgnoreNormal==false)
    {
        aHash = HashFloat(aHash, pNormX);
        aHash = HashFloat(aHash, pNormY);
        aHash = HashFloat(aHash, pNormZ);
    }
    
    return (int)(aHash % mHashTableSize);
}

int FModelDataOptimizer::PushNode(int pMapToIndex, float pX, float pY, float pZ,
                         float pU, float pV, float pW,
                         float pNormX, float pNormY, float pNormZ, FList *pList)
{
    int aReturn = 0;
    
    int aCount = pList->mCount;
    
    if(aCount >= mHashTableSize)
    {
        SizeHashTable(aCount + aCount / 1 + 256, pList);
    }
    
    unsigned int aHash = Hash(pX,pY,pZ,
                              pU,pV,pW,
                              pNormX,pNormY,pNormZ);
    
    
    
    FModelDataOptimizerNode *aNode = mHashTable[aHash];
    
    bool aFound = false;
    
    if(aNode)
    {
        while((aNode != 0) && (aFound == false))
        {
            aFound = true;
            
            if(mIgnoreXYZ==false)
            {
                if((aNode->mX != pX) || 
                   (aNode->mY != pY) ||
                   (aNode->mZ != pZ))
                {
                    aFound=false;
                }
            }
            
            if(mIgnoreUVW==false)
            {
                if((aNode->mU != pU) || 
                   (aNode->mV != pV) ||
                   (aNode->mW != pW))
                {
                    aFound=false;
                }
            }
            
            if(mIgnoreNormal==false)
            {
                if((aNode->mNormX != pNormX) || 
                   (aNode->mNormY != pNormY) ||
                   (aNode->mNormZ != pNormZ))
                {
                    aFound=false;
                }
            }
            
            if(aFound)
            {
                aNode->mCount++;
                aReturn = aNode->mIndex;
            }
            else
            {
                aNode=aNode->mNextNode;
            }
            
        }
    }
    
    if(aFound == false)
    {
        FModelDataOptimizerNode *aNode=new FModelDataOptimizerNode();
        
        aNode->mCount = 0;
        
        aReturn = pList->mCount;
        aNode->mIndex = aReturn;
        
        aNode->mX=pX;
        aNode->mY=pY;
        aNode->mZ=pZ;
        
        aNode->mU=pU;
        aNode->mV=pV;
        aNode->mW=pW;
        
        aNode->mNormX=pNormX;
        aNode->mNormY=pNormY;
        aNode->mNormZ=pNormZ;
        
        aNode->mMapIndex=pMapToIndex;
        
        pList->Add(aNode);
        
        if(mHashTable[aHash] == 0)
        {
            mHashTable[aHash] = aNode;
            aNode->mNextNode = 0;
        }
        else
        {
            aNode->mNextNode = mHashTable[aHash];
            mHashTable[aHash] = aNode; 
        }
    }
    
    return aReturn;
}


void FModelDataOptimizer::Push(FModelData *pData, FList *pList)
{
    if(pData)
    {
        int aCount = pData->mXYZCount;
        
        float aX, aY, aZ, aU, aV, aW, aNormX, aNormY, aNormZ;
        for(int i=0;i<aCount;i++)
        {
            aX = pData->GetX(i);
            aY = pData->GetY(i);
            aZ = pData->GetZ(i);
            
            aU = pData->GetU(i);
            aV = pData->GetV(i);
            aW = pData->GetW(i);
            
            aNormX = pData->GetNormX(i);
            aNormY = pData->GetNormY(i);
            aNormZ = pData->GetNormZ(i);
            
            PushNode(-1, aX, aY, aZ, aU, aV, aW, aNormX, aNormY, aNormZ, pList);
            
        }
        
    }
}

void FModelDataOptimizer::SizeHashTable(int pSize, FList *pList)
{
    
    mHashTableSize=pSize;
    
    mHashTable = new FModelDataOptimizerNode*[pSize];
    
    for(int i=0;i<pSize;i++)
    {
        mHashTable[i] = 0;
    }
    
    EnumList(FModelDataOptimizerNode, aNode, (*pList))
    {
        aNode->mNextNode = 0;
    }
    
    EnumList(FModelDataOptimizerNode, aNode, (*pList))
    {
        int aHash = Hash(aNode->mX, aNode->mY, aNode->mZ, aNode->mU, aNode->mV, aNode->mW, aNode->mNormX, aNode->mNormY, aNode->mNormZ);
        
        
           if(mHashTable[aHash] == 0)
           {
               mHashTable[aHash] = aNode;
               aNode->mNextNode = 0;
           }
           else
           {
               aNode->mNextNode = mHashTable[aHash];
               mHashTable[aHash] = aNode; 
           }
    }
}

void FModelDataOptimizer::PrintOverview()
{
    int aMaximumIndex=0;
    
    for(int i=0;i<mIndexCount;i++)
    {
        if(mIndex[i] > aMaximumIndex)
        {
            aMaximumIndex = mIndex[i];
        }
    }
    
    printf("\n\nDataOptimizer: [Max Ind %d (%f%% Short Max) [%d Indeces] [%d Cyphers]\n\n", aMaximumIndex, (((float)aMaximumIndex) / 65535.0f), mIndexCount, mCypherCount);
    
    
}

void FModelDataOptimizer::Print()
{
    printf("Model Codex!\n\n");
    printf("Hash Count[%d] Size[%d]\n", mCypherCount, mHashTableSize);
    
    for(int i=0;i<mHashTableSize;i++)
    {
        FModelDataOptimizerNode *aNode = mHashTable[i];
        
        int aCount=0;
        int aTotal=0;
        
        while(aNode)
        {
            aTotal+=aNode->mCount;
            aCount++;
            aNode = aNode->mNextNode;
        }
        
        if(aCount > 0)
        {
            printf("Index[%d] Has (%d) Codex Nodes! (%d Model Nodes) \n", i, aCount, aTotal);
        }
    }
}

void FModelDataOptimizer::Generate(FModelData *pData)
{
    if(!pData)return;
    
    
    FList aNodeList;
 
    mIndexCount = pData->mXYZCount;
    mIndex = new unsigned int[mIndexCount+1];
    
    float aX, aY, aZ, aU, aV, aW, aNormX, aNormY, aNormZ;
    
    int aCodexIndex;
    
    for(int i=0;i<mIndexCount;i++)
    {
        aX = pData->GetX(i);
        aY = pData->GetY(i);
        aZ = pData->GetZ(i);
        
        if(pData->mUVWCount > 0)
        {
            aU = pData->GetU(i);
            aV = pData->GetV(i);
            aW = pData->GetW(i);
        }
        else
        {
            aU = 0.0f;
            aV = 0.0f;
            aW = 0.0f;
        }
        
        
        if(pData->mNormalCount > 0)
        {
            aNormX = pData->GetNormX(i);
            aNormY = pData->GetNormY(i);
            aNormZ = pData->GetNormZ(i);
        }
        else
        {
            aNormX = 0;
            aNormY = 0;
            aNormZ = 0;
        }
        
        aCodexIndex = PushNode(i, aX, aY, aZ, aU, aV, aW, aNormX, aNormY, aNormZ, &aNodeList);
        
        mIndex[i]=aCodexIndex;
    }
    
    int aHashListCount = aNodeList.mCount;
    mCypherCount = aHashListCount;
    
    mCypher=new unsigned int[aHashListCount + 1];
    
    int aCodexNodeIndex=0;
    
    EnumList(FModelDataOptimizerNode, aNode, aNodeList)
    {
        mCypher[aCodexNodeIndex]=aNode->mMapIndex;
        aCodexNodeIndex++;
    }
    FreeList(FModelDataOptimizerNode, aNodeList)
}

void FModelDataOptimizer::SolveXYZ(FModelData *pReference, FModelData *pTarget)
{
    pTarget->SizeXYZ(mCypherCount);
    int aWrapIndex;
    for(int i=0;i<mCypherCount;i++)
    {
        aWrapIndex = mCypher[i];
        pTarget->AddXYZ(pReference->GetX(aWrapIndex), pReference->GetY(aWrapIndex), pReference->GetZ(aWrapIndex));
    }
}

void FModelDataOptimizer::SolveUVW(FModelData *pReference, FModelData *pTarget)
{
    pTarget->SizeUVW(mCypherCount);
    int aWrapIndex;
    for(int i=0;i<mCypherCount;i++)
    {
        aWrapIndex = mCypher[i];
        pTarget->AddUVW(pReference->GetU(aWrapIndex), pReference->GetV(aWrapIndex), pReference->GetW(aWrapIndex));
    }
}

void FModelDataOptimizer::SolveNormal(FModelData *pReference, FModelData *pTarget)
{
    pTarget->SizeNormal(mCypherCount);
    int aWrapIndex;
    for(int i=0;i<mCypherCount;i++)
    {
        aWrapIndex = mCypher[i];
        pTarget->AddNormal(pReference->GetNormX(aWrapIndex),pReference->GetNormY(aWrapIndex),pReference->GetNormZ(aWrapIndex));
    }
}

void FModelDataOptimizer::Convert(FModelData *pData, FModelDataIndexed *pTarget)
{
    if(pTarget != 0)
    {
        pTarget->Free();
    }
    
    if((pData != 0) && (pTarget != 0))
    {
        //FModelDataIndexed *aReturn = new FModelDataIndexed();
        
        if(mCypherCount <= 0)
        {
            Generate(pData);
        }
        
        for(int i=0;i<mCypherCount;i++)
        {
            int aWrapIndex = mCypher[i];
            
            pTarget->AddXYZ(pData->GetX(aWrapIndex), pData->GetY(aWrapIndex), pData->GetZ(aWrapIndex));
            
            if(pData->mUVWCount > 0)
            {
                pTarget->AddUVW(pData->GetU(aWrapIndex), pData->GetV(aWrapIndex), pData->GetW(aWrapIndex));
            }
            if(pData->mNormalCount > 0)
            {
                pTarget->AddNormal(pData->GetNormX(aWrapIndex),pData->GetNormY(aWrapIndex),pData->GetNormZ(aWrapIndex));
            }
        }
        
        for(int i=0;i<mIndexCount;i++)
        {
            pTarget->AddIndex(mIndex[i]);
        }
        
        //printf("Converted Targ[ %d %d %d %d ]\n", pTarget->mXYZCount, pTarget->mUVWCount, pTarget->mNormalCount, pTarget->mIndexCount);
    }
}

FModelDataIndexed *FModelDataOptimizer::Convert(FModelData *pData)
{
    
    FModelDataIndexed *aReturn = new FModelDataIndexed();
    
    Convert(pData, aReturn);
    
    /*
    
    if(mCypherCount <= 0)Generate(pData);
    
    for(int i=0;i<mCypherCount;i++)
    {
        int aWrapIndex = mCypher[i];
        
        aReturn->AddXYZ(pData->GetX(aWrapIndex), pData->GetY(aWrapIndex), pData->GetZ(aWrapIndex));
        aReturn->AddUVW(pData->GetU(aWrapIndex), pData->GetV(aWrapIndex), pData->GetW(aWrapIndex));
        aReturn->AddNormal(pData->GetNormX(aWrapIndex),pData->GetNormY(aWrapIndex),pData->GetNormZ(aWrapIndex));
    }
    
    for(int i=0;i<mIndexCount;i++)
    {
        aReturn->AddIndex(mIndex[i]);
    }
    
    aReturn->PrintOverview();
    */
    
    return aReturn;
}


