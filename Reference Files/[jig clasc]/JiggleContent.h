//
//  JiggleContent.h
//  Ghibli
//
//  Created by Nick Raptis on 7/4/14.
//  Copyright (c) 2014 Union AdWorks LLC. All rights reserved.
//

#ifndef __Ghibli__JiggleContent__
#define __Ghibli__JiggleContent__

//This is a concept idea for a possible animation idea in the ghibli app.
//Expanding upon the particle physics knowledge base from attempting this
//on the FiatSource app.

//Hmm, need to sketch this out and see what kind of triangulation mesh scheme is gonna
//sing the way I want it to for the desired effect.

#include "FView.h"
#include "JiggleArea.h"
//#include "JiggleScrollView.h"
#include "JiggleZoomContainer.h"
#include "TopTools.h"
#include "BottomTools.h"

//
class JiggleContent : public FView
{
    
public:
    
    JiggleContent();
    virtual ~JiggleContent();
    
    virtual void                            Update();
    virtual void                            Draw();
    
    virtual void                            TouchDown(float pX, float pY, void *pData);
    virtual void                            TouchMove(float pX, float pY, void *pData);
    virtual void                            TouchUp(float pX, float pY, void *pData);
    virtual void                            TouchFlush();
    
    virtual void                            Notify(void *pData);
    
    TopTools                                *mTopTools;
    BottomTools                             *mBottomTools;
    
    KitPanel                                *mMenuPanel;
    JiggleZoomContainer                     *mContainer;
    
    FList                                   mJigglePointList;
    
    
};

extern JiggleContent *gJiggleScene;
extern JiggleZoomContainer *gJiggleContainer;

#endif /* defined(__Ghibli__JiggleContent__) */
