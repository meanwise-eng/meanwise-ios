//
//  UserSession.m
//  MeanWiseUX
//
//  Created by Hardik on 28/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UserSession.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation UserSession

+(APIObjects_ProfileObj *)sessionProfileObj
{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    
    UINavigationController *vc=(UINavigationController *)topController;
    ViewController *t=(ViewController *)vc.topViewController;
    
    return t.sessionMain;
    
}
+(NSString *)getFirstName
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.first_name;
}
+(NSString *)getBirthDate;
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.dob;

}
+(NSString *)getPhoneNumber;
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.phone;

}
+(NSString *)getCityLocation
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.city;

}
+(NSString *)getProfileStoryTitle
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.profile_story_title;
   
}
+(NSString *)getProfileStoryDesc
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.profile_story_description;
    
}

+(NSString *)getLastName
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.last_name;
}
+(APIObjects_ProfileObj *)getUserObj
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj;

}
+(NSString *)getFullName
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    NSString *string=[NSString stringWithFormat:@"%@ %@",obj.first_name,obj.last_name];
    return string;
}
+(NSString *)getBioText
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.bio;

}
+(NSString *)getProfilePictureURL
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.profile_photo_small;
}
+(NSString *)getBigProfilePictureURL
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.profile_photo;
}

+(NSString *)getCoverPictureURL
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.cover_photo;
}
+(NSString *)getProffesion
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.profession;
}

+(NSString *)getUserId
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.userId;
}
+(NSString *)getUserName
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.username;
}
+(NSString *)getAccessToken
{
    APIObjects_ProfileObj *obj=[self sessionProfileObj];
    return obj.accessToken;
   
}
+(void)setSessionProfileObj:(NSDictionary *)sessionDict andAccessToken:(NSString *)token
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    
    UINavigationController *vc=(UINavigationController *)topController;
    ViewController *t=(ViewController *)vc.topViewController;

    t.sessionMain=[[APIObjects_ProfileObj alloc] init];
    t.sessionMain.accessToken=token;
    [t.sessionMain setUpWithDict:sessionDict];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:t.sessionMain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:encodedObject forKey:@"MW_UserSession"];
    [defaults synchronize];
    
}
+(void)setUserSessionIfExist
{
    
    NSUserDefaults *default1=[NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [default1 objectForKey:@"MW_UserSession"];
    APIObjects_ProfileObj *obj = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];


    if(obj==nil)
    {
        obj=nil;
    }

    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    
    UINavigationController *vc=(UINavigationController *)topController;
    ViewController *t=(ViewController *)vc.topViewController;
    
    t.sessionMain=obj;

    
}
+(void)clearUserSession;
{
    
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    
    UINavigationController *vc=(UINavigationController *)topController;
    ViewController *t=(ViewController *)vc.topViewController;
    
    t=nil;
    
    
    NSUserDefaults *default1=[NSUserDefaults standardUserDefaults];
    [default1 removeObjectForKey:@"MW_UserSession"];
    [default1 synchronize];


}

@end
