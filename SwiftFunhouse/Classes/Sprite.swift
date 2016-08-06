//
//  Sprite.swift
//  MashupGL
//
//  Created by Nicholas Raptis on 7/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import Foundation

public class Sprite {
    
    var texture:Texture? = nil
    
    //"Single Source of Truth" doesn't necessarily apply
    //because a sprite can be only a slice of a texture...
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    
    
    /*
    var width: CGFloat {
        get {
            if texture != nil {
                return CGFloat(texture!.width)
            }
            return 0.0
        }
        set {
            
        }
    }
    */
    
    public init() {
        
    }
    
    deinit {
        clear()
    }
    
    func clear() {
        
        width = 0.0
        height = 0.0
        
        texture = nil
    }
    
    public func load(filename: String) {
        
        clear()
        
    }
    
}


/*
float                           mBufferVertex[16];
GFX_MODEL_INDEX_TYPE            mBufferIndex[6];

float                           mWidth;
float                           mHeight;

float                           mWidth2;
float                           mHeight2;

int                             mBindIndex;

unsigned int                    mBufferSlotVertex;
unsigned int                    mBufferSlotIndex;
 
 
 
 
*/


/*

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
    mBufferSlotVertex = 0;
    mBufferSlotIndex = 0;
}

FSprite::~FSprite()
{
    
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
        
        if(pImage->mBindIndex > 0)
        {
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
            
            mBufferSlotVertex = gfx_bufferVertexGenerate(mBufferVertex, 16);
            mBufferSlotIndex = gfx_bufferIndexGenerate(mBufferIndex, 6);
        }
    }
}

void FSprite::Center(float pX, float pY)
{
    FMatrix aHold = gfx_matrixModelViewGet();
    FMatrix aMatrix = aHold;
    aMatrix = FMatrixTranslate(aMatrix, pX, pY, 0.0f);
    gfx_matrixModelViewSet(aMatrix);
    Draw();
    gfx_matrixModelViewSet(aHold);
}

void FSprite::Draw(float pX, float pY)
{
    Center(pX + mWidth2, pY + mHeight2);
}

void FSprite::DrawScaled(float pX, float pY, float pScale)
{
    FMatrix aHold = gfx_matrixModelViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(pX, pY);
    aMatrix.Scale(pScale);
    
    gfx_matrixModelViewSet(aMatrix);
    Draw();
    gfx_matrixModelViewSet(aHold);
}

void FSprite::DrawRotated(float pX, float pY, float pRotation)
{
    FMatrix aHold = gfx_matrixModelViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(pX, pY);
    aMatrix.Rotate(pRotation);
    
    gfx_matrixModelViewSet(aMatrix);
    Draw();
    gfx_matrixModelViewSet(aHold);
}

void FSprite::Draw(float pX, float pY, float pRotation, float pScale)
{
    FMatrix aHold = gfx_matrixModelViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(pX, pY);
    aMatrix.Scale(pScale);
    aMatrix.Rotate(pRotation);
    gfx_matrixModelViewSet(aMatrix);
    Draw();
    gfx_matrixModelViewSet(aHold);
}

void FSprite::Draw()
{
    //glUseProgram(gGLProgram);
    //gfx_shaderAttachFragment(gGLShaderFragmentTexture);
    
    gfx_bufferVertexBind(mBufferSlotVertex);
    gfx_bufferIndexBind(mBufferSlotIndex);
    
    gfx_positionSetPointer(2, 0);
    gfx_texCoordSetPointer(2, 8);
    
    gfx_bindTexture(mBindIndex);
    gfx_drawElementsTriangle(6, 0);
}

*/


















