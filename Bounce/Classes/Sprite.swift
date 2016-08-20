//
//  Sprite.swift
//  MashupGL
//
//  Created by Nicholas Raptis on 7/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import Foundation
import GLKit

public class Sprite {
    
    var texture:Texture? = nil
    
    //"Single Source of Truth" doesn't necessarily apply
    //because a sprite can be only a slice of a texture...
    //var width:CGFloat = 0.0
    //var height:CGFloat = 0.0
    var size:CGSize = CGSizeZero
    
    private var vertexBuffer:[GLfloat] = [GLfloat](count:40, repeatedValue: 0.0)
    private var indexBuffer:[IndexBufferType] = [IndexBufferType](count: 6, repeatedValue: 0)
    
    private var vertexBufferSlot:BufferIndex?
    private var indexBufferSlot:BufferIndex?
    
    private var needsRefresh = true
    
    var x1: CGFloat {
        get { return CGFloat(vertexBuffer[ 0])}
        set {vertexBuffer[ 0] = GLfloat(newValue);needsRefresh=true}
    }
    var x2: CGFloat {
        get { return CGFloat(vertexBuffer[10])}
        set {vertexBuffer[10] = GLfloat(newValue);needsRefresh=true}
    }
    var x3: CGFloat {
        get { return CGFloat(vertexBuffer[20])}
        set {vertexBuffer[20] = GLfloat(newValue);needsRefresh=true}
    }
    var x4: CGFloat {
        get { return CGFloat(vertexBuffer[30])}
        set {vertexBuffer[30] = GLfloat(newValue);needsRefresh=true}
    }
    
    var y1: CGFloat {
        get { return CGFloat(vertexBuffer[ 1])}
        set {vertexBuffer[ 1] = GLfloat(newValue);needsRefresh=true}
    }
    var y2: CGFloat {
        get { return CGFloat(vertexBuffer[11])}
        set {vertexBuffer[11] = GLfloat(newValue);needsRefresh=true}
    }
    var y3: CGFloat {
        get { return CGFloat(vertexBuffer[21])}
        set {vertexBuffer[21] = GLfloat(newValue);needsRefresh=true}
    }
    var y4: CGFloat {
        get { return CGFloat(vertexBuffer[31])}
        set {vertexBuffer[31] = GLfloat(newValue);needsRefresh=true}
    }
    
    var u1: CGFloat {
        get { return CGFloat(vertexBuffer[ 3])}
        set {vertexBuffer[ 3] = GLfloat(newValue);needsRefresh=true}
    }
    var u2: CGFloat {
        get { return CGFloat(vertexBuffer[13])}
        set {vertexBuffer[13] = GLfloat(newValue);needsRefresh=true}
    }
    var u3: CGFloat {
        get { return CGFloat(vertexBuffer[23])}
        set {vertexBuffer[23] = GLfloat(newValue);needsRefresh=true}
    }
    var u4: CGFloat {
        get { return CGFloat(vertexBuffer[33])}
        set {vertexBuffer[33] = GLfloat(newValue);needsRefresh=true}
    }
    
    var v1: CGFloat {
        get { return CGFloat(vertexBuffer[ 4])}
        set {vertexBuffer[ 4] = GLfloat(newValue);needsRefresh=true}
    }
    var v2: CGFloat {
        get { return CGFloat(vertexBuffer[14])}
        set {vertexBuffer[14] = GLfloat(newValue);needsRefresh=true}
    }
    var v3: CGFloat {
        get { return CGFloat(vertexBuffer[24])}
        set {vertexBuffer[24] = GLfloat(newValue);needsRefresh=true}
    }
    var v4: CGFloat {
        get { return CGFloat(vertexBuffer[34])}
        set {vertexBuffer[34] = GLfloat(newValue);needsRefresh=true}
    }
    
    var startX: CGFloat {
        get { return x1}
        set {
            x1 = newValue
            x3 = newValue
        }
    }
    
    var endX: CGFloat {
        get { return x2}
        set {
            x2 = newValue
            x4 = newValue
        }
    }
    
    var startY: CGFloat {
        get { return y1}
        set {
            y1 = newValue
            y2 = newValue
        }
    }
    
    var endY: CGFloat {
        get { return y3}
        set {
            y3 = newValue
            y4 = newValue
        }
    }
    
    public init() {
        vertexBuffer = [-128.0, -128.0, 0.0,    0.0, 0.0, 0.0,    1.0, 1.0, 1.0, 1.0,
                         128.0, -128.0, 0.0,    1.0, 0.0, 0.0,    1.0, 1.0, 1.0, 1.0,
                        -128.0,  128.0, 0.0,    0.0, 1.0, 0.0,    1.0, 1.0, 1.0, 1.0,
                         128.0,  128.0, 0.0,    1.0, 1.0, 0.0,    1.0, 1.0, 1.0, 1.0]
        indexBuffer = [0, 2, 1, 1, 2, 3]
    }
    
    deinit {
        clear()
    }
    
    func bind() {
        gG.textureBind(texture: texture)
    }
    
    func clear() {
        size = CGSizeZero
        texture = nil
        
        gG.bufferDelete(bufferIndex: vertexBufferSlot)
        vertexBufferSlot = nil
        
        gG.bufferDelete(bufferIndex: indexBufferSlot)
        indexBufferSlot = nil
    }
    
    public func load(path path: String?) {
        load(texture: Texture(path: path))
    }
    
    public func load(texture t: Texture?) {
        clear()
        if let newTexture = t where newTexture.bindIndex != nil {// && newTexture.width > 0 && newTexture.height > 0 {
            load(texture: newTexture, rect: CGRect(x: CGFloat(-newTexture.width) / 2.0, y: CGFloat(-newTexture.height) / 2.0, width: CGFloat(newTexture.width), height: CGFloat(newTexture.height)))
        }
        
        
    }
    
    public func load(texture t: Texture?, rect:CGRect) {
        
        clear()
        if let newTexture = t where newTexture.bindIndex != nil && newTexture.width > 0 && newTexture.height > 0 {
            
            texture = newTexture
            
            size = CGSize(width: rect.size.width, height: rect.size.height)
            
            let width2 = size.width / 2.0
            let height2 = size.height / 2.0
            
            startX = CGFloat(-width2)
            endX = CGFloat(width2)
            
            startY = CGFloat(-height2)
            endY = CGFloat(height2)
            
            vertexBufferSlot = gG.bufferVertexGenerate(data: vertexBuffer, size: 40)
            indexBufferSlot = gG.bufferIndexGenerate(data: indexBuffer, size: 6)
        }
    }
    
    public func draw() {
        
        if needsRefresh {
            refreshVB()
        }
        
        gG.bufferIndexBind(indexBufferSlot)
        gG.bufferVertexBind(vertexBufferSlot)
        
        gG.positionEnable()
        gG.positionSetPointer(size: 3, offset: 0, stride: 10)
        
        gG.texCoordEnable()
        gG.textureCoordSetPointer(size: 3, offset: 3, stride: 10)
        
        gG.colorArrayEnable()
        gG.colorArraySetPointer(size: 4, offset: 6, stride: 10)
        
        gG.textureEnable()
        gG.textureBind(texture: texture)
        
        gG.drawElementsTriangle(count:6, offset: 0)
    }
    
    public func drawCentered(pos pos:CGPoint) {
        
        
        
        
        var modelView = gG.matrixModelViewGet()
        
        
        //print("modelView = \(modelView.m)")
        
        
        //m = GLKMatrix4Scale(m, 0.85, 0.85, 0.85)
        
        //print("m2 = \(m.array)")
        
        
        //var matrix = GLKMatrix4Translate(modelView, Float(pos.x), Float(pos.y), 0.0)
        //var matrix = GLKMatrix4MakeTranslation(Float(pos.x), Float(pos.y), 0.0)
        
        //gG.matrixModelViewSet(matrix)
        
        
        //textureDisable()
        
        
        draw()
    }
    
    public func drawCentered(pos pos:CGPoint, scale:CGFloat, rot: CGFloat) {
        

        draw()
        
    }
    
    
    internal func refreshVB() {
        
        if let checkIndex = vertexBufferSlot {
            gG.bufferVertexSetData(bufferIndex: checkIndex, data: vertexBuffer, size: 40)
            needsRefresh = false
        }
        
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


















