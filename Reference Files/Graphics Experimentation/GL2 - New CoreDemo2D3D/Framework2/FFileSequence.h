//
//  FFileSequence.h
//  DoomKnights
//
//  Created by Nick Raptis on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FILE_SEQUENCE_H
#define FILE_SEQUENCE_H

#include "stdafx.h"

class FFileSequence
{
public:
    
    FFileSequence();
    ~FFileSequence();
    
    static bool                         LoadSequence(const char *pFileBase, const char *pExtension, FList &pFList, int pStartIndex, int pEndIndex, int pLeadingZeroCount);
    static bool                         LoadSequence(const char *pFileBase, const char *pExtension, FList &pFList, int pStartIndex, int pEndIndex);
    
    static bool                         LoadSequence(const char *pFileBase, FList &pFList, int pStartIndex, int pEndIndex);
    
    //static int                          FindLeadingZeroCount(const char *pFileBase, const char *pExtension, int pStartIndex, int pEndIndex);
    
    
};

#endif
