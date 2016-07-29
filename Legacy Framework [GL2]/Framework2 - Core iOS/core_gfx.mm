#include "FModelData.h"//
//  core_gfx.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "core_os.h"
#include "core_gfx.h"
#include "stdafx.h"
#include "FFile.h"
#include "FSprite.h"
#include "FApp.h"

#import <GLKit/GLKit.h>

FSprite gSpriteBlank;

int gGLProgram = 0;
int gGLProgramPrimitive = 0;

//unsigned int gGLShaderFragmentTexture;
//unsigned int gGLShaderFragmentPrimitive;

//unsigned int gGLShaderVertexTexture;


unsigned int gGLBufferRender;

unsigned int gGLSlotPosition;
unsigned int gGLSlotTexCoord;
unsigned int gGLSlotColor;
unsigned int gGLSlotNormal;

unsigned int gGLUniformProjection;
unsigned int gGLUniformWorldView;

unsigned int gGLBufferDepth;

unsigned int gGLUniformTexture;

FMatrix gGFXProjection;
FMatrix gGFXWorldView;

unsigned int gGLBufferQuad;
unsigned int gGLBufferTriangle;

int gGLBlendMode = -1;
bool gGLBlendEnabled = false;

void gfx_preinitialize()
{
    //GLKMatrix4Add();
    
    //GLKMatrix4Transpose(<#GLKMatrix4 matrix#>)
    
    //gGLProgram = glCreateProgram();
    //printf("GL Program [%d]\n", gGLProgram);
}

void gfx_initialize()
{
    //We assume that we already have the depth and render buffers set up from the OS here...
    
    /*
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    if(!_context)
    {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if(![EAGLContext setCurrentContext:_context])
    {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    
    glGenRenderbuffers(1, &gGLBufferDepth);
    glBindRenderbuffer(GL_RENDERBUFFER, gGLBufferDepth);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    
    glGenRenderbuffers(1, &gGLBufferRender);
    glBindRenderbuffer(GL_RENDERBUFFER, gGLBufferRender);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    */
    
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, gGLBufferRender);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, gGLBufferDepth);

    
    gGLProgram = glCreateProgram();
    
    unsigned int aShaderFragment = gfx_shaderCompileFragment("FragmentShaderTexture.glsl");
    unsigned int aShaderVertex = gfx_shaderCompileVertex("VertexShaderTexture.glsl");
    
    glAttachShader(gGLProgram, aShaderFragment);
    glAttachShader(gGLProgram, aShaderVertex);
    
    glLinkProgram(gGLProgram);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(gGLProgram, GL_LINK_STATUS, &linkSuccess);
    if(linkSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetProgramInfoLog(gGLProgram, sizeof(messages), 0, &messages[0]);
        printf("%s\n", messages);
        exit(1);
    }
    

    /*
    gGLProgramPrimitive = glCreateProgram();
    
    aShaderFragment = gfx_shaderCompileFragment("FragmentShaderTexture.glsl");
    aShaderVertex = gfx_shaderCompileVertex("VertexShaderTexture.glsl");
    
    NSLog(@"Shader [2nd] Fr[%d] Ve[%d]", aShaderFragment, aShaderVertex);
    
    gfx_shaderAttachFragment(aShaderFragment);
    gfx_shaderAttachVertex(aShaderVertex);
    
    glLinkProgram(gGLProgramPrimitive);
    
    glGetProgramiv(gGLProgramPrimitive, GL_LINK_STATUS, &linkSuccess);
    if(linkSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetProgramInfoLog(gGLProgram, sizeof(messages), 0, &messages[0]);
        printf("%s\n", messages);
        exit(1);
    }
    
    */
    
    
    
    
    glUseProgram(gGLProgram);
    
    
    gGLSlotPosition = glGetAttribLocation(gGLProgram, "Position");
    gGLSlotTexCoord = glGetAttribLocation(gGLProgram, "TexCoordIn");
    gGLSlotColor = glGetAttribLocation(gGLProgram, "SourceColor");
    
    
    gGLUniformWorldView = glGetUniformLocation(gGLProgram, "WorldMatrix");
    gGLUniformTexture = glGetUniformLocation(gGLProgram, "Texture");
    
    //gGLSlotModulateColor
    
    gfx_matrixWorldViewReset();
    
    gGLBufferQuad = gfx_bufferVertexGenerate();
    gGLBufferTriangle = gfx_bufferVertexGenerate();
    
    glViewport(0, 0, gDeviceWidth, gDeviceHeight);
    
    gfx_colorSet();
    
    gSpriteBlank.Load("empty_white_square");

}

void gfx_clear()
{
    gfx_clear(0.0f, 0.0f, 0.0f);
}

void gfx_clear(float pRed, float pGreen, float pBlue, float pAlpha)
{
    glClearColor(pRed, pGreen, pBlue, pAlpha);
	glClear(GL_COLOR_BUFFER_BIT);
}

void gfx_clearDepth()
{
    glClear(GL_DEPTH_BUFFER_BIT);
}


void gfx_positionEnable()
{
    glEnableVertexAttribArray(gGLSlotPosition);
}

void gfx_positionDisable()
{
    glDisableVertexAttribArray(gGLSlotPosition);
}

void gfx_texCoordEnable()
{
    glEnableVertexAttribArray(gGLSlotTexCoord);
}

void gfx_texCoordDisable()
{
    glDisableVertexAttribArray(gGLSlotTexCoord);
}

void gfx_colorEnable()
{
    glEnableVertexAttribArray(gGLSlotColor);
}

void gfx_colorDisable()
{
    glDisableVertexAttribArray(gGLSlotColor);
}

void gfx_blendEnable()
{
    if(gGLBlendEnabled == false)
    {
        gRenderQueue.RenderDump();
        glEnable(GL_BLEND);
        gGLBlendEnabled = true;
    }
}

void gfx_blendDisable()
{
    if(gGLBlendEnabled == true)
    {
        gRenderQueue.RenderDump();
        glDisable(GL_BLEND);
        gGLBlendEnabled = false;
    }
}

void gfx_blendSetAlpha()
{
    if(gGLBlendMode != 0)
    {
        gRenderQueue.RenderDump();
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        gGLBlendMode = 0;
    }
    
}

void gfx_blendSetAdditive()
{
    if(gGLBlendMode != 1)
    {
        gRenderQueue.RenderDump();
        glBlendFunc(GL_SRC_ALPHA,GL_ONE);
        gGLBlendMode = 1;
    }
}

void gfx_cullFacesEnable()
{
    glEnable(GL_CULL_FACE);
}

void gfx_cullFacesDisable()
{
    glDisable(GL_CULL_FACE);
}

void gfx_cullFacesSetFront()
{
    glCullFace(GL_FRONT);
}

void gfx_cullFacesSetBack()
{
    glCullFace(GL_BACK);
}


void gfx_colorSet()
{
    gfx_colorSet(1.0f, 1.0f, 1.0f, 1.0f);
}

void gfx_colorSet(float pAlpha)
{
    gfx_colorSet(1.0f, 1.0f, 1.0f, pAlpha);
}

void gfx_colorSet(float pRed, float pGreen, float pBlue)
{
    gfx_colorSet(pRed, pGreen, pBlue, 1.0f);
}

void gfx_colorSet(float pRed, float pGreen, float pBlue, float pAlpha)
{
    gRenderQueue.mRed = pRed;
    gRenderQueue.mGreen = pGreen;
    gRenderQueue.mBlue = pBlue;
    gRenderQueue.mAlpha = pAlpha;
    
    //glUniform4f(gGLUniformColorModulate, pRed, pGreen, pBlue, pAlpha);
}

void gfx_colorSetSwatch(int pColorIndex)
{
    
    if(pColorIndex == 0      )gfx_colorSet(1.0f, 0.0f, 0.0f);
    else if(pColorIndex == 1 )gfx_colorSet(0.0f, 1.0f, 0.0f);
    else if(pColorIndex == 2 )gfx_colorSet(0.0f, 0.0f, 1.0f);
    else if(pColorIndex == 3 )gfx_colorSet(1.0f, 0.5f, 0.0f);
    else if(pColorIndex == 4 )gfx_colorSet(0.0f, 1.0f, 0.5f);
    else if(pColorIndex == 5 )gfx_colorSet(0.5f, 0.0f, 1.0f);
    else if(pColorIndex == 6 )gfx_colorSet(1.0f, 0.0f, 0.5f);
    else if(pColorIndex == 7 )gfx_colorSet(0.5f, 1.0f, 0.0f);
    else if(pColorIndex == 8 )gfx_colorSet(0.0f, 0.5f, 1.0f);
    else if(pColorIndex == 9 )gfx_colorSet(1.0f, 0.5f, 1.0f);
    
    else if(pColorIndex == 10)gfx_colorSet(1.0f, 1.0f, 0.5f);
    else if(pColorIndex == 11)gfx_colorSet(0.5f, 1.0f, 1.0f);
    else if(pColorIndex == 12)gfx_colorSet(1.0f, 1.0f, 0.5f);
    else if(pColorIndex == 13)gfx_colorSet(0.5f, 1.0f, 1.0f);
    else if(pColorIndex == 14)gfx_colorSet(1.0f, 0.5f, 1.0f);
    else if(pColorIndex == 15)gfx_colorSet(0.5f, 0.5f, 0.5f);
    else if(pColorIndex == 16)gfx_colorSet(1.0f, 1.0f, 1.0f);
    else                      gfx_colorSet(0.0f, 0.0f, 0.0f);
    
}

void gfx_colorSet(FColor pColor)
{
    gfx_colorSet(pColor.mRed, pColor.mGreen, pColor.mBlue, pColor.mAlpha);
}

void gfx_drawQuad(float x1, float y1,float x2, float y2,float x3, float y3,float x4, float y4)
{
    gSpriteBlank.mBufferVertex[0]=x1;
	gSpriteBlank.mBufferVertex[1]=y1;
	gSpriteBlank.mBufferVertex[2]=x2;
	gSpriteBlank.mBufferVertex[3]=y2;
	gSpriteBlank.mBufferVertex[4]=x3;
	gSpriteBlank.mBufferVertex[5]=y3;
	gSpriteBlank.mBufferVertex[6]=x4;
	gSpriteBlank.mBufferVertex[7]=y4;
    
    //gfx_bufferVertexSetData(gSpriteBlank.mBufferSlotVertex, gSpriteBlank.mBufferVertex, 16);
    //gSpriteBlank.Draw();
    
    gRenderQueue.EnqueueQuad(x1, y1, x2, y2, x3, y3, x4, y4, gSpriteBlank.mBindIndex);
    
    /*
    gfx_positionEnable();
    gfx_positionSetPointer(2, 0);
    //gfx_texCoordDisable();
    
    gfx_bindTexture(gSpriteBlank.mBindIndex);
    
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    */
}

void gfx_drawPoint(float pX, float pY, float pSize)
{
    gfx_drawRect(pX - pSize / 2.0f, pY - pSize / 2.0f, pSize, pSize);
}

void gfx_drawRect(float x, float y, float pWidth, float pHeight)
{
	gfx_drawQuad(x,y,x+pWidth,y,x,y+pHeight,x+pWidth,y+pHeight);
}

void gfx_drawRect(FRect pRect)
{
    gfx_drawRect(pRect.mX, pRect.mY, pRect.mWidth, pRect.mHeight);
}


void gfx_drawLine(float x1, float y1, float x2, float y2, float pThickness)
{
	float aDirX = x2 - x1;
	float aDirY = y2 - y1;
	
	float aDist = sqrtf((aDirX*aDirX) + (aDirY*aDirY));
	
	aDirX /= aDist;
	aDirY /= aDist;
	
	float aHold = aDirX;
	aDirX=-aDirY;
	aDirY=aHold;
	
	aDirX*=pThickness;
	aDirY*=pThickness;
    
	gfx_drawQuad(x1-aDirX,y1-aDirY,x1+aDirX,y1+aDirY,x2-aDirX,y2-aDirY,x2+aDirX,y2+aDirY);
}


int gfx_generateTexture(unsigned int *pData, int pWidth, int pHeight)
{
    int aBindIndex=-1;
    
    glGenTextures(1, (GLuint*)(&aBindIndex));
    
    if(aBindIndex == -1)
    {
        printf("Error Binding Texture [%d x %d]\n", pWidth, pHeight);
    }
    else
    {
        gfx_bindTexture(aBindIndex, pData, pWidth, pHeight);
    }
    
    return aBindIndex;
}

void gfx_deleteTexture(int pIndex)
{
    glDeleteTextures(1, (GLuint*)(&(pIndex)));
}

void gfx_bindTexture(int pIndex, unsigned int *pData, int pWidth, int pHeight)
{
    gfx_bindTexture(pIndex);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, pWidth, pHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData);
}

void gfx_bindTexture(int pIndex)
{
    glBindTexture(GL_TEXTURE_2D, pIndex);
}


void gfx_bufferVertexBind(unsigned int pIndex)
{
    glBindBuffer(GL_ARRAY_BUFFER, pIndex);
}

void gfx_bufferIndexBind(unsigned int pIndex)
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, pIndex);
}


unsigned int gfx_bufferVertexGenerate(float *pData, int pSize)
{
    /*unsigned int aReturn = 0;
    glGenBuffers(1, &aReturn);
    glBindBuffer(GL_ARRAY_BUFFER, aReturn);
    glBufferData(GL_ARRAY_BUFFER, pSize * 4, pData, GL_STATIC_DRAW);
    return aReturn;*/
    
    unsigned int aReturn = gfx_bufferVertexGenerate();
    gfx_bufferVertexSetData(aReturn, pData, pSize);
    return aReturn;
}

unsigned int gfx_bufferVertexGenerate()
{
    unsigned int aReturn = 0;
    glGenBuffers(1, &aReturn);
    return aReturn;
}

void gfx_bufferVertexSetData(unsigned int pBufferIndex, float *pData, int pSize)
{
    glBindBuffer(GL_ARRAY_BUFFER, pBufferIndex);
    glBufferData(GL_ARRAY_BUFFER, pSize * 4, pData, GL_STATIC_DRAW);
}

unsigned int gfx_bufferIndexGenerate(GFX_MODEL_INDEX_TYPE *pData, int pSize)
{
    unsigned int aReturn = gfx_bufferIndexGenerate();
    gfx_bufferIndexSetData(aReturn, pData, pSize);
    return aReturn;
}

unsigned int gfx_bufferIndexGenerate()
{
    unsigned int aReturn = 0;
    glGenBuffers(1, &aReturn);
    return aReturn;
}

void gfx_bufferIndexSetData(unsigned int pBufferIndex, GFX_MODEL_INDEX_TYPE *pData, int pSize)
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, pBufferIndex);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, pSize * sizeof(GL_ELEMENT_ARRAY_BUFFER), pData, GL_STATIC_DRAW);
}

void gfx_bufferDelete(unsigned int pIndex)
{
    if(pIndex != 0)
    {
        glDeleteBuffers(1, (unsigned int *)(&(pIndex)));
    }
}

void gfx_positionSetPointer(int pSize, unsigned int pOffset, unsigned int pStride)
{
    glVertexAttribPointer(gGLSlotPosition, pSize, GL_FLOAT, GL_FALSE, (pStride << 2), (GLvoid*)(pOffset << 2));
}

void gfx_texCoordSetPointer(int pSize, unsigned int pOffset, unsigned int pStride)
{
    glVertexAttribPointer(gGLSlotTexCoord, pSize, GL_FLOAT, GL_FALSE, (pStride << 2), (GLvoid*)(pOffset << 2));
}

void gfx_colorSetPointer(unsigned int pOffset, unsigned int pStride)
{
    glVertexAttribPointer(gGLSlotColor, 4, GL_FLOAT, GL_FALSE, (pStride << 2), (GLvoid*)(pOffset << 2));
}

void gfx_drawElementsTriangle(int pCount, unsigned int pOffset)
{
    glDrawElements(GL_TRIANGLES, pCount, GFX_MODEL_INDEX_GL_TYPE, (GLvoid*)(pOffset << 1));
}



FMatrix gfx_matrixWorldViewGet()
{
    return gGFXWorldView;
}

void gfx_matrixWorldViewSet(FMatrix pMatrix)
{
    gRenderQueue.RenderDump();
    gGFXWorldView = pMatrix;
    glUniformMatrix4fv(gGLUniformWorldView, 1, 0, gGFXWorldView.m);
}

void gfx_matrixWorldViewReset()
{
    gRenderQueue.RenderDump();
    gGFXWorldView.Reset();
    glUniformMatrix4fv(gGLUniformWorldView, 1, 0, gGFXWorldView.m);
}

void gfx_depthEnable()
{
    glEnable(GL_DEPTH_TEST);
}

void gfx_depthDisable()
{
    glDisable(GL_DEPTH_TEST);
}

void gfx_depthClear()
{
    glClear(GL_DEPTH_BUFFER_BIT);
}

void gfx_shaderAttachFragment(unsigned int pShaderIndex)
{
    glAttachShader(gGLProgram, pShaderIndex);
}

void gfx_shaderAttachVertex(unsigned int pShaderIndex)
{
    glAttachShader(gGLProgram, pShaderIndex);
}


unsigned int gfx_shaderCompile(const char *pShaderPath, GLenum pShaderType)
{
    unsigned int aShader = 0;
    FFile aFile;
    aFile.Load(pShaderPath);
    if(aFile.mLength > 0)
    {
        aShader = glCreateShader(pShaderType);
        const char *aData = (const char*)(aFile.mData);
        int aLength = (int)aFile.mLength;
        glShaderSource(aShader, 1, &aData, &(aLength));
        glCompileShader(aShader);
        int aCompileSuccess;
        glGetShaderiv(aShader, GL_COMPILE_STATUS, &aCompileSuccess);
        if(aCompileSuccess == GL_FALSE)
        {
            GLchar aErrorMessage[1024];
            glGetShaderInfoLog(aShader, sizeof(aErrorMessage), 0, &aErrorMessage[0]);
            printf("Shader Error!\n");
            printf("%s", aErrorMessage);
        }
    }
    return aShader;
}

unsigned int gfx_shaderCompileVertex(const char *pShaderPath)
{
    return gfx_shaderCompile(pShaderPath, GL_VERTEX_SHADER);
}

unsigned int gfx_shaderCompileFragment(const char *pShaderPath)
{
    return gfx_shaderCompile(pShaderPath, GL_FRAGMENT_SHADER);
}



/*
 
void Graphics::UnbindTexture()
{
    glDisable(GL_TEXTURE_2D);
}

void Graphics::EnableTexture()
{
    glEnable(GL_TEXTURE_2D);
}

void Graphics::DisableTexture()
{
    glDisable(GL_TEXTURE_2D);
}
*/


