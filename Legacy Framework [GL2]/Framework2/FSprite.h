//
//  FSprite.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/2/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef CoreDemo_FSprite_h
#define CoreDemo_FSprite_h

#include "core_gfx.h"
#include "FString.h"

class FImage;

class FSprite
{
public:
    
    FSprite();
    virtual ~FSprite();
    
    void                            Kill();
    
    void                            Load(const char *pFileName);

    inline void                     Load(char *pFileName){Load((const char*)pFileName);}
    inline void                     Load(FString pFileName){Load((const char*)(pFileName.c()));}
    void                            Load(FImage *pImage);
    void                            Load(FImage *pImage, int pX, int pY, int pWidth, int pHeight);
    
    
    bool                            DidLoad();
    
    float                           mBufferVertex[16];
    GFX_MODEL_INDEX_TYPE            mBufferIndex[6];
    
    float                           mWidth;
    float                           mHeight;
    
    float                           mWidth2;
    float                           mHeight2;
    
    int                             mBindIndex;
    
    void                            Center(float pX, float pY);
    
    void                            Draw();
    void                            Draw(float pX, float pY);
    void                            DrawScaled(float pX, float pY, float pScale);
    void                            DrawScaled(float pX, float pY, float pScaleX, float pScaleY);
    void                            DrawRotated(float pX, float pY, float pRotation);
    void                            Draw(float pX, float pY, float pRotation, float pScale=1.0f);
    
    
    //void                          DrawPercent
    
    inline float                    GetStartU(){return mBufferVertex[8 + 0];}
	inline float                    GetStartV(){return mBufferVertex[8 + 1];}
	inline float                    GetEndU(){return mBufferVertex[8 + 6];}
	inline float                    GetEndV(){return mBufferVertex[8 + 7];}
    
    inline float                    GetStartX(){return mBufferVertex[0];}
	inline float                    GetStartY(){return mBufferVertex[1];}
	inline float                    GetEndX(){return mBufferVertex[6];}
	inline float                    GetEndY(){return mBufferVertex[7];}
    
    
    void                            SetStartU(float pU){mBufferVertex[8 + 0]=pU;mBufferVertex[8 + 4]=pU;}
	void                            SetStartV(float pV){mBufferVertex[8 + 1]=pV;mBufferVertex[8 + 3]=pV;}
	void                            SetEndU(float pU){mBufferVertex[8 + 6]=pU;mBufferVertex[8 + 2]=pU;}
	void                            SetEndV(float pV){mBufferVertex[8 + 7]=pV;mBufferVertex[8 + 5]=pV;}
    
    void                            SetStartX(float pX){mBufferVertex[0]=pX;mBufferVertex[4]=pX;}
	void                            SetStartY(float pY){mBufferVertex[1]=pY;mBufferVertex[3]=pY;}
	void                            SetEndX(float pX){mBufferVertex[6]=pX;mBufferVertex[2]=pX;}
	void                            SetEndY(float pY){mBufferVertex[7]=pY;mBufferVertex[5]=pY;}
    
    
};

#endif
