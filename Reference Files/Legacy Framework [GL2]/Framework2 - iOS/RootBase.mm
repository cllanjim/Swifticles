//
//  RootBase.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#import "RootBase.h"

@implementation RootBase

@synthesize glViewController;

@synthesize viewControllerCurrent;
@synthesize viewControllerPrevious;

@synthesize globalUpdateTimer;

@synthesize arrayGlobalUpdaters;

@synthesize containerView;

@synthesize disableAnimation;

@synthesize pushDirection;

@synthesize pushTop;

@synthesize pushNotificationsToken;

@synthesize musicPlayer;
@synthesize musicPlayerFading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.arrayGlobalUpdaters = [[NSMutableArray alloc] init];
    
    musicFadeOutTick = 0;
    musicFadeOutTickMax = 5;
    musicFadeOut = false;
    
    musicFadeInTick = 0;
    musicFadeInTickMax = 5;
    musicFadeIn = false;
    
    
    musicVolume = 0.5f;
    
    musicLoop = false;
    musicFadeLoop = false;
    
    NSLog(@"Root Base Created..");
    
    pushTop = 0.0f;
    
    pushDirection = ROOT_PUSH_DIR_LEFT;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    return self;
}

- (void)viewDidLoad
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, gDeviceWidth, gDeviceHeight);
    
    [super viewDidLoad];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, gDeviceWidth, gDeviceHeight)];
    containerView.clipsToBounds = YES;
    [self.view addSubview:containerView];
    
    self.globalUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(1/60.0f) target:self selector:@selector(globalUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:globalUpdateTimer forMode:NSRunLoopCommonModes];
    
    self.glViewController = [[GLViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)ready
{
    
}

- (void)pushTo:(UIViewController *)pViewController animated:(BOOL)pAnimated
{
    if([viewControllerPrevious respondsToSelector:@selector(nuke)])[viewControllerPrevious performSelector:@selector(nuke)];
    [self.viewControllerPrevious.view removeFromSuperview];
    self.viewControllerPrevious=nil;
    
    self.viewControllerPrevious = viewControllerCurrent;
    
    self.viewControllerCurrent = nil;
    
    self.viewControllerCurrent = pViewController;
    
    [containerView addSubview:viewControllerCurrent.view];
    
    //viewControllerCurrent.view.frame = CGRectMake(self.view.frame.size.width, 0.0f, viewControllerCurrent.view.frame.size.width, viewControllerCurrent.view.frame.size.height);
    
    viewControllerCurrent.view.frame = CGRectMake(0.0f, 0.0f, viewControllerCurrent.view.frame.size.width, viewControllerCurrent.view.frame.size.height);
    viewControllerCurrent.view.alpha = 0.0f;
    
    if(pAnimated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    //viewControllerPrevious.view.frame = CGRectMake(-self.view.frame.size.width, 0.0f, viewControllerPrevious.view.frame.size.width, viewControllerPrevious.view.frame.size.height);
    //viewControllerCurrent.view.frame = CGRectMake(0.0f, 0.0f, viewControllerCurrent.view.frame.size.width, viewControllerCurrent.view.frame.size.height);
    
    viewControllerCurrent.view.alpha = 1.0f;
    
    if(pAnimated)
    {
        [UIView commitAnimations];
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    NSLog(@"Animation Did Stop... Root Base!");
    
    /*
     if([viewControllerPrevious respondsToSelector:@selector(nuke)])[viewControllerPrevious performSelector:@selector(nuke)];
     [self.viewControllerPrevious.view removeFromSuperview];
     self.viewControllerPrevious=nil;
     */
}



- (void)playMusic:(NSString*) path withDelegate:(id)del
{
    /*
    
	if(musicPlayer)
	{
		[musicPlayer stop];
		musicPlayer.delegate=nil;
		musicPlayer=nil;
	}
	
	NSURL *aURL = [[NSURL alloc] initFileURLWithPath:aPath];
    NSError *aError;
	
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:aURL error:&aError];
    
	[musicPlayer prepareToPlay];
	[musicPlayer setVolume: 1];
	[musicPlayer setDelegate: del];
	[musicPlayer play];
    
    */
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    NSLog(@"AudioPlayerFinished! Successful(%d) Loop(main: %d, fade: %d)", flag, musicLoop, musicFadeLoop);
    
    if(player == musicPlayer)
    {
        if(musicLoop)
        {
            [musicPlayer play];
        }
        else
        {
            [musicPlayer stop];
            musicPlayer.delegate = nil;
            self.musicPlayer = nil;
        }
        
        /*
        musicFadeOutTick = 0;
        musicFadeOutTickMax = 5;
        musicFadeOut = false;
        
        musicFadeInTick = 0;
        musicFadeInTickMax = 5;
        musicFadeIn = false;
        */
        
        
    }
    else if(player == musicPlayerFading)
    {
        if(musicFadeLoop)
        {
            [musicPlayerFading play];
        }
        else
        {
            [musicPlayerFading stop];
            musicPlayerFading.delegate = nil;
            self.musicPlayerFading = nil;
        }
    }
    
    /*
	if(musicPlayer)
	{
        if(loopMusic)
        {
            [musicPlayer play];
        }
        else
        {
            [musicPlayer stop];
            musicPlayer=nil;
        }
	}
    */
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    
}

- (void)globalUpdate
{
    
    //NSLog(@"Global Update!");
    
    
    /*
    musicFadeLoop = false;
    musicFadeOutTick = 0;
    musicFadeOutTickMax = 0;
    musicFadeOut = false;
    
    musicFadeInTick = pDurationTicks;
    musicFadeInTickMax = pDurationTicks;
    musicFadeIn = YES;
    */
    
    
    if(musicFadeIn)
    {
        musicFadeInTick--;
        
        if(musicFadeInTick <= 0)
        {
            [musicPlayer setVolume:(musicVolume)];
            musicFadeIn = NO;
        }
        else
        {
            if(musicFadeInTickMax <= 0)musicFadeInTickMax = 1;
            
            
            float aPercent = ((float)musicFadeInTick) / ((float)musicFadeInTickMax);
            
            if(aPercent < 0.0f)aPercent = 0.0f;
            if(aPercent > 1.0f)aPercent = 1.0f;
            aPercent = 1.0f - aPercent;
            
            [musicPlayer setVolume:(aPercent * musicVolume)];
            
        }
    }
    
    
    if(musicFadeOut)
    {
        musicFadeOutTick--;
        
        if(musicFadeOutTick <= 0)
        {
            [musicPlayerFading stop];
            musicPlayerFading.delegate = nil;
            self.musicPlayerFading = nil;
            
            musicFadeOut = NO;
        }
        else
        {
            if(musicFadeOutTickMax <= 0)musicFadeOutTickMax = 1;
            
            float aPercent = ((float)musicFadeOutTick) / ((float)musicFadeOutTickMax);
            
            if(aPercent < 0.0f)aPercent = 0.0f;
            if(aPercent > 1.0f)aPercent = 1.0f;
            
            [musicPlayerFading setVolume:(aPercent * musicVolume)];
            
        }
    }
    
    for(UIViewController *aViewController in arrayGlobalUpdaters)
    {
        [aViewController performSelector:@selector(globalUpdate)];
    }
    
}

- (void)globalUpdateAdd:(UIViewController *)pViewController
{
    if(arrayGlobalUpdaters == nil)self.arrayGlobalUpdaters = [[NSMutableArray alloc] init];
    
    if([arrayGlobalUpdaters containsObject:pViewController] == NO)
    {
        if([pViewController respondsToSelector:@selector(globalUpdate)])
        {
            [arrayGlobalUpdaters addObject:pViewController];
        }
    }
}

- (void)globalUpdateRemove:(UIViewController *)pViewController
{
    if(arrayGlobalUpdaters != nil)
    {
        if([arrayGlobalUpdaters containsObject:pViewController])
        {
            [arrayGlobalUpdaters removeObject:pViewController];
        }
    }
}



- (void)enterBackground
{
    [glViewController updateStop];
}

- (void)enterForeground
{
    [glViewController updateStart];
}


- (void)musicPlay:(NSString *)pPath withLoop:(BOOL)pLoop
{
    [self musicPlay:pPath withVolume:1.0f withLoop:pLoop];
}

- (void)musicPlay:(NSString *)pPath withVolume:(float)pVolume withLoop:(BOOL)pLoop
{
    
    NSLog(@"Music Play [%@]", pPath);
    
    musicLoop = NO;
    
	if(musicPlayer)
	{
		[musicPlayer stop];
		musicPlayer.delegate = nil;
		self.musicPlayer = nil;
	}
    
    bool aFail = true;
    
    NSURL *aURL = [[NSURL alloc] initFileURLWithPath: pPath];
    
    if(aURL)
    {
        NSError *aError;
        
        
        musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:aURL error:&aError];
        
        if(aError)
        {
            NSLog(@"Music Error!");
            NSLog(@"[%@]", pPath);
            NSLog(@"(%@)", aError);
        }
        else
        {
            [musicPlayer prepareToPlay];
            [musicPlayer setVolume:(musicVolume * pVolume)];
            [musicPlayer setDelegate:self];
            [musicPlayer play];
            
            musicLoop = pLoop;
            aFail = NO;
        }
    }
    
}

- (void)musicCrossFadeWithPath:(NSString *)pPath withDurationTicks:(int)pDurationTicks withLoop:(BOOL)pLoop
{
    if(pDurationTicks < 1)pDurationTicks = 1;
    
    [self musicFadeOutWithDurationTicks:pDurationTicks];
    
    if(musicPlayer)
	{
		[musicPlayer stop];
		musicPlayer.delegate = nil;
		self.musicPlayer = nil;
	}
    
    
    [self musicPlay:pPath withVolume:0.0f withLoop:pLoop];
    
    
    musicFadeInTick = pDurationTicks;
    musicFadeInTickMax = pDurationTicks;
    musicFadeIn = YES;
    
    
    //musicFadeLoop
    
    
}

- (void)musicFadeOutWithDurationTicks:(int)pDurationTicks
{
    if(pDurationTicks < 1)pDurationTicks = 1;
    
    if(musicPlayerFading)
	{
		[musicPlayerFading stop];
		musicPlayerFading.delegate = nil;
		self.musicPlayerFading = nil;
	}
    
    
    if(musicPlayer)
    {
        self.musicPlayerFading = musicPlayer;
        self.musicPlayer = nil;
        
        musicFadeLoop = musicLoop;
        musicFadeOutTick = pDurationTicks;
        musicFadeOutTickMax = pDurationTicks;
        musicFadeOut = true;
    }
    else
    {
        musicFadeLoop = false;
        musicFadeOutTick = 0;
        musicFadeOutTickMax = 0;
        musicFadeOut = false;
    }
    
}


- (void)musicFadeInWith:(NSString *)pPath withDurationTicks:(int)pDurationTicks
{
    
}

- (void)musicStop
{
    
}

- (BOOL)musicIsPlaying
{
    BOOL aReturn = NO;
    
    
    return aReturn;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"MEMORY WARNING!!!");
    [super didReceiveMemoryWarning];
}


@end
