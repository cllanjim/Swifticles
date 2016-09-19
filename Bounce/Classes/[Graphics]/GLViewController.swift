//
//  GameViewController.swift
//  CombinedGL
//
//  Created by Nicholas Raptis on 7/31/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import GLKit
import OpenGLES

class GLViewController: GLKViewController {
    
    var program: GLuint = 0
    var context: EAGLContext? = nil
    
    func update() { }
    func load() { }
    func draw() { }
    
    deinit {
        self.tearDownGL()
        if EAGLContext.current() === self.context {
            EAGLContext.setCurrent(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredFramesPerSecond = 60
        context = EAGLContext(api: .openGLES2)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        view.isMultipleTouchEnabled = true
        view.isUserInteractionEnabled = true
        view.isExclusiveTouch = false
        
        self.setupGL()
        
        self.performSelector(onMainThread: #selector(load), with: nil, waitUntilDone: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && (self.view.window != nil) {
            
            print("************************")
            print("***  GL - SUICIDE!!! ***")
            print("************************")
            /*
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
            */
        }
    }
    
    func setupGL() {
        EAGLContext.setCurrent(self.context)
        loadShaders()
        Graphics.shared.create()
    }
    
    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        Graphics.shared.dispose()
        if program != 0 {
            glDeleteProgram(program)
            program = 0
        }
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        Graphics.shared.clear()
        Graphics.shared.colorSet()
        Graphics.shared.blendEnable()
        Graphics.shared.blendSetAlpha()
        draw()
    }
    
    func loadShaders() -> Void {
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        var vertShaderPathname: String
        var fragShaderPathname: String
        
        // Create shader program.
        program = glCreateProgram()
        
        // Create and compile vertex shader.
        vertShaderPathname = Bundle.main.path(forResource: "VertexShader", ofType: "glsl")!
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) == false {
            print("Failed to compile vertex shader")
            return
        }
        
        // Create and compile fragment shader.
        fragShaderPathname = Bundle.main.path(forResource: "FragmentShader", ofType: "glsl")!
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname) {
            print("Failed to compile fragment shader")
            return
        }
        
        // Attach vertex shader to program.
        glAttachShader(program, vertShader)
        
        // Attach fragment shader to program.
        glAttachShader(program, fragShader)
        
        // Link program.
        if !self.linkProgram(program) {
            print("Failed to link program: \(program)")
            if vertShader != 0 {
                glDeleteShader(vertShader)
                vertShader = 0
            }
            if fragShader != 0 {
                glDeleteShader(fragShader)
                fragShader = 0
            }
            if program != 0 {
                glDeleteProgram(program)
                program = 0
            }
            return
        }
        
        glUseProgram(program)
        
        Graphics.shared.shaderSlotSlotPosition = glGetAttribLocation(program, "Position")
        Graphics.shared.shaderSlotSlotTexCoord = glGetAttribLocation(program, "TexCoordIn")
        Graphics.shared.shaderSlotSlotColor = glGetAttribLocation(program, "SourceColor")
        
        Graphics.shared.shaderSlotUniformEnableTexture = glGetUniformLocation(program, "EnableTexture")
        Graphics.shared.shaderSlotUniformEnableModulate = glGetUniformLocation(program, "EnableModulate")
        
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
    }
    
    func compileShader(_ shader: inout GLuint, type: GLenum, file: String) -> Bool {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: String.Encoding.utf8.rawValue).utf8String!
        } catch {
            print("Failed to load vertex shader")
            return false
        }
        //var castSource = UnsafePointer<GLchar>(source)
        var castSource: UnsafePointer<GLchar>? = UnsafePointer<GLchar>(source)
        
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    func linkProgram(_ prog: GLuint) -> Bool {
        print("GLViewController.linkProgram()")
        
        var status: GLint = 0
        glLinkProgram(prog)
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
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
