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
        
        sharedInstance.Profile_isPaused=false;
        sharedInstance.Profile_isVisibleBounds=TRUE;
        sharedInstance.Profile_screenIdentifier=@"";
        sharedInstance.Profile_urlIdentifier=@"";
        sharedInstance.Profile_isKilling=false;
        
        sharedInstance.NotificationPost_isPaused=false;
        sharedInstance.NotificationPost_isVisibleBounds=TRUE;
        sharedInstance.NotificationPost_screenIdentifier=@"";
        sharedInstance.NotificationPost_urlIdentifier=@"";
        sharedInstance.NotificationPost_isKilling=false;
        
        
        
        
        sharedInstance.All_isPaused=false;
        
        
        
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

-(void)StartKeepKillingProfileFeedVideosIfAvaialble
{
    self.Profile_isKilling=true;
}
-(void)StopKeepKillingProfileFeedVideosIfAvaialble
{
    self.Profile_isKilling=false;
}
-(void)StartKeepKillingNotificationVideosIfAvaialble
{
    self.NotificationPost_isKilling=true;
}
-(void)StopKeepKillingNotificationVideosIfAvaialble
{
    self.NotificationPost_isKilling=false;
}


@end
