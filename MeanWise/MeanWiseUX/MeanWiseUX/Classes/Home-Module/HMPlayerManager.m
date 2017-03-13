//
//  HMPlayerManager.m
//  VideoPlayerDemo
//
//  Created by Hardik on 11/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HMPlayerManager.h"

@implementation HMPlayerManager

+ (instancetype)sharedInstance
{
    static HMPlayerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HMPlayerManager alloc] init];
        
        sharedInstance.Home_screenIdentifier=@"";
        sharedInstance.Home_urlIdentifier=@"";
        sharedInstance.Home_isPaused=FALSE;
        sharedInstance.Home_isVisibleBounds=TRUE;
        
        sharedInstance.Explore_isPaused=false;
        sharedInstance.Explore_isVisibleBounds=false;
        sharedInstance.Explore_screenIdentifier=@"";
        sharedInstance.Explore_urlIdentifier=@"";
        sharedInstance.Explore_isKilling=false;
        
        
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(void)StartKeepKillingExploreFeedVideosIfAvaialble;
{
    self.Explore_isKilling=true;
}
-(void)StopKeepKillingExploreFeedVideosIfAvaialble;
{
    self.Explore_isKilling=false;
}

@end
