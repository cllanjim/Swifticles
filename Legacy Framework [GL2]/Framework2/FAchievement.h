/*
 *
 *  FAchievement.h
 *  Darts
 *
 *  Created by Nick Raptis on 11/30/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef ACHIEVEMENT_H
#define ACHIEVEMENT_H

#include "FFile.h"
#include "FList.h"

class FAchievement
{
public:
    
    FAchievement(const char *pName, int pProgressMax);
    FAchievement();
    
    virtual ~FAchievement();
    
    void                SetUp(const char *pName, int pProgressMax=1);
    
    //mName is also used as identifier for GameCenter or OpenFeint...
    FString				mName;
	
	virtual void		Load(FFile *pFile);
	virtual void		Save(FFile *pFile);
	
	virtual void		ResetProgress();
	virtual bool		AddProgress(int pProgress=1);
	
	void				Print();
	
	//Is it posted to Game Center / OpenFeint yet?
	bool				mPosted;
	
	//Once mProgress = mProgressMax, we are complete. Great for stuff like "do 5,000 of X."
	int					mProgress;
	int					mProgressMax;
	
	int					mProgressSaved;
	
	//Is the achievement complete?? Well... IS IT?
	bool				mComplete;
	bool				mCompletedThisUpdate;
	
	//Used exclusively for achievement manager...
	bool				mAutoResetsOnLevelUp;
	bool				mAutoResetsOnGameOver;
    
	bool				mAutoResetsOnAction;
	int					mAutoResetsActionId;
};

class FAchievementGroup
{
public:
    
    FAchievementGroup(const char *pGroupName);
    virtual ~FAchievementGroup();
    
    void                    Add(const char *pFAchievementName, int pProgressMax=1);
    void                    AddProgress(FList *pBubbleFList, int pProgress=1);
    
    FString                 mGroupName;
    
    FList                    mFAchievementFList;
};

class FAchievementManager
{
public:
    
	FAchievementManager();
	virtual ~FAchievementManager();
    
	void					LevelUp();
	void					GameOver();
	void					PerformAction(int pAction);
	
	void					Reset();
    
    void                    Add(const char *pFAchievementName, int pProgressMax=1);
    void                    Add(const char *pFAchievementName, const char *pGroupName, int pProgressMax=1);
    
	bool					Exists(FString pName);
    
    void                    GetAllFAchievements(FList *pFList);
    
    void                    Synchronize(const char *pFAchievementName, int pProgress);
    void                    Synchronize(FAchievement *pFAchievement, int pProgress);
    
    
    
    FAchievement				*GetFAchievement(const char *pName);
    FAchievement				*GetFAchievement(char *pName);
	FAchievement				*GetFAchievement(FString pName);
    
    void                    AddProgressGroup(const char *pGroupName, FList *pBubbleFList, int pProgress=1);
    FAchievement				*AddProgress(const char *pFAchievementName, int pProgress=1);
    
	void					Print();
	
	virtual void			Load();
	virtual void			Save();
    
    FList                    mFAchievementFList;
    FList                    mFAchievementGroupFList;
};


#endif