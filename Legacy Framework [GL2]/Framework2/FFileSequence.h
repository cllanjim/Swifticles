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
    
    bool                            LoadSequence(const char *pFileBase, const char *pExtension, FList &pList, int pStartIndex, int pEndIndex, int pLeadingZeroCount);
    bool                            LoadSequence(const char *pFileBase, const char *pExtension, FList &pList, int pStartIndex, int pEndIndex);
    bool                            LoadSequence(const char *pFileBase, FList &pList, int pStartIndex, int pEndIndex);
    
    FList                           mList;
};

#endif
