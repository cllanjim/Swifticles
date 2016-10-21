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
    
    //private var _writeNode1 = DrawNode()
    //private var _writeNode2 = DrawNode()
    //private var _writeNode3 = DrawNode()
    
    
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
            vertexBufferSlot = Graphics.bufferGenerate()
        }
        
        if vertexBufferSlot != nil && count > 0 {
            Graphics.bufferVertexSetData(bufferIndex: vertexBufferSlot, data: &vertexBuffer, size: count * 30)
            ShaderProgramMesh.shared.positionEnable()
            ShaderProgramMesh.shared.texCoordEnable()
            ShaderProgramMesh.shared.colorArrayEnable()
            
            if let checkTexture = texture {
                Graphics.textureEnable()
                Graphics.textureBind(texture: checkTexture)
            } else {
                ShaderProgramMesh.shared.textureBlankBind()
                Graphics.textureDisable()
            }
            
            ShaderProgramMesh.shared.positionSetPointer(size: 3, offset: 0, stride: 10)
            ShaderProgramMesh.shared.textureCoordSetPointer(size: 3, offset: 3, stride: 10)
            ShaderProgramMesh.shared.colorArraySetPointer(size: 4, offset: 6, stride: 10)
            Graphics.drawTriangleList(count: count * 3, offset: 0)
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


