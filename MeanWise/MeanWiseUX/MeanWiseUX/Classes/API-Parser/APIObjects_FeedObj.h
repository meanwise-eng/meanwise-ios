//
//  APIObjects_FeedObj.h
//  MeanWiseUX
//
//  Created by Hardik on 22/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"


@interface APIObjects_FeedObj : NSObject

@property (nonatomic,strong) NSNumber *colorNumber;
@property (nonatomic, strong) NSString* postId;
@property (nonatomic, strong) NSString* image_url;

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* user_profile_photo_small;
@property (nonatomic,strong) NSString *user_cover_photo;
@property (nonatomic, strong) NSString* user_firstname;

@property (nonatomic, strong) NSString* video_url;
@property (nonatomic, strong) NSString* video_thumb_url;

@property (nonatomic, strong) NSString* user_lastname;
@property (nonatomic, strong) NSString* user_profession;
@property (nonatomic, strong) NSString* user_id;

@property (nonatomic, strong) NSString* interest_name;
@property (nonatomic, strong) NSNumber* num_comments;
@property (nonatomic, strong) NSNumber* num_likes;
@property (nonatomic, strong) NSString* timeString;

@property (nonatomic,strong) NSNumber *is_liked;
@property (nonatomic, strong) NSNumber* mediaType;

@property (nonatomic, strong) NSArray* mentioned_users;
@property (nonatomic, strong) NSArray* topicLists;

@property (nonatomic,strong) NSNumber *isPanoromaVideo;

-(void)setUpWithDict:(NSDictionary *)dict;

@end
