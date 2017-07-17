//
//  APIObjects_ProfileObj.h
//  MeanWiseUX
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIObjects_ProfileObj : NSObject

@property (nonatomic,strong) NSNumber *colorNumber;


@property (nonatomic, strong) NSString* idDetail;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* cover_photo;
@property (nonatomic, strong) NSString* bio;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* first_name;
@property (nonatomic, strong) NSString* last_name;
@property (nonatomic, strong) NSString* profile_photo_small;
@property (nonatomic, strong) NSString* profile_photo;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* dob;
@property (nonatomic, strong) NSString* phone;

@property (nonatomic,strong) NSArray *interests;

@property (nonatomic, strong) NSArray* skill_List;
@property (nonatomic, strong) NSString* profile_background_color;
@property (nonatomic,strong) NSString *profession_text;
@property (nonatomic,strong) NSNumber *user_type;


@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* profile_story_title;
@property (nonatomic, strong) NSString* profile_story_description;

@property (nonatomic,strong) NSArray *userFriends;
@property (nonatomic,strong) NSString *friendShipStatus;


@property (nonatomic,strong) NSArray *skillsX;
@property (nonatomic, strong) NSString* professionX;

-(void)setUpWithDict:(NSDictionary *)dict;

@end
