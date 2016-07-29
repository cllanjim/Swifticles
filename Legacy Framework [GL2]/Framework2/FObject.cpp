//
//  FObject.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/19/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FObject.h"


FObject::FObject()
{
    mKill = 0;
}

FObject::~FObject()
{
    
}

void FObject::Kill()
{
    mKill = 5;
}