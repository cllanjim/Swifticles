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
    
    //override var view: GLView!
    
    var context: EAGLContext? = nil
    
    func update() { }
    func load() { }
    func draw() { }
    
    var skipDrawCount:Int = 0
    var isRendering = false
    
    deinit {
        self.tearDownGL()
        if EAGLContext.current() === self.context {
            EAGLContext.setCurrent(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredFramesPerSecond = 30
        context = EAGLContext(api: .openGLES3)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        view.drawableColorFormat = .RGB565
        //GLKViewDrawableColorFormatRGB565
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
        //loadShaders()
        Graphics.create()
    }
    
    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        ShaderProgramMesh.shared.dispose()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        if isRendering == false {
            
            isRendering = true
            
            Graphics.clear()
            Graphics.blendEnable()
            Graphics.blendSetAlpha()
            draw()
            
            isRendering = false
        }
    }
}
