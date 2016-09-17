//
//  FObjectList.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/19/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_OBJECT_LIST_H
#define FRAMEWORK_OBJECT_LIST_H

#include "FObject.h"
#include "FList.h"

class FObjectList
{
public:
    
    FObjectList();
    virtual ~FObjectList();
    
    void                                    Add(FObject *pObject);
    void                                    Remove(FObject *pObject);
    
    void                                    Update();
    void                                    Draw();
    
    void                                    KillAll();
    
    FList                                   mObjects;
    FList                                   mObjectsKill;
    FList                                   mObjectsDelete;
    
};

#endif
