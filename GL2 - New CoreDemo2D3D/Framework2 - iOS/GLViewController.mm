//
//  GLViewController.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#import "GLViewController.h"
#import "Root.h"
#import "MainApp.h"

@implementation GLViewController

@synthesize updateTimer;

//@synthesize glView;

@synthesize openGLView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0.0f, 0.0f, gDeviceWidth, gDeviceHeight);
    
    
    
    
    
    self.openGLView = [[OpenGLView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:openGLView];
    
    
    //self.glView = [[GLView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    //glView.backgroundColor = [UIColor orangeColor];
    //[self.view addSubview:glView];
}

- (void)updateStart
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:(1 / 60.0f) target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)updateStop
{
    [updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)update
{
    [openGLView render];
    
    if(gApp)
    {
        //gApp->BaseUpdate();
        //gApp->BaseDraw();
    }
    //[glView render];
}

@end
