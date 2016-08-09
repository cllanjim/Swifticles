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
    
    var bindIndex: BufferIndex
    
    var width: Int
    var height: Int
    
    public init() {
        bindIndex = -1
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
        gG.textureDelete(index: bindIndex)
        bindIndex = -1
    }
    
    public func load(path path:String?) {
        
        clear()
        
        if let texturePath = path where texturePath.characters.count > 0 {
            
            var textureWidth:GLsizei = 0
            var textureHeight:GLsizei = 0
            
            var scaledWidth:GLsizei = 0
            var scaledHeight:GLsizei = 0
            
            let imageData = Texture.Load(path:texturePath, textureWidth: &textureWidth, textureHeight: &textureHeight, scaledWidth: &scaledWidth, scaledHeight: &scaledHeight)
            
            width = Int(textureWidth)
            height = Int(textureHeight)
            
            bindIndex = gG.textureGenerate(width: Int(scaledWidth), height: Int(scaledHeight), data: imageData)
            
            free(imageData)
        }
    }
    
    private class func Load(path path:String, inout textureWidth: GLsizei, inout textureHeight: GLsizei, inout scaledWidth: GLsizei, inout scaledHeight: GLsizei) -> UnsafeMutablePointer<()> {
        
        if let image = UIImage(named: path) {
            if image.size.width > 0 && image.size.height > 0 {
                
                textureWidth = GLsizei(image.size.width)
                textureHeight = GLsizei(image.size.height)
                
                scaledWidth = GLsizei(image.size.width * image.scale)
                scaledHeight = GLsizei(image.size.height * image.scale)
                
                print("Loaded Texture\n\(textureWidth)x\(textureHeight) scale \(image.scale)\n\(scaledWidth)x\(scaledHeight)")
                
                let cgImage = image.CGImage;
                let imageData: UnsafeMutablePointer<()> = malloc(Int(scaledWidth * scaledHeight * 4))
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let cgContext = CGBitmapContextCreate(imageData, Int(scaledWidth), Int(scaledHeight), 8, Int(scaledWidth * 4), colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
                let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(Int(scaledWidth)), height: CGFloat(Int(scaledHeight)))
                
                CGContextSetBlendMode(cgContext, CGBlendMode.Copy)
                
                CGContextClearRect(cgContext, rect)
                CGContextDrawImage(cgContext, rect, cgImage)
                
                return imageData
            }
        }
        return nil
    }
}





