//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#import "FSprite.h"
#import "FModelData.h"

#import "FList.h"

@interface OpenGLView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    /*
    FSprite mSprite1;
    FSprite mSprite2;
    
    FModelDataIndexed mSnail;
    
    float *mModelBufferData;
    
    unsigned int mModelVertex;
    unsigned int mModelIndex;
    
    FList mTest3DList;
    
    float testRot;
    
    bool didTestLoad;
    */
}

//- (void)testLoad;

-(void)render;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;

@end
