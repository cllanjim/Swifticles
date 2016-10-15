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



//typealias ShaderAttribute = GLint
//typealias ShaderUniform = GLint

//enum Program: UInt32 { case simple = 0, mesh = 1, sprite = 2 }
//let ShaderProgramCount = 2

//enum ShaderProgram: UInt32 { case tcmesh = 0, shape = 1 }

class Graphics {
    
    /*
     private enum Program: UInt32 { case simple = 0, mesh = 1, sprite = 2 }
     
     private enum ShaderAttr: GLint {
     case positionArray = 0,
     textureCoordArray = 1,
     colorArray = 2,
     normalArray = 3,
     projectionMatrix = 4,
     modelViewMatrix = 5,
     colorModulate = 6,
     texture = 7
     }
     
     var selectedShaderProgramSlot: GLuint
     private var selectedShaderProgram: Program = .simpl
     */
    
    
    //var slotUniformProjection:GLint = 0
    //var slotUniformModelView:GLint = 0
    //var slotUniformTexture:GLint = 0
    //var slotUniformColorModulate:GLint = 0
    //var slotAttrPositionArray:GLint = 0
    //var slotAttrTexCoordArray:GLint = 0
    //var slotAttrColorArray:GLint = 0
    //var slotAttrNormalArray:GLint = 0
    
    //private var _projectionMatrix = Matrix()
    //private var _modelViewMatrix = Matrix()
    
    
    
    //static let shared = Graphics()
    //private init() { }
    
    
    //Expects external engine to have set up
    //the uniforms, slotAttrPositionArray etc.
    
    //Interesting note - we ALWAYS are using textures,
    //no matter WHAT!!!
    
    //TODO: Can we switch textured drawing on and off using shader?!?!
    //TODO: Load 2 programs, one for textured drawing, one for colored shape drawing..
    //(Lower priority than finishing the app...)
    class func create() {
        
        ShaderProgramMesh.shared.load()
        //ShaderProgramSimple.shared.load()
        //ShaderProgramSprite.shared.load()
        
        
        Graphics.textureEnable()
        
        
    }
    
    class func dispose() {
        
        ShaderProgramMesh.shared.dispose()
        ShaderProgramSimple.shared.dispose()
        ShaderProgramSprite.shared.dispose()
    }
    
    class func clear() {
        //Graphics.
        clear(r: 0.0, g: 0.0, b: 0.0)
    }
    
    class func clear(r:GLfloat, g:GLfloat, b:GLfloat) {
        glClearColor(r, g, b, 1.0);
        glClear(GLenum(GL_COLOR_BUFFER_BIT))
    }
    
    
    
    class func blendEnable() {
        glEnable(GLenum(GL_BLEND))
    }
    
    class func blendDisable() {
        glDisable(GLenum(GL_BLEND))
    }
    
    class func blendSetAlpha() {
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
    }
    
    class func blendSetAdditive() {
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE))
    }
    
    class func blendSetPremultiplied()
    {
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
    }
    
    class func cullFacesEnable() {
        glEnable(GLenum(GL_CULL_FACE))
    }
    
    class func cullFacesDisable() {
        glDisable(GLenum(GL_CULL_FACE))
    }
    
    class func cullFacesSetFront() {
        glCullFace(GLenum(GL_FRONT))
    }
    
    class func cullFacesSetBack() {
        glCullFace(GLenum(GL_BACK))
    }
    
    class func bufferVertexGenerate(data:inout [GLfloat], size:Int) -> BufferIndex {
        let result:BufferIndex = Graphics.bufferGenerate()
        bufferVertexSetData(bufferIndex:result, data: &data, size: size)
        return result
    }
    
    class func bufferGenerate() -> BufferIndex {
        var result = GLuint()
        glGenBuffers(1, &result)
        return BufferIndex(result)
    }
    
    class func bufferDelete(bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            var index = GLuint(checkIndex)
            glDeleteBuffers(1, &index)
        }
    }
    
    class func bufferVertexSetData(bufferIndex:BufferIndex?, data:inout [GLfloat], size:Int) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), GLuint(checkIndex))
            glBufferData(GLenum(GL_ARRAY_BUFFER), size * MemoryLayout<GLfloat>.size, &data, GLenum(GL_STATIC_DRAW))
        }
    }
    
    class func bufferIndexGenerate(data:inout [IndexBufferType], size:Int) -> BufferIndex {
        let result = bufferGenerate()
        bufferIndexSetData(bufferIndex:result, data: &data, size: size)
        return result
    }
    
    class func bufferIndexSetData(bufferIndex:BufferIndex?, data:inout [IndexBufferType], size:Int) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLuint(checkIndex))
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), size * MemoryLayout<UInt32>.size, &data, GLenum(GL_STATIC_DRAW))
        }
    }
    
    class func bufferVertexBind(_ bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), GLuint(checkIndex))
        }
    }
    
    class func bufferIndexBind(_ bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLuint(checkIndex))
        }
    }
    
    class func drawElementsTriangle(count:Int, offset:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 1))
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(count), GLenum(GL_UNSIGNED_SHORT), ptr)
    }
    
    class func drawTriangleList(count:Int, offset:Int) {
        glDrawArrays(GLenum(GL_TRIANGLES), GLint(offset), GLint(count))
    }
    
    class func drawTriangleStrip(count:Int, offset:Int) {
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), GLint(offset), GLint(count))
    }
    
    /*
    func matrixProjectionGet() -> Matrix {
        let result = Matrix()
        result.set(_projectionMatrix)
        return result
        
    }
    
    func matrixModelViewGet() -> Matrix {
        let result = Matrix()
        result.set(_modelViewMatrix)
        return result
    }
    
    func matrixProjectionSet(_ mat:Matrix) {
        _projectionMatrix.set(mat)
        glUniformMatrix4fv(slotUniformProjection, 1, 0, _projectionMatrix.m)
    }
    
    func matrixModelViewSet(_ mat:Matrix) {
        _modelViewMatrix.set(mat)
        glUniformMatrix4fv(slotUniformModelView, 1, 0, _modelViewMatrix.m)
    }
    
    func matrixProjectionReset() {
        matrixProjectionSet(Matrix())
    }
    
    func matrixModelViewReset() {
        matrixModelViewSet(Matrix())
    }
    */
    
    class func depthEnable() {
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    
    class func depthDisable() {
        glDisable(GLenum(GL_DEPTH_TEST))
    }
    
    class func depthClear() {
        glClear(GLenum(GL_DEPTH_BUFFER_BIT))
    }
    
    class func textureGenerate() -> BufferIndex {
        var result = GLuint()
        glGenTextures(1, &result)
        return BufferIndex(result);
    }
    
    class func textureGenerate(width:Int, height:Int, data:UnsafeMutableRawPointer?) -> BufferIndex? {
        if width > 0 && height > 0 && data != nil {
            let bindIndex = textureGenerate()
            textureSetData(bufferIndex: bindIndex, width: width, height: height, data: data)
            return bindIndex
        }
        return nil
    }
    
    class func textureSetData(bufferIndex:BufferIndex?, width:Int, height:Int, data:UnsafeMutableRawPointer?) {
        if let checkIndex = bufferIndex , let checkData = data, width > 0 && height > 0 {
            textureBind(bufferIndex:checkIndex)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), checkData)
        }
    }
    
    class func textureBind(texture:Texture?) {
        if let checkTexture = texture {
            if let checkIndex = checkTexture.bindIndex {
                glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(checkIndex))
            }
        }
    }
    
    class func textureBind(bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(checkIndex))
        }
    }
    
    class func textureDelete(bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            var index = GLuint(checkIndex)
            glDeleteTextures(1, &index)
        }
    }
    
    
    
    class func textureEnable() {
        glEnable(GLenum(GL_TEXTURE_2D))
        //glUniform1ui(slotUniformEnableTexture, 1)
    }
    
    class func textureDisable() {
        glDisable(GLenum(GL_TEXTURE_2D))
        
        //TEMP... JK Forever
        //textureBlankBind()
    }
    
    class func viewport(_ rect:CGRect) {
        glViewport(GLint(rect.origin.x), GLint(rect.origin.y), GLint(rect.size.width + 0.5), GLint(rect.size.height + 0.5))
    }
    
    class func clip(clipRect:CGRect) {
        glEnable(GLenum(GL_SCISSOR_TEST))
        glScissor(GLint(clipRect.origin.x), GLint(clipRect.origin.y), GLsizei(clipRect.size.width), GLsizei(clipRect.size.height))
    }
    
    class func clipDisable() {
        glDisable(GLenum(GL_SCISSOR_TEST))
    }
}

//let gG:Graphics = Graphics()
