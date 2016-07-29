//
//  RootBase.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#define ROOT_PUSH_DIR_LEFT 0
#define ROOT_PUSH_DIR_RIGHT 1
#define ROOT_PUSH_DIR_UP 2
#define ROOT_PUSH_DIR_DOWN 3

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"
#import "GLViewController.h"

@interface RootBase : UIViewController <AVAudioPlayerDelegate>
{
    GLViewController                            *glViewController;
    
    UIViewController                            *viewControllerCurrent;
    UIViewController                            *viewControllerPrevious;
    
    NSTimer                                     *globalUpdateTimer;
    
    NSMutableArray                              *arrayGlobalUpdaters;
    
    UIView                                      *containerView;
    
    BOOL                                        disableAnimation;
    
    int                                         pushDirection;
    
    float                                       pushTop;
    
    NSString                                    *pushNotificationsToken;
    
    AVAudioPlayer                               *musicPlayer;
    AVAudioPlayer                               *musicPlayerFading;
    
    
    int                                         musicFadeOutTick;
    int                                         musicFadeOutTickMax;
    bool                                        musicFadeOut;
    
    int                                         musicFadeInTick;
    int                                         musicFadeInTickMax;
    bool                                        musicFadeIn;
    
    
    float                                       musicVolume;
    
    bool                                        musicLoop;
    bool                                        musicFadeLoop;
    
    
}

@property (nonatomic, retain) GLViewController *glViewController;

@property (nonatomic, retain) IBOutlet UIViewController *viewControllerCurrent;
@property (nonatomic, retain) IBOutlet UIViewController *viewControllerPrevious;

@property (nonatomic, retain) NSTimer *globalUpdateTimer;

@property (nonatomic, retain) NSMutableArray *arrayGlobalUpdaters;

@property (nonatomic, retain) UIView *containerView;

@property (nonatomic, assign) BOOL disableAnimation;

@property (nonatomic, assign) int pushDirection;

@property (nonatomic, assign) float pushTop;

@property (nonatomic, retain) NSString *pushNotificationsToken;

@property (nonatomic, retain) AVAudioPlayer *musicPlayer;
@property (nonatomic, retain) AVAudioPlayer *musicPlayerFading;


- (void)ready;

- (void)musicPlay:(NSString *)pPath withLoop:(BOOL)pLoop;
- (void)musicPlay:(NSString *)pPath withVolume:(float)pVolume withLoop:(BOOL)pLoop;

- (void)musicCrossFadeWithPath:(NSString *)pPath withDurationTicks:(int)pDurationTicks withLoop:(BOOL)pLoop;
- (void)musicFadeOutWithDurationTicks:(int)pDurationTicks;
- (void)musicFadeInWith:(NSString *)pPath withDurationTicks:(int)pDurationTicks;

- (void)musicStop;

- (BOOL)musicIsPlaying;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;


- (void)globalUpdate;
- (void)globalUpdateAdd:(UIViewController *)pViewController;
- (void)globalUpdateRemove:(UIViewController *)pViewController;

- (void)enterBackground;
- (void)enterForeground;

- (void)pushTo:(UIViewController *)pViewController animated:(BOOL)pAnimated;
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
