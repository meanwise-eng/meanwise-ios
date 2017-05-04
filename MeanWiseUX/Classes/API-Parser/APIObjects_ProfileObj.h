//
//  APIObjects_ProfileObj.h
//  MeanWiseUX
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIObjects_ProfileObj : NSObject

@property (nonatomic, strong) NSString* idDetail;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* cover_photo;
@property (nonatomic, strong) NSString* bio;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* first_name;
@property (nonatomic, strong) NSString* last_name;
@property (nonatomic, strong) NSString* profession;
@property (nonatomic, strong) NSString* profile_photo_small;
@property (nonatomic, strong) NSString* profile_photo;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* dob;
@property (nonatomic, strong) NSString* phone;

@property (nonatomic,strong) NSArray *interests;
@property (nonatomic,strong) NSArray *skills;

@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* profile_story_title;
@property (nonatomic, strong) NSString* profile_story_description;

@property (nonatomic,strong) NSArray *userFriends;
@property (nonatomic,strong) NSString *friendShipStatus;

-(void)setUpWithDict:(NSDictionary *)dict;

@end
