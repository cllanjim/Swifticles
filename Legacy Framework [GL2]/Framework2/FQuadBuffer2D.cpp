//
//  FQuadBuffer2D.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/31/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FQuadBuffer2D.h"
#include "FApp.h"


FQuadBuffer2D::FQuadBuffer2D()
{
    mBufferVertex = 0;
    mBufferIndex = 0;
    
    mBufferSlotVertex = 0;
    mBufferSlotIndex = 0;
    
    mVertexSize = 0;
    mVertexCount = 0;
    
    mIndexSize = 0;
    mIndexCount = 0;
}

FQuadBuffer2D::~FQuadBuffer2D()
{
    gfx_bufferDelete(mBufferSlotVertex);
    gfx_bufferDelete(mBufferSlotIndex);
}

void FQuadBuffer2D::AddQuad(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4)
{
    AddNode(pX1, pY1, 0, 0);
    AddNode(pX2, pY2, 1, 0);
    
    AddNode(pX3, pY3, 0, 1);
    AddNode(pX4, pY4, 1, 1);
    
}

void FQuadBuffer2D::AddNode(float pX, float pY, float pU, float pV)
{
    if((mVertexCount + 4) >= mVertexSize)
    {
        mVertexSize = (mVertexCount + mVertexCount / 2) + 200;
        
        float *aBufferVertex = new float[mVertexSize];
        
        for(int i=0;i<mVertexCount;i++)
        {
            aBufferVertex[i] = mBufferVertex[i];
        }
        
        delete [] mBufferVertex;
        mBufferVertex = aBufferVertex;
    }
    
    mBufferVertex[mVertexCount + 0] = pX;
    mBufferVertex[mVertexCount + 1] = pY;
    mBufferVertex[mVertexCount + 2] = pU;
    mBufferVertex[mVertexCount + 3] = pV;
    
    mVertexCount += 4;
}

void FQuadBuffer2D::IndexReset()
{
    mIndexCount = 0;
}

void FQuadBuffer2D::IndexAdd(GFX_MODEL_INDEX_TYPE pIndex)
{
    if(mIndexCount >= mIndexSize)
    {
        mIndexSize = (mIndexCount + mIndexCount / 2) + 200;
        
        GFX_MODEL_INDEX_TYPE *aBufferIndex = new GFX_MODEL_INDEX_TYPE[mIndexSize];
        
        for(int i=0;i<mIndexCount;i++)aBufferIndex[i] = mBufferIndex[i];
        
        delete [] mBufferIndex;
        
        mBufferIndex = aBufferIndex;
    }
    
    mBufferIndex[mIndexCount] = pIndex;
    
    mIndexCount++;
}


void FQuadBuffer2D::Generate()
{
    //gfx_bufferDelete(mBufferSlotVertex);
    //gfx_bufferDelete(mBufferSlotIndex);
    
    IndexReset();
    
    int aIndexBase = 0;
    for(int i = 0;i < mVertexCount;i += 16)
    {
        
        IndexAdd(aIndexBase + 0);
        IndexAdd(aIndexBase + 2);
        IndexAdd(aIndexBase + 1);
        
        IndexAdd(aIndexBase + 1);
        IndexAdd(aIndexBase + 2);
        IndexAdd(aIndexBase + 3);
        
        aIndexBase += 4;
        
    }
    
    //mBufferSlotVertex = gfx_bufferVertexGenerate(mBufferVertex, mVertexCount);
    //mBufferSlotIndex = gfx_bufferIndexGenerate(mBufferIndex, mIndexCount);
    
}


void FQuadBuffer2D::Reset()
{
    mVertexCount = 0;
    mIndexCount = 0;
}


void FQuadBuffer2D::Draw(int pBindIndex)
{
    Generate();
    
    int aCount = (mVertexCount / 4);
    
    if(aCount > 0)
    {
        FVertex2D *aVertex = new FVertex2D[aCount];
     
        int aBufferIndex = 0;
        for(int i=0;i<aCount;i++)
        {
            aVertex[i].mX = mBufferVertex[aBufferIndex];aBufferIndex++;
            aVertex[i].mY = mBufferVertex[aBufferIndex];aBufferIndex++;
            aVertex[i].mU = mBufferVertex[aBufferIndex];aBufferIndex++;
            aVertex[i].mV = mBufferVertex[aBufferIndex];aBufferIndex++;
            
            aVertex[i].mRed = gRenderQueue.mRed;
            aVertex[i].mGreen = gRenderQueue.mGreen;
            aVertex[i].mBlue = gRenderQueue.mBlue;
            aVertex[i].mAlpha = gRenderQueue.mAlpha;
        }
        
        gRenderQueue.Enqueue(aVertex, aCount, mBufferIndex, mIndexCount, pBindIndex);
        
        delete [] aVertex;
    }
    
    
    /*
    ≈
    
    gfx_bufferVertexBind(mBufferSlotVertex);
    gfx_bufferIndexBind(mBufferSlotIndex);
    
    gfx_positionSetPointer(2, 0, 4);
    gfx_texCoordSetPointer(2, 2, 4);
    
    if(pBindIndex != -1)gfx_bindTexture(pBindIndex);
    gfx_drawElementsTriangle(mIndexCount, 0);
    */
}





