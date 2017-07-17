//
//  UserSession.h
//  MeanWiseUX
//
//  Created by Hardik on 28/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObjects_ProfileObj.h"

@interface UserSession : NSObject


+(APIObjects_ProfileObj *)sessionProfileObj;

+(NSString *)getFullName;
+(NSString *)getProfilePictureURL;
+(NSString *)getUserId;
+(NSString *)getUserName;
+(NSString *)getCoverPictureURL;
+(NSString *)getBigProfilePictureURL;
+(NSString *)getBioText;
+(NSString *)getFirstName;
+(NSString *)getLastName;
+(NSString *)getBirthDate;
+(NSString *)getPhoneNumber;

+(NSNumber *)getUserType;
+(NSString *)getProfileBackgroundColor;
+(NSArray *)getUserCustomSkills;
+(NSString *)getprofessiontext;

+(NSString *)getCityLocation;
+(NSString *)getProfileStoryTitle;
+(NSString *)getProfileStoryDesc;

+(NSArray *)getUserInterests;




+(NSString *)getAccessToken;
+(NSString *)getAccessTokenOnLaunch;

//Old
+(NSArray *)getXUserSkills;
+(NSString *)getXProffesion;

+(APIObjects_ProfileObj *)getUserObj;

//Use while New login
+(void)setSessionProfileObj:(NSDictionary *)sessionDict andAccessToken:(NSString *)token;

//Use when app re-starts to check
+(void)setUserSessionIfExist;

//User whle Signout
+(void)clearUserSession;
@end
