//
//  Texture.swift
//  CombinedGL
//
//  Created by Nicholas Raptis on 8/1/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(OSX)
    import OpenGL
#else
    import OpenGLES
    import ImageIO
#endif

public class Texture {
    
    var id: GLuint
    var width: GLsizei
    var height: GLsizei
    
    public init() {
        id = 0
        width = 0
        height = 0
        glGenTextures(1, &id)
    }
    
    public convenience init(filename: String) {
        self.init()
        
        load(filename)
    }
    
    deinit {
        glDeleteTextures(1, &id)
    }
    
    public func load(filename: String) -> Bool {
        return load(filename, antialias: false)
    }
    
    /// @return true on success
    public func load(filename: String, antialias: Bool) -> Bool {
        let imageData = Texture.Load(filename, width: &width, height: &height)
        
        glBindTexture(GLenum(GL_TEXTURE_2D), id)
        
        if antialias {
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR_MIPMAP_LINEAR)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        } else {
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        }
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        
        #if os(OSX)
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GLenum(GL_BGRA), GLenum(GL_UNSIGNED_INT_8_8_8_8_REV), UnsafePointer(imageData))
        #else
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), UnsafePointer(imageData))
        #endif
        
        if antialias {
            glGenerateMipmap(GLenum(GL_TEXTURE_2D))
        }
        
        free(imageData)
        return false
    }
    
    private class func Load(filename: String, inout width: GLsizei, inout height: GLsizei) -> UnsafeMutablePointer<()> {
        let url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), filename as NSString, "", nil)
        
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
        
        width = GLsizei(CGImageGetWidth(image))
        height = GLsizei(CGImageGetHeight(image))
        
        let zero: CGFloat = 0
        let rect = CGRectMake(zero, zero, CGFloat(Int(width)), CGFloat(Int(height)))
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        
        let imageData: UnsafeMutablePointer<()> = malloc(Int(width * height * 4))
        let ctx = CGBitmapContextCreate(imageData, Int(width), Int(height), 8, Int(width * 4), colourSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        //if flipVertical {
        //    CGContextTranslateCTM(ctx, zero, CGFloat(Int(height)))
        //    CGContextScaleCTM(ctx, 1, -1)
        //}
        
        CGContextSetBlendMode(ctx, CGBlendMode.Copy)
        CGContextDrawImage(ctx, rect, image)
        
        // The caller is required to free the imageData buffer
        return imageData
    }
}