//
//  DrawTriangleBuffer.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//


import UIKit

class DrawTriangleBuffer {
    
    private(set) var count = 0
    
    private var t = [DrawTriangle]()
    //private var i = [IndexBufferType]()
    
    private var vertexBuffer = [GLfloat]()// = [GLfloat](count:16, repeatedValue: 0.0)
    //private var indexBuffer = [IndexBufferType]()// = [IndexBufferType](count: 6, repeatedValue: 0)
    
    private var vertexBufferSlot:BufferIndex?
    //private var indexBufferSlot:BufferIndex?
    
    init() {
        
    }
    
    deinit {
        print("DrawTriangleBuffer.deinit()")
    }
    
    func reset() {
        count = 0
        //t.removeAll(keepCapacity: true)
        //vertexBuffer.removeAll(keepCapacity: true)
        
        
    }
    
    func draw(texture texture:Texture?) {
        
        if vertexBufferSlot == nil{
            vertexBufferSlot = gG.bufferGenerate()
        }
        
        //if indexBufferSlot == nil{
        //    indexBufferSlot = gG.bufferGenerate()
        //}
        
        if vertexBufferSlot != nil && vertexBufferSlot != nil {
            
            gG.bufferVertexBind(vertexBufferSlot)
            //gG.bufferIndexBind(indexBufferSlot)
            
            gG.positionEnable()
            gG.texCoordEnable()
            gG.colorArrayEnable()
            
            for index in 0..<count {
            
                
                //var tri = t[index]
                
                //vertexBuffer = tri.buffer //tri.buffer
                //indexBuffer = [0, 2, 1, 1, 2, 3]
                
                //gG.rectDraw(x: Float(tri.x1 - 7), y: Float(tri.y1 - 2), width: 15, height: 15)
                //gG.rectDraw(x: Float(tri.x2 - 7), y: Float(tri.y2 - 2), width: 15, height: 15)
                //gG.rectDraw(x: Float(tri.x3 - 7), y: Float(tri.y3 - 2), width: 15, height: 15)
                
                if let checkTexture = texture {
                    gG.textureEnable()
                    gG.textureBind(texture: checkTexture)
                } else {
                    gG.textureDisable()
                }
                
                gG.bufferVertexSetData(bufferIndex: vertexBufferSlot, data: t[index].buffer, size: 30)
                
                gG.positionSetPointer(size: 3, offset: 0, stride: 10)
                gG.textureCoordSetPointer(size: 3, offset: 3, stride: 10)
                gG.colorArraySetPointer(size: 4, offset: 6, stride: 10)
                
                gG.drawTriangleList(count: 3, offset: 0)
                
            } 
        }
    }
    
    func add(triangle triangle:DrawTriangle) {
        set(index: count, triangle: triangle)
    }
    
    func set(index index:Int, triangle:DrawTriangle) {
        
        if index < 0 {
            return
        }
        
        if index >= count {
            count = index + 1
            
            let newCapacity = count * 40
            if newCapacity > vertexBuffer.capacity {
                print("vbuffer count \(vertexBuffer.count) cap \(vertexBuffer.capacity) newCap \(newCapacity) adjust \(newCapacity + newCapacity / 2 + 1)")
                vertexBuffer.reserveCapacity(newCapacity + newCapacity / 2 + 1)
            }
        }
        
        if index >= t.count {
            while index >= t.count {
                t.append(DrawTriangle())
            }
        }
        t[index].set(triangle: triangle)
    }
}


