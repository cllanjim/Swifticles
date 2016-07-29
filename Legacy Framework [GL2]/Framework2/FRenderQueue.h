//
//  FRenderQueue.h
//  CoreDemo
//
//  Created by Nick Raptis on 11/4/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef __CoreDemo__FRenderQueue__
#define __CoreDemo__FRenderQueue__

#include "core_gfx.h"
#include "FVertex.h"
#include "FColor.h"
#include "FSprite.h"

#define RENDER_QUEUE_VERTEX_BUFFER_SIZE 4096
#define RENDER_QUEUE_INDEX_BUFFER_SIZE 16384
#define RENDER_QUEUE_NODE_BUFFER_SIZE 1024

class FRenderQueueNode
{
public:
    
    FRenderQueueNode();
    ~FRenderQueueNode();
    
    int                                 mBindIndex;
    
    int                                 mStartIndexVertex;
    int                                 mStartIndexIndex;
    
    int                                 mIndexCount;
};

class FRenderQueue
{
public:
    
    FRenderQueue();
    ~FRenderQueue();
    
    void                                RenderDump();
    
    void                                Enqueue(FVertex2D *pVertexBuffer, int pVertexCount, GFX_MODEL_INDEX_TYPE *pIndexBuffer, int pIndexCount, int pBindIndex);
    void                                EnqueueSpriteCenter(FSprite *pSprite, float pX, float pY);
    void                                EnqueueSpriteDraw(FSprite *pSprite, float pX, float pY);
    
    void                                EnqueueSpriteDrawScaled(FSprite *pSprite, float pX, float pY, float pScale);
    void                                EnqueueSpriteDrawScaled(FSprite *pSprite, float pX, float pY, float pScaleX, float pScaleY);
    
    void                                EnqueueSpriteDrawRotated(FSprite *pSprite, float pX, float pY, float pRotation);
    
    void                                EnqueueSpriteDraw(FSprite *pSprite, float pX, float pY, float pRotation, float pScale);
    
    
    void                                EnqueueQuad(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4, int pBindIndex);
    
    void                                EnqueueQuad(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4,
                                                    float pU1, float pV1, float pU2, float pV2, float pU3, float pV3, float pU4, float pV4, int pBindIndex);
    
    
    
    FVertex2D                           mVertex[RENDER_QUEUE_VERTEX_BUFFER_SIZE];
    GFX_MODEL_INDEX_TYPE                mIndex[RENDER_QUEUE_INDEX_BUFFER_SIZE];
    FRenderQueueNode                    mNode[RENDER_QUEUE_NODE_BUFFER_SIZE];
    
    int                                 mNodeCount;
    int                                 mWriteIndexVertex;
    int                                 mWriteIndexIndex;
    
    float                               mRed;
    float                               mGreen;
    float                               mBlue;
    float                               mAlpha;
    
    unsigned int                        mBufferSlotVertex;
    unsigned int                        mBufferSlotIndex;
    
};



#endif
