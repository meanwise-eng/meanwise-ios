//
//  HMPlayerManager.h
//  VideoPlayerDemo
//
//  Created by Hardik on 11/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPlayerManager : NSObject



@property (nonatomic, strong) NSString *Home_screenIdentifier;
@property (nonatomic, strong) NSString *Home_urlIdentifier;
@property (nonatomic,assign) BOOL Home_isPaused;
@property (nonatomic,assign) BOOL Home_isVisibleBounds;


@property (nonatomic, strong) NSString *Explore_screenIdentifier;
@property (nonatomic, strong) NSString *Explore_urlIdentifier;
@property (nonatomic,assign) BOOL Explore_isPaused;
@property (nonatomic,assign) BOOL Explore_isVisibleBounds;
@property (nonatomic,assign) BOOL Explore_isKilling;









+ (instancetype)sharedInstance;
-(void)StartKeepKillingExploreFeedVideosIfAvaialble;
-(void)StopKeepKillingExploreFeedVideosIfAvaialble;

@end
