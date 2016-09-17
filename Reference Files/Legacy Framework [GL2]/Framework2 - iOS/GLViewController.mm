//
//  GLViewController.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#import "GLViewController.h"
#import "Root.h"
#import "MainApp.h"

@implementation GLViewController

@synthesize openGLView;
@synthesize displayLink;
@synthesize animationFrameInterval;
@synthesize animating;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    animating = FALSE;
    
    self.animationFrameInterval = 1;
    self.displayLink = nil;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0.0f, 0.0f, gDeviceWidth, gDeviceHeight);
    
    self.view.opaque = YES;
    self.view.layer.opaque = YES;
    
    self.openGLView = [[GLView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:openGLView];
    
    
    //self.glView = [[GLView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    //glView.backgroundColor = [UIColor orangeColor];
    //[self.view addSubview:glView];
}

- (void)updateStart
{
    
    /*
    NSLog(@"Update Start!");
    
    //[updateTimer invalidate];
    //self.updateTimer = nil;
    
    if(updateTimer == nil)
    {
        NSLog(@"Starting Update.. For Real");
        
        
        
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1/20 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    else
    {
        NSLog(@"Already one update happeningz!!");
    }
     
     
    */
    
    NSLog(@"Starting Updates..");
    
    if(!animating)
    {
        self.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(update)];
        [self.displayLink setFrameInterval:animationFrameInterval];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        //self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval target:self selector:@selector(updateView) userInfo:nil repeats:YES];
        
        animating = TRUE;
    }
}

- (void)updateStop
{
    NSLog(@"Going Inactive - Updates Stop?");
    
    
    /*
    [updateTimer invalidate];
    self.updateTimer = nil;
    */
    
    
    if(animating)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
        
        //self.updateTimer = nil;
    }
    
}

- (void)update
{
    [openGLView render];
}

@end
