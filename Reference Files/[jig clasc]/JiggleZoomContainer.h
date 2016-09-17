//
//  ImageImport.h
//  JiggleReloaded
//
//  Created by Nicholas Raptis on 1/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

#ifndef ImageImportSCO_hpp
#define ImageImportSCO_hpp

#include "FZoomView.h"
#include "JiggleArea.h"
#include "StyleSprite.h"
#include "FXML.h"

class JiggleZoomCanvas;
class ImageImportContent;
class JiggleZoomContainer : public FZoomView
{
public:
    
    JiggleZoomContainer();
    virtual ~JiggleZoomContainer();
    
    virtual void                                    Update();
    virtual void                                    Draw();
    
    void                                            SetUp(float pX, float pY, float pWidth, float pHeight);
    
    FXMLTag                                         *SaveXML();
    void                                            LoadXML(FXMLTag *pTag);
    
    virtual void                                    TouchDown(float pX, float pY, void *pData);
    virtual void                                    TouchMove(float pX, float pY, void *pData);
    virtual void                                    TouchUp(float pX, float pY, void *pData);
    virtual void                                    TouchFlush();
    
    virtual bool                                    AllowPan();
    virtual bool                                    AllowPinch();
    virtual bool                                    AllowRotate();
    
    virtual void                                    SetContentView(FGestureView *pView);
    
    
    //JiggleZoomCanvas                                *mCanvas;
    JiggleArea                                      *mJiggle;
    
    
    FSprite                                         *mBackLoop;
    FList                                           mDrawQuadList;
    
    StyleSprite                                     mStyleShadow;
    
};


class JiggleZoomCanvas : public FGestureView
{
public:
    
    JiggleZoomCanvas();
    virtual ~JiggleZoomCanvas();
    
    virtual void                                    Update();
    virtual void                                    Draw();
    
    //Gesture Functions...
    virtual void                                    PanBegin(float pX, float pY);
    virtual void                                    Pan(float pX, float pY);
    virtual void                                    PanEnd(float pX, float pY, float pSpeedX, float pSpeedY);
    
    virtual void                                    PinchBegin(float pScale);
    virtual void                                    Pinch(float pScale);
    virtual void                                    PinchEnd(float pScale);
    
    virtual void                                    RotateStart(float pRotation);
    virtual void                                    Rotate(float pRotation);
    virtual void                                    RotateEnd(float pRotation);
    
    void                                            SetUp(float pX, float pY, float pWidth, float pHeight);
    
};

#endif /* ImageImport_hpp */
