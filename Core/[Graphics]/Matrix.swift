//
//  Matrix.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/19/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation
import OpenGLES
import UIKit

class Matrix {
    
    var m:[GLfloat] = [GLfloat](repeating: 0.0, count: 16)
    
    init() {
        reset()
    }
    
    convenience init(_ m00:GLfloat, _ m01:GLfloat, _ m02:GLfloat, _ m03:GLfloat,
                     _ m10:GLfloat, _ m11:GLfloat, _ m12:GLfloat, _ m13:GLfloat,
                     _ m20:GLfloat, _ m21:GLfloat, _ m22:GLfloat, _ m23:GLfloat,
                     _ m30:GLfloat, _ m31:GLfloat, _ m32:GLfloat, _ m33:GLfloat) {
        self.init()
        m[0]=m00;m[1]=m01;m[2]=m02;m[3]=m03
        m[4]=m10;m[5]=m11;m[6]=m12;m[7]=m13
        m[8]=m20;m[9]=m21;m[10]=m22;m[11]=m23
        m[12]=m30;m[13]=m31;m[14]=m32;m[15]=m33
    }
    
    convenience init(_ matrix:Matrix) {
        self.init()
        set(matrix)
    }
    
    func clone() -> Matrix {
        return Matrix(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15])
    }
    
    func set(_ matrix:Matrix) {
        m[0]=matrix.m[0];m[1]=matrix.m[1];m[2]=matrix.m[2];m[3]=matrix.m[3];
        m[4]=matrix.m[4];m[5]=matrix.m[5];m[6]=matrix.m[6];m[7]=matrix.m[7];
        m[8]=matrix.m[8];m[9]=matrix.m[9];m[10]=matrix.m[10];m[11]=matrix.m[11];
        m[12]=matrix.m[12];m[13]=matrix.m[13];m[14]=matrix.m[14];m[15]=matrix.m[15];
    }
    
    func reset() {
        m[0]=1.0;m[1]=0.0;m[2]=0.0;m[3]=0.0
        m[4]=0.0;m[5]=1.0;m[6]=0.0;m[7]=0.0
        m[8]=0.0;m[9]=0.0;m[10]=1.0;m[11]=0.0
        m[12]=0.0;m[13]=0.0;m[14]=0.0;m[15]=1.0
    }
    
    func scale(_ scaleFactor:GLfloat) {
        scale(scaleFactor, scaleFactor, scaleFactor)
    }
    
    func scale(_ scaleX:GLfloat, _ scaleY:GLfloat, _ scaleZ:GLfloat) {
        m[0] *= scaleX;m[1] *= scaleX;m[2] *= scaleX;m[3] *= scaleX;
        m[4] *= scaleY;m[5] *= scaleY;m[6] *= scaleY;m[7] *= scaleY;
        m[8] *= scaleZ;m[9] *= scaleZ;m[10] *= scaleZ;m[11] *= scaleZ;
    }
    
    func translate(_ tx: GLfloat, _ ty: GLfloat, _ tz: GLfloat) {
        let mat = Matrix(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[0] * tx + m[4] * ty + m[8] * tz + m[12], m[1] * tx + m[5] * ty + m[9] * tz + m[13], m[2] * tx + m[6] * ty + m[10] * tz + m[14], m[15])
        set(mat)
    }
    
    func translate(_ tx: CGFloat, _ ty: CGFloat, _ tz: CGFloat) {
        translate(GLfloat(tx), GLfloat(ty), GLfloat(tz))
    }
    
    class func createOrtho(left:GLfloat, right:GLfloat, bottom:GLfloat, top:GLfloat, nearZ:GLfloat, farZ:GLfloat) -> Matrix {
        let ral = right + left;
        let rsl = right - left;
        let tab = top + bottom;
        let tsb = top - bottom;
        let fan = farZ + nearZ;
        let fsn = farZ - nearZ;
        return Matrix(2.0 / rsl, 0.0, 0.0, 0.0, 0.0, 2.0 / tsb, 0.0, 0.0,
                    0.0, 0.0, -2.0 / fsn, 0.0, -ral / rsl, -tab / tsb, -fan / fsn, 1.0)
    }
    
}
