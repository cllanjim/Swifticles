//
//  ShaderProgram.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/23/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

typealias ShaderProgramRef = GLint

class ShaderProgram
{
    
    func loadProgram(vertexShaderPath: String, fragmentShaderPath:String) -> ShaderProgramRef? {
        
        var vertShader: GLuint?
        var fragShader: GLuint?
        
        // Create shader program.
        let program = ShaderProgramRef(glCreateProgram())
        
        // Create and compile vertex shader.
        let vPath = FileUtils.getBundlePath(filePath: vertexShaderPath)
        //Bundle.main.path(forResource: vertexShaderPath, ofType: "glsl")!
        
        vertShader = compileShader(type: GLenum(GL_VERTEX_SHADER), file: vPath)
        if vertShader == nil {
            print("Failed to compile vertex shader")
            return nil
        }
        
        // Create and compile fragment shader.
        let fPath = FileUtils.getBundlePath(filePath: fragmentShaderPath)
        fragShader = compileShader(type: GLenum(GL_FRAGMENT_SHADER), file: fPath)
        if fragShader == nil {
            print("Failed to compile fragment shader")
            return nil
        }
        
        // Attach vertex shader to program.
        glAttachShader(GLuint(program), vertShader!)
        
        // Attach fragment shader to program.
        glAttachShader(GLuint(program), fragShader!)
        
        // Link program.
        if !self.linkProgram(GLuint(program)) {
            print("Failed to link program: \(program)")
            if vertShader != 0 {
                glDeleteShader(vertShader!)
            }
            if fragShader != 0 {
                glDeleteShader(fragShader!)
            }
            if program != 0 {
                glDeleteProgram(GLuint(program))
            }
            return nil
        }
        
        /*
         glUseProgram(program)
         
         Graphics.shared.shaderSlotSlotPosition = glGetAttribLocation(program, "Position")
         Graphics.shared.shaderSlotSlotTexCoord = glGetAttribLocation(program, "TexCoordIn")
         Graphics.shared.shaderSlotSlotColor = glGetAttribLocation(program, "SourceColor")
         Graphics.shared.shaderSlotUniformProjection = glGetUniformLocation(program, "ProjectionMatrix")
         Graphics.shared.shaderSlotUniformModelView = glGetUniformLocation(program, "ModelViewMatrix")
         Graphics.shared.shaderSlotUniformTexture = glGetUniformLocation(program, "Texture")
         Graphics.shared.shaderSlotUniformColorModulate = glGetUniformLocation(program, "ModulateColor")
         
         // Release vertex and fragment shaders.
         if vertShader != 0 {
         glDetachShader(program, vertShader)
         glDeleteShader(vertShader)
         }
         if fragShader != 0 {
         glDetachShader(program, fragShader)
         glDeleteShader(fragShader)
         }
         */
        
        
        return program
    }
    
    func compileShader(type: GLenum, file: String) -> GLuint? {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue).utf8String!
        } catch {
            print("Failed to load vertex shader")
            return nil
        }
        //var castSource = UnsafePointer<GLchar>(source)
        var castSource: UnsafePointer<GLchar>? = UnsafePointer<GLchar>(source)
        
        let shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return nil
        }
        return shader
    }
    
    func linkProgram(_ prog: GLuint) -> Bool {
        print("Graphics.linkProgram()")
        
        var status: GLint = 0
        glLinkProgram(prog)
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        
        return true
    }
    
}
