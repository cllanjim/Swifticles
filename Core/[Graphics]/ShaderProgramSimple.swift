//
//  ShaderProgramSimple.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

class ShaderProgramSimple : ShaderProgram
{
    static let shared = ShaderProgramSimple()
    private override init() { }
    
    override func load() {
        loadProgram(vertexShaderPath: "MeshVertexShader.glsl", fragmentShaderPath: "MeshFragmentShader.glsl")
        loadClean()
    }
    
}
