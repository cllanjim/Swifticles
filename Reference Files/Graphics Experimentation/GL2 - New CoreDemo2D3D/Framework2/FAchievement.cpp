/*
 *  FAchievement.cpp
 *  Darts
 *
 *  Created by Nick Raptis on 11/30/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "FAchievement.h"
#include "stdafx.h"
#include "core_os.h"

FAchievement::FAchievement(const char *pName, int pProgressMax)
{
    SetUp(pName, pProgressMax);
}

FAchievement::FAchievement()
{
    SetUp((const char *)0, 1);
}

void FAchievement::SetUp(const char *pName, int pProgressMax)
{
    mName = pName;
    
    mProgressMax = pProgressMax;
    
	mCompletedThisUpdate = false;
	mAutoResetsOnLevelUp = false;
	mAutoResetsOnGameOver = false;
	mAutoResetsOnAction = false;
	
	mAutoResetsActionId = -1;
	mProgress = 0;
	mProgressSaved = 0;
	
	mPosted = false;
	mComplete = false;
    
	mName = pName;
	mProgress = 0;
	mProgressMax = pProgressMax;
}

FAchievement::~FAchievement()
{
    
}

void FAchievement::ResetProgress()
{
	mProgress = 0;
	mProgressSaved = 0;
}

void FAchievement::Load(FFile *pFile)
{
	if(pFile)
	{
		mProgress=pFile->ReadInt();
		mProgressMax=pFile->ReadInt();
		mAutoResetsActionId=pFile->ReadInt();
		mProgressSaved=pFile->ReadInt();
		
		mComplete=pFile->ReadBool();
		mCompletedThisUpdate=pFile->ReadBool();
		mPosted=pFile->ReadBool();
		mAutoResetsOnLevelUp=pFile->ReadBool();
		mAutoResetsOnGameOver=pFile->ReadBool();
		mAutoResetsOnAction=pFile->ReadBool();
        
        mName=pFile->ReadString();
	}
}

void FAchievement::Print()
{
	printf("%s: complete: %d (%d/%d) posted: %d\n", mName.c(), mComplete, mProgress, mProgressMax, mPosted);
}

void FAchievement::Save(FFile *pFile)
{
	if(pFile)
	{
		pFile->WriteInt(mProgress);
		pFile->WriteInt(mProgressMax);
		pFile->WriteInt(mAutoResetsActionId);
		pFile->WriteInt(mProgressSaved);
		
		pFile->WriteBool(mComplete);
		pFile->WriteBool(mCompletedThisUpdate);
		pFile->WriteBool(mPosted);
		pFile->WriteBool(mAutoResetsOnLevelUp);
		pFile->WriteBool(mAutoResetsOnGameOver);
		pFile->WriteBool(mAutoResetsOnAction);
        
        pFile->WriteString(mName);
	}
}

bool FAchievement::AddProgress(int pProgress)
{
	if(mProgress<mProgressMax)
	{
		mProgress+=pProgress;
		if(mProgress>mProgressMax)mProgress=mProgressMax;
		if(mProgress<0)mProgress=0;
		if(mProgress==mProgressMax)
		{
            //TODO: Hmmm??
            /*
			if(gApp)
			{
				gApp->DisplayFAchievement(this);
			}
            */
			mComplete=true;
			return true;
		}
	}
	else
	{
		mProgress=mProgressMax;
	}
	
	return false;
}

/////////////////////////
/////////////////////////
/////////////////////////


FAchievementGroup::FAchievementGroup(const char *pGroupName)
{
    mGroupName = pGroupName;
}

FAchievementGroup::~FAchievementGroup()
{
    
}

void FAchievementGroup::AddProgress(FList *pBubbleFList, int pProgress)
{
    EnumList(FAchievement, aFAchievement, mFAchievementFList)
    {
        if(aFAchievement->AddProgress(pProgress))
        {
            //printf("FAchievement Complete [%s]\n\n", aFAchievement->mName.c());
            
            if(pBubbleFList)
            {
                pBubbleFList->Add(aFAchievement);
            }
            
        }
    }
}

void FAchievementGroup::Add(const char *pFAchievementName, int pProgressMax)
{
    FAchievement *aFAchievement = 0;
    EnumList(FAchievement, aCheck, mFAchievementFList)
    {
        if(aCheck->mName == pFAchievementName)
        {
            aFAchievement = aCheck;
        }
    }
    if(aFAchievement == 0)
    {
        aFAchievement = new FAchievement(pFAchievementName, pProgressMax);
        mFAchievementFList += aFAchievement;
    }
    else
    {
        aFAchievement->mProgressMax = pProgressMax;
    }
}

/////////////////////////
/////////////////////////
/////////////////////////


FAchievementManager::FAchievementManager()
{
    
}

FAchievementManager::~FAchievementManager()
{
    Reset();
}

void FAchievementManager::LevelUp()
{
	
}

void FAchievementManager::GameOver()
{
	
}

void FAchievementManager::PerformAction(int pAction)
{
	
}


FAchievement *FAchievementManager::GetFAchievement(const char *pName)
{
    FAchievement *aReturn=0;
    
    EnumList(FAchievement, aFAchievement, mFAchievementFList)
    {
        if(aFAchievement->mName == pName)
        {
            aReturn = aFAchievement;
        }
    }
    
    if(aReturn == 0)
    {
        EnumList(FAchievementGroup, aGroup, mFAchievementGroupFList)
        {
            EnumList(FAchievement, aFAchievement, aGroup->mFAchievementFList)
            {
                if(aFAchievement->mName == pName)
                {
                    aReturn = aFAchievement;
                }
            }
        }
    }
    
	return aReturn;
}

FAchievement *FAchievementManager::GetFAchievement(char *pName)
{
    return GetFAchievement((const char*)pName);
}

FAchievement *FAchievementManager::GetFAchievement(FString pName)
{
    return GetFAchievement((const char*)pName.c());
}

void FAchievementManager::AddProgressGroup(const char *pGroupName, FList *pBubbleFList, int pProgress)
{
    EnumList(FAchievementGroup, aGroup, mFAchievementGroupFList)
    {
        if(aGroup->mGroupName == pGroupName)
        {
            aGroup->AddProgress(pBubbleFList, pProgress);
        }
    }
}

FAchievement *FAchievementManager::AddProgress(const char *pFAchievementName, int pProgress)
{
	FAchievement *aFAchievement = GetFAchievement(pFAchievementName);
	if(aFAchievement)
	{
		if(aFAchievement->AddProgress(pProgress))
		{
			return aFAchievement;
		}
	}
	return 0;
}

void FAchievementManager::Add(const char *pFAchievementName, int pProgressMax)
{
    FAchievement *aFAchievement = 0;
    EnumList(FAchievement, aCheck, mFAchievementFList)
    {
        if(aCheck->mName == pFAchievementName)
        {
            aFAchievement = aCheck;
        }
    }
    if(aFAchievement == 0)
    {
        aFAchievement = new FAchievement(pFAchievementName, pProgressMax);
        mFAchievementFList += aFAchievement;
    }
    else
    {
        aFAchievement->mProgressMax = pProgressMax;
    }
}

void FAchievementManager::Add(const char *pFAchievementName, const char *pGroupName, int pProgressMax)
{
    FAchievementGroup *aGroup = 0;
    EnumList(FAchievementGroup, aCheckGroup, mFAchievementGroupFList)
    {
        if(aCheckGroup->mGroupName == pGroupName)aGroup = aCheckGroup;
    }
    if(aGroup == 0)
    {
        aGroup = new FAchievementGroup(pGroupName);
        mFAchievementGroupFList += aGroup;
    }
    aGroup->Add(pFAchievementName, pProgressMax);
}

void FAchievementManager::GetAllFAchievements(FList *pFList)
{
    
    EnumList(FAchievementGroup, aGroup, mFAchievementGroupFList)
    {
        EnumList(FAchievement, aFAchievement, aGroup->mFAchievementFList)
        {
            pFList->Add(aFAchievement);
        }
    }
    
    EnumList(FAchievement, aFAchievement, mFAchievementFList)
    {
        pFList->Add(aFAchievement);
    }
    
}


bool FAchievementManager::Exists(FString pName)
{
    return GetFAchievement(pName) != 0;
}

void FAchievementManager::Reset()
{
    
}

void FAchievementManager::Load()
{
	FFile aFFile;
	aFFile.Load(FString("achievements.dat"));
	
	int aFAchievementCount=aFFile.ReadInt();
	
    for(int i=0;i<aFAchievementCount;i++)
	{
		FAchievement *aFAchievement = new FAchievement();
		aFAchievement->Load(&aFFile);
        Synchronize(aFAchievement->mName.c(), aFAchievement->mProgress);
        delete aFAchievement;
	}
    
    int aFAchievementGroupCount=aFFile.ReadInt();
    for(int k=0;k<aFAchievementGroupCount;k++)
	{
        aFAchievementCount=aFFile.ReadInt();
        for(int i=0;i<aFAchievementCount;i++)
        {
            FAchievement *aFAchievement = new FAchievement();
            aFAchievement->Load(&aFFile);
            Synchronize(aFAchievement->mName.c(), aFAchievement->mProgress);
            delete aFAchievement;
        }
	}
    
}

void FAchievementManager::Save()
{
    
    FFile aFFile;
    
    aFFile.WriteInt(mFAchievementFList.mCount);
    EnumList(FAchievement, aFAchievement, mFAchievementFList)
    {
        aFAchievement->Save(&aFFile);
    }
    
    aFFile.WriteInt(mFAchievementGroupFList.mCount);
    EnumList(FAchievementGroup, aGroup, mFAchievementGroupFList)
    {
        aFFile.WriteInt(aGroup->mFAchievementFList.mCount);
        EnumList(FAchievement, aFAchievement, aGroup->mFAchievementFList)
        {
            aFAchievement->Save(&aFFile);
        }
    }
    
	aFFile.Save(gDirDocuments + FString("achievements.dat"));
    
}

void FAchievementManager::Synchronize(const char *pFAchievementName, int pProgress)
{
    EnumList(FAchievement, aFAchievement, mFAchievementFList)
    {
        if(aFAchievement->mName == pFAchievementName)
        {
            Synchronize(aFAchievement, pProgress);
        }
    }
    
    EnumList(FAchievementGroup, aGroup, mFAchievementGroupFList)
    {
        EnumList(FAchievement, aFAchievement, aGroup->mFAchievementFList)
        {
            if(aFAchievement->mName == pFAchievementName)
            {
                Synchronize(aFAchievement, pProgress);
            }
        }
    }
    
}

void FAchievementManager::Synchronize(FAchievement *pFAchievement, int pProgress)
{
    if(pFAchievement)
    {
        if(pFAchievement->mProgress < pProgress)
        {
            pFAchievement->mProgress = pProgress;
            if(pFAchievement->mProgress > pFAchievement->mProgressMax)
            {
                pFAchievement->mProgress = pFAchievement->mProgressMax;
            }
        }
    }
}


void FAchievementManager::Print()
{
	printf("\n\n[--FAchievement FList--]\n");
    
    
    printf("\n[Ungrouped]\n{\n");
    EnumList(FAchievement, aFAchievement, mFAchievementFList)
    {
        printf("\t");
        aFAchievement->Print();
    }
    printf("}\n");
    
    EnumList(FAchievementGroup, aGroup, mFAchievementGroupFList)
    {
        printf("\n[Group %s]\n{\n", aGroup->mGroupName.c());
        
        EnumList(FAchievement, aFAchievement, aGroup->mFAchievementFList)
        {
            printf("\t");
            aFAchievement->Print();
        }
        
        printf("}\n");
    }
}

