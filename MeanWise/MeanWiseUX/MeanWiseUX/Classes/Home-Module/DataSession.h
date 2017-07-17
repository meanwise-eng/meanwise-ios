//
//  DataSession.h
//  MeanWiseUX
//
//  Created by Hardik on 19/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObjects_ProfileObj.h"

@interface SignupDataObjects : NSObject
-(void)clearAllData;

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* first_name;
@property (nonatomic, strong) NSString* last_name;
@property (nonatomic, strong) NSString* dob;
@property (nonatomic, strong) NSString* cover_photo;
@property (nonatomic, strong) NSString* profile_photo;

@property (nonatomic, strong) NSArray* skills;
@property (nonatomic, strong) NSArray* interests;


@end



@interface DataSession : NSObject
{
  
    
}
+ (instancetype)sharedInstance;
-(void)postLiked:(NSString *)postId;
-(void)postUnliked:(NSString *)postId;
-(void)userProfileUpdate:(APIObjects_ProfileObj *)userObject;
-(void)updateCommentCountForPostId:(NSString *)postId andCommentCount:(int)commentCount;
-(int)getUpdatedCommentCountForPostId:(NSString *)postId;



@property (nonatomic, strong) NSNumber *SocialshareStatus;
@property (nonatomic, strong) SignupDataObjects *signupObject;

@property (nonatomic, strong) NSMutableArray* homeFeedResults;
@property (nonatomic, strong) NSMutableArray* exploreFeedResults;
@property (nonatomic, strong) NSMutableArray* searchUserResults;


@property (nonatomic, strong) NSMutableArray* notificationsResults;
@property (nonatomic, strong) NSNumber* noOfNewNotificationReceived;

@property (nonatomic, strong) NSNumber* noOfInstantNotificationReceived;

@end


