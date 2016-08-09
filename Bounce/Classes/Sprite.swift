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
    //var width:CGFloat = 0.0
    //var height:CGFloat = 0.0
    var size:CGSize = CGSizeZero
    
    
    
    private var vertexBuffer:[GLfloat] = [GLfloat](count:16, repeatedValue: 0.0)
    private var indexBuffer:[IndexBufferType] = [IndexBufferType](count: 6, repeatedValue: 0)
    
    //private var vertexBufferSlot:BufferIndex = -1
    //private var indexBufferSlot:BufferIndex = -1

    //vertexBuffer = [-128.0, -128.0, 0.0, 0.0, 128.0, -128.0,  1.0, 0.0, -128.0, 128.0,  0.0, 1.0, 128.0, 128.0,  1.0, 1.0]
    //indexBuffer = [0, 2, 1, 1, 2, 3]
        
    //vertexBufferSlot = bufferVertexGenerate(data: vertexBuffer, size: 16)
    //indexBufferSlot = bufferIndexGenerate(data: indexBuffer, size: 6)
        
    
    public init() {
        vertexBuffer[0] = -128
        
    }
    
    deinit {
        clear()
    }
    
    func clear() {
        size = CGSizeZero
        texture = nil
    }
    
    public func load(path path: String?) {
        load(texture: Texture(path: path))
    }
    
    public func load(texture t: Texture?) {
        
        clear()
        
        if let newTexture = t {
            if newTexture.bindIndex != -1 {// && newTexture.width > 0 && newTexture.height > 0 {
                
                
                load(texture: newTexture, rect: CGRect(x: CGFloat(-newTexture.width) / 2.0, y: CGFloat(-newTexture.height) / 2.0, width: CGFloat(newTexture.width), height: CGFloat(newTexture.height)))
                    
                
                //texture = newTexture
            }
        }
        
        
    }
    
    public func load(texture t: Texture?, rect:CGRect) {
        
        clear()
        if let newTexture = t where newTexture.bindIndex != -1 && newTexture.width > 0 && newTexture.height > 0 {
            
            texture = newTexture
            
            
        }
    }
    
    public func drawCentered(pos pos:CGPoint) {
        
    }
    
    public func drawCentered(pos pos:CGPoint, scale:CGFloat, rot: CGFloat) {
        
    }
    
    
    
}


/*
float                           mBufferVertex[16];
GFX_MODEL_INDEX_TYPE            mBufferIndex[6];

float                           mWidth;
float                           mHeight;

float                           mWidth2;
float                           mHeight2;

int                             mBufferIndex;

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
    
    mBufferIndex = -1;
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
    
    if(mBufferIndex != -1)
    {
        if(gAppBase)
        {
            gAppBase->BindRemove(mBufferIndex);
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
        
        if(pImage->mBufferIndex > 0)
        {
            mBufferIndex = pImage->mBufferIndex;
            if(gAppBase)gAppBase->BindAdd(mBufferIndex);
            
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
    
    gfx_bindTexture(mBufferIndex);
    gfx_drawElementsTriangle(6, 0);
}

*/


















