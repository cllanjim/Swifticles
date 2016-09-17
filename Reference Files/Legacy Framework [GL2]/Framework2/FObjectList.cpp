//
//  FObjectList.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/19/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FObjectList.h"


FObjectList::FObjectList()
{
    
}

FObjectList::~FObjectList()
{
    FreeList(FObject, mObjects);
    FreeList(FObject, mObjectsKill);
    FreeList(FObject, mObjectsDelete);
}

void FObjectList::Add(FObject *pObject)
{
    if(pObject)
    {
        mObjects.Add(pObject);
    }
}

void FObjectList::Remove(FObject *pObject)
{
    mObjects.Remove(pObject);
    mObjectsKill.Remove(pObject);
    mObjectsDelete.Remove(pObject);
}

void FObjectList::Update()
{
    
    EnumList(FObject, aObject, mObjects)
    {
        if(aObject->mKill == false)
        {
            aObject->Update();
            if(aObject->mKill)
            {
                mObjectsKill.Add(aObject);
            }
        }
    }
    
    EnumList(FObject, aObject, mObjectsKill)
    {
        mObjects.Remove(aObject);
        aObject->mKill--;
        if(aObject->mKill <= 0)
        {
            mObjectsDelete.Add(aObject);
        }
    }
    
    EnumList(FObject, aObject, mObjectsDelete)
    {
        mObjectsKill.Remove(aObject);
        delete aObject;
    }
    
    mObjectsDelete.RemoveAll();
}

void FObjectList::Draw()
{
    EnumList(FObject, aObject, mObjects)
    {
        if(aObject->mKill == false)
        {
            aObject->Draw();
        }
    }
}

void FObjectList::KillAll()
{
    EnumList(FObject, aObject, mObjects)
    {
        aObject->Kill();
        mObjectsKill.Add(aObject);
    }
    mObjects.RemoveAll();
}
