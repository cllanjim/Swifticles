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

/*
extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}
*/

class Graphics {
    
    private var cTestProjectionMatrix = [Float]()
    private var cTestModelViewMatrix = [Float]()
    
    private var cProjectionMatrix = Matrix()
    private var cModelViewMatrix = Matrix()
    
    private var cWhiteSprite: Sprite = Sprite()
    
    // x y z u v w r g b a (10) * 4 = 40
    private var cRectVertexBuffer = [GLfloat](count:40, repeatedValue: 0.0)
    private var cRectIndexBuffer = [IndexBufferType](count: 6, repeatedValue: 0)
    
    private var cRectVertexBufferSlot:BufferIndex?
    private var cRectIndexBufferSlot:BufferIndex?
    
    init() {
        print("Graphics.init()")
    }
    
    //Expects external engine to have set up
    //the uniforms, gGLSlotPosition etc.
    
    //Interesting note - we ALWAYS are using textures,
    //no matter WHAT!!!
    func create() {
        
        print("Graphics.create()")
        
        cWhiteSprite.load(path: "white_square")
        
        cRectVertexBuffer = [-128.0, -128.0, 0.0,    0.0, 0.0, 0.0,    1.0, 1.0, 1.0, 1.0,
                              128.0, -128.0, 0.0,    1.0, 0.0, 0.0,    1.0, 1.0, 1.0, 1.0,
                             -128.0,  128.0, 0.0,    0.0, 1.0, 0.0,    1.0, 1.0, 1.0, 1.0,
                              128.0,  128.0, 0.0,    1.0, 1.0, 0.0,    1.0, 1.0, 1.0, 1.0]
        cRectIndexBuffer = [0, 2, 1, 1, 2, 3]
        
        cRectVertexBufferSlot = bufferVertexGenerate(data: cRectVertexBuffer, size: 40)
        cRectIndexBufferSlot = bufferIndexGenerate(data: cRectIndexBuffer, size: 6)
        
        textureEnable()
        
        matrixModelViewSet(Matrix())
        matrixProjectionSet(Matrix())
        
        //cRectVertexBuffer.forEach() { value in
        //    print("Float = \(value)")
        //}
        
    }
    
    func dispose() {
        
        print("Graphics.dispose()")
        
        cWhiteSprite.clear()
        
        bufferDelete(bufferIndex: cRectVertexBufferSlot)
        cRectVertexBufferSlot = nil
        
        bufferDelete(bufferIndex: cRectIndexBufferSlot)
        cRectIndexBufferSlot = nil
    }
    
    func quadDraw(x1 x1:GLfloat, y1:GLfloat, x2:GLfloat, y2:GLfloat, x3:GLfloat, y3:GLfloat, x4:GLfloat, y4:GLfloat) {
        
        cRectVertexBuffer[0] = x1
        cRectVertexBuffer[1] = y1
        cRectVertexBuffer[10] = x2
        cRectVertexBuffer[11] = y2
        cRectVertexBuffer[20] = x3
        cRectVertexBuffer[21] = y3
        cRectVertexBuffer[30] = x4
        cRectVertexBuffer[31] = y4
        
        textureBind(bufferIndex: cWhiteSprite.texture?.bindIndex)
        
        bufferIndexBind(cRectIndexBufferSlot)
        bufferVertexSetData(bufferIndex: cRectVertexBufferSlot, data: cRectVertexBuffer, size: 40)
        
        positionEnable()
        positionSetPointer(size: 3, offset: 0, stride: 10)
        
        texCoordEnable()
        textureCoordSetPointer(size: 3, offset: 3, stride: 10)
        
        colorArrayEnable()
        colorArraySetPointer(size: 4, offset: 6, stride: 10)
        
        drawElementsTriangle(count:6, offset: 0)
    }
    
    func rectDraw(rect:CGRect) {
        rectDraw(x: GLfloat(rect.origin.x), y: GLfloat(rect.origin.y), width: GLfloat(rect.size.width), height: GLfloat(rect.size.height))
    }
    
    func rectDraw(x x:GLfloat, y:GLfloat, width:GLfloat, height:GLfloat) {
        quadDraw(x1: x, y1: y, x2: x+width, y2: y, x3: x, y3: y+height, x4: x+width, y4: y+height)
    }
    
    func pointDraw(point point:CGPoint) {
        pointDraw(point: point, size: 8.0)
    }
    
    func pointDraw(point point:CGPoint, size: GLfloat) {
        rectDraw(x: GLfloat(point.x - CGFloat(size / 2.0)), y: GLfloat(point.y - CGFloat(size / 2.0)), width: size, height: size)
    }
    
    func lineDraw(p1 p1:CGPoint, p2:CGPoint, thickness:CGFloat) {
        
        var diff = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
        
        var dist = diff.x * diff.x + diff.y * diff.y
        
        if dist > 0.01 {
            
            
            dist = sqrt(dist)
            
            diff.x = (diff.x / dist) * thickness
            diff.y = (diff.y / dist) * thickness
            
            let holdX = diff.x
            diff.x = -diff.y
            diff.y = holdX
            
            quadDraw(x1: GLfloat(p1.x-diff.x), y1: GLfloat(p1.y-diff.y), x2: GLfloat(p1.x+diff.x), y2: GLfloat(p1.y+diff.y),
                     x3: GLfloat(p2.x-diff.x), y3: GLfloat(p2.y-diff.y), x4: GLfloat(p2.x+diff.x), y4: GLfloat(p2.y+diff.y))
            
            
        }
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
        glUniform4f(gGLUniformColorModulate, r, g, b, a)
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
    
    func colorArrayEnable() {
        glEnableVertexAttribArray(GLuint(gGLSlotColor))
    }
    
    func colorArrayDisable() {
        glDisableVertexAttribArray(GLuint(gGLSlotColor))
    }
    
    func blendEnable() {
        glEnable(GLenum(GL_BLEND))
    }
    
    func blendDisable() {
        glDisable(GLenum(GL_BLEND))
    }
    
    func blendSetAlpha() {
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
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
        return result
    }
    
    func bufferGenerate() -> BufferIndex {
        var result = GLuint()
        glGenBuffers(1, &result)
        return BufferIndex(result)
    }
    
    func bufferDelete(bufferIndex bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            var index = GLuint(checkIndex)
            glDeleteBuffers(1, &index)
        }
    }
    
    func bufferVertexSetData(bufferIndex bufferIndex:BufferIndex?, data:[GLfloat], size:Int) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), GLuint(checkIndex))
            glBufferData(GLenum(GL_ARRAY_BUFFER), size * sizeof(GLfloat), data, GLenum(GL_STATIC_DRAW))
        }
    }
    
    func bufferIndexGenerate(data data:[IndexBufferType], size:Int) -> BufferIndex {
        let result = bufferGenerate()
        bufferIndexSetData(bufferIndex:result, data: data, size: size)
        return result
    }
    
    func bufferIndexSetData(bufferIndex bufferIndex:BufferIndex?, data:[IndexBufferType], size:Int) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLuint(checkIndex))
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), size * sizeof(UInt32), data, GLenum(GL_STATIC_DRAW))
        }
    }
    
    func bufferVertexBind(bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), GLuint(checkIndex))
        }
    }
    
    func bufferIndexBind(bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLuint(checkIndex))
        }
    }
    
    func positionSetPointer(size size:Int, offset:Int, stride:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(gGLSlotPosition), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func textureCoordSetPointer(size size:Int, offset:Int, stride:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(gGLSlotTexCoord), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func colorArraySetPointer(size size:Int, offset:Int, stride:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(gGLSlotColor), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func drawElementsTriangle(count count:Int, offset:Int) {
        let ptr = UnsafePointer<Void>(bitPattern: (offset << 1))
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(count), GLenum(GL_UNSIGNED_SHORT), ptr)
    }
    
    func drawTriangleList(count count:Int, offset:Int) {
        glDrawArrays(GLenum(GL_TRIANGLES), GLint(offset), GLint(count))
    }
    
    func drawTriangleStrip(count count:Int, offset:Int) {
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), GLint(offset), GLint(count))
    }
    
    func matrixProjectionGet() -> Matrix {
        return cProjectionMatrix
    }
    
    func matrixModelViewGet() -> Matrix {
        return cModelViewMatrix
    }
    
    func matrixProjectionSet(mat:Matrix) {
        cProjectionMatrix.set(mat)
        glUniformMatrix4fv(gGLUniformProjection, 1, 0, cProjectionMatrix.m)
    }
    
    func matrixModelViewSet(mat:Matrix) {
        cModelViewMatrix.set(mat)
        glUniformMatrix4fv(gGLUniformModelView, 1, 0, cModelViewMatrix.m)
    }
    
    func matrixProjectionReset() {
        matrixProjectionSet(Matrix())
    }
    
    func matrixModelViewReset() {
        matrixModelViewSet(Matrix())
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
    
    func textureGenerate(width width:Int, height:Int, data:UnsafeMutablePointer<()>) -> BufferIndex? {
        if width > 0 && height > 0 && data != nil {
            let bindIndex = textureGenerate()
            textureSetData(bufferIndex: bindIndex, width: width, height: height, data: data)
            return bindIndex
        }
        return nil
    }
    
    func textureSetData(bufferIndex bufferIndex:BufferIndex?, width:Int, height:Int, data:UnsafeMutablePointer<()>) {
        if let checkIndex = bufferIndex where width > 0 && height > 0 && data != nil {
            textureBind(bufferIndex:checkIndex)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height),
                         0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), UnsafePointer(data))
        }
    }
    
    func textureBind(texture texture:Texture?) {
        if let checkTexture = texture {
            if let checkIndex = checkTexture.bindIndex {
                glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(checkIndex))
            }
        }
    }
    
    func textureBind(bufferIndex bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(checkIndex))
        }
    }
    
    func textureDelete(bufferIndex bufferIndex:BufferIndex?) {
        if let checkIndex = bufferIndex {
            var index = GLuint(checkIndex)
            glDeleteTextures(1, &index)
        }
    }
    
    func textureBlankBind() -> Void {
        textureBind(texture: textureBlank())
    }
    
    func textureBlank() -> Texture? {
        return cWhiteSprite.texture
    }
    
    func textureEnable() {
        glEnable(GLenum(GL_TEXTURE_2D))
    }
    
    func textureDisable() {
        glDisable(GLenum(GL_TEXTURE_2D))
    }
    
    func viewport(rect:CGRect) {
        glViewport(GLint(rect.origin.x), GLint(rect.origin.y), GLint(rect.size.width + 0.5), GLint(rect.size.height + 0.5))
    }
    //
    
    
    
    
    //static float cClipPlane[4][4] = {{0.0f, 1.0f, 0.0f, 0.0f}, {1.0f, 0.0f, 0.0f, 0.0f}, {-1.0f, 0.0f, 0.0f, 512.0f}, {0.0f, -1.0f, 0.0f, 512.0f}};
    
    
    
    //void Graphics::Clip(float pX, float pY, float pWidth, float pHeight)
    //{
    /*
     if(cClipStackCount > 0)
     {
     float aParentX = cClipStack[cClipStackCount - 1][0];
     float aParentY = cClipStack[cClipStackCount - 1][1];
     float aParentWidth = cClipStack[cClipStackCount - 1][2];
     float aParentHeight = cClipStack[cClipStackCount - 1][3];
     float aParentRight = aParentX + aParentWidth;
     float aParentBottom = aParentY + aParentHeight;
     
     //Log("ClipParent[%d] = [%f %f %f %f]\n", cClipStackCount, aParentX, aParentY, aParentWidth, aParentHeight);
     
     if(pX < aParentX)pX = aParentX;
     if(pY < aParentY)pY = aParentY;
     
     if((pX + pWidth) > aParentRight)
     {
     pWidth = (aParentRight - pX);
     }
     
     if((pY + pHeight) > aParentBottom)
     {
     pHeight = (aParentBottom - pY);
     }
     }
     */
    
    var cClipPlane0 = [GLfloat](count:4, repeatedValue: 0.0)
    var cClipPlane1 = [GLfloat](count:4, repeatedValue: 0.0)
    var cClipPlane2 = [GLfloat](count:4, repeatedValue: 0.0)
    var cClipPlane3 = [GLfloat](count:4, repeatedValue: 0.0)
    
    
    func clip(clipRect clipRect:CGRect) {
        
        glEnable(GLenum(GL_SCISSOR_TEST))
        glScissor(GLint(clipRect.origin.x), GLint(clipRect.origin.y), GLsizei(clipRect.size.width), GLsizei(clipRect.size.height))
        
        /*
    
        //GLfloat planeTop[]    = {0.0f, -1.0f, 0.0f, viewRect.origin.y + viewSize.height * s};
        //GLfloat planeBottom[] = {0.0f, 1.0f, 0.0f, -viewRect.origin.y};
        //GLfloat planeLeft[]   = {1.0f, 0.0f, 0.0f, -viewRect.origin.x};
        //GLfloat planeRight[]  = {-1.0f, 0.0f, 0.0f, viewRect.origin.x + viewSize.width * s};
        
        glEnable(GLenum(GL_CLIP_PLANE0))
        glEnable(GLenum(GL_CLIP_PLANE1))
        glEnable(GLenum(GL_CLIP_PLANE2))
        glEnable(GLenum(GL_CLIP_PLANE3))
        
        
        //GLfloat planeTop[]    = {
        cClipPlane0[0] = 0.0
        cClipPlane0[1] = -1.0
        cClipPlane0[2] = 0.0
        cClipPlane0[3] = GLfloat(clipRect.origin.y + clipRect.size.height)
    
        
        //GLfloat planeBottom[] = {
        cClipPlane1[0] = 0.0
        cClipPlane1[1] = 1.0
        cClipPlane1[2] = 0.0
        cClipPlane1[3] = GLfloat(-clipRect.origin.y)
    
    //GLfloat planeLeft[]   = {
        cClipPlane2[0] = 1.0
        cClipPlane2[1] = 0.0
        cClipPlane2[2] = 0.0
        cClipPlane2[3] = GLfloat(-clipRect.origin.x)
        
        
        //GLfloat planeRight[]  = {
        cClipPlane3[0] = -1.0
        cClipPlane3[1] = 0.0
        cClipPlane3[2] = 0.0
        cClipPlane3[3] = GLfloat(clipRect.origin.x + clipRect.size.width)

        glClipPlanef(GLenum(GL_CLIP_PLANE0), cClipPlane0);
        glClipPlanef(GLenum(GL_CLIP_PLANE1), cClipPlane1);
        glClipPlanef(GLenum(GL_CLIP_PLANE2), cClipPlane2);
        glClipPlanef(GLenum(GL_CLIP_PLANE3), cClipPlane3);
        */
    }
    
    func clipDisable() {
        
        glDisable(GLenum(GL_SCISSOR_TEST))
        
        /*
        glDisable(GLenum(GL_CLIP_PLANE0))
        glDisable(GLenum(GL_CLIP_PLANE1))
        glDisable(GLenum(GL_CLIP_PLANE2))
        glDisable(GLenum(GL_CLIP_PLANE3))
        */
    }
    
    
    /*
    void Graphics::ClipAbsolute(float pX, float pY, float pWidth, float pHeight)
    {
    //glScissor(pX, gDeviceScreenHeight - (pY + pHeight), pWidth, pHeight);
    
    //cClipRect[0] = pX;
    //cClipRect[1] = pY;
    //cClipRect[2] = pWidth;
    //cClipRect[3] = pHeight;
    
    cClipPlane[0][0] = 0.0f;
    cClipPlane[0][1] = 1.0f;
    cClipPlane[0][2] = 0.0f;
    cClipPlane[0][3] = 0.0f;
    
    cClipPlane[1][0] = 1.0f;
    cClipPlane[1][1] = 0.0f;
    cClipPlane[1][2] = 0.0f;
    cClipPlane[1][3] = 0.0f;
    
    cClipPlane[2][0] = -1.0f;
    cClipPlane[2][1] = 0.0f;
    cClipPlane[2][2] = 0.0f;
    cClipPlane[2][3] = pWidth;
    
    cClipPlane[3][0] = 0.0f;
    cClipPlane[3][1] = -1.0f;
    cClipPlane[3][2] = 0.0f;
    cClipPlane[3][3] = pHeight;
    
    glClipPlanef(GL_CLIP_PLANE0, cClipPlane[0]);
    glClipPlanef(GL_CLIP_PLANE1, cClipPlane[1]);
    glClipPlanef(GL_CLIP_PLANE2, cClipPlane[2]);
    glClipPlanef(GL_CLIP_PLANE3, cClipPlane[3]);
    }
    */
    
}

let gG:Graphics = Graphics()
