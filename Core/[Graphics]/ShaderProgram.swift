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
    var program:ShaderProgramRef = 0
    
    var vertShader: GLuint?
    var fragShader: GLuint?
    
    //Common Attributes
    var slotAttrPositionArray:GLint = 0
    var slotAttrTexCoordArray:GLint = 0
    var slotAttrColorArray:GLint = 0
    var slotAttrNormalArray:GLint = 0
    
    //Common Uniforms
    var slotUniformProjection:GLint = 0
    var slotUniformModelView:GLint = 0
    var slotUniformTexture:GLint = 0
    var slotUniformColorModulate:GLint = 0
    
    //They will all use projection and model view matrices.
    private var _projectionMatrix = Matrix()
    private var _modelViewMatrix = Matrix()
    
    func load() {
        loadClean()
    }
    
    func dispose() {
    
        if program != 0 {
            glDeleteProgram(GLuint(program))
            program = 0
        }
    
    }
    
    func colorSet() {
        colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
    }
    
    func colorSet(a:GLfloat) {
        colorSet(r: 1.0, g: 1.0, b: 1.0, a: a)
    }
    
    func colorSet(r:GLfloat, g:GLfloat, b:GLfloat) {
        colorSet(r: r, g: g, b: b, a: 1.0)
    }
    
    func colorSet(r:GLfloat, g:GLfloat, b:GLfloat, a:GLfloat) { }
    
    func colorSet(color:UIColor) {
        var r: CGFloat = 0.0;var g: CGFloat = 0.0;var b: CGFloat = 0.0;var a: CGFloat = 0.0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            colorSet(r: GLfloat(r), g: GLfloat(g), b: GLfloat(b), a: GLfloat(a))
        }
    }
    
    func matrixProjectionGet() -> Matrix {
        let result = Matrix()
        result.set(_projectionMatrix)
        return result
    }
    
    func matrixModelViewGet() -> Matrix {
        let result = Matrix()
        result.set(_modelViewMatrix)
        return result
    }
    
    func matrixProjectionSet(_ mat:Matrix) {
        _projectionMatrix.set(mat)
        glUniformMatrix4fv(slotUniformProjection, 1, 0, _projectionMatrix.m)
    }
    
    func matrixModelViewSet(_ mat:Matrix) {
        _modelViewMatrix.set(mat)
        glUniformMatrix4fv(slotUniformModelView, 1, 0, _modelViewMatrix.m)
    }
    
    func matrixProjectionReset() {
        matrixProjectionSet(Matrix())
    }
    
    func matrixModelViewReset() {
        matrixModelViewSet(Matrix())
    }
    
    func positionEnable() {
        glEnableVertexAttribArray(GLuint(slotAttrPositionArray))
    }
    
    func positionDisable() {
        glDisableVertexAttribArray(GLuint(slotAttrPositionArray))
    }
    
    func texCoordEnable() {
        glEnableVertexAttribArray(GLuint(slotAttrTexCoordArray))
    }
    
    func texCoordDisable() {
        glDisableVertexAttribArray(GLuint(slotAttrTexCoordArray))
    }
    
    func colorArrayEnable() {
        glEnableVertexAttribArray(GLuint(slotAttrColorArray))
    }
    
    func colorArrayDisable() {
        glDisableVertexAttribArray(GLuint(slotAttrColorArray))
    }
    
    func positionSetPointer(size:Int, offset:Int, stride:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(slotAttrPositionArray), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func textureCoordSetPointer(size:Int, offset:Int, stride:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(slotAttrTexCoordArray), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func colorArraySetPointer(size:Int, offset:Int, stride:Int) {
        let ptr = UnsafeRawPointer(bitPattern: (offset << 2))
        glVertexAttribPointer(GLenum(slotAttrColorArray), GLint(size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(stride << 2), ptr)
    }
    
    func loadProgram(vertexShaderPath: String, fragmentShaderPath:String) {
        
        // Create shader program.
        program = ShaderProgramRef(glCreateProgram())
        
        // Create and compile vertex shader.
        let vPath = FileUtils.getBundlePath(filePath: vertexShaderPath)
        //Bundle.main.path(forResource: vertexShaderPath, ofType: "glsl")!
        
        vertShader = compileShader(type: GLenum(GL_VERTEX_SHADER), file: vPath)
        if vertShader == nil {
            print("Failed to compile vertex shader \(vertexShaderPath)")
            return
        }
        
        // Create and compile fragment shader.
        let fPath = FileUtils.getBundlePath(filePath: fragmentShaderPath)
        fragShader = compileShader(type: GLenum(GL_FRAGMENT_SHADER), file: fPath)
        if fragShader == nil {
            print("Failed to compile fragment shader \(fragmentShaderPath)")
            return
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
            return
        }
        
        glUseProgram(GLuint(program))
        
        ShaderProgramMesh.shared.slotAttrPositionArray = glGetAttribLocation(GLuint(program), "Position")
        ShaderProgramMesh.shared.slotAttrTexCoordArray = glGetAttribLocation(GLuint(program), "TexCoordIn")
        ShaderProgramMesh.shared.slotAttrColorArray = glGetAttribLocation(GLuint(program), "SourceColor")
        ShaderProgramMesh.shared.slotAttrNormalArray = glGetAttribLocation(GLuint(program), "Normal")
        
        ShaderProgramMesh.shared.slotUniformProjection = glGetUniformLocation(GLuint(program), "ProjectionMatrix")
        ShaderProgramMesh.shared.slotUniformModelView = glGetUniformLocation(GLuint(program), "ModelViewMatrix")
        ShaderProgramMesh.shared.slotUniformTexture = glGetUniformLocation(GLuint(program), "Texture")
        ShaderProgramMesh.shared.slotUniformColorModulate = glGetUniformLocation(GLuint(program), "ModulateColor")
        
        /*
         
         
         ShaderProgramMesh.shared.shaderSlotSlotPosition = glGetAttribLocation(program, "Position")
         ShaderProgramMesh.shared.shaderSlotSlotTexCoord = glGetAttribLocation(program, "TexCoordIn")
         ShaderProgramMesh.shared.shaderSlotSlotColor = glGetAttribLocation(program, "SourceColor")
         ShaderProgramMesh.shared.shaderSlotUniformProjection = glGetUniformLocation(program, "ProjectionMatrix")
         ShaderProgramMesh.shared.shaderSlotUniformModelView = glGetUniformLocation(program, "ModelViewMatrix")
         ShaderProgramMesh.shared.shaderSlotUniformTexture = glGetUniformLocation(program, "Texture")
         ShaderProgramMesh.shared.shaderSlotUniformColorModulate = glGetUniformLocation(program, "ModulateColor")
         
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
        
    }
    
    func loadClean() {
        if vertShader != nil && vertShader != 0 {
            glDetachShader(GLuint(program), vertShader!)
            glDeleteShader(vertShader!)
        }
        if fragShader != nil && fragShader != 0 {
            glDetachShader(GLuint(program), fragShader!)
            glDeleteShader(fragShader!)
        }
    }
    
    private func compileShader(type: GLenum, file: String) -> GLuint? {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue).utf8String!
        } catch {
            print("Failed to load shader \(file)")
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
    
    private func linkProgram(_ prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            print("Failed to link program.")
            return false
        }
        return true
    }
    
    func validateProgram(_ prog: GLuint) -> Bool {
        var logLength: GLsizei = 0
        var status: GLint = 0
        
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log: [GLchar] = [GLchar](repeating: 0, count: Int(logLength))
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(log)")
        }
        
        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
        var returnVal = true
        if status == 0 {
            returnVal = false
        }
        return returnVal
    }
    
}
