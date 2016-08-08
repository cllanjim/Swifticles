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
    
    var texxx:Texture?
    
    
    func update() {
        
    }
    
    
    func draw() {
//        
//        let width = self.view.frame.size.width
//        let height = self.view.frame.size.height
//        
//        let p = GLKMatrix4MakeOrtho(0.0, Float(width), Float(height), 0.0, -2048, 2048)
//        gG.matrixProjectionSet(p)
//        
//        
//        var m = GLKMatrix4MakeScale(0.85, 0.85, 0.85)
//        
//        //GLKMatrix4Identity
//        
//        print("m1 = \(m.m)")
//        
//        
//        //m = GLKMatrix4Scale(m, 0.85, 0.85, 0.85)
//        
//        print("m2 = \(m.array)")
//        
//        
//        //m = GLKMatrix4Rotate(m, 0.1, 0.7, 0.1, 0.25)
//        
//        gG.matrixModelViewSet(m)
//        
//        
//        
//        gG.blendEnable()
//        gG.blendSetAlpha()
//        
//        gG.colorSet(r: 1.0, g: 0.25, b: 0.15, a: 1.0)
//        gG.rectDraw(CGRect(x: 10, y: 10, width: 300, height: 300))
//        
//        gG.colorSet(a: 0.8)
//        
//        gG.rectDraw(x: 22.0, y: 220.0, width: 256.0, height: 256.0)
//        
    }
    
    
    deinit {
        print("GameViewController.deinit()")
        self.tearDownGL()
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(API: .OpenGLES3)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        
        view.drawableDepthFormat = .Format24
        
        
        self.setupGL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }
    
    func setupGL() {
        
        print("GameViewController.setupGL()")
        
        EAGLContext.setCurrentContext(self.context)
        
        self.loadShaders()
        
        gG.create()
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        //glGenVertexArraysOES(1, &vertexArray)
        //glBindVertexArrayOES(vertexArray)
        //glGenBuffers(1, &vertexBuffer)
        
        
        
        
        var path = ""//FileUtils.getBundle()
        
        //hero_stego_spike_1.png
        //old.png
        
        path = path.stringByAppendingString("hero_stego_spike_1")
        texxx = Texture(filename: path)
        texxx?.load("rock")
        
    }
    
    func tearDownGL() {
        
        
        
        EAGLContext.setCurrentContext(self.context)
        
        gG.dispose()
        
        //glDeleteBuffers(1, &vertexBuffer)
        //glDeleteVertexArraysOES(1, &vertexArray)
        
        //self.effect = nil
        
        if program != 0 {
            glDeleteProgram(program)
            program = 0
        }
    }
    
    
    
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        
        glClearColor(0.05, 0.06, 0.0925, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        gG.colorSet()
        
        draw()
        
        
        
        
    }
    
    func loadShaders() -> Bool {
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        var vertShaderPathname: String
        var fragShaderPathname: String
        
        // Create shader program.
        program = glCreateProgram()
        
        // Create and compile vertex shader.
        vertShaderPathname = NSBundle.mainBundle().pathForResource("VertexShader", ofType: "glsl")!
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) == false {
            print("Failed to compile vertex shader")
            return false
        }
        
        // Create and compile fragment shader.
        fragShaderPathname = NSBundle.mainBundle().pathForResource("FragmentShader", ofType: "glsl")!
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname) {
            print("Failed to compile fragment shader")
            return false
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
            
            return false
        }
        
        gGLSlotPosition = glGetAttribLocation(program, "Position")
        gGLSlotTexCoord = glGetAttribLocation(program, "TexCoordIn")
        gGLUniformProjection = glGetUniformLocation(program, "ProjectionMatrix")
        gGLUniformModelView = glGetUniformLocation(program, "ModelViewMatrix")
        gGLUniformTexture = glGetUniformLocation(program, "Texture")
        gGLUniformColorModulate = glGetUniformLocation(program, "ModulateColor")
        
        // Release vertex and fragment shaders.
        if vertShader != 0 {
            glDetachShader(program, vertShader)
            glDeleteShader(vertShader)
        }
        
        if fragShader != 0 {
            glDetachShader(program, fragShader)
            glDeleteShader(fragShader)
        }
        
        glUseProgram(program)
        
        return true
    }
    
    func compileShader(inout shader: GLuint, type: GLenum, file: String) -> Bool {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding).UTF8String
        } catch {
            print("Failed to load vertex shader")
            return false
        }
        var castSource = UnsafePointer<GLchar>(source)
        
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
    
    func linkProgram(prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        
        return true
    }
    
    func validateProgram(prog: GLuint) -> Bool {
        var logLength: GLsizei = 0
        var status: GLint = 0
        
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log: [GLchar] = [GLchar](count: Int(logLength), repeatedValue: 0)
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
