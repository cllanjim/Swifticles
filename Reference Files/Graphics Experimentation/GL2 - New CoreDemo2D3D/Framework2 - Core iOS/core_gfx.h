//
//  core_gfx.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef FRAMEWORK_CORE_GFX
#define FRAMEWORK_CORE_GFX

#include "FString.h"
#include "FMatrix.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#define GFX_MODEL_INDEX_TYPE unsigned short

void gfx_preinitialize();
void gfx_initialize();

void gfx_clear();
void gfx_clear(float pRed, float pGreen, float pBlue, float pAlpha=1.0f);

void gfx_clearDepth();

void gfx_drawQuad(float x1, float y1,float x2, float y2,float x3, float y3,float x4, float y4);
void gfx_drawQuad(float x1, float y1,float x2, float y2,float x3, float y3,float x4, float y4);
void gfx_drawRect(float x, float y, float pWidth, float pHeight);
void gfx_drawPoint(float pX, float pY, float pSize=7);

int gfx_generateTexture(unsigned int *pData, int pWidth, int pHeight);
void gfx_deleteTexture(int pIndex);
void gfx_bindTexture(int pIndex, unsigned int *pData, int pWidth, int pHeight);
void gfx_bindTexture(int pIndex);

void gfx_bufferVertexBind(unsigned int pIndex);
void gfx_bufferIndexBind(unsigned int pIndex);

unsigned int gfx_bufferVertexGenerate(float *pData, int pSize);
unsigned int gfx_bufferVertexGenerate();
void gfx_bufferVertexSetData(unsigned int pBufferIndex, float *pData, int pSize);

unsigned int gfx_bufferIndexGenerate(GFX_MODEL_INDEX_TYPE *pData, int pSize);
unsigned int gfx_bufferIndexGenerate();
void gfx_bufferIndexSetData(unsigned int pBufferIndex, GFX_MODEL_INDEX_TYPE *pData, int pSize);

void gfx_positionEnable();
void gfx_positionDisable();
void gfx_texCoordEnable();
void gfx_texCoordDisable();
void gfx_blendEnable();
void gfx_blendDisable();
void gfx_blendSetAlpha();
void gfx_blendSetAdditive();
void gfx_cullFacesEnable();
void gfx_cullFacesDisable();
void gfx_cullFacesSetFront();
void gfx_cullFacesSetBack();

void gfx_colorSet();
void gfx_colorSet(float pAlpha);
void gfx_colorSet(float pRed, float pGreen, float pBlue);
void gfx_colorSet(float pRed, float pGreen, float pBlue, float pAlpha);

void gfx_positionSetPointer(int pSize=2, unsigned int pOffset=0);
void gfx_texCoordSetPointer(int pSize=2, unsigned int pOffset=0);

FMatrix gfx_matrixProjectionGet();
FMatrix gfx_matrixModelViewGet();

void gfx_matrixProjectionSet(FMatrix pMatrix);
void gfx_matrixModelViewSet(FMatrix pMatrix);

void gfx_matrixProjectionReset();
void gfx_matrixModelViewReset();

void gfx_drawElementsTriangle(int pCount, unsigned int pOffset=0);

void gfx_depthEnable();
void gfx_depthDisable();
void gfx_depthClear();

void gfx_shaderAttachFragment(unsigned int pShaderIndex);
void gfx_shaderAttachVertex(unsigned int pShaderIndex);

unsigned int gfx_shaderCompile(const char *pShaderPath, GLenum pShaderType);
unsigned int gfx_shaderCompileVertex(const char *pShaderPath);
unsigned int gfx_shaderCompileFragment(const char *pShaderPath);

extern int gGLProgram;
extern int gGLProgramPrimitive;


//extern unsigned int gGLShaderFragmentTexture;
//extern unsigned int gGLShaderFragmentPrimitive;
//extern unsigned int gGLShaderVertexTexture;

extern unsigned int gGLBufferDepth;
extern unsigned int gGLBufferRender;

extern unsigned int gGLUniformProjection;
extern unsigned int gGLUniformModelView;
extern unsigned int gGLUniformTexture;
extern unsigned int gGLUniformColorModulate;

extern unsigned int gGLSlotPosition;
extern unsigned int gGLSlotTexCoord;
extern unsigned int gGLSlotNormal;

extern unsigned int gGLBufferQuad;
extern unsigned int gGLBufferTriangle;

extern FMatrix gGFXProjection;
extern FMatrix gGFXModelView;

#endif