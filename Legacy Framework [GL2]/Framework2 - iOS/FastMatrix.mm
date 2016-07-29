//
//  FastMatrix.m
//  CoreDemo
//
//  Created by Nick Raptis on 10/25/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#import "FastMatrix.h"
#include <Accelerate/Accelerate.h>

#import <GLKit/GLKit.h>

FMatrix FMatrixCreate(float m00, float m01, float m02, float m03,
                      float m10, float m11, float m12, float m13,
                      float m20, float m21, float m22, float m23,
                      float m30, float m31, float m32, float m33)
{
    FMatrix m = { m00, m01, m02, m03,
        m10, m11, m12, m13,
        m20, m21, m22, m23,
        m30, m31, m32, m33 };
    return m;
}

FMatrix FMatrixCreateAndTranspose(float m00, float m01, float m02, float m03,
                                  float m10, float m11, float m12, float m13,
                                  float m20, float m21, float m22, float m23,
                                  float m30, float m31, float m32, float m33)
{
    FMatrix m = { m00, m10, m20, m30,
        m01, m11, m21, m31,
        m02, m12, m22, m32,
        m03, m13, m23, m33 };
    return m;
}

FMatrix FMatrixCreateWithArray(float values[16])
{
    FMatrix m = { values[0], values[1], values[2], values[3],
        values[4], values[5], values[6], values[7],
        values[8], values[9], values[10], values[11],
        values[12], values[13], values[14], values[15] };
    return m;
}

FMatrix FMatrixCreateTranslation(float tx, float ty, float tz)
{
    FMatrix m;
    m.m[12] = tx;
    m.m[13] = ty;
    m.m[14] = tz;
    return m;
}

FMatrix FMatrixCreateScale(float sx, float sy, float sz)
{
    FMatrix m;
    m.m[0] = sx;
    m.m[5] = sy;
    m.m[10] = sz;
    return m;
}

FMatrix FMatrixCreateRotation(float radians, float x, float y, float z)
{
    float cos = cosf(radians);
    float cosp = 1.0f - cos;
    float sin = sinf(radians);
    
    float aDist = x * x + y * y + z * z;
    
    if(aDist > 0.01f)
    {
        aDist = sqrtf(aDist);
        x /= aDist;
        y /= aDist;
        z /= aDist;
    }
    
    FMatrix m = { cos + cosp * x * x,
        cosp * x * y + z * sin,
        cosp * x * z - y * sin,
        0.0f,
        cosp * x * y - z * sin,
        cos + cosp * y * y,
        cosp * y * z + x * sin,
        0.0f,
        cosp * x * z + y * sin,
        cosp * y * z - x * sin,
        cos + cosp * z * z,
        0.0f,
        0.0f,
        0.0f,
        0.0f,
        1.0f };
    
    return m;
}

FMatrix FMatrixCreateXRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    FMatrix m = { 1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, cos, sin, 0.0f,
        0.0f, -sin, cos, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f };
    
    return m;
}

FMatrix FMatrixCreateYRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    FMatrix m = { cos, 0.0f, -sin, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        sin, 0.0f, cos, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f };
    
    return m;
}

FMatrix FMatrixCreateZRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    FMatrix m = { cos, sin, 0.0f, 0.0f,
        -sin, cos, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f };
    
    return m;
}

FMatrix FMatrixCreatePerspective(float fovyRadians, float aspect, float nearZ, float farZ)
{
    float cotan = 1.0f / tanf(fovyRadians / 2.0f);
    
    FMatrix m = { cotan / aspect, 0.0f, 0.0f, 0.0f,
        0.0f, cotan, 0.0f, 0.0f,
        0.0f, 0.0f, (farZ + nearZ) / (nearZ - farZ), -1.0f,
        0.0f, 0.0f, (2.0f * farZ * nearZ) / (nearZ - farZ), 0.0f };
    
    return m;
}

FMatrix FMatrixCreateFrustum(float left, float right, float bottom, float top, float nearZ, float farZ)
{
    float ral = right + left;
    float rsl = right - left;
    float tsb = top - bottom;
    float tab = top + bottom;
    float fan = farZ + nearZ;
    float fsn = farZ - nearZ;
    
    FMatrix m = {2.0f * nearZ / rsl, 0.0f, 0.0f, 0.0f,
        0.0f, 2.0f * nearZ / tsb, 0.0f, 0.0f,
        ral / rsl, tab / tsb, -fan / fsn, -1.0f,
        0.0f, 0.0f, (-2.0f * farZ * nearZ) / fsn, 0.0f};
    
    return m;
}

FMatrix FMatrixCreateOrtho(float left, float right, float bottom, float top, float nearZ, float farZ)
{
    float ral = right + left;
    float rsl = right - left;
    float tab = top + bottom;
    float tsb = top - bottom;
    float fan = farZ + nearZ;
    float fsn = farZ - nearZ;
    
    FMatrix m = { 2.0f / rsl, 0.0f, 0.0f, 0.0f,
        0.0f, 2.0f / tsb, 0.0f, 0.0f,
        0.0f, 0.0f, -2.0f / fsn, 0.0f,
        -ral / rsl, -tab / tsb, -fan / fsn, 1.0f };
    
    return m;
}

FMatrix FMatrixCreateLookAt(float eyeX, float eyeY, float eyeZ, float centerX, float centerY, float centerZ, float upX, float upY, float upZ)
{
    float aNX = eyeX - centerX;
    float aNY = eyeY - centerY;
    float aNZ = eyeZ - centerZ;
    
    float aDist = aNX * aNX + aNY * aNY + aNZ * aNZ;
    
    if(aDist > 0.01f)
    {
        aDist = sqrtf(aDist);
        aNX /= aDist;
        aNY /= aDist;
        aNZ /= aDist;
    }
    
    float aUX = upY * aNZ - upZ * aNY;
    float aUY = upZ * aNX - upX * aNZ;
    float aUZ = upX * aNY - upY * aNX;
    
    aDist = aUX * aUX + aUY * aUY + aUZ * aUZ;
    if(aDist > 0.01f)
    {
        aDist = sqrtf(aDist);
        aUX /= aDist;
        aUY /= aDist;
        aUZ /= aDist;
    }
    
    float aVX = aNY * aUZ - aNZ * aUY;
    float aVY = aNZ * aUX - aNX * aUZ;
    float aVZ = aNX * aUY - aNY * aUX;
    
    FMatrix m = {aUX, aVX, aNX, 0.0f,
        aUY, aVY, aNY, 0.0f,
        aUZ, aVZ, aNZ, 0.0f,
        -aUX * eyeX + -aUY * eyeY + -aUZ * eyeZ,
        -aVX * eyeX + -aVY * eyeY + -aVZ * eyeZ,
        -aNX * eyeX + -aNY * eyeY + -aNZ * eyeZ,
        1.0f };
    
    return m;
}

FMatrix FMatrixTranspose(FMatrix matrix)
{
    FMatrix m = { matrix.m[0], matrix.m[4], matrix.m[8], matrix.m[12],
        matrix.m[1], matrix.m[5], matrix.m[9], matrix.m[13],
        matrix.m[2], matrix.m[6], matrix.m[10], matrix.m[14],
        matrix.m[3], matrix.m[7], matrix.m[11], matrix.m[15] };
    return m;
}

FMatrix FMatrixMultiply(FMatrix matrixLeft, FMatrix matrixRight)
{
    /*
    Matrix operator*(const Matrix& m) const {
        if(cols != m.rows) throw "cant multiply!";
        
        Matrix result(rows,m.cols);
        
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, rows, m.cols, cols, 1, matrix, cols, m.matrix, m.cols, 1, result.matrix, result.cols);
        
        return result;
    }
    */
    
    //float32x4x4_t iMatrixLeft = *(float32x4x4_t *)&matrixLeft;
    //float32x4x4_t iMatrixRight = *(float32x4x4_t *)&matrixRight;
    
    #if defined(__ARM_NEON__)
    
    float32x4x4_t iMatrixRight =
    {{
        {matrixRight.m[0], matrixRight.m[1], matrixRight.m[2], matrixRight.m[3]},
        {matrixRight.m[4], matrixRight.m[5], matrixRight.m[6], matrixRight.m[7]},
        {matrixRight.m[8], matrixRight.m[9], matrixRight.m[10], matrixRight.m[11]},
        {matrixRight.m[12], matrixRight.m[13], matrixRight.m[14], matrixRight.m[15]}
    }};
    
    float32x4x4_t iMatrixLeft =
    {{
        {matrixLeft.m[0], matrixLeft.m[1], matrixLeft.m[2], matrixLeft.m[3]},
        {matrixLeft.m[4], matrixLeft.m[5], matrixLeft.m[6], matrixLeft.m[7]},
        {matrixLeft.m[8], matrixLeft.m[9], matrixLeft.m[10], matrixLeft.m[11]},
        {matrixLeft.m[12], matrixLeft.m[13], matrixLeft.m[14], matrixLeft.m[15]}
    }};
    
    float32x4x4_t m;
    
    m.val[0] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[0], 0));
    m.val[1] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[1], 0));
    m.val[2] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[2], 0));
    m.val[3] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[3], 0));
    
    m.val[0] = vmlaq_n_f32(m.val[0], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[0], 1));
    m.val[1] = vmlaq_n_f32(m.val[1], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[1], 1));
    m.val[2] = vmlaq_n_f32(m.val[2], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[2], 1));
    m.val[3] = vmlaq_n_f32(m.val[3], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[3], 1));
    
    m.val[0] = vmlaq_n_f32(m.val[0], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[0], 2));
    m.val[1] = vmlaq_n_f32(m.val[1], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[1], 2));
    m.val[2] = vmlaq_n_f32(m.val[2], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[2], 2));
    m.val[3] = vmlaq_n_f32(m.val[3], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[3], 2));
    
    m.val[0] = vmlaq_n_f32(m.val[0], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[0], 3));
    m.val[1] = vmlaq_n_f32(m.val[1], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[1], 3));
    m.val[2] = vmlaq_n_f32(m.val[2], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[2], 3));
    m.val[3] = vmlaq_n_f32(m.val[3], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[3], 3));
    
    return *(FMatrix *)&(m);
    
#else
    
    FMatrix aMatrix;
    
    aMatrix.m[0]  = matrixLeft.m[0] * matrixRight.m[0]  + matrixLeft.m[4] * matrixRight.m[1]  + matrixLeft.m[8] * matrixRight.m[2]   + matrixLeft.m[12] * matrixRight.m[3];
	aMatrix.m[4]  = matrixLeft.m[0] * matrixRight.m[4]  + matrixLeft.m[4] * matrixRight.m[5]  + matrixLeft.m[8] * matrixRight.m[6]   + matrixLeft.m[12] * matrixRight.m[7];
	aMatrix.m[8]  = matrixLeft.m[0] * matrixRight.m[8]  + matrixLeft.m[4] * matrixRight.m[9]  + matrixLeft.m[8] * matrixRight.m[10]  + matrixLeft.m[12] * matrixRight.m[11];
	aMatrix.m[12] = matrixLeft.m[0] * matrixRight.m[12] + matrixLeft.m[4] * matrixRight.m[13] + matrixLeft.m[8] * matrixRight.m[14]  + matrixLeft.m[12] * matrixRight.m[15];
    
	aMatrix.m[1]  = matrixLeft.m[1] * matrixRight.m[0]  + matrixLeft.m[5] * matrixRight.m[1]  + matrixLeft.m[9] * matrixRight.m[2]   + matrixLeft.m[13] * matrixRight.m[3];
	aMatrix.m[5]  = matrixLeft.m[1] * matrixRight.m[4]  + matrixLeft.m[5] * matrixRight.m[5]  + matrixLeft.m[9] * matrixRight.m[6]   + matrixLeft.m[13] * matrixRight.m[7];
	aMatrix.m[9]  = matrixLeft.m[1] * matrixRight.m[8]  + matrixLeft.m[5] * matrixRight.m[9]  + matrixLeft.m[9] * matrixRight.m[10]  + matrixLeft.m[13] * matrixRight.m[11];
	aMatrix.m[13] = matrixLeft.m[1] * matrixRight.m[12] + matrixLeft.m[5] * matrixRight.m[13] + matrixLeft.m[9] * matrixRight.m[14]  + matrixLeft.m[13] * matrixRight.m[15];
    
	aMatrix.m[2]  = matrixLeft.m[2] * matrixRight.m[0]  + matrixLeft.m[6] * matrixRight.m[1]  + matrixLeft.m[10] * matrixRight.m[2]  + matrixLeft.m[14] * matrixRight.m[3];
	aMatrix.m[6]  = matrixLeft.m[2] * matrixRight.m[4]  + matrixLeft.m[6] * matrixRight.m[5]  + matrixLeft.m[10] * matrixRight.m[6]  + matrixLeft.m[14] * matrixRight.m[7];
	aMatrix.m[10] = matrixLeft.m[2] * matrixRight.m[8]  + matrixLeft.m[6] * matrixRight.m[9]  + matrixLeft.m[10] * matrixRight.m[10] + matrixLeft.m[14] * matrixRight.m[11];
	aMatrix.m[14] = matrixLeft.m[2] * matrixRight.m[12] + matrixLeft.m[6] * matrixRight.m[13] + matrixLeft.m[10] * matrixRight.m[14] + matrixLeft.m[14] * matrixRight.m[15];
    
	aMatrix.m[3]  = matrixLeft.m[3] * matrixRight.m[0]  + matrixLeft.m[7] * matrixRight.m[1]  + matrixLeft.m[11] * matrixRight.m[2]  + matrixLeft.m[15] * matrixRight.m[3];
	aMatrix.m[7]  = matrixLeft.m[3] * matrixRight.m[4]  + matrixLeft.m[7] * matrixRight.m[5]  + matrixLeft.m[11] * matrixRight.m[6]  + matrixLeft.m[15] * matrixRight.m[7];
	aMatrix.m[11] = matrixLeft.m[3] * matrixRight.m[8]  + matrixLeft.m[7] * matrixRight.m[9]  + matrixLeft.m[11] * matrixRight.m[10] + matrixLeft.m[15] * matrixRight.m[11];
	aMatrix.m[15] = matrixLeft.m[3] * matrixRight.m[12] + matrixLeft.m[7] * matrixRight.m[13] + matrixLeft.m[11] * matrixRight.m[14] + matrixLeft.m[15] * matrixRight.m[15];
    
    return aMatrix;
     
#endif
    
}

FMatrix FMatrixAdd(FMatrix matrixLeft, FMatrix matrixRight)
{
    FMatrix m;
    
    m.m[0] = matrixLeft.m[0] + matrixRight.m[0];
    m.m[1] = matrixLeft.m[1] + matrixRight.m[1];
    m.m[2] = matrixLeft.m[2] + matrixRight.m[2];
    m.m[3] = matrixLeft.m[3] + matrixRight.m[3];
    
    m.m[4] = matrixLeft.m[4] + matrixRight.m[4];
    m.m[5] = matrixLeft.m[5] + matrixRight.m[5];
    m.m[6] = matrixLeft.m[6] + matrixRight.m[6];
    m.m[7] = matrixLeft.m[7] + matrixRight.m[7];
    
    m.m[8] = matrixLeft.m[8] + matrixRight.m[8];
    m.m[9] = matrixLeft.m[9] + matrixRight.m[9];
    m.m[10] = matrixLeft.m[10] + matrixRight.m[10];
    m.m[11] = matrixLeft.m[11] + matrixRight.m[11];
    
    m.m[12] = matrixLeft.m[12] + matrixRight.m[12];
    m.m[13] = matrixLeft.m[13] + matrixRight.m[13];
    m.m[14] = matrixLeft.m[14] + matrixRight.m[14];
    m.m[15] = matrixLeft.m[15] + matrixRight.m[15];
    
    return m;
}

FMatrix FMatrixSubtract(FMatrix matrixLeft, FMatrix matrixRight)
{
    FMatrix m;
    
    m.m[0] = matrixLeft.m[0] - matrixRight.m[0];
    m.m[1] = matrixLeft.m[1] - matrixRight.m[1];
    m.m[2] = matrixLeft.m[2] - matrixRight.m[2];
    m.m[3] = matrixLeft.m[3] - matrixRight.m[3];
    
    m.m[4] = matrixLeft.m[4] - matrixRight.m[4];
    m.m[5] = matrixLeft.m[5] - matrixRight.m[5];
    m.m[6] = matrixLeft.m[6] - matrixRight.m[6];
    m.m[7] = matrixLeft.m[7] - matrixRight.m[7];
    
    m.m[8] = matrixLeft.m[8] - matrixRight.m[8];
    m.m[9] = matrixLeft.m[9] - matrixRight.m[9];
    m.m[10] = matrixLeft.m[10] - matrixRight.m[10];
    m.m[11] = matrixLeft.m[11] - matrixRight.m[11];
    
    m.m[12] = matrixLeft.m[12] - matrixRight.m[12];
    m.m[13] = matrixLeft.m[13] - matrixRight.m[13];
    m.m[14] = matrixLeft.m[14] - matrixRight.m[14];
    m.m[15] = matrixLeft.m[15] - matrixRight.m[15];
    
    return m;
}

FMatrix FMatrixTranslate(FMatrix matrix, float tx, float ty, float tz)
{
    FMatrix m = { matrix.m[0], matrix.m[1], matrix.m[2], matrix.m[3],
        matrix.m[4], matrix.m[5], matrix.m[6], matrix.m[7],
        matrix.m[8], matrix.m[9], matrix.m[10], matrix.m[11],
        matrix.m[0] * tx + matrix.m[4] * ty + matrix.m[8] * tz + matrix.m[12],
        matrix.m[1] * tx + matrix.m[5] * ty + matrix.m[9] * tz + matrix.m[13],
        matrix.m[2] * tx + matrix.m[6] * ty + matrix.m[10] * tz + matrix.m[14],
        matrix.m[15] };
    return m;
}

FMatrix FMatrixScale(FMatrix matrix, float sx, float sy, float sz)
{
    FMatrix m = { matrix.m[0] * sx, matrix.m[1] * sx, matrix.m[2] * sx, matrix.m[3] * sx,
        matrix.m[4] * sy, matrix.m[5] * sy, matrix.m[6] * sy, matrix.m[7] * sy,
        matrix.m[8] * sz, matrix.m[9] * sz, matrix.m[10] * sz, matrix.m[11] * sz,
        matrix.m[12], matrix.m[13], matrix.m[14], matrix.m[15] };
    return m;
}

FMatrix FMatrixRotate(FMatrix matrix, float radians, float x, float y, float z)
{
    FMatrix rm = FMatrixCreateRotation(radians, x, y, z);
    return FMatrixMultiply(matrix, rm);
}

FMatrix FMatrixRotateX(FMatrix matrix, float radians)
{
    FMatrix rm = FMatrixCreateXRotation(radians);
    return FMatrixMultiply(matrix, rm);
}

FMatrix FMatrixRotateY(FMatrix matrix, float radians)
{
    FMatrix rm = FMatrixCreateYRotation(radians);
    return FMatrixMultiply(matrix, rm);
}

FMatrix FMatrixRotateZ(FMatrix matrix, float radians)
{
    FMatrix rm = FMatrixCreateZRotation(radians);
    return FMatrixMultiply(matrix, rm);
}


