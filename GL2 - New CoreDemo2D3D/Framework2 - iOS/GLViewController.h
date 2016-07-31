//
//  GLViewController.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface GLViewController : UIViewController
{
    NSTimer                             *updateTimer;
    OpenGLView                          *openGLView;
}

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) OpenGLView *openGLView;

- (void)updateStart;
- (void)updateStop;

- (void)update;

@end
