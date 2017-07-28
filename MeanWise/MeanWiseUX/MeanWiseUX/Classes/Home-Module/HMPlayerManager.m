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
        sharedInstance.Home_isVisibleBounds=false;
        sharedInstance.Home_RefreshIdentifier=[NSNumber numberWithLong:1];

        sharedInstance.Explore_isPaused=false;
        sharedInstance.Explore_isVisibleBounds=true;
        sharedInstance.Explore_screenIdentifier=@"";
        sharedInstance.Explore_urlIdentifier=@"";
        sharedInstance.Explore_isKilling=false;
        
        sharedInstance.Profile_screenIdentifier=@"";
        sharedInstance.Profile_urlIdentifier=@"";
        sharedInstance.Profile_isPaused=false;
        sharedInstance.Profile_isVisibleBounds=TRUE;
        sharedInstance.Profile_isKilling=false;
        sharedInstance.Profile_RefreshIdentifier=[NSNumber numberWithLong:1];
        
        sharedInstance.NotificationPost_isPaused=false;
        sharedInstance.NotificationPost_isVisibleBounds=TRUE;
        sharedInstance.NotificationPost_screenIdentifier=@"";
        sharedInstance.NotificationPost_urlIdentifier=@"";
        sharedInstance.NotificationPost_isKilling=false;
        
        sharedInstance.DeepLinkPost_isPaused=false;
        sharedInstance.DeepLinkPost_isVisibleBounds=TRUE;
        sharedInstance.DeepLinkPost_screenIdentifier=@"";
        sharedInstance.DeepLinkPost_urlIdentifier=@"";
        sharedInstance.DeepLinkPost_isKilling=false;
        sharedInstance.DeepLink_RefreshIdentifier=[NSNumber numberWithLong:1];
        

        sharedInstance.AllVideosURLIdentifiers=[[NSMutableArray alloc] init];
        
        sharedInstance.All_isPaused=false;
        
        
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSNumber *)generateNewDeepLinkRefreshIdentifier
{
    NSNumber *number=[NSNumber numberWithLong:[self.DeepLink_RefreshIdentifier intValue]+1];
    
    self.DeepLink_RefreshIdentifier=number;
    
    return number;

}
-(NSNumber *)generateNewProfileRefreshIdentifier
{

    NSNumber *number=[NSNumber numberWithLong:[self.Profile_RefreshIdentifier intValue]+1];
    
    self.Profile_RefreshIdentifier=number;
    
    return number;
    
}
-(NSNumber *)generateHomeRefreshIdentifier
{
    
    NSNumber *number=[NSNumber numberWithLong:[self.Home_RefreshIdentifier intValue]+1];
    
    self.Home_RefreshIdentifier=number;
    
    return number;
    
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

-(void)StartKeepKillingDeepLinkVideosIfAvaialble
{
    self.DeepLinkPost_isKilling=true;
}
-(void)StopKeepKillingDeepLinkVideosIfAvaialble
{
    self.DeepLinkPost_isKilling=false;

}



-(void)setNotificationPost_urlIdentifier:(NSString *)NotificationPost_urlIdentifier
{
    _NotificationPost_urlIdentifier=NotificationPost_urlIdentifier;
}
-(void)setHome_urlIdentifier:(NSString *)Home_urlIdentifier
{
    _Home_urlIdentifier=Home_urlIdentifier;
}
-(void)setExplore_urlIdentifier:(NSString *)Explore_urlIdentifier
{
    _Explore_urlIdentifier=Explore_urlIdentifier;
}
-(void)setProfile_urlIdentifier:(NSString *)Profile_urlIdentifier
{
    _Profile_urlIdentifier=Profile_urlIdentifier;
}
-(void)addNewURLIntoStack:(NSString *)string
{

    
    [self.AllVideosURLIdentifiers addObject:string];
 
    
}
@end
