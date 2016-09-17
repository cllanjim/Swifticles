
//
//  FFont.h
//  CrazyDartsArc
//
//  Created by Nick Raptis on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
//

#ifndef FONT_DRAW_H
#define FONT_DRAW_H

#include "FSprite.h"

class FFont
{
public:
    
    FFont();
    ~FFont();
    
    //char                *mData;
    //int                 mSize;
    //int                 mWriteIndex;
    
    float               mMaxWidth;
    float               mMaxHeight;
    
    FString             mPrefix;
    
    FSprite             mSprite[256];
    float               mSpacingBefore[256];
    float               mSpacingAfter[256];
    
    //void                Write(const char *pText);
    //void                WriteNumber(int pNumber);
    
    void                Draw(const char *pText, float pX, float pY);
    void                Right(const char *pText, float pX, float pY);
    void                Center(const char *pText, float pX, float pY);
    void                Center(const char *pText, float pX, float pY, float pScale);
    
    void                Draw(FString pText, float pX, float pY){Draw((const char *)pText.c(), pX, pY);}
    void                Right(FString pText, float pX, float pY){Right((const char *)pText.c(), pX, pY);}
    void                Center(FString pText, float pX, float pY){Center((const char *)pText.c(), pX, pY);}
    void                Center(FString pText, float pX, float pY, float pScale){Center((const char *)pText.c(), pX, pY, pScale);}
    
    float               Width(const char *pText);
    
    void                PadLength(int pLengthPad);
    
    float               mVerticalHeight;
    float               mVerticalSpacing;
    
    void                LoadRange(char pStart, char pEnd, const char *pFilePrefix);
    
    void                LoadAlphaNumeric(const char *pFilePrefix);
    
    void                Load(char *pCharacters, const char *pFilePrefix=0);
    
};

#endif








