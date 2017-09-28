//
//  APIObjects_DiscussionObj.h
//  MeanWiseUX
//
//  Created by Hardik on 10/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIObjects_DiscussionObj : NSObject

/*
 
 text
 type
 datetime
 post_id
 comment_id
 userprofile.first_name
 userprofile.last_Name
 userid
 userprofilepicture
 posttext
 postimageurl
 
 */


@property (nonatomic,strong) NSNumber *post_id;
@property (nonatomic,strong) NSNumber *comment_id;

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* datetime;
@property (nonatomic, strong) NSString* type;

@property (nonatomic, strong) NSNumber* userprofile_user_id;
@property (nonatomic, strong) NSString* userprofile_first_name;
@property (nonatomic, strong) NSString* userprofile_last_name;
@property (nonatomic, strong) NSString* userprofile_profile_photo_thumbnail_url;

@property (nonatomic, strong) NSString* post_text;
@property (nonatomic, strong) NSString* post_image_url;

-(void)setUpWithDict:(NSDictionary *)dict;



@end
