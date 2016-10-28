//
//  GLView.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/27/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import GLKit
import OpenGLES

class BounceView: GLView {
    
    var defaultScaleFactor: CGFloat = 1.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    deinit {
        
    }
    
    func setUp() {
        
        defaultScaleFactor = self.contentScaleFactor
        
        self.isOpaque = true
        self.contentScaleFactor = 1.0
        
        //enableSetNeedsDisplay = true
    }
    
    
    override func display() {
        
        if let engine = ApplicationController.shared.engine {
            if engine.stereoscopic {
                
                self.contentScaleFactor = 1.0
                
                engine.stereoscopicChannel = false
                engine.setStereoscopicBlendBackground(stereoscopicImage: self.snapshot)
                engine.stereoscopicChannel = true
                super.display()
                engine.stereoscopicChannel = false
                
                self.contentScaleFactor = defaultScaleFactor
                
            } else {
                self.contentScaleFactor = defaultScaleFactor
                super.display()
            }
            
        }
    }
}
