//
//  FModelDataRenderer.cpp
//  AugmentedReality
//
//  Created by Nick Raptis on 1/3/14.
//  Copyright (c) 2014 Chrysler Group LLC. All rights reserved.
//

#include "FModelDataRenderer.h"


FModelDataRenderer::FModelDataRenderer()
{
    mRefreshIndex = false;
    mRefreshVertex = false;
    
    mBufferVertex = 0;
    mBufferVertexCountPerElement = 0;
    mBufferVertexCountTotal = 0;
    mBufferVertexSize = 0;
    
    mBufferIndex = 0;
    mBufferIndexCount = 0;
    mBufferIndexSize = 0;
    
    mBufferVertexOffsetXYZ = 0;
    mBufferVertexOffsetUVW = 0;
    mBufferVertexOffsetNormal = 0;
    mBufferVertexOffsetColor = 0;
    
    mBufferSlotVertex = 0;
    mBufferSlotIndex = 0;
    
    mBindIndex = -1;
}

FModelDataRenderer::~FModelDataRenderer()
{
    if(mBufferSlotVertex > 0)
    {
        gfx_bufferDelete(mBufferSlotVertex);
        mBufferSlotVertex = 0;
    }
    
    if(mBufferSlotIndex > 0)
    {
        gfx_bufferDelete(mBufferSlotIndex);
        mBufferSlotIndex = 0;
    }
}

void FModelDataRenderer::SetIndex(GFX_MODEL_INDEX_TYPE *pIndex, int pCount)
{
    if(pCount > mBufferIndexSize)
    {
        delete [] mBufferIndex;
        
        mBufferIndexSize = pCount;
        
        mBufferIndex = new GFX_MODEL_INDEX_TYPE[mBufferIndexSize];
    }
    
    for(int i=0;i<pCount;i++)
    {
        mBufferIndex[i] = pIndex[i];
    
        //if(mRefreshIndex == false)
        //printf("Buffer[%d] = [%d]\n", i, (int)(mBufferIndex[i]));
        
    }
    
    mBufferIndexCount = pCount;
    mRefreshIndex = true;
}

void FModelDataRenderer::SetData(float *pXYZ, float *pUVW, float *pNormal, int pCount)
{
    if((pCount > 0) && (pXYZ != 0))
    {
        
        for(int i=0;i<pCount;i++)
        {
            int x = i * 3;
            
            //printf("Orig[%f %f %f] -> [%f %f %f]\n", pXYZ[x + 0], pXYZ[x + 1], pXYZ[x + 2], pUVW[x + 0], pUVW[x + 1], pUVW[x + 2]);
            
            
        }
        
        
        int aBufferCount = pCount * 3;
        
        int aXYZCount = 0;
        int aUVWCount = 0;
        int aNormalCount = 0;
        int aColorCount = aBufferCount + pCount;
        
        if(pXYZ != 0)aXYZCount = aBufferCount;
        if(pUVW != 0)aUVWCount = aBufferCount;
        if(pNormal != 0)aNormalCount = aBufferCount;
        
        int aVertexBufferSize = aXYZCount + aUVWCount + aNormalCount + aColorCount;
        //int aIndexBufferSize = mIndexCount;
        
        if(aVertexBufferSize <= 0)
        {
            mBufferVertexCountTotal = 0;
            mBufferVertexCountPerElement = 0;
            return;
        }
        
        mBufferVertexCountTotal = aVertexBufferSize;
        
        
        
        int aOffset = 0;
        
        if(pXYZ != 0)
        {
            mBufferVertexOffsetXYZ = aOffset;
            aOffset += aXYZCount;
        }
        else
        {
            mBufferVertexOffsetXYZ = -1;
        }
        
        if(pUVW != 0)
        {
            mBufferVertexOffsetUVW = aOffset;
            aOffset += aUVWCount;
        }
        else
        {
            mBufferVertexOffsetUVW = -1;
        }
        
        if(pNormal != 0)
        {
            mBufferVertexOffsetNormal = aOffset;
            aOffset += aNormalCount;
        }
        else
        {
            mBufferVertexOffsetNormal = -1;
        }
        
        mBufferVertexOffsetColor = aOffset;
        
        
        if(aVertexBufferSize > mBufferVertexSize)
        {
            delete [] mBufferVertex;
            
            mBufferVertexSize = aVertexBufferSize;
            
            mBufferVertex = new float[mBufferVertexSize];
            for(int i=0;i<aVertexBufferSize;i++)mBufferVertex[i] = 1.0f;
            
        }
        
        
        
        
        
        
        
        int aBufferWriteIndex = 0;
        
        for(int i=0;i<aXYZCount;i++)
        {
            mBufferVertex[aBufferWriteIndex] = pXYZ[i];
            aBufferWriteIndex++;
        }
        
        for(int i=0;i<aUVWCount;i++)
        {
            mBufferVertex[aBufferWriteIndex] = pUVW[i];
            aBufferWriteIndex++;
        }
        
        for(int i=0;i<aNormalCount;i++)
        {
            mBufferVertex[aBufferWriteIndex] = pNormal[i];
            aBufferWriteIndex++;
        }
        
        mBufferVertexCountPerElement = pCount;
        mRefreshVertex = true;
    }
}

void FModelDataRenderer::Draw()
{
    if((mBufferVertexCountTotal > 0) && (mBufferVertexCountPerElement > 0) && (mBufferIndexCount > 0))
    {
        if(mBufferSlotVertex == 0)
        {
                mBufferSlotVertex = gfx_bufferVertexGenerate();
                mBufferSlotIndex = gfx_bufferIndexGenerate();
        }
        
        if(mRefreshVertex)gfx_bufferVertexSetData(mBufferSlotVertex, mBufferVertex, mBufferVertexCountTotal);
        if(mRefreshIndex)gfx_bufferIndexSetData(mBufferSlotIndex, mBufferIndex, mBufferIndexCount);
        
        gfx_bufferVertexBind(mBufferSlotVertex);
        gfx_bufferIndexBind(mBufferSlotIndex);
        
        gfx_positionSetPointer(3, mBufferVertexOffsetXYZ);
        gfx_texCoordSetPointer(3, mBufferVertexOffsetUVW);
        gfx_colorSetPointer(mBufferVertexOffsetColor);
        
        //glVertexAttribPointer(gGLSlotPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
        
        //glVertexAttribPointer(gGLSlotTexCoord, 3, GL_FLOAT, GL_FALSE, 0, 0);
        
        
        //glVertexAttribPointer(gGLSlotTexCoord, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)(mBufferVertexPartCount * 3 * 4));
        
        
        /*
        for(int i=0;i<mBufferVertexCountPerElement;i++)
        {
            int x = i * 3;
            printf("%d - XYZ[%f %f %f] UVW[%f %f %f]\n", i, mBufferVertex[mBufferVertexOffsetXYZ+x+0], mBufferVertex[mBufferVertexOffsetXYZ+x+1], mBufferVertex[mBufferVertexOffsetXYZ+x+2], mBufferVertex[mBufferVertexOffsetUVW+x+0], mBufferVertex[mBufferVertexOffsetUVW+x+1], mBufferVertex[mBufferVertexOffsetUVW+x+2]  );
            
        }
        */
        
        if(mBindIndex != -1)gfx_bindTexture(mBindIndex);
        
        gfx_drawElementsTriangle(mBufferIndexCount, 0);
        
        
        
        //glBindBuffer(GL_ARRAY_BUFFER, mBufferSlotVertex);
        //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mBufferSlotIndex);
        
        //glVertexAttribPointer(gGLSlotPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
        //glVertexAttribPointer(gGLSlotTexCoord, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)(mBufferVertexPartCount * 3 * 4));
        
        //glBindTexture(GL_TEXTURE_2D, mBindIndex);
        //glDrawElements(GL_TRIANGLES, mIndexCount, GL_UNSIGNED_SHORT, 0);
        
        
        
        
    }
}



