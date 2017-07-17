//
//  SignUpTransitionScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 25/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "SignUpTransitionScreen.h"
#import "UserSession.h"
#import "DataSession.h"

@implementation SignUpTransitionScreen

-(void)setUpForSignup:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2;
{
    
    
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:2];
//    
//    
//    accessToken=@"";
//    
//    emailUserId=[credintials valueForKey:@"username"];
//
    
    
    delegate=target;
    successFunc=func1;
    failFunc=func2;
    msgLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    loaderImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:msgLBL];
    [self addSubview:loaderImageView];
    
    msgLBL.text=@"Authenticating..";
    msgLBL.textColor=[UIColor whiteColor];
    msgLBL.textAlignment=NSTextAlignmentCenter;
    
    loaderImageView.image=[UIImage imageNamed:@"video-loader.png"];
    
    loaderImageView.center=self.center;
    msgLBL.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-50);
    [self rotateImageView];
    
    
    
    //[DataSession sharedInstance].signupObject.username=usernameField.text;

    //[self redirectForFail:nil];
    
    NSString *userName=[DataSession sharedInstance].signupObject.username;
    NSString *email=[DataSession sharedInstance].signupObject.email;
    NSString *first_name=[DataSession sharedInstance].signupObject.first_name;
    NSString *last_name=[DataSession sharedInstance].signupObject.last_name;
    NSString *profile_photo=[DataSession sharedInstance].signupObject.profile_photo;
    NSString *cover_photo=[DataSession sharedInstance].signupObject.cover_photo;
    NSString *password=[DataSession sharedInstance].signupObject.password;
    NSString *dob=[DataSession sharedInstance].signupObject.dob;
    
    NSArray *interest=[DataSession sharedInstance].signupObject.interests;
    NSArray *skills=[DataSession sharedInstance].signupObject.skills;
    
    
    
    NSString *interestStr = [[interest valueForKey:@"id"] componentsJoinedByString:@","];
    
//    NSString *skillStr = [[skills valueForKey:@"id"] componentsJoinedByString:@","];
    
    interestStr=[NSString stringWithFormat:@"[%@]",interestStr];
//    skillStr=[NSString stringWithFormat:@"[%@]",skillStr];
    
    
//@"[1,2]"
    NSDictionary *dict1=@{
                          @"username":userName,
                          @"email":email,
                          @"password":password,
                          @"first_name":first_name,
                          @"last_name":last_name,
                          @"dob":dob,
                          @"interests":interestStr,
                          @"skills_list":skills,
                          @"profile_photo":profile_photo,
                          @"cover_photo":cover_photo,
                          @"invite_code":@"REALPEOPLE",
                          @"profile_background_color":@"#66CCFF",
                         // @"profession":@"1"
                          
                          };
    

    
    
    

    [self requestForSignupWithDic:dict1];
    

}
-(void)requestForSignupWithDic:(NSDictionary *)dict
{
    manager=nil;
    manager=[[APIManager alloc] init];
    [manager sendRequestForSignUp:dict delegate:self andSelector:@selector(signupRequestReceived:)];
    
}
-(void)signupRequestReceived:(APIResponseObj *)obj
{
    if(obj.statusCode==200)
    {
        // {"error":"","status":"success","results":{"auth_token":"052c5302c725bda9d8a19959dcedf4ca07b30314","user":23,"userprofile":12}}

        NSString *accessTokenReceived=[obj.response valueForKey:@"auth_token"];
        NSString *userId=[obj.response valueForKey:@"user"];
        
        [self retrivingUserData:accessTokenReceived andUserId:userId];
        
    }
    else
    {
        NSLog(@"%@",obj.message);
        [self redirectForFail:nil];
    }
    
    
}
-(void)retrivingUserData:(NSString *)token andUserId:(NSString *)userId
{
    manager=nil;
    
    accessToken=token;
    
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForUserData:token andUserId:userId delegate:self andSelector:@selector(retrivingUserDataReceived:)];
    
    
    
    
    
}
-(void)retrivingUserDataReceived:(APIResponseObj *)responseObj
{
    
    
    if(responseObj.statusCode!=200)
    {
        [self redirectForFail:responseObj.response];
        manager=nil;
        
    }
    else
    {
        [self saveSession:responseObj.response];
        [self redirectForSuccess:nil];
        
        manager=nil;
        
        
    }
    
}
-(void)saveSession:(NSDictionary *)dict;
{
    [AnalyticsMXManager PushAnalyticsEvent:@"Signup Completed"];
    [UserSession setSessionProfileObj:dict andAccessToken:accessToken];
    
}


#pragma mark - Flow


-(void)redirectForSuccess:(id)sender
{
    
    [delegate performSelector:successFunc withObject:nil afterDelay:1.0f];
    
}
-(void)redirectForFail:(NSDictionary *)dict
{
    
    [delegate performSelector:failFunc withObject:dict afterDelay:1.0f];
    
}

#pragma mark - Helper

- (void)rotateImageView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [loaderImageView setTransform:CGAffineTransformRotate(loaderImageView.transform, M_PI_2)];
    }completion:^(BOOL finished){
        if (finished) {
            [self rotateImageView];
        }
    }];
}
@end
