//
//  Texture.swift
//  CombinedGL
//
//  Created by Nicholas Raptis on 8/1/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import CoreGraphics
import OpenGLES

class Texture {
    
    var bindIndex: BufferIndex?
    
    var width: Int = 0
    var height: Int = 0
    
    var textureWidth:GLsizei = 0
    var textureHeight:GLsizei = 0
    var scaledWidth:GLsizei = 0
    var scaledHeight:GLsizei = 0
    
    public init() {
        bindIndex = nil
        width = 0
        height = 0
    }
    
    public convenience init(path: String?) {
        self.init()
        load(path: path)
    }
    
    deinit {
        clear()
    }
    
    func clear() {
        width = 0
        height = 0
        textureWidth = 0
        textureHeight = 0
        scaledWidth = 0
        scaledHeight = 0
        Graphics.textureDelete(bufferIndex: bindIndex)
        bindIndex = nil
    }
    
    open func loadOver(imageData: inout UnsafeMutableRawPointer) {
        Graphics.textureSetData(bufferIndex: bindIndex, width: Int(scaledWidth), height: Int(scaledHeight), data: &imageData)
    }
    
    func Load(data: inout UnsafeMutableRawPointer, textureWidth: Int, textureHeight: Int, scaledWidth: Int, scaledHeight: Int) {
        clear()
        self.textureWidth = GLsizei(textureWidth)
        self.textureHeight = GLsizei(textureHeight)
        self.scaledWidth = GLsizei(scaledWidth)
        self.scaledHeight = GLsizei(scaledHeight)
        width = Int(textureWidth)
        height = Int(textureHeight)
        bindIndex = Graphics.textureGenerate(width: Int(scaledWidth), height: Int(scaledHeight), data: &data)
    }
    
    func load(image:UIImage?) {
        clear()
        if let loadImage = image {
            var imageData = Texture.Load(image:loadImage, textureWidth: &textureWidth, textureHeight: &textureHeight, scaledWidth: &scaledWidth, scaledHeight: &scaledHeight)
            if imageData != nil {
                defer { free(imageData) }
                width = Int(textureWidth)
                height = Int(textureHeight)
                bindIndex = Graphics.textureGenerate(width: Int(scaledWidth), height: Int(scaledHeight), data: &(imageData!))
            }
        }
    }
    
    func load(path:String?) {
        clear()
        if let texturePath = path , texturePath.characters.count > 0 {
            load(image: UIImage(named: texturePath))
        }
    }
    
    class func Load(image:UIImage?, textureWidth: inout GLsizei, textureHeight: inout GLsizei, scaledWidth: inout GLsizei, scaledHeight: inout GLsizei) -> UnsafeMutableRawPointer? {
        if let loadImage = image , loadImage.size.width > 0 && loadImage.size.height > 0 {
            
            let w = GLsizei(loadImage.size.width * loadImage.scale)
            let h = GLsizei(loadImage.size.height * loadImage.scale)
            var imageData: UnsafeMutableRawPointer = malloc(Int(w * h * 4))
            Texture.LoadOver(image: image, data: &imageData, textureWidth: &textureWidth, textureHeight: &textureHeight, scaledWidth: &scaledWidth, scaledHeight: &scaledHeight)
            return imageData
        }
        return nil
    }
    
    
    class func LoadOver(image:UIImage?, data: inout UnsafeMutableRawPointer, textureWidth: inout GLsizei, textureHeight: inout GLsizei, scaledWidth: inout GLsizei, scaledHeight: inout GLsizei) {
        if let loadImage = image, loadImage.size.width > 0 && loadImage.size.height > 0 {
            textureWidth = GLsizei(loadImage.size.width)
            textureHeight = GLsizei(loadImage.size.height)
            scaledWidth = GLsizei(loadImage.size.width * loadImage.scale)
            scaledHeight = GLsizei(loadImage.size.height * loadImage.scale)
            let cgImage = loadImage.cgImage;
            //let imageData: UnsafeMutableRawPointer = malloc(Int(scaledWidth * scaledHeight * 4))
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let context = CGContext(data: data, width: Int(scaledWidth), height: Int(scaledHeight), bitsPerComponent: 8, bytesPerRow: Int(scaledWidth * 4), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
                
                let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(Int(scaledWidth)), height: CGFloat(Int(scaledHeight)))
                context.setBlendMode(CGBlendMode.copy)
                context.clear(rect)
                context.draw(cgImage!, in: rect)
            }
        }
    }
}





