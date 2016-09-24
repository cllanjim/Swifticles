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
    
    
    var slotUniformProjection:GLint = 0
    var slotUniformModelView:GLint = 0
    var slotUniformTexture:GLint = 0
    var slotUniformColorModulate:GLint = 0
    var slotSlotPosition:GLint = 0
    var slotSlotTexCoord:GLint = 0
    var slotSlotColor:GLint = 0
    var slotSlotNormal:GLint = 0
    
    private var cProjectionMatrix = Matrix()
    private var cModelViewMatrix = Matrix()
    
    private var cWhiteSprite: Sprite = Sprite()
    
    // x y z u v w r g b a (10) * 4 = 40
    var cRectVertexBuffer = [GLfloat](repeating: 1.0, count: 40)
    var cRectIndexBuffer = [IndexBufferType](repeating: 0, count: 6)
    
    private var cRectVertexBufferSlot:BufferIndex?
    private var cRectIndexBufferSlot:BufferIndex?
    
    static let shared = Graphics()
    private init() { }
    
    //Expects external engine to have set up
    //the uniforms, slotSlotPosition etc.
    
    //Interesting note - we ALWAYS are using textures,
    //no matter WHAT!!!
    
    //TODO: Can we switch textured drawing on and off using shader?!?!
    //TODO: Load 2 programs, one for textured drawing, one for colored shape drawing..
    //(Lower priority than finishing the app...)
    func create() {
        cWhiteSprite.load(path: "white_square")
        
        cRectVertexBuffer[ 0] = -128.0
        cRectVertexBuffer[ 1] = -128.0
        cRectVertexBuffer[ 2] = 0.0
        cRectVertexBuffer[ 3] = 0.0
        cRectVertexBuffer[ 4] = 0.0
        cRectVertexBuffer[ 5] = 0.0
        
        cRectVertexBuffer[10] = 128.0
        cRectVertexBuffer[11] = -128.0
        cRectVertexBuffer[12] = 0.0
        cRectVertexBuffer[13] = 1.0
        cRectVertexBuffer[14] = 0.0
        cRectVertexBuffer[15] = 0.0
        
        cRectVertexBuffer[20] = -128.0
        cRectVertexBuffer[21] = 128.0
        cRectVertexBuffer[22] = 0.0
        cRectVertexBuffer[23] = 0.0
        cRectVertexBuffer[24] = 1.0
        cRectVertexBuffer[25] = 0.0
        
        cRectVertexBuffer[30] = 128.0
        cRectVertexBuffer[31] = 128.0
        cRectVertexBuffer[32] = 0.0
        cRectVertexBuffer[33] = 1.0
        cRectVertexBuffer[34] = 1.0
        cRectVertexBuffer[35] = 0.0
        
        cRectIndexBuffer[0] = 0
        cRectIndexBuffer[1] = 2
        cRectIndexBuffer[2] = 1
        cRectIndexBuffer[3] = 1
        cRectIndexBuffer[4] = 2
        cRectIndexBuffer[5] = 3
        
        cRectVertexBufferSlot = Graphics.bufferVertexGenerate(data: &cRectVertexBuffer, size: 40)
        cRectIndexBufferSlot = Graphics.bufferIndexGenerate(data: &cRectIndexBuffer, size: 6)
        
        Graphics.textureEnable()
        
        matrixModelViewSet(Matrix())
        matrixProjectionSet(Matrix())
    }
    
    func dispose() {
        cWhiteSprite.clear()
        
        Graphics.bufferDelete(bufferIndex: cRectVertexBufferSlot)
        cRectVertexBufferSlot = nil
        
        Graphics.bufferDelete(bufferIndex: cRectIndexBufferSlot)
        cRectIndexBufferSlot = nil
    }
    
    //Why is this slower than balls? (iPad Air)
    func quadDraw(x1:GLfloat, y1:GLfloat, x2:GLfloat, y2:GLfloat, x3:GLfloat, y3:GLfloat, x4:GLfloat, y4:GLfloat) {
        cRectVertexBuffer[0] = x1
        cRectVertexBuffer[1] = y1
        cRectVertexBuffer[10] = x2
        cRectVertexBuffer[11] = y2
        cRectVertexBuffer[20] = x3
        cRectVertexBuffer[21] = y3
        cRectVertexBuffer[30] = x4
        cRectVertexBuffer[31] = y4
        
        Graphics.textureBind(bufferIndex: cWhiteSprite.texture?.bindIndex)
        
        Graphics.bufferIndexBind(cRectIndexBufferSlot)
        Graphics.bufferVertexSetData(bufferIndex: cRectVertexBufferSlot, data: &cRectVertexBuffer, size: 40)
        
        positionEnable()
        positionSetPointer(size: 3, offset: 0, stride: 10)
        
        texCoordEnable()
        textureCoordSetPointer(size: 3, offset: 3, stride: 10)
        
        colorArrayEnable()
        colorArraySetPointer(size: 4, offset: 6, stride: 10)
        
        Graphics.drawElementsTriangle(count:6, offset: 0)
    }
    
    func rectDraw(_ rect:CGRect) {
        rectDraw(x: GLfloat(rect.origin.x), y: GLfloat(rect.origin.y), width: GLfloat(rect.size.width), height: GLfloat(rect.size.height))
    }
    
    func rectDraw(x:GLfloat, y:GLfloat, width:GLfloat, height:GLfloat) {
        quadDraw(x1: x, y1: y, x2: x+width, y2: y, x3: x, y3: y+height, x4: x+width, y4: y+height)
    }
    
    func pointDraw(point:CGPoint) {
        pointDraw(point: point, size: 8.0)
    }
    
    func pointDraw(point:CGPoint, size: GLfloat) {
        rectDraw(x: GLfloat(point.x - CGFloat(size / 2.0)), y: GLfloat(point.y - CGFloat(size / 2.0)), width: size, height: size)
    }
    
    func triangleDraw(_ triangle:DrawTriangle) {
        cRectVertexBuffer[ 0] = GLfloat(triangle.x1)
        cRectVertexBuffer[ 1] = GLfloat(triangle.y1)
        cRectVertexBuffer[ 2] = GLfloat(triangle.z1)
        cRectVertexBuffer[ 3] = GLfloat(triangle.u1)
        cRectVertexBuffer[ 4] = GLfloat(triangle.v1)
        cRectVertexBuffer[ 5] = GLfloat(triangle.w1)
        cRectVertexBuffer[ 6] = GLfloat(triangle.r1)
        cRectVertexBuffer[ 7] = GLfloat(triangle.g1)
        cRectVertexBuffer[ 8] = GLfloat(triangle.b1)
        cRectVertexBuffer[ 9] = GLfloat(triangle.a1)
        
        cRectVertexBuffer[10] = GLfloat(triangle.x2)
        cRectVertexBuffer[11] = GLfloat(triangle.y2)
        cRectVertexBuffer[12] = GLfloat(triangle.z2)
        cRectVertexBuffer[13] = GLfloat(triangle.u2)
        cRectVertexBuffer[14] = GLfloat(triangle.v2)
        cRectVertexBuffer[15] = GLfloat(triangle.w2)
        cRectVertexBuffer[16] = GLfloat(triangle.r2)
        cRectVertexBuffer[17] = GLfloat(triangle.g2)
        cRectVertexBuffer[18] = GLfloat(triangle.b2)
        cRectVertexBuffer[19] = GLfloat(triangle.a2)
        
        cRectVertexBuffer[20] = GLfloat(triangle.x3)
        cRectVertexBuffer[21] = GLfloat(triangle.y3)
        cRectVertexBuffer[22] = GLfloat(triangle.z3)
        cRectVertexBuffer[23] = GLfloat(triangle.u3)
        cRectVertexBuffer[24] = GLfloat(triangle.v3)
        cRectVertexBuffer[25] = GLfloat(triangle.w3)
        cRectVertexBuffer[26] = GLfloat(triangle.r3)
        cRectVertexBuffer[27] = GLfloat(triangle.g3)
        cRectVertexBuffer[28] = GLfloat(triangle.b3)
        cRectVertexBuffer[29] = GLfloat(triangle.a3)
        
        Graphics.bufferVertexSetData(bufferIndex: cRectVertexBufferSlot, data: &cRectVertexBuffer, size: 30)
        
        positionEnable()
        positionSetPointer(size: 3, offset: 0, stride: 10)
        
        texCoordEnable()
        textureCoordSetPointer(size: 3, offset: 3, stride: 10)
        
        colorArrayEnable()
        colorArraySetPointer(size: 4, offset: 6, stride: 10)
        
        Graphics.drawTriangleList(count: 3, offset: 0)
    }
    
    func lineDraw(p1:CGPoint, p2:CGPoint, thickness:CGFloat) {
        var diff = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
        var dist = diff.x * diff.x + diff.y * diff.y
        if dist > 0.01 {
            dist = sqrt(dist)
            diff.x = (diff.x / dist) * thickness
            diff.y = (diff.y / dist) * thickness
            //flop vector to norm.
            let holdX = diff.x
            diff.x = -diff.y
            diff.y = holdX
            //draw a long quad.
            quadDraw(x1: GLfloat(p1.x-diff.x), y1: GLfloat(p1.y-diff.y), x2: GLfloat(p1.x+diff.x), y2: GLfloat(p1.y+diff.y),
                     x3: GLfloat(p2.x-diff.x), y3: GLfloat(p2.y-diff.y), x4: GLfloat(p2.x+diff.x), y4: GLfloat(p2.y+diff.y))
        }
    }
    
    func colorSet() {
        colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
    }
    
    func colorSet(a:GLfloat) {
        colorSet(r: 1.0, g: 1.0, b: 1.0, a: a)
    }
    
    func colorSet(r:GLfloat, g:GLfloat, b:GLfloat) {
        colorSet(r: r, g: g, b: b, a: 1.0)
    }
    
    func colorSet(r:GLfloat, g:GLfloat, b:GLfloat, a:GLfloat) {
        //glUniform4f(slotUniformColorModulate, r, g, b, a)
        
        cRectVertexBuffer[6] = r
        cRectVertexBuffer[16] = r
        cRectVertexBuffer[26] = r
        cRectVertexBuffer[36] = r
        
        cRectVertexBuffer[7] = g
        cRectVertexBuffer[17] = g
        cRectVertexBuffer[27] = g
        cRectVertexBuffer[37] = g
        
        cRectVertexBuffer[8] = b
        cRectVertexBuffer[18] = b
        cRectVertexBuffer[28] = b
        cRectVertexBuffer[38] = b
        
        cRectVertexBuffer[9] = b
        cRectVertexBuffer[19] = b
        cRectVertexBuffer[29] = b
        cRectVertexBuffer[39] = b
    }
    
    func colorSet(color:UIColor) {
        var r: CGFloat = 0.0;var g: CGFloat = 0.0;var b: CGFloat = 0.0;var a: CGFloat = 0.0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            colorSet(r: GLfloat(r), g: GLfloat(g), b: GLfloat(b), a: GLfloat(a))
        }
    }
    
    class func clear() {
        //Graphics.
        clear(r: 0.0, g: 0.0, b: 0.0)
    }
    
    class func clear(r:GLfloat, g:GLfloat, b:GLfloat) {
        glClearColor(r, g, b, 1.0);
        glClear(GLenum(GL_COLOR_BUFFER_BIT))
    }
    
    func positionEnable() {
        glEnableVertexAttribArray(GLuint(slotSlotPosition))
    }
    
    func positionDisable() {
        glDisableVertexAttribArray(GLuint(slotSlotPosition))
    }
    
    func texCoordEnable() {
        glEnableVertexAttribArray(GLuint(slotSlotTexCoord))
    }
    
    func texCoordDisable() {
        glDisableVertexAttribArray(GLuint(slotSlotTexCoord))
    }
    
    func colorArrayEnable() {
        glEnableVertexAttribArray(GLuint(slotSlotColor))
    }
    
    func colorArrayDisable() {
        glDisableVertexAttribArray(GLuint(slotSlotColor))
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
    
    func positionSetPointer(size:Int, offset:Int, stride:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(slotSlotPosition), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func textureCoordSetPointer(size:Int, offset:Int, stride:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(slotSlotTexCoord), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func colorArraySetPointer(size:Int, offset:Int, stride:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(slotSlotColor), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
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
    
    func matrixProjectionGet() -> Matrix {
        let result = Matrix()
        result.set(cProjectionMatrix)
        return result
    }
    
    func matrixModelViewGet() -> Matrix {
        return cModelViewMatrix
    }
    
    func matrixProjectionSet(_ mat:Matrix) {
        cProjectionMatrix.set(mat)
        glUniformMatrix4fv(slotUniformProjection, 1, 0, cProjectionMatrix.m)
    }
    
    func matrixModelViewSet(_ mat:Matrix) {
        cModelViewMatrix.set(mat)
        glUniformMatrix4fv(slotUniformModelView, 1, 0, cModelViewMatrix.m)
    }
    
    func matrixProjectionReset() {
        matrixProjectionSet(Matrix())
    }
    
    func matrixModelViewReset() {
        matrixModelViewSet(Matrix())
    }
    
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
    
    func textureBlankBind() -> Void {
        Graphics.textureBind(texture: textureBlank())
    }
    
    func textureBlank() -> Texture? {
        return cWhiteSprite.texture
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
