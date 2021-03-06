//
//  Graphics.swift
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
typealias BufferIndex = GLint

var gGLBufferDepth:GLuint = 0
var gGLBufferRender:GLuint = 0

var gGLUniformProjection:GLint = 0
var gGLUniformModelView:GLint = 0
var gGLUniformTexture:GLint = 0
var gGLUniformColorModulate:GLint = 0

var gGLSlotPosition:GLint = 0
var gGLSlotTexCoord:GLint = 0
var gGLSlotColor:GLint = 0
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
    
    private var cRectVertexBuffer:[GLfloat] = [GLfloat](count:16, repeatedValue: 0.0)
    private var cRectIndexBuffer:[IndexBufferType] = [IndexBufferType](count: 6, repeatedValue: 0)
    
    private var cRectVertexBufferSlot:BufferIndex = -1
    private var cRectIndexBufferSlot:BufferIndex = -1
    
    init() {
        print("Graphics.init()")
    }
    
    //Expects external engine to have set up
    //the uniforms, gGLSlotPosition etc.
    func create() {
        
        print("Graphics.create()")
        
        //XYUV, XYUV, XYUV, XYUV
        cRectVertexBuffer = [-128.0, -128.0, 0.0, 0.0, 128.0, -128.0,  1.0, 0.0, -128.0, 128.0,  0.0, 1.0, 128.0, 128.0,  1.0, 1.0]
        cRectIndexBuffer = [0, 2, 1, 1, 2, 3]
        
        cRectVertexBufferSlot = bufferVertexGenerate(data: cRectVertexBuffer, size: 16)
        cRectIndexBufferSlot = bufferIndexGenerate(data: cRectIndexBuffer, size: 6)
        
        
        //cRectVertexBuffer.forEach() { value in
        //    print("Float = \(value)")
        //}
        
    }
    
    func dispose() {
        
        print("Graphics.dispose()")
        
        bufferDelete(bufferIndex: cRectVertexBufferSlot)
        bufferDelete(bufferIndex: cRectIndexBufferSlot)
    }
    
    func quadDraw(x1 x1:GLfloat, y1:GLfloat, x2:GLfloat, y2:GLfloat, x3:GLfloat, y3:GLfloat, x4:GLfloat, y4:GLfloat) {
        
        cRectVertexBuffer[0] = x1
        cRectVertexBuffer[1] = y1
        cRectVertexBuffer[4] = x2
        cRectVertexBuffer[5] = y2
        cRectVertexBuffer[8] = x3
        cRectVertexBuffer[9] = y3
        cRectVertexBuffer[12] = x4
        cRectVertexBuffer[13] = y4
        
        //textureDisable()
        textureEnable()
        
        bufferIndexBind(cRectIndexBufferSlot)
        bufferVertexSetData(bufferIndex: cRectVertexBufferSlot, data: cRectVertexBuffer, size: 16)
        
        positionEnable()
        positionSetPointer(size: 2, offset: 0, stride: 4)
        
        texCoordEnable()
        textureCoordSetPointer(size: 2, offset: 2, stride: 4)
        
        drawElementsTriangle(count:6, offset: 0)
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
    
    func bufferVertexGenerate(data data:[GLfloat], size:Int) -> BufferIndex {
        let result:BufferIndex = bufferGenerate()
        bufferVertexSetData(bufferIndex:result, data: data, size: size)
        return result;
    }
    
    func bufferGenerate() -> BufferIndex {
        var result = GLuint()
        glGenBuffers(1, &result);
        return BufferIndex(result);
    }
    
    func bufferDelete(bufferIndex bufferIndex:BufferIndex) {
        if bufferIndex >= 0 {
            var index = GLuint(bufferIndex)
            glDeleteBuffers(1, &index)
        }
    }
    
    func bufferVertexSetData(bufferIndex bufferIndex:BufferIndex, data:[GLfloat], size:Int) {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), GLuint(bufferIndex))
        glBufferData(GLenum(GL_ARRAY_BUFFER), size * sizeof(GLfloat), data, GLenum(GL_STATIC_DRAW))
    }
    
    func bufferIndexGenerate(data data:[IndexBufferType], size:Int) -> BufferIndex {
        let result = bufferGenerate()
        bufferIndexSetData(bufferIndex:result, data: data, size: size);
        return result;
    }
    
    func bufferIndexSetData(bufferIndex bufferIndex:BufferIndex, data:[IndexBufferType], size:Int) {
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLuint(bufferIndex))
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), size * sizeof(UInt32), data, GLenum(GL_STATIC_DRAW))
    }
    
    func bufferVertexBind(bufferIndex:BufferIndex) {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), GLuint(bufferIndex))
    }
    
    func bufferIndexBind(bufferIndex:BufferIndex) {
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLuint(bufferIndex))
    }
    
    func positionSetPointer(size size:Int, offset:Int, stride:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(gGLSlotPosition), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func textureCoordSetPointer(size size:Int, offset:Int, stride:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(gGLSlotTexCoord), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func colorSetPointer(size size:Int, offset:Int, stride:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(gGLSlotColor), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func drawElementsTriangle(count count:Int, offset:Int)
    {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 1))
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(count), GLenum(GL_UNSIGNED_SHORT), ptr)
    }
    
    func matrixProjectionGet() -> GLKMatrix4 {
        return cProjectionMatrix
    }
    
    func matrixModelViewGet() -> GLKMatrix4 {
        return cModelViewMatrix
    }
    
    func matrixProjectionSet(mat:GLKMatrix4) {
        cProjectionMatrix = mat
        withUnsafePointer(&cProjectionMatrix) {
            glUniformMatrix4fv(gGLUniformProjection, 1, 0, UnsafePointer($0))
        }
    }
    
    func matrixModelViewSet(mat:GLKMatrix4) {
        cModelViewMatrix = mat
        withUnsafePointer(&cModelViewMatrix) {
            glUniformMatrix4fv(gGLUniformModelView, 1, 0, UnsafePointer($0))
        }
    }
    
    func matrixProjectionReset() {
        matrixProjectionSet(GLKMatrix4Identity)
    }
    
    func matrixModelViewReset() {
        matrixModelViewSet(GLKMatrix4Identity)
    }
    
    func depthEnable() {
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    
    func depthDisable() {
        glDisable(GLenum(GL_DEPTH_TEST))
    }
    
    func depthClear() {
        glClear(GLenum(GL_DEPTH_BUFFER_BIT))
    }
    
    func textureGenerate() -> BufferIndex {
        var result = GLuint()
        glGenTextures(1, &result)
        return BufferIndex(result);
    }
    
    func textureGenerate(width width:Int, height:Int, data:UnsafeMutablePointer<()>) -> BufferIndex {
        if width > 0 && height > 0 && data != nil {
            let bindIndex = textureGenerate()
            textureSetData(bindIndex, width: width, height: height, data: data)
            return bindIndex
        }
        return -1
    }
    
    func textureSetData(index:BufferIndex, width:Int, height:Int, data:UnsafeMutablePointer<()>) {
        if width > 0 && height > 0 && data != nil {
            textureBind(index)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), UnsafePointer(data))
        }
    }
    
    func textureBind(index:BufferIndex) {
        glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(index));
    }
    
    func textureDelete(index index:BufferIndex) {
        if index >= 0 {
            var uindex = GLuint(index)
            glDeleteTextures(1, &uindex)
        }
    }
    
    func textureEnable() {
        glEnable(GLenum(GL_TEXTURE_2D))
    }
    
    func textureDisable() {
        glDisable(GLenum(GL_TEXTURE_2D))
    }
}

let gG:Graphics = Graphics()
