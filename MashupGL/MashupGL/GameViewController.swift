//
//  GameViewController.swift
//  MashupGL
//
//  Created by Nicholas Raptis on 7/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import GLKit
import OpenGLES

//var uniforms = [GLint](count: 2, repeatedValue: 0)

class GameViewController: GLKViewController {
    
    var program: GLuint = 0
    
    var vertexArray: GLuint = 0
    var vertexBuffer: GLuint = 0
    
    var context: EAGLContext? = nil
    
    deinit {
        self.tearDownGL()
        
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(API: .OpenGLES2)
        
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
        
        EAGLContext.setCurrentContext(self.context)
        
        
        
        //todo
        var framebuffer = GLuint();
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer);
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), gGLBufferRender);
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), gGLBufferDepth);
        
        
        
        
        self.loadShaders()
        
        
        /*
        glEnable(GLenum(GL_DEPTH_TEST))
         
        glGenVertexArraysOES(1, &vertexArray)
        glBindVertexArrayOES(vertexArray)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(sizeof(GLfloat) * gCubeVertexData.count), &gCubeVertexData, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(0))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Normal.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(12))
        
        glBindVertexArrayOES(0)
        */
        
    }
    
    func tearDownGL() {
        EAGLContext.setCurrentContext(self.context)
        
        glDeleteBuffers(1, &vertexBuffer)
        glDeleteVertexArraysOES(1, &vertexArray)
        
        if program != 0 {
            glDeleteProgram(program)
            program = 0
        }
    }
    
    // MARK: - GLKView and GLKViewController delegate methods
    
    func update() {
        
        //let aspect = fabsf(Float(self.view.bounds.size.width / self.view.bounds.size.height))
        //let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
        
        
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        //glClearColor(0.65, 0.65, 0.65, 1.0)
        //glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        gG.clear(r: 0.25, g: 0.25, b: 0.34)
        gG.clearDepth()
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        
        //gGLSlotPosition = glGetAttribLocation(program, "Position")
        //gGLSlotTexCoord = glGetAttribLocation(program, "TexCoordIn")
        
        //gGLUniformProjection = glGetUniformLocation(program, "Projection")
        //gGLUniformModelView = glGetUniformLocation(program, "ModelView")
        //gGLUniformTexture = glGetUniformLocation(program, "Texture")
        //gGLUniformColorModulate = glGetUniformLocation(program, "ModulateColor")
        
        
        
        var p = GLKMatrix4MakeOrtho(0.0, Float(width), Float(height), 0.0, 2048, -2048)
        
        gG.matrixProjectionSet(p)
        gG.matrixModelViewReset()
        
        //gG.matrixModelViewSet(p)
        //gG.matrixProjectionReset()
        
        
        gG.colorSet(r: 1.0, g: 0.25, b: 0.15, a: 1.0)
        gG.rectDraw(CGRect(x: -10, y: -10, width: 300, height: 100))
        
        gG.colorSet(r: 0.2, g: 0.15, b: 0.8, a: 0.8)
        gG.rectDraw(x: 170, y: 70, width: 90, height: 380)
        
        //p.m
        
        //FMatrix aPojection = FMatrixCreateOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
        //gfx_matrixProjectionSet(aPojection);
        
        
        
    }
    
    // MARK: -  OpenGL ES 2 shader compilation
    
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
        
        // Bind attribute locations.
        // This needs to be done prior to linking.
        //glBindAttribLocation(program, GLuint(GLKVertexAttrib.Position.rawValue), "position")
        //glBindAttribLocation(program, GLuint(GLKVertexAttrib.Normal.rawValue), "normal")
        
        
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
        
        glUseProgram(program);
        
        
        // Get uniform locations.
        
        
        gGLSlotPosition = glGetAttribLocation(program, "Position")
        gGLSlotTexCoord = glGetAttribLocation(program, "TexCoordIn")
        
        gGLUniformProjection = glGetUniformLocation(program, "ProjectionMatrix")
        gGLUniformModelView = glGetUniformLocation(program, "ModelViewMatrix")
        gGLUniformTexture = glGetUniformLocation(program, "Texture")
        gGLUniformColorModulate = glGetUniformLocation(program, "ModulateColor")
        
        //TODO
        // Release vertex and fragment shaders.
        if vertShader != 0 {
            //glDetachShader(program, vertShader)
            //glDeleteShader(vertShader)
        }
        if fragShader != 0 {
            //glDetachShader(program, fragShader)
            //glDeleteShader(fragShader)
        }
        
        
        //gG.matrixProjectionReset();
        //gG.matrixModelViewReset();
        
        
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

//var gCubeVertexData: [GLfloat] = [
//    // Data layout for each line below is:
//    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
//    0.5, -0.5, -0.5,        1.0, 0.0, 0.0,
//    0.5, 0.5, -0.5,         1.0, 0.0, 0.0,
//    0.5, -0.5, 0.5,         1.0, 0.0, 0.0,
//    0.5, -0.5, 0.5,         1.0, 0.0, 0.0,
//    0.5, 0.5, -0.5,         1.0, 0.0, 0.0,
//    0.5, 0.5, 0.5,          1.0, 0.0, 0.0,
//    
//    0.5, 0.5, -0.5,         0.0, 1.0, 0.0,
//    -0.5, 0.5, -0.5,        0.0, 1.0, 0.0,
//    0.5, 0.5, 0.5,          0.0, 1.0, 0.0,
//    0.5, 0.5, 0.5,          0.0, 1.0, 0.0,
//    -0.5, 0.5, -0.5,        0.0, 1.0, 0.0,
//    -0.5, 0.5, 0.5,         0.0, 1.0, 0.0,
//    
//    -0.5, 0.5, -0.5,        -1.0, 0.0, 0.0,
//    -0.5, -0.5, -0.5,      -1.0, 0.0, 0.0,
//    -0.5, 0.5, 0.5,         -1.0, 0.0, 0.0,
//    -0.5, 0.5, 0.5,         -1.0, 0.0, 0.0,
//    -0.5, -0.5, -0.5,      -1.0, 0.0, 0.0,
//    -0.5, -0.5, 0.5,        -1.0, 0.0, 0.0,
//    
//    -0.5, -0.5, -0.5,      0.0, -1.0, 0.0,
//    0.5, -0.5, -0.5,        0.0, -1.0, 0.0,
//    -0.5, -0.5, 0.5,        0.0, -1.0, 0.0,
//    -0.5, -0.5, 0.5,        0.0, -1.0, 0.0,
//    0.5, -0.5, -0.5,        0.0, -1.0, 0.0,
//    0.5, -0.5, 0.5,         0.0, -1.0, 0.0,
//    
//    0.5, 0.5, 0.5,          0.0, 0.0, 1.0,
//    -0.5, 0.5, 0.5,         0.0, 0.0, 1.0,
//    0.5, -0.5, 0.5,         0.0, 0.0, 1.0,
//    0.5, -0.5, 0.5,         0.0, 0.0, 1.0,
//    -0.5, 0.5, 0.5,         0.0, 0.0, 1.0,
//    -0.5, -0.5, 0.5,        0.0, 0.0, 1.0,
//    
//    0.5, -0.5, -0.5,        0.0, 0.0, -1.0,
//    -0.5, -0.5, -0.5,      0.0, 0.0, -1.0,
//    0.5, 0.5, -0.5,         0.0, 0.0, -1.0,
//    0.5, 0.5, -0.5,         0.0, 0.0, -1.0,
//    -0.5, -0.5, -0.5,      0.0, 0.0, -1.0,
//    -0.5, 0.5, -0.5,        0.0, 0.0, -1.0
//]
