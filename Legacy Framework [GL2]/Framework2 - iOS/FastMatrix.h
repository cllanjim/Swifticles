//
//  FastMatrix.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/25/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FMatrix.h"

FMatrix FMatrixCreate(float m00, float m01, float m02, float m03, float m10, float m11, float m12, float m13, float m20, float m21, float m22, float m23, float m30, float m31, float m32, float m33);
FMatrix FMatrixCreateAndTranspose(float m00, float m01, float m02, float m03, float m10, float m11, float m12, float m13, float m20, float m21, float m22, float m23, float m30, float m31, float m32, float m33);
FMatrix FMatrixCreateWithArray(float values[16]);
FMatrix FMatrixCreateTranslation(float tx, float ty, float tz);
FMatrix FMatrixCreateScale(float sx, float sy, float sz);
FMatrix FMatrixCreateRotation(float radians, float x, float y, float z);
FMatrix FMatrixCreateXRotation(float radians);
FMatrix FMatrixCreateYRotation(float radians);
FMatrix FMatrixCreateZRotation(float radians);
FMatrix FMatrixCreatePerspective(float fovyRadians, float aspect, float nearZ, float farZ);
FMatrix FMatrixCreateFrustum(float left, float right, float bottom, float top, float nearZ, float farZ);
FMatrix FMatrixCreateOrtho(float left, float right, float bottom, float top, float nearZ, float farZ);
FMatrix FMatrixCreateLookAt(float eyeX, float eyeY, float eyeZ, float centerX, float centerY, float centerZ, float upX, float upY, float upZ);

FMatrix FMatrixTranspose(FMatrix matrix);
FMatrix FMatrixMultiply(FMatrix matrixLeft, FMatrix matrixRight);
FMatrix FMatrixAdd(FMatrix matrixLeft, FMatrix matrixRight);
FMatrix FMatrixSubtract(FMatrix matrixLeft, FMatrix matrixRight);
FMatrix FMatrixTranslate(FMatrix matrix, float tx, float ty, float tz);
FMatrix FMatrixScale(FMatrix matrix, float sx, float sy, float sz);
FMatrix FMatrixRotate(FMatrix matrix, float radians, float x, float y, float z);
FMatrix FMatrixRotateX(FMatrix matrix, float radians);
FMatrix FMatrixRotateY(FMatrix matrix, float radians);
FMatrix FMatrixRotateZ(FMatrix matrix, float radians);

