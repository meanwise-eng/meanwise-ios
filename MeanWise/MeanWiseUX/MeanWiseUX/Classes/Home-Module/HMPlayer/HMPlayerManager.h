//
//  HMPlayerManager.h
//  VideoPlayerDemo
//
//  Created by Hardik on 11/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPlayerManager : NSObject


@property (nonatomic,strong) NSMutableArray *MX_StackArray;
@property (nonatomic,strong) NSMutableArray *MX_DeletedArray;

+ (instancetype)sharedInstance;

-(NSString *)MX_getNewIdentifierRow;
-(void)MX_setLastPlayerPaused:(BOOL)flag;
-(void)MX_setLastPlayerFullMode:(BOOL)flag;
-(void)MX_KillLastPlayerRow;
-(void)MX_setURL:(NSString *)urlStr forIdentifier:(NSString *)identifier;
-(BOOL)MX_ifLastURLisAlready:(NSString *)string;
-(BOOL)MX_shouldKillThePlayerForIdentifier:(NSString *)string;
-(BOOL)MX_shouldPlayPlayerForURL:(NSString *)urlString withIdentifier:(NSString *)identifier;


#pragma mark - Working Engine


@property (nonatomic, strong) NSString *HM_screenIdentifier;
@property (nonatomic, strong) NSString *HM_urlIdentifier;
@property (nonatomic,assign) BOOL HM_isPaused;
@property (nonatomic,assign) BOOL HM_isFullScreen;
@property (nonatomic,assign) BOOL HM_isKilling;
-(void)StartKeepKillingHMLinkVideosIfAvaialble;
-(void)StopKeepKillingHMLinkVideosIfAvaialble;


////****///







#pragma mark - Old Engine



//  --------------------------- //

@property (nonatomic, strong) NSMutableArray *AllVideosURLIdentifiers;

@property (nonatomic, strong) NSString *Home_screenIdentifier;
@property (nonatomic, strong) NSString *Home_urlIdentifier;
@property (nonatomic,assign) BOOL Home_isPaused;
@property (nonatomic,assign) BOOL Home_isVisibleBounds;
@property (nonatomic, strong) NSNumber *Home_RefreshIdentifier;


@property (nonatomic, strong) NSString *Profile_screenIdentifier;
@property (nonatomic, strong) NSString *Profile_urlIdentifier;
@property (nonatomic,assign) BOOL Profile_isPaused;
@property (nonatomic,assign) BOOL Profile_isVisibleBounds;
@property (nonatomic,assign) BOOL Profile_isKilling;
@property (nonatomic, strong) NSNumber *Profile_RefreshIdentifier;


@property (nonatomic, strong) NSString *Explore_screenIdentifier;
@property (nonatomic, strong) NSString *Explore_urlIdentifier;
@property (nonatomic,assign) BOOL Explore_isPaused;
@property (nonatomic,assign) BOOL Explore_isVisibleBounds;
@property (nonatomic,assign) BOOL Explore_isKilling;

@property (nonatomic, strong) NSString *NotificationPost_screenIdentifier;
@property (nonatomic, strong) NSString *NotificationPost_urlIdentifier;
@property (nonatomic,assign) BOOL NotificationPost_isPaused;
@property (nonatomic,assign) BOOL NotificationPost_isVisibleBounds;
@property (nonatomic,assign) BOOL NotificationPost_isKilling;

@property (nonatomic, strong) NSString *DeepLinkPost_screenIdentifier;
@property (nonatomic, strong) NSString *DeepLinkPost_urlIdentifier;
@property (nonatomic,assign) BOOL DeepLinkPost_isPaused;
@property (nonatomic,assign) BOOL DeepLinkPost_isVisibleBounds;
@property (nonatomic,assign) BOOL DeepLinkPost_isKilling;
@property (nonatomic, strong) NSNumber *DeepLink_RefreshIdentifier;

@property (nonatomic,assign) BOOL All_isPaused;


-(void)StartKeepKillingExploreFeedVideosIfAvaialble;
-(void)StopKeepKillingExploreFeedVideosIfAvaialble;

-(void)StartKeepKillingProfileFeedVideosIfAvaialble;
-(void)StopKeepKillingProfileFeedVideosIfAvaialble;

-(void)StartKeepKillingNotificationVideosIfAvaialble;
-(void)StopKeepKillingNotificationVideosIfAvaialble;

-(void)StartKeepKillingDeepLinkVideosIfAvaialble;
-(void)StopKeepKillingDeepLinkVideosIfAvaialble;



-(NSNumber *)generateNewProfileRefreshIdentifier;
-(NSNumber *)generateHomeRefreshIdentifier;
-(NSNumber *)generateNewDeepLinkRefreshIdentifier;

@end
