//
//  DTVGraphics.swift
//  MashupGL
//
//  Created by Nicholas Raptis on 7/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import GLKit
import OpenGLES
import QuartzCore
import CoreData

typealias IndexBufferType = GLushort

var gGLBufferDepth:GLuint = 0
var gGLBufferRender:GLuint = 0

var gGLUniformProjection:GLint = 0
var gGLUniformModelView:GLint = 0
var gGLUniformTexture:GLint = 0
var gGLUniformColorModulate:GLint = 0

var gGLSlotPosition:GLint = 0
var gGLSlotTexCoord:GLint = 0
var gGLSlotNormal:GLint = 0

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}

class Graphics {
    
    private var cProjectionMatrix = GLKMatrix4Identity
    private var cModelViewMatrix = GLKMatrix4Identity
    
    private var cRectVertexBuffer:[GLfloat] = [GLfloat](count:8, repeatedValue: 0.0)
    private var cRectIndexBuffer:[IndexBufferType] = [IndexBufferType](count: 6, repeatedValue: 0)
    
    private var cRectVertexBufferSlot:GLuint = 0
    private var cRectIndexBufferSlot:GLuint = 0
    
    init() {
        
        cRectVertexBuffer = [-128, -128, 128, -128, -128, 128, 128, 128]
        
        //cRectVertexBuffer[0] = -128
        //cRectVertexBuffer[1] = -128
        //cRectVertexBuffer[2] = 128
        //cRectVertexBuffer[3] = -128
        //cRectVertexBuffer[4] = -128
        //cRectVertexBuffer[5] = 128
        //cRectVertexBuffer[6] = 128
        //cRectVertexBuffer[7] = 128
        
        cRectIndexBuffer = [0, 2, 1, 1, 2, 3]
        
        //cRectIndexBuffer[0] = 0
        //cRectIndexBuffer[1] = 2
        //cRectIndexBuffer[2] = 1
        //cRectIndexBuffer[3] = 1
        //cRectIndexBuffer[4] = 2
        //cRectIndexBuffer[5] = 3
        
        cRectVertexBufferSlot = bufferVertexGenerate(data: cRectVertexBuffer, size: 8)
        cRectIndexBufferSlot = bufferIndexGenerate(data: cRectIndexBuffer, size: 6)
    }
    
    func quadDraw(x1 x1:GLfloat, y1:GLfloat, x2:GLfloat, y2:GLfloat, x3:GLfloat, y3:GLfloat, x4:GLfloat, y4:GLfloat) {
        
        cRectVertexBuffer[0] = x1
        cRectVertexBuffer[1] = y1
        cRectVertexBuffer[2] = x2
        cRectVertexBuffer[3] = y2
        cRectVertexBuffer[4] = x3
        cRectVertexBuffer[5] = y3
        cRectVertexBuffer[6] = x4
        cRectVertexBuffer[7] = y4
        
        //cRectVertexBuffer.append(10.0)
        //cRectVertexBuffer.append(16.0)
        
        bufferVertexSetData(bufferIndex: cRectVertexBufferSlot, data: cRectVertexBuffer, size: 8)
        
        //bufferVertexSetData(gSpriteBlank.mBufferSlotVertex, gSpriteBlank.mBufferVertex, 16);
        
        
        bufferVertexBind(cRectVertexBufferSlot);
        bufferIndexBind(cRectIndexBufferSlot);
        
        positionEnable()
        positionSetPointer(size: 4, offset: 0, stride: 0)
        
        
        drawElementsTriangle(count:6, offset: 0)
        
        //drawElementsTriangle(6, 0);
        
        //drawE
        
        //positionSetPointer(2, 0);
        //quadDrawtexCoordSetPointer(2, 8);
        
        //quadDrawbindTexture(mBindIndex);
        //
        
        
        //cRectQuad
        
        
        /*
         float aPos[8];
         aPos[0]=x1;
         aPos[1]=y1;
         aPos[2]=x2;
         aPos[3]=y2;
         aPos[4]=x3;
         aPos[5]=y3;
         aPos[6]=x4;
         aPos[7]=y4;
         */
        
        
        /*
         gSpriteBlank.mBufferVertex[0]=x1;
         gSpriteBlank.mBufferVertex[1]=y1;
         gSpriteBlank.mBufferVertex[2]=x2;
         gSpriteBlank.mBufferVertex[3]=y2;
         gSpriteBlank.mBufferVertex[4]=x3;
         gSpriteBlank.mBufferVertex[5]=y3;
         gSpriteBlank.mBufferVertex[6]=x4;
         gSpriteBlank.mBufferVertex[7]=y4;
         
         //glDisable(GL_TEXTURE_2D);
         //bufferVertexSetData(gGLBufferQuad, aPos, 8);
         
         bufferVertexSetData(gSpriteBlank.mBufferSlotVertex, gSpriteBlank.mBufferVertex, 16);
         
         
         gSpriteBlank.Draw();
         */
        
    }
    
    func rectDraw(rect:CGRect) {
        rectDraw(x: GLfloat(rect.origin.x), y: GLfloat(rect.origin.y), width: GLfloat(rect.size.width), height: GLfloat(rect.size.height))
    }
    
    func rectDraw(x x:GLfloat, y:GLfloat, width:GLfloat, height:GLfloat) {
        quadDraw(x1: x, y1: y, x2: x+width, y2: y, x3: x, y3: y+height, x4: x+width, y4: y+height)
    }
    
    func colorSet() {
        colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
    }
    
    func colorSet(a a:GLfloat) {
        colorSet(r: 1.0, g: 1.0, b: 1.0, a: a)
    }
    
    func colorSet(r r:GLfloat, g:GLfloat, b:GLfloat) {
        colorSet(r: r, g: g, b: b, a: 1.0)
    }
    
    func colorSet(r r:GLfloat, g:GLfloat, b:GLfloat, a:GLfloat) {
        glUniform4f(gGLUniformColorModulate, r, g, b, a);
    }
    
    func clear() {
        clear(r: 0.0, g: 0.0, b: 0.0)
    }
    
    func clear(r r:GLfloat, g:GLfloat, b:GLfloat) {
        glClearColor(r, g, b, 1.0);
        glClear(GLenum(GL_COLOR_BUFFER_BIT))
    }
    
    func depthClear() {
        glClear(GLenum(GL_DEPTH_BUFFER_BIT))
    }
    
    
    func positionEnable() {
        glEnableVertexAttribArray(GLuint(gGLSlotPosition))
    }
    
    func positionDisable() {
        glDisableVertexAttribArray(GLuint(gGLSlotPosition))
    }
    
    func texCoordEnable() {
        glEnableVertexAttribArray(GLuint(gGLSlotTexCoord))
    }
    
    func texCoordDisable() {
        glDisableVertexAttribArray(GLuint(gGLSlotTexCoord))
    }
    
    func blendEnable() {
        glEnable(GLenum(GL_BLEND))
    }
    
    func blendDisable() {
        glDisable(GLenum(GL_BLEND))
    }
    
    func blendSetAlpha() {
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA));
    }
    
    func blendSetAdditive() {
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE))
    }
    
    func cullFacesEnable() {
        glEnable(GLenum(GL_CULL_FACE))
    }
    
    func cullFacesDisable() {
        glDisable(GLenum(GL_CULL_FACE))
    }
    
    func cullFacesSetFront() {
        glCullFace(GLenum(GL_FRONT))
    }
    
    func cullFacesSetBack() {
        glCullFace(GLenum(GL_BACK))
    }
    
    func bufferVertexGenerate(data data:[GLfloat], size:Int) -> GLuint {
        let result:GLuint = bufferGenerate()
        bufferVertexSetData(bufferIndex:result, data: data, size: size)
        return result;
    }
    
    func bufferGenerate() -> GLuint {
        var result = GLuint()
        glGenBuffers(1, &result);
        return result;
    }
    
    func bufferVertexSetData(bufferIndex bufferIndex:GLuint, data:[GLfloat], size:Int) {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIndex)
        glBufferData(GLenum(GL_ARRAY_BUFFER), size * sizeof(GLfloat), data, GLenum(GL_STATIC_DRAW))
    }
    
    func bufferIndexGenerate(data data:[IndexBufferType], size:Int) -> GLuint {
        let result = bufferGenerate()
        bufferIndexSetData(bufferIndex:result, data: data, size: size);
        return result;
    }
    
    func bufferIndexSetData(bufferIndex bufferIndex:GLuint, data:[IndexBufferType], size:Int) {
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), bufferIndex)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), size * sizeof(UInt32), data, GLenum(GL_STATIC_DRAW))
    }
    



    func bufferVertexBind(bufferIndex:GLuint) {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIndex)
    }
    
    func bufferIndexBind(bufferIndex:GLuint) {
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), bufferIndex)
    }
    
    
    func positionSetPointer(size size:Int, offset:Int, stride:Int)
    {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        //glVertexAttribPointer(GLenum(gGLSlotPosition), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLint(stride << 2), ptr);
        glVertexAttribPointer(GLenum(gGLSlotPosition), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLint(stride << 2), nil);
        
        
    }

    /*
    func textureCoordSetPointer(size size:Int, offset:Int, stride:Int)
    {
        glVertexAttribPointer(gGLSlotTexCoord, size, GL_FLOAT, GL_FALSE, (pStride << 2), (GLvoid*)(pOffset << 2));
    }

    func colorSetPointer(offset:Int, stride:Int)
    {
        glVertexAttribPointer(gGLSlotColor, 4, GL_FLOAT, GL_FALSE, (pStride << 2), (GLvoid*)(pOffset << 2));
    }

    

     */
    
    
    func drawElementsTriangle(count count:Int, offset:Int)
    {
        //IndexBufferType
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 1))
        //glDrawElements(GLenum(GL_TRIANGLES), GLsizei(count), GLenum(GL_UNSIGNED_SHORT), ptr);
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(count), GLenum(GL_UNSIGNED_SHORT), nil);
        
    }
    
    
    //cProjectionMatrix = GLKMatrix4Identity
    //cModelViewMatrix = GLKMatrix4Identity
    
    func matrixProjectionGet() -> GLKMatrix4 {
        return cProjectionMatrix
    }
    
    func matrixModelViewGet() -> GLKMatrix4 {
        return cModelViewMatrix
    }
    
    func matrixProjectionSet(mat:GLKMatrix4) {
        cProjectionMatrix = mat
        //glUniformMatrix4fv(gGLUniformProjection, 1, 0, mat.array)
        
        withUnsafePointer(&cProjectionMatrix, {
            glUniformMatrix4fv(gGLUniformProjection, 1, 0, UnsafePointer($0))
        })
    }
    
    func matrixModelViewSet(mat:GLKMatrix4) {
        cModelViewMatrix = mat
        
        withUnsafePointer(&cModelViewMatrix, {
            glUniformMatrix4fv(gGLUniformModelView, 1, 0, UnsafePointer($0))
        })
        
        //glUniformMatrix4fv(gGLUniformModelView, 1, 0, cModelViewMatrix.array)
    }
    
    func matrixProjectionReset() {
        matrixProjectionSet(GLKMatrix4Identity)
        
        //glUniformMatrix4fv(gGLUniformProjection, 1, 0, cProjectionMatrix.array);
    }
    
    func matrixModelViewReset() {
        
        matrixModelViewSet(GLKMatrix4Identity)
        //cModelViewMatrix = GLKMatrix4Identity
        //glUniformMatrix4fv(gGLUniformModelView, 1, 0, cModelViewMatrix.array);
    }
    
    func depthEnable() {
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    
    func depthDisable() {
        glDisable(GLenum(GL_DEPTH_TEST))
    }
    
    func clearDepth() {
        glClear(GLenum(GL_DEPTH_BUFFER_BIT))
    }
    
    
    /*
     
     glViewport(0, 0, gDeviceWidth, gDeviceHeight);
     
     colorSet();
     
     gSpriteBlank.Load("empty_white_square");
     
     }
     
     
     
     
     
     
     
     int generateTexture(unsigned int *pData, int pWidth, int pHeight)
     {
     int aBindIndex=-1;
     
     glGenTextures(1, (GLuint*)(&aBindIndex));
     
     if(aBindIndex == -1)
     {
     printf("Error Binding Texture [%d x %d]\n", pWidth, pHeight);
     }
     else
     {
     bindTexture(aBindIndex, pData, pWidth, pHeight);
     }
     
     return aBindIndex;
     }
     
     void deleteTexture(int pIndex)
     {
     glDeleteTextures(1, (GLuint*)(&(pIndex)));
     }
     
     void bindTexture(int pIndex, unsigned int *pData, int pWidth, int pHeight)
     {
     bindTexture(pIndex);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
     glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, pWidth, pHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData);
     }
     
     void bindTexture(int pIndex)
     {
     glBindTexture(GL_TEXTURE_2D, pIndex);
     }
     
     */
    
    
    class var sharedInstance: Graphics
    {
        struct Static {
            static var cTokenOnce: dispatch_once_t = 0
            static var cInstance: Graphics? = nil
        }
        dispatch_once(&Static.cTokenOnce){Static.cInstance = Graphics()}
        return Static.cInstance!
    }
    
}


let gG:Graphics = Graphics.sharedInstance



