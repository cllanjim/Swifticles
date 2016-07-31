//
//  RootBase.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#import "RootBase.h"

@implementation RootBase

@synthesize glViewController;

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
    self.glViewController = [[GLViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.view addSubview:glViewController.view];
    
    
}

- (void)didReceiveMemoryWarning
{
    
}

@end
