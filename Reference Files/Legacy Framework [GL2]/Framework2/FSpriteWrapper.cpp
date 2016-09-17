//
//  FSpriteWrapper.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/24/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FSpriteWrapper.h"

FSpriteWrapper::FSpriteWrapper()
{
    mSprite = 0;
    
    mBufferVertexCount = 16;
    mBufferVertexSize = 16;
    
    mBufferIndexCount = 6;
    mBufferIndexSize = 6;
    
    mBufferVertex = new float[mBufferVertexSize];
    mBufferIndex = new GFX_MODEL_INDEX_TYPE[mBufferIndexSize];
    
    
    mBufferVertex[0] = -128;
    mBufferVertex[1] = -128;
    mBufferVertex[2] = 128;
    mBufferVertex[3] = -128;
    mBufferVertex[4] = -128;
    mBufferVertex[5] = 128;
    mBufferVertex[6] = 128;
    mBufferVertex[7] = 128;
    
    mBufferVertex[8 + 0] = 0;
    mBufferVertex[8 + 1] = 0;
    mBufferVertex[8 + 2] = 1;
    mBufferVertex[8 + 3] = 0;
    mBufferVertex[8 + 4] = 0;
    mBufferVertex[8 + 5] = 1;
    mBufferVertex[8 + 6] = 1;
    mBufferVertex[8 + 7] = 1;
    
    mBufferIndex[0] = 0;
    mBufferIndex[1] = 2;
    mBufferIndex[2] = 1;
    mBufferIndex[3] = 1;
    mBufferIndex[4] = 2;
    mBufferIndex[5] = 3;
    
    mBindIndex = -1;
    
    mStartU = 0;
    mStartV = 0;
    mEndU = 1.0f;
    mEndV = 1.0f;
    
    mStartX = -128.0f;
    mStartY = -128.0f;
    mEndX = 128.0f;
    mEndY = 128.0f;
    
    mBufferSlotVertex = gfx_bufferVertexGenerate(mBufferVertex, 16);
    mBufferSlotIndex = gfx_bufferIndexGenerate(mBufferIndex, 6);
    
}

FSpriteWrapper::~FSpriteWrapper()
{
    gfx_bufferDelete(mBufferSlotVertex);
    gfx_bufferDelete(mBufferSlotIndex);
}


void FSpriteWrapper::SetUp(FSprite *pSprite)
{
    if(pSprite)
    {
        
        mSprite = pSprite;
        mBindIndex = pSprite->mBindIndex;
        
        mStartU = pSprite->GetStartU();
        mStartV = pSprite->GetStartV();
        mEndU = pSprite->GetEndU();
        mEndV = pSprite->GetEndV();
        
        mStartX = pSprite->GetStartX();
        mStartY = pSprite->GetStartY();
        mEndX = pSprite->GetEndU();
        mEndY = pSprite->GetEndV();
        
        mBufferVertex[8 + 0] = mStartU;
        mBufferVertex[8 + 1] = mStartV;
        mBufferVertex[8 + 2] = mEndU;
        mBufferVertex[8 + 3] = mStartV;
        mBufferVertex[8 + 4] = mStartU;
        mBufferVertex[8 + 5] = mEndV;
        mBufferVertex[8 + 6] = mEndU;
        mBufferVertex[8 + 7] = mEndV;
        
        
        mBufferVertex[0] = mStartX;
        mBufferVertex[1] = mStartY;
        mBufferVertex[2] = mEndX;
        mBufferVertex[3] = mStartY;
        mBufferVertex[4] = mStartX;
        mBufferVertex[5] = mEndY;
        mBufferVertex[6] = mEndX;
        mBufferVertex[7] = mEndY;
        
    }
    else
    {
        mSprite = 0;
        mBindIndex = -1;
    }
}

void FSpriteWrapper::SetRect(float pX, float pY, float pWidth, float pHeight)
{
    
    mStartX = pX;
    mStartY = pY;
    
    mEndX = pX + pWidth;
    mEndY = pY + pHeight;
    
    mBufferVertex[0] = pX;
    mBufferVertex[4] = pX;
    
    mBufferVertex[1] = pY;
    mBufferVertex[3] = pY;
    
    mBufferVertex[6] = mEndX;
    mBufferVertex[2] = mEndX;
    
    mBufferVertex[7] = mEndY;
    mBufferVertex[5] = mEndY;
    
    
    
    //void                            SetStartX(float pX){mBufferVertex[0]=pX;mBufferVertex[4]=pX;}
	//void                            SetStartY(float pY){mBufferVertex[1]=pY;mBufferVertex[3]=pY;}
	//void                            SetEndX(float pX){mBufferVertex[6]=pX;mBufferVertex[2]=pX;}
	//void                            SetEndY(float pY){mBufferVertex[7]=pY;mBufferVertex[5]=pY;}
    
}


void FSpriteWrapper::DrawPercentHorizontal(float pStartPercent, float pEndPercent)
{
    
    float aWidth = mEndX - mStartX;
    float aTexWidth = mEndU - mStartU;
    
    mBufferVertex[8 + 0] = mStartU + aTexWidth * pStartPercent;
    mBufferVertex[8 + 1] = mStartV;
    mBufferVertex[8 + 2] = mStartU + aTexWidth * pEndPercent;
    mBufferVertex[8 + 3] = mStartV;
    mBufferVertex[8 + 4] = mStartU + aTexWidth * pStartPercent;
    mBufferVertex[8 + 5] = mEndV;
    mBufferVertex[8 + 6] = mStartU + aTexWidth * pEndPercent;
    mBufferVertex[8 + 7] = mEndV;
    
    mBufferVertex[0] = mStartX + aWidth * pStartPercent;
    mBufferVertex[1] = mStartY;
    mBufferVertex[2] = mStartX + aWidth * pEndPercent;
    mBufferVertex[3] = mStartY;
    mBufferVertex[4] = mStartX + aWidth * pStartPercent;
    mBufferVertex[5] = mEndY;
    mBufferVertex[6] = mStartX + aWidth * pEndPercent;
    mBufferVertex[7] = mEndY;
    
    gRenderQueue.EnqueueQuad(mBufferVertex[0], mBufferVertex[1], mBufferVertex[2], mBufferVertex[3], mBufferVertex[4], mBufferVertex[5], mBufferVertex[6], mBufferVertex[7], mBufferVertex[8], mBufferVertex[9], mBufferVertex[10], mBufferVertex[11], mBufferVertex[12], mBufferVertex[13], mBufferVertex[14], mBufferVertex[15], mBindIndex);
    
    //Draw();
}

void FSpriteWrapper::Draw()
{
    gfx_bufferVertexSetData(mBufferSlotVertex, mBufferVertex, mBufferVertexCount);
    gfx_bufferIndexSetData(mBufferSlotIndex, mBufferIndex, mBufferIndexCount);
    
    gfx_bufferVertexBind(mBufferSlotVertex);
    gfx_bufferIndexBind(mBufferSlotIndex);
    
    gfx_positionSetPointer(2, 0);
    gfx_texCoordSetPointer(2, 8);
    
    gfx_bindTexture(mBindIndex);
    gfx_drawElementsTriangle(6, 0);
}

