//
//  SpriteShaderProgram.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

class ShaderProgramSprite : ShaderProgram
{
    static let shared = ShaderProgramSprite()
    private override init() { }
    
    override func load() {
        loadProgram(vertexShaderPath: "MeshVertexShader.glsl", fragmentShaderPath: "MeshFragmentShader.glsl")
        loadClean()
    }
    
}
