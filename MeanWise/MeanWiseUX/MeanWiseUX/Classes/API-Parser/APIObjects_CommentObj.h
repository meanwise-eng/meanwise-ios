//
//  APIObjects_CommentObj.h
//  MeanWiseUX
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIObjects_CommentObj : NSObject

@property (nonatomic, strong) NSString* commentId;
@property (nonatomic, strong) NSString* post_id;
@property (nonatomic, strong) NSString* user_first_name;
@property (nonatomic, strong) NSString* user_last_name;
@property (nonatomic, strong) NSString* user_profile_photo;
@property (nonatomic, strong) NSString* user_profile_photo_small;
@property (nonatomic, strong) NSString* user_username;
@property (nonatomic, strong) NSString* comment_text;
@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, strong) NSString* timeString;
@property (nonatomic, strong) NSArray* mentioned_users;
@property (nonatomic, strong) NSNumber* comment_id_number;


-(void)setUpWithDict:(NSDictionary *)dict;

@end
