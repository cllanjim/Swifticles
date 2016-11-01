//
//  MeshShaderProgram.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

class ShaderProgramMesh : ShaderProgram
{
    static let shared = ShaderProgramMesh()
    private override init() { }
    
    
    private var cWhiteSprite: Sprite = Sprite()
    
    // x y z u v w r g b a (10) * 4 = 40
    var cRectVertexBuffer = [GLfloat](repeating: 1.0, count: 40)
    var cRectIndexBuffer = [IndexBufferType](repeating: 0, count: 6)
    
    private var cRectVertexBufferSlot:BufferIndex?
    private var cRectIndexBufferSlot:BufferIndex?
    
    
    override func load() {
        loadProgram(vertexShaderPath: "MeshVertexShader.glsl", fragmentShaderPath: "MeshFragmentShader.glsl")
        loadClean()
        
        
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
        
        matrixModelViewSet(Matrix())
        matrixProjectionSet(Matrix())
    }
    
    override func dispose() {
        super.dispose()
        
        cWhiteSprite.clear()
        
        Graphics.bufferDelete(bufferIndex: cRectVertexBufferSlot)
        cRectVertexBufferSlot = nil
        
        Graphics.bufferDelete(bufferIndex: cRectIndexBufferSlot)
        cRectIndexBufferSlot = nil
    }
    
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
    
    func pointDraw(point:CGPoint, size: CGFloat) {
        rectDraw(x: GLfloat(point.x - CGFloat(size / 2.0)), y: GLfloat(point.y - CGFloat(size / 2.0)), width: GLfloat(size), height: GLfloat(size))
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
    
    override func colorSet(r:GLfloat, g:GLfloat, b:GLfloat, a:GLfloat) {
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
        
        cRectVertexBuffer[9] = a
        cRectVertexBuffer[19] = a
        cRectVertexBuffer[29] = a
        cRectVertexBuffer[39] = a
    }
    
    func textureBlankBind() -> Void {
        Graphics.textureBind(texture: textureBlank())
    }
    
    func textureBlank() -> Texture? {
        return cWhiteSprite.texture
    }
    
}
