//
//  FApp.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#include "FApp.h"



FRandomizer gRand;

FApp *gAppBase;

FApp::FApp()
{
    gAppBase = this;
    
    mBindList = 0;
	mBindCountList = 0;
	mBindListSize = 0;
	mBindListCount = 0;
}

FApp::~FApp()
{
    
}

void FApp::BaseUpdate()
{
    Update();
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseUpdate();
        
        if(aView->mKill)
        {
            mViewsKill.Add(aView);
        }
    }
    
    EnumList(FView, aView, mViewsKill)
    {
        mViews.Remove(aView);
        aView->mKill--;
        if(aView->mKill <= 0)
        {
            mViewsDelete.Add(aView);
        }
    }
    
    EnumList(FView, aView, mViewsDelete)
    {
        mViewsKill.Remove(aView);
        delete aView;
    }
    
    mViewsDelete.RemoveAll();
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseUpdate();
    }
}

void FApp::BaseDraw()
{
    Draw();
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseDraw();
    }
}

void FApp::BaseMouseDown(float pX, float pY)
{
    MouseDown(pX, pY);
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseMouseDown(pX, pY);
    }
}

void FApp::BaseMouseUp(float pX, float pY)
{
    MouseUp(pX, pY);
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseMouseUp(pX, pY);
    }
}

void FApp::BaseMouseMove(float pX, float pY)
{
    MouseMove(pX, pY);
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseMouseMove(pX, pY);
    }
}

void FApp::BaseTouchDown(float pX, float pY, void *pData)
{
    TouchDown(pX, pY, pData);
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseTouchDown(pX, pY, pData);
    }
}

void FApp::BaseTouchUp(float pX, float pY, void *pData)
{
    TouchUp(pX, pY, pData);
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseTouchUp(pX, pY, pData);
    }
}

void FApp::BaseTouchMove(float pX, float pY, void *pData)
{
    TouchMove(pX, pY, pData);
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseTouchMove(pX, pY, pData);
    }
}

void FApp::BaseTouchFlush()
{
    TouchFlush();
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseTouchFlush();
    }
}

void FApp::BaseInactive()
{
    BaseTouchFlush();
    Inactive();
    
}

void FApp::BaseActive()
{
    Active();
}

void FApp::BindListPrint()
{
	//printf("BindList[Count=%d Size=%d]={\n", mBindListCount, mBindListSize);
	for(int i=0;i<mBindListCount;i++)
	{
		//printf("[c:%d i:%d]", mBindCountList[i], mBindList[i]);
		if(i < mBindListCount - 1)printf(", ");
	}
}

void FApp::BindAdd(int pIndex)
{
	for(int i=0;i<mBindListCount;i++)
	{
		if(mBindList[i] == pIndex)
		{
			mBindCountList[i]++;
			return;
		}
	}
    
	if(mBindListCount == mBindListSize)
	{
		mBindListSize = mBindListSize + mBindListSize / 2 + 1;
		int *aNewBindList = new int[mBindListSize];
		for(int i=0;i<mBindListCount;i++)
		{
			aNewBindList[i]=mBindList[i];
		}
		delete[]mBindList;
		mBindList=aNewBindList;
		
		int *aNewBindCountList = new int[mBindListSize];
		for(int i=0;i<mBindListCount;i++)
		{
			aNewBindCountList[i]=mBindCountList[i];
		}
        
		delete[]mBindCountList;
		mBindCountList = aNewBindCountList;
    }
    
	mBindList[mBindListCount] = pIndex;
	mBindCountList[mBindListCount] = 1;
	mBindListCount++;
}

void FApp::BindRemove(int pIndex)
{
	int aSlot = -1;
	
	for(int i=0;i<mBindListCount;i++)
	{
		if(mBindList[i] == pIndex)
		{
			aSlot=i;
			break;
		}
	}
    
	if(aSlot != -1)
	{
		mBindCountList[aSlot]--;
		if(mBindCountList[aSlot] <= 0)
		{
            gfx_deleteTexture(pIndex);
            
			int aCap = mBindListCount-1;
			
			for(int i=aSlot;i<aCap;i++)
			{
				mBindList[i]=mBindList[i+1];
				mBindCountList[i]=mBindCountList[i+1];
			}
			mBindListCount--;
		}
	}
}

void FApp::BindPurgeAll()
{
	BindListPrint();
    
	for(int i=0;i<mBindListCount;i++)
    {
        gfx_deleteTexture(mBindList[i]);
    }
	
	delete[]mBindList;
	mBindList=0;
	
	delete[]mBindCountList;
	mBindCountList=0;
	
	mBindListSize=0;
	mBindListCount=0;
}


void FApp::ViewAdd(FView *pView)
{
    printf("Adding View!\n");
    mViews.Add(pView);
}

void FApp::ViewSendBack(FView *pView)
{
    mViews.MoveToBack(pView);
}

void FApp::ViewSendFront(FView *pView)
{
    mViews.MoveToFront(pView);
}
