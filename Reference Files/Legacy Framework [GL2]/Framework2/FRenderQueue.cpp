//
//  FRenderQueue.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 11/4/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FRenderQueue.h"
#include "FMath.h"

FRenderQueueNode::FRenderQueueNode()
{
    mBindIndex = -1;
    
    mStartIndexVertex = 0;
    mStartIndexIndex = 0;
    
    mIndexCount = 0;
}

FRenderQueueNode::~FRenderQueueNode()
{
    
}

FRenderQueue::FRenderQueue()
{
    mNodeCount = 0;
    mWriteIndexVertex = 0;
    mWriteIndexIndex = 0;
    
    mRed = 1.0f;
    mGreen = 1.0f;
    mBlue = 1.0f;
    mAlpha = 1.0f;
    
    mBufferSlotVertex = 0;
    mBufferSlotIndex = 0;
}

FRenderQueue::~FRenderQueue()
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

void FRenderQueue::RenderDump()
{
    
    if(mNodeCount > 0)
    {
        
    
    
    if(mBufferSlotVertex == 0)
    {
        mBufferSlotVertex = gfx_bufferVertexGenerate();
        mBufferSlotIndex = gfx_bufferIndexGenerate();
    }
    
    //mBufferSlotVertex = gfx_bufferVertexGenerate();
    //mBufferSlotIndex = gfx_bufferIndexGenerate();
    
    glBindBuffer(GL_ARRAY_BUFFER, mBufferSlotVertex);
        //glBufferData(GL_ARRAY_BUFFER, mWriteIndexVertex * 4 * 8, mVertex, GL_STATIC_DRAW);
    glBufferData(GL_ARRAY_BUFFER, mWriteIndexVertex * sizeof(FVertex2D), mVertex, GL_STATIC_DRAW);

    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mBufferSlotIndex);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, (mWriteIndexIndex) * sizeof(GL_ELEMENT_ARRAY_BUFFER), mIndex, GL_STATIC_DRAW);
    
    
    
    
    int aLastBindIndex = -1;
    
    for(int i=0;i<mNodeCount;i++)
    {
        gfx_bindTexture(mNode[i].mBindIndex);
        
        //printf("VertexSize [%d ]\n", (int)(sizeof(FVertex2D)));
        
        int aVertexIndex = (mNode[i].mStartIndexVertex * sizeof(FVertex2D));
        
        glVertexAttribPointer(gGLSlotPosition, 2, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(aVertexIndex));
        glVertexAttribPointer(gGLSlotTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(aVertexIndex + 2 * 4));
        glVertexAttribPointer(gGLSlotColor, 4, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(aVertexIndex + 4 * 4));
        
        glDrawElements(GL_TRIANGLES, mNode[i].mIndexCount, GFX_MODEL_INDEX_GL_TYPE, (GLvoid*)(mNode[i].mStartIndexIndex * (sizeof(GFX_MODEL_INDEX_TYPE))));
        
        
        
        /*
        unsigned int mBufferSlotVertex = gfx_bufferVertexGenerate();
        
        glBindBuffer(GL_ARRAY_BUFFER, mBufferSlotVertex);
        glBufferData(GL_ARRAY_BUFFER, 8 * 4 * 8, aVertex, GL_STATIC_DRAW);
        
        unsigned int mBufferSlotIndex = gfx_bufferIndexGenerate();
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mBufferSlotIndex);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6 * sizeof(GL_ELEMENT_ARRAY_BUFFER), mBufferIndex, GL_STATIC_DRAW);
        
        gfx_bindTexture(mTilePowerup[POWERUP_SWEEP_QUAD][1].mBindIndex);
        
        glVertexAttribPointer(gGLSlotPosition, 2, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(0));
        glVertexAttribPointer(gGLSlotTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(2 * 4));
        glVertexAttribPointer(gGLSlotColor, 4, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(4 * 4));
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(0));
        */
        
    }
    
    /*
    gfx_bindTexture(mTilePowerup[POWERUP_SWEEP_QUAD][1].mBindIndex);
    
    glVertexAttribPointer(gGLSlotPosition, 2, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(0));
    glVertexAttribPointer(gGLSlotTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(2 * 4));
    glVertexAttribPointer(gGLSlotColor, 4, GL_FLOAT, GL_FALSE, sizeof(FVertex2D), (GLvoid*)(4 * 4));
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(0));
    */
    
    
    
    }
    
    
    
    
    
    mNodeCount = 0;
    mWriteIndexVertex = 0;
    mWriteIndexIndex = 0;
}

void FRenderQueue::Enqueue(FVertex2D *pVertexBuffer, int pVertexCount, GFX_MODEL_INDEX_TYPE *pIndexBuffer, int pIndexCount, int pBindIndex)
{
    bool aOverflow = false;
    
    
    if((mWriteIndexVertex + pVertexCount) >= RENDER_QUEUE_VERTEX_BUFFER_SIZE)aOverflow = true;
    if((mWriteIndexIndex + pIndexCount) >= RENDER_QUEUE_INDEX_BUFFER_SIZE)aOverflow = true;
    if((mNodeCount + 1) >= RENDER_QUEUE_NODE_BUFFER_SIZE)aOverflow = true;
    
    if(aOverflow)
    {
        RenderDump();
        
        //printf("We overflowed the render buffer...! Damn!\n");
    }
    
    int aCapWriteIndexVertex = (mWriteIndexVertex + pVertexCount);
    int aCapWriteIndexIndex = (mWriteIndexIndex + pIndexCount);
    
    mNode[mNodeCount].mBindIndex = pBindIndex;
    mNode[mNodeCount].mStartIndexVertex = mWriteIndexVertex;
    mNode[mNodeCount].mStartIndexIndex = mWriteIndexIndex;
    mNode[mNodeCount].mIndexCount = pIndexCount;
    
    for(int i=mWriteIndexIndex;i<aCapWriteIndexIndex;i++)
    {
        mIndex[i] = (pIndexBuffer[i - mWriteIndexIndex]);
    }
    
    for(int i=mWriteIndexVertex;i<aCapWriteIndexVertex;i++)
    {
        mVertex[i] = pVertexBuffer[i - mWriteIndexVertex];
    }
    
    mWriteIndexVertex = aCapWriteIndexVertex;
    mWriteIndexIndex = aCapWriteIndexIndex;
    mNodeCount++;
}

void FRenderQueue::EnqueueSpriteCenter(FSprite *pSprite, float pX, float pY)
{
    float aStartX = pSprite->GetStartX() + pX;
    float aStartY = pSprite->GetStartY() + pY;
    
    float aEndX = pSprite->GetEndX() + pX;
    float aEndY = pSprite->GetEndY() + pY;
    
    float aStartU = pSprite->GetStartU();
    float aStartV = pSprite->GetStartV();
    
    float aEndU = pSprite->GetEndU();
    float aEndV = pSprite->GetEndV();
    
    EnqueueQuad(aStartX, aStartY, aEndX, aStartY, aStartX, aEndY, aEndX, aEndY, aStartU, aStartV, aEndU, aStartV, aStartU, aEndV, aEndU, aEndV, pSprite->mBindIndex);
}

void FRenderQueue::EnqueueSpriteDraw(FSprite *pSprite, float pX, float pY)
{
    EnqueueSpriteCenter(pSprite, pX + pSprite->mWidth2, pY + pSprite->mHeight2);
}

void FRenderQueue::EnqueueSpriteDrawScaled(FSprite *pSprite, float pX, float pY, float pScale)
{
    float aStartX = pSprite->GetStartX() * pScale + pX;
    float aStartY = pSprite->GetStartY() * pScale + pY;
    
    float aEndX = pSprite->GetEndX() * pScale + pX;
    float aEndY = pSprite->GetEndY() * pScale + pY;
    
    float aStartU = pSprite->GetStartU();
    float aStartV = pSprite->GetStartV();
    
    float aEndU = pSprite->GetEndU();
    float aEndV = pSprite->GetEndV();
    
    EnqueueQuad(aStartX, aStartY, aEndX, aStartY, aStartX, aEndY, aEndX, aEndY, aStartU, aStartV, aEndU, aStartV, aStartU, aEndV, aEndU, aEndV, pSprite->mBindIndex);
}

void FRenderQueue::EnqueueSpriteDrawScaled(FSprite *pSprite, float pX, float pY, float pScaleX, float pScaleY)
{
    float aStartX = pSprite->GetStartX() * pScaleX + pX;
    float aStartY = pSprite->GetStartY() * pScaleY + pY;
    
    float aEndX = pSprite->GetEndX() * pScaleX + pX;
    float aEndY = pSprite->GetEndY() * pScaleY + pY;
    
    float aStartU = pSprite->GetStartU();
    float aStartV = pSprite->GetStartV();
    
    float aEndU = pSprite->GetEndU();
    float aEndV = pSprite->GetEndV();
    
    EnqueueQuad(aStartX, aStartY, aEndX, aStartY, aStartX, aEndY, aEndX, aEndY, aStartU, aStartV, aEndU, aStartV, aStartU, aEndV, aEndU, aEndV, pSprite->mBindIndex);
}


void FRenderQueue::EnqueueSpriteDrawRotated(FSprite *pSprite, float pX, float pY, float pRotation)
{
    EnqueueSpriteDraw(pSprite, pX, pY, pRotation, 1.0f);
}

void FRenderQueue::EnqueueSpriteDraw(FSprite *pSprite, float pX, float pY, float pRotation, float pScale)
{
    if(pRotation == 0.0f)
    {
        if(pScale == 1.0f)
        {
            EnqueueSpriteCenter(pSprite, pX, pY);
        }
        else
        {
            EnqueueSpriteDrawScaled(pSprite, pX, pY, pScale);
        }
    }
    else
    {
        float aRotationRadians = fmath_degreesToRadians(pRotation);
        
        float aStartX = pSprite->GetStartX();
        float aStartY = pSprite->GetStartY();
        float aEndX = pSprite->GetEndX();
        float aEndY = pSprite->GetEndY();
        
        float aX[4];
        float aY[4];
        
        aX[0] = aStartX;
        aY[0] = aStartY;
        
        aX[1] = aEndX;
        aY[1] = aStartY;
        
        aX[2] = aStartX;
        aY[2] = aEndY;
        
        aX[3] = aEndX;
        aY[3] = aEndY;
        
        for(int i=0;i<4;i++)
        {
            
            float aDiffX = aX[i];
            float aDiffY = aY[i];
            
            float aRot = -atan2f(aDiffX, aDiffY);
            
            //fmath_faceTarget(aDiffX, aDiffY);
            
            float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
            
            if(aDist > 0.01f)
            {
                aDist = sqrtf(aDist);
            }
            
            aRot += aRotationRadians;
            
            float aDirX = sin(-aRot);
            float aDirY = cos(-aRot);
            
            aX[i] = aDirX * (aDist * pScale) + pX;
            aY[i] = aDirY * (aDist * pScale) + pY;
        }
        
        float aStartU = pSprite->GetStartU();
        float aStartV = pSprite->GetStartV();
        
        float aEndU = pSprite->GetEndU();
        float aEndV = pSprite->GetEndV();
        
        EnqueueQuad(aX[0], aY[0], aX[1], aY[1], aX[2], aY[2], aX[3], aY[3], aStartU, aStartV, aEndU, aStartV, aStartU, aEndV, aEndU, aEndV, pSprite->mBindIndex);
    }
}



void FRenderQueue::EnqueueQuad(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4, int pBindIndex)
{
    EnqueueQuad(pX1, pY1, pX2, pY2, pX3, pY3, pX4, pY4, 0, 0, 1, 0, 0, 1, 1, 1, pBindIndex);
}

void FRenderQueue::EnqueueQuad(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4,
                               float pU1, float pV1, float pU2, float pV2, float pU3, float pV3, float pU4, float pV4, int pBindIndex)
{
    FVertex2D aVertex[4];
    
    for(int i=0;i<4;i++)
    {
        aVertex[i].mRed = mRed;
        aVertex[i].mGreen = mGreen;
        aVertex[i].mBlue = mBlue;
        aVertex[i].mAlpha = mAlpha;
    }
    
    aVertex[0].mX = pX1;
    aVertex[0].mY = pY1;
    aVertex[0].mU = pU1;
    aVertex[0].mV = pV1;

    aVertex[1].mX = pX2;
    aVertex[1].mY = pY2;
    aVertex[1].mU = pU2;
    aVertex[1].mV = pV2;
    
    aVertex[2].mX = pX3;
    aVertex[2].mY = pY3;
    aVertex[2].mU = pU3;
    aVertex[2].mV = pV3;
    
    aVertex[3].mX = pX4;
    aVertex[3].mY = pY4;
    aVertex[3].mU = pU4;
    aVertex[3].mV = pV4;
    
    GFX_MODEL_INDEX_TYPE aBufferIndex[6];
    
    aBufferIndex[0] = 0;
    aBufferIndex[1] = 2;
    aBufferIndex[2] = 1;
    aBufferIndex[3] = 1;
    aBufferIndex[4] = 2;
    aBufferIndex[5] = 3;
    
    Enqueue(aVertex, 4, aBufferIndex, 6, pBindIndex);
}

