//
//  CoinObject.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/16/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef __CoreDemo__CoinObject__
#define __CoreDemo__CoinObject__

#include "MainApp.h"

class CoinObject
{
public:
    
    CoinObject();
    ~CoinObject();
    
    void                Update();
    void                Draw();
    
    
    float               mX;
    float               mY;
    float               mZ;
    
    float               mRotX;
    float               mRotY;
    float               mRotZ;
    
    float               mRotXSpeed;
    float               mRotYSpeed;
    float               mRotZSpeed;
    
    float               mScale;
};



#endif /* defined(__CoreDemo__CoinObject__) */
