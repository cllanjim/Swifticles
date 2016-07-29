//
//  FSprite.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/2/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FSprite.h"
#include "FImage.h"
#include "FApp.h"
#include "core_gfx.h"

FSprite::FSprite()
{
    mWidth = 0.0f;
    mHeight = 0.0f;
    
    mWidth2 = 0.0f;
    mHeight2 = 0.0f;
    
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
}

FSprite::~FSprite()
{
    Kill();
}

void FSprite::Kill()
{
    mWidth = 0.0f;
    mHeight = 0.0f;
    
    mWidth2 = 0.0f;
    mHeight2 = 0.0f;
    
    if(mBindIndex != -1)
    {
        if(gAppBase)
        {
            gAppBase->BindRemove(mBindIndex);
        }
        
        mBindIndex = -1;
    }
    
}

void FSprite::Load(const char *pFileName)
{
    FImage aImage;
    aImage.Load(pFileName);
    Load(&aImage);
}

void FSprite::Load(FImage *pImage)
{
    Kill();
    
    if(pImage)
    {
        pImage->Bind();
        
        if(pImage->mBindIndex > 0 && pImage->mWidth > 0 && pImage->mHeight > 0)
        {
            Load(pImage, 0, 0, pImage->mWidth, pImage->mHeight);
            
            /*
            mBindIndex = pImage->mBindIndex;
            if(gAppBase)gAppBase->BindAdd(mBindIndex);
            
            mWidth = (float)pImage->mWidth;
            mHeight = (float)pImage->mHeight;
            
            mWidth2 = mWidth / 2.0f;
            mHeight2 = mHeight / 2.0f;
            
            mBufferVertex[0] = -mWidth2;
            mBufferVertex[1] = -mHeight2;
            mBufferVertex[2] = mWidth2;
            mBufferVertex[3] = -mHeight2;
            mBufferVertex[4] = -mWidth2;
            mBufferVertex[5] = mHeight2;
            mBufferVertex[6] = mWidth2;
            mBufferVertex[7] = mHeight2;
            
            float aStartU=(float)pImage->mOffsetX/(float)pImage->mExpandedWidth;
            float aStartV=(float)pImage->mOffsetY/(float)pImage->mExpandedHeight;
            float aEndU=(float)(pImage->mOffsetX + pImage->mWidth)/(float)pImage->mExpandedWidth;
            float aEndV=(float)(pImage->mOffsetY + pImage->mHeight)/(float)pImage->mExpandedHeight;
            
            mBufferVertex[8 + 0] = aStartU;
            mBufferVertex[8 + 1] = aStartV;
            mBufferVertex[8 + 2] = aEndU;
            mBufferVertex[8 + 3] = aStartV;
            mBufferVertex[8 + 4] = aStartU;
            mBufferVertex[8 + 5] = aEndV;
            mBufferVertex[8 + 6] = aEndU;
            mBufferVertex[8 + 7] = aEndV;
            */
            
        }
    }
}

void FSprite::Load(FImage *pImage, int pX, int pY, int pWidth, int pHeight)
{
    Kill();
    
    if(pImage)
    {
        pImage->Bind();
        
        if(pImage->mBindIndex > 0 && pImage->mWidth > 0 && pImage->mHeight > 0)
        {
            mBindIndex = pImage->mBindIndex;
            if(gAppBase)gAppBase->BindAdd(mBindIndex);
            
            pX += pImage->mOffsetX;
            pY += pImage->mOffsetY;
            
            mWidth = (float)pWidth;
            mHeight = (float)pHeight;
            
            mWidth2 = mWidth / 2.0f;
            mHeight2 = mHeight / 2.0f;
            
            mBufferVertex[0] = -mWidth2;
            mBufferVertex[1] = -mHeight2;
            mBufferVertex[2] = mWidth2;
            mBufferVertex[3] = -mHeight2;
            mBufferVertex[4] = -mWidth2;
            mBufferVertex[5] = mHeight2;
            mBufferVertex[6] = mWidth2;
            mBufferVertex[7] = mHeight2;
            
            //float aStartU=(float)pImage->mOffsetX/(float)pImage->mExpandedWidth;
            //float aStartV=(float)pImage->mOffsetY/(float)pImage->mExpandedHeight;
            //float aEndU=(float)(pImage->mOffsetX + pImage->mWidth)/(float)pImage->mExpandedWidth;
            //float aEndV=(float)(pImage->mOffsetY + pImage->mHeight)/(float)pImage->mExpandedHeight;
            
            float aStartU = (float)pX/(float)pImage->mExpandedWidth;
            float aStartV = (float)pY/(float)pImage->mExpandedHeight;
            float aEndU = (float)(pX+pWidth)/(float)pImage->mExpandedWidth;
            float aEndV = (float)(pY+pHeight)/(float)pImage->mExpandedHeight;
            
            
            mBufferVertex[8 + 0] = aStartU;
            mBufferVertex[8 + 1] = aStartV;
            mBufferVertex[8 + 2] = aEndU;
            mBufferVertex[8 + 3] = aStartV;
            mBufferVertex[8 + 4] = aStartU;
            mBufferVertex[8 + 5] = aEndV;
            mBufferVertex[8 + 6] = aEndU;
            mBufferVertex[8 + 7] = aEndV;
        }
    }
}

bool FSprite::DidLoad()
{
    bool aReturn = true;
    
    if(mBindIndex <= 0)aReturn = false;
    if(mWidth <= 0)aReturn = false;
    if(mHeight <= 0)aReturn = false;
    
    return aReturn;
}

void FSprite::Center(float pX, float pY)
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteCenter(this, pX, pY);
    
    /*
    FMatrix aHold = gfx_matrixWorldViewGet();
    FMatrix aMatrix = aHold;
    aMatrix.Translate(pX, pY);
    //aMatrix = FMatrixTranslate(aMatrix, pX, pY, 0.0f);
    gfx_matrixWorldViewSet(aMatrix);
    Draw();
    gfx_matrixWorldViewSet(aHold);
    */
}

void FSprite::Draw(float pX, float pY)
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteDraw(this, pX, pY);
    
    //Center(pX + mWidth2, pY + mHeight2);
}

void FSprite::DrawScaled(float pX, float pY, float pScale)
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteDrawScaled(this, pX, pY, pScale);
    
    /*
    FMatrix aHold = gfx_matrixWorldViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(pX, pY);
    if(pScale != 1.0f)aMatrix.Scale(pScale);
    
    gfx_matrixWorldViewSet(aMatrix);
    Draw();
    gfx_matrixWorldViewSet(aHold);
    */
}

void FSprite::DrawScaled(float pX, float pY, float pScaleX, float pScaleY)
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteDrawScaled(this, pX, pY, pScaleX, pScaleY);
}

void FSprite::DrawRotated(float pX, float pY, float pRotation)
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteDrawRotated(this, pX, pY, pRotation);
    
    /*
    FMatrix aHold = gfx_matrixWorldViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(pX, pY);
    if(pRotation != 0.0f)aMatrix.Rotate(pRotation);
    
    gfx_matrixWorldViewSet(aMatrix);
    Draw();
    gfx_matrixWorldViewSet(aHold);
    */
}

void FSprite::Draw(float pX, float pY, float pRotation, float pScale)
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteDraw(this, pX, pY, pRotation, pScale);
    
    /*
    FMatrix aHold = gfx_matrixWorldViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(pX, pY);
    if(pScale != 1.0f)aMatrix.Scale(pScale);
    if(pRotation != 0.0f)aMatrix.Rotate(pRotation);
    gfx_matrixWorldViewSet(aMatrix);
    
    Draw();
    gfx_matrixWorldViewSet(aHold);
    */
    
}

void FSprite::Draw()
{
    if(mBindIndex != -1)gRenderQueue.EnqueueSpriteCenter(this, 0.0f, 0.0f);
    
    /*
    gfx_bufferVertexBind(mBufferSlotVertex);
    gfx_bufferIndexBind(mBufferSlotIndex);
    
    gfx_positionSetPointer(2, 0);
    gfx_texCoordSetPointer(2, 8);
    
    gfx_bindTexture(mBindIndex);
    gfx_drawElementsTriangle(6, 0);
    */
    
}



/*
float aTex[8];
float aVer[8];

float aWidth=mTextureVertex[2] - mTextureVertex[0];
float aTexWidth=mTextureCoord[2] - mTextureCoord[0];

aTex[0] = mTextureCoord[0] + aTexWidth * pStartPercent;
aTex[1] = mTextureCoord[1];
aTex[2] = mTextureCoord[0] + aTexWidth * pEndPercent;
aTex[3] = mTextureCoord[3];
aTex[4] = mTextureCoord[0] + aTexWidth * pStartPercent;
aTex[5] = mTextureCoord[5];
aTex[6] = mTextureCoord[0] + aTexWidth * pEndPercent;
aTex[7] = mTextureCoord[7];

aVer[0] = mTextureVertex[0] + aWidth * pStartPercent;
aVer[1] = mTextureVertex[1];
aVer[2] = mTextureVertex[0] + aWidth * pEndPercent;
aVer[3] = mTextureVertex[3];
aVer[4] = mTextureVertex[0] + aWidth * pStartPercent;
aVer[5] = mTextureVertex[5];
aVer[6] = mTextureVertex[0] + aWidth * pEndPercent;
aVer[7] = mTextureVertex[7];




glEnable( GL_TEXTURE_2D);
glBindTexture(GL_TEXTURE_2D, mBindIndex);
glVertexPointer(2,GL_FLOAT,0,aVer);
glTexCoordPointer(2,GL_FLOAT,0,aTex);
glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
glDisable( GL_TEXTURE_2D);
*/