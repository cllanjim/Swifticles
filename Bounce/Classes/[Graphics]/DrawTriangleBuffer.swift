//
//  DrawTriangleBuffer.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//


import UIKit

class DrawTriangleBuffer {
    
    var count:Int { return _count }
    internal var _count:Int = 0
    
    var data = [DrawTriangle]()
    //private var i = [IndexBufferType]()
    
    var vertexBuffer = [GLfloat]()// = [GLfloat](count:16, repeatedValue: 0.0)
    //private var indexBuffer = [IndexBufferType]()// = [IndexBufferType](count: 6, repeatedValue: 0)
    
    private var vertexBufferSlot:BufferIndex?
    //private var indexBufferSlot:BufferIndex?
    
    init() {
        
    }
    
    deinit {
        print("DrawTriangleBuffer.deinit()")
    }
    
    func reset() {
        _count = 0
    }
    
    subscript(index:Int) -> DrawTriangle {
        get {
            return data[index]
        }
        set(element) {
            set(index: index, triangle: element)
            //set(index: index, node1: element.node1, node2: element.node2, node3: element.node3)
        }
    }
    
    func ensureCapacity(_ capacity: Int) {
        if capacity >= data.count {
            var newCapacity = capacity + capacity / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count < newCapacity {
                data.append(DrawTriangle())
            }
            
            newCapacity = newCapacity * 30 + 30
            vertexBuffer.reserveCapacity(newCapacity)
            while vertexBuffer.count < newCapacity {
                vertexBuffer.append(0.0)
            }
        }
    }
    
    func ensureCount(_ index: Int) {
        ensureCapacity(index)
        if index >= _count {
            _count = index + 1
        }
    }
    
    func draw(texture:Texture?) {
        
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
            
            for index in 0..<_count {
                
                
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
                
                
                //gG.bufferVertexSetData(bufferIndex: vertexBufferSlot, data: &t[index].buffer, size: 30)
                
                gG.positionSetPointer(size: 3, offset: 0, stride: 10)
                gG.textureCoordSetPointer(size: 3, offset: 3, stride: 10)
                gG.colorArraySetPointer(size: 4, offset: 6, stride: 10)
                
                gG.drawTriangleList(count: 3, offset: 0)
                
            }
        }
    }
    
    func add(triangle:DrawTriangle) {
        set(index: count, triangle: triangle)
    }
    
    func set(index:Int, triangle:DrawTriangle) {
        set(index: index, node1: triangle.node1, node2: triangle.node2, node3: triangle.node3)
    }
    
    func set(index:Int, node1:DrawNode, node2:DrawNode, node3:DrawNode) {
        guard index >= 0 else { return }
        ensureCount(index)
        data[index].node1.set(drawNode: node1)
        data[index].node2.set(drawNode: node2)
        data[index].node3.set(drawNode: node3)
        
        data[index].writeToTriangleList(&vertexBuffer, index: index * 30)
        //vertexBuffer
    }
    
    
}


