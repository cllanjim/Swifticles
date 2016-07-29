//
//  GLViewController.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

@interface GLViewController : UIViewController
{
    BOOL                                animating;
    NSInteger							animationFrameInterval;
    CADisplayLink						*displayLink;
    
    
    GLView                              *openGLView;
}

@property (nonatomic, strong) GLView *openGLView;
@property (nonatomic, retain) CADisplayLink *displayLink;
@property (readonly, nonatomic) BOOL animating;
@property (nonatomic, assign) NSInteger animationFrameInterval;

- (void)updateStart;
- (void)updateStop;

- (void)update;

@end
