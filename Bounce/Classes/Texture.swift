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

public class Texture {
    
    var bindIndex: BufferIndex?
    
    var width: Int
    var height: Int
    
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
        gG.textureDelete(bufferIndex: bindIndex)
        bindIndex = nil
    }
    
    public func load(image image:UIImage?) {
        clear()
        if let loadImage = image {
            
            var textureWidth:GLsizei = 0
            var textureHeight:GLsizei = 0
            
            var scaledWidth:GLsizei = 0
            var scaledHeight:GLsizei = 0
            
            let imageData = Texture.Load(image:loadImage, textureWidth: &textureWidth, textureHeight: &textureHeight, scaledWidth: &scaledWidth, scaledHeight: &scaledHeight)
            
            width = Int(textureWidth)
            height = Int(textureHeight)
            
            bindIndex = gG.textureGenerate(width: Int(scaledWidth), height: Int(scaledHeight), data: imageData)
            
            free(imageData)
        }
    }
    
    public func load(path path:String?) {
        clear()
        if let texturePath = path where texturePath.characters.count > 0 {
            load(image: UIImage(named: texturePath))
        }
    }
    
    private class func Load(image image:UIImage?, inout textureWidth: GLsizei, inout textureHeight: GLsizei, inout scaledWidth: GLsizei, inout scaledHeight: GLsizei) -> UnsafeMutablePointer<()> {
        
        if let loadImage = image where loadImage.size.width > 0 && loadImage.size.height > 0 {
            
            textureWidth = GLsizei(loadImage.size.width)
            textureHeight = GLsizei(loadImage.size.height)
            
            scaledWidth = GLsizei(loadImage.size.width * loadImage.scale)
            scaledHeight = GLsizei(loadImage.size.height * loadImage.scale)
            
            print("Loaded Texture\n\(textureWidth)x\(textureHeight) scale \(loadImage.scale)\n\(scaledWidth)x\(scaledHeight)")
            
            let cgImage = loadImage.CGImage;
            let imageData: UnsafeMutablePointer<()> = malloc(Int(scaledWidth * scaledHeight * 4))
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgContext = CGBitmapContextCreate(imageData, Int(scaledWidth), Int(scaledHeight), 8, Int(scaledWidth * 4), colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(Int(scaledWidth)), height: CGFloat(Int(scaledHeight)))
            
            CGContextSetBlendMode(cgContext, CGBlendMode.Copy)
            
            CGContextClearRect(cgContext, rect)
            CGContextDrawImage(cgContext, rect, cgImage)
            
            return imageData
            
        }
        return nil
    }
}





