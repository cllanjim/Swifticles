//
//  FApp.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FApp.h"

FRandomizer gRand;
FRenderQueue gRenderQueue;

FApp *gAppBase;

FApp::FApp()
{
    printf("FApp Created!\n");
    
    gAppBase = this;
    
    mBindList = 0;
	mBindCountList = 0;
	mBindListSize = 0;
	mBindListCount = 0;
    
    mTransition = 0;
    mTransitionToView = 0;
    mTransitionFromView = 0;
    
    
    //printf("SizeOf Model Type = [%d]", sizeof(GFX_MODEL_INDEX_TYPE) );
    
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
    
    
    
    mPopoverViewCurrent = 0;
    if(mPopoverViews.mCount > 0)
    {
        EnumList(FView, aView, mPopoverViews)
        {
            aView->BaseUpdate();
            if(aView->mKill)
            {
                mPopoverViewsKill.Add(aView);
            }
            else
            {
                mPopoverViewCurrent = aView;
            }
        }
    }
    EnumList(FView, aView, mPopoverViewsKill)
    {
        mPopoverViews.Remove(aView);
        aView->mKill--;
        if(aView->mKill <= 0)
        {
            mPopoverViewsDelete.Add(aView);
        }
    }
    EnumList(FView, aView, mPopoverViewsDelete)
    {
        mPopoverViewsKill.Remove(aView);
        delete aView;
    }
    mPopoverViewsDelete.RemoveAll();
    
    
    
    
    if(mTransition)
    {
        if(mTransition->mKill == 0)
        {
            mTransition->Update();
        }
        else
        {
            mTransition->mKill--;
            if(mTransition->mKill <= 0)
            {
                delete mTransition;
                mTransition = 0;
            }
        }
    }
}

void FApp::BaseDraw()
{
    Draw();
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseDraw();
    }
    
    gRenderQueue.RenderDump();
    
}

void FApp::BaseDrawOver()
{
    DrawOver();
    
    EnumList(FView, aView, mViews)
    {
        aView->BaseDrawOver();
    }
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseDraw();
        //mPopoverViewCurrent->DrawOver();
    }
    
    if(mTransition)
    {
        if(mTransition->mKill == 0)
        {
            mTransition->Draw();
        }
    }
    
    gRenderQueue.RenderDump();
}

void FApp::BaseMouseDown(float pX, float pY)
{
    MouseDown(pX, pY);
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseMouseDown(pX, pY);
    }
    else
    {
        EnumList(FView, aView, mViews)
        {
            aView->BaseMouseDown(pX, pY);
        }
    }
}

void FApp::BaseMouseUp(float pX, float pY)
{
    MouseUp(pX, pY);
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseMouseUp(pX, pY);
    }
    else
    {
        EnumList(FView, aView, mViews)
        {
            aView->BaseMouseUp(pX, pY);
        }
    }
}

void FApp::BaseMouseMove(float pX, float pY)
{
    MouseMove(pX, pY);
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseMouseMove(pX, pY);
    }
    else
    {
        EnumList(FView, aView, mViews)
        {
            aView->BaseMouseMove(pX, pY);
        }
    }
}

void FApp::BaseTouchDown(float pX, float pY, void *pData)
{
    TouchDown(pX, pY, pData);
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseTouchDown(pX, pY, pData);
    }
    else
    {
        EnumList(FView, aView, mViews)
        {
            aView->BaseTouchDown(pX, pY, pData);
        }
    }
}

void FApp::BaseTouchUp(float pX, float pY, void *pData)
{
    TouchUp(pX, pY, pData);
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseTouchUp(pX, pY, pData);
    }
    else
    {
        EnumList(FView, aView, mViews)
        {
            aView->BaseTouchUp(pX, pY, pData);
        }
    }
}

void FApp::BaseTouchMove(float pX, float pY, void *pData)
{
    TouchMove(pX, pY, pData);
    
    if(mPopoverViewCurrent)
    {
        mPopoverViewCurrent->BaseTouchMove(pX, pY, pData);
    }
    else
    {
        EnumList(FView, aView, mViews)
        {
            aView->BaseTouchMove(pX, pY, pData);
        }
    }
}

void FApp::BaseTouchFlush()
{
    TouchFlush();
    
    EnumList(FView, aView, mPopoverViews)
    {
        aView->BaseTouchFlush();
    }
    
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
	
	delete [] mBindList;
	mBindList = 0;
	
	delete [] mBindCountList;
	mBindCountList = 0;
	
	mBindListSize = 0;
	mBindListCount = 0;
}


void FApp::ViewAdd(FView *pView)
{
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


void FApp::PopoverViewAdd(FView *pView)
{
    if(pView)
    {
        mPopoverViews.Add(pView);
    }
}


void FApp::TransitionTo(FView *pToView, FView *pFromView, FTransition *pTransition)
{
    mTransitionToView = pToView;
    mTransitionFromView = pFromView;
    if(pFromView == 0)
    {
        EnumListReverse(FView, aView, mViews)
        {
            if((aView->mKill == 0) && (pFromView ==0))
            {
                mTransitionFromView = aView;
                printf("From View Auto Set To [%s]\n", mTransitionFromView->mName.c());
            }
        }
    }
    
    if(pTransition == 0)
    {
        pTransition = new FTransition();
    }
    
    mTransition = pTransition;
}

void FApp::TransitionSwapViews()
{
    if(mTransitionToView)
    {
        ViewAdd(mTransitionToView);
    }
    
    if(mTransitionFromView)
    {
        printf("Killing View[%s]\n", mTransitionFromView->mName.c());
        mTransitionFromView->Kill();
    }
    
    if(true)
    {
        EnumList(FView, aView, mPopoverViews)
        {
            aView->Kill();
        }
    }
    
    mTransitionToView = 0;
    mTransitionFromView = 0;
}


