//
//  FObject.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/19/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_OBJECT_H
#define FRAMEWORK_OBJECT_H

class FObject
{
public:
    
    FObject();
    virtual ~FObject();
    
    virtual void                            Update(){}
    virtual void                            Draw(){}
    
    void                                    Kill();
    int                                     mKill;
};

#endif
