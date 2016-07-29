//
//  FFileSequence.cpp
//  DoomKnights
//
//  Created by Nick Raptis on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "FFileSequence.h"
#include "FFile.h"

FFileSequence::FFileSequence()
{
    
}

FFileSequence::~FFileSequence()
{
    FreeList(FString, mList);
}

bool FFileSequence::LoadSequence(const char *pFileBase, const char *pExtension, FList &pList, int pStartIndex, int pEndIndex, int pLeadingZeroCount)
{
    bool aReturn = false;
    
    FString aFileBase = pFileBase;
    FString aExtension = pExtension;
    FString aNumberString = FString(pStartIndex);
    
    if(aNumberString.mLength < pLeadingZeroCount)
    {
        FString aZeroString;
        aZeroString.Write('0', (pLeadingZeroCount - aNumberString.mLength), 0);
        aNumberString = (aZeroString + aNumberString);
    }
    
    FString aCheck = (aFileBase + aNumberString + FString(".") + aExtension);
    if(os_fileExists(aCheck.c()))
    {
        pList += new FString(aCheck);
        aReturn=true;
    }
    
    if(aReturn == false)
    {
        aCheck = (gDirBundle + aFileBase + aNumberString + FString(".") + aExtension);
        if(os_fileExists(aCheck.c()))
        {
            pList += new FString(aCheck);
            aFileBase = (gDirBundle + aFileBase);
            aReturn=true;
        }
    }
    
    if(aReturn == false)
    {
        aCheck = (gDirDocuments + aFileBase + aNumberString + FString(".") + aExtension);
        if(os_fileExists(aCheck.c()))
        {
            pList += new FString(aCheck);
            aFileBase = (gDirDocuments + aFileBase);
            aReturn=true;
        }
    }
    
    if(aReturn)
    {
        for(int aIndex=pStartIndex+1;((aIndex<=pEndIndex) || (pEndIndex == -1));aIndex++)
        {
            aNumberString = FString(aIndex);
            if(aNumberString.mLength < pLeadingZeroCount)
            {
                FString aZeroString;
                aZeroString.Write('0', (pLeadingZeroCount - aNumberString.mLength), 0);
                aNumberString = (aZeroString + aNumberString);
            }
            
            aCheck = (aFileBase + aNumberString + FString(".") + aExtension);
            
            
            if(os_fileExists(aCheck.c()))
            {
                pList += new FString(aCheck);
            }
            else
            {
                break;
            }
        }
    }
    
    return aReturn;
}

bool FFileSequence::LoadSequence(const char *pFileBase, const char *pExtension, FList &pList, int pStartIndex, int pEndIndex)
{
    bool aReturn = false;
    
    for(int aLeadingZeros=1;((aLeadingZeros<8) && (aReturn==false));aLeadingZeros++)
    {
        aReturn = LoadSequence(pFileBase, pExtension, pList, pStartIndex, pEndIndex, aLeadingZeros);
    }
    
    return aReturn;
}

bool FFileSequence::LoadSequence(const char *pFileBase, FList &pList, int pStartIndex, int pEndIndex)
{
    bool aReturn = false;
    
    if(!aReturn)
    {
        aReturn = LoadSequence(pFileBase, "png", pList, pStartIndex, pEndIndex);
    }
    if(!aReturn)
    {
        aReturn = LoadSequence(pFileBase, "jpg", pList, pStartIndex, pEndIndex);
    }
    if(!aReturn)
    {
        aReturn = LoadSequence(pFileBase, "obj", pList, pStartIndex, pEndIndex);
    }
    
    return aReturn;
}





