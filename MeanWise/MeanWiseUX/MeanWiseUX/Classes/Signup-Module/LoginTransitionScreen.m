//
//  LoginTransitionScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 25/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "LoginTransitionScreen.h"
#import "UserSession.h"

@implementation LoginTransitionScreen

-(void)setUpForLogin:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2 andDict:(NSDictionary *)credintials;
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:2];

    
    accessToken=@"";
    
    emailUserId=[credintials valueForKey:@"email"];
    
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
    
    
    [self loginRequestSend:[credintials valueForKey:@"email"] andPassword:[credintials valueForKey:@"password"]];
    
}
-(void)loginRequestSend:(NSString *)email andPassword:(NSString *)password
{
    NSDictionary *dict1=@{
                          @"email":email,
                          @"password":password,
                          };
    
    manager=[[APIManager alloc] init];
    [manager sendRequestForLoginWithData:dict1 delegate:self andSelector:@selector(loginResponse:)];
    
}

-(void)loginResponse:(APIResponseObj *)responseObj
{
    
    if(responseObj.statusCode!=200)
    {
        [self redirectForFail:responseObj.response];
        manager=nil;

    }
    else
    {
        
        [self retrivingUserData:[responseObj.response valueForKey:@"token"] andUserId:[responseObj.response valueForKey:@"user_id"]];
        NSLog(@"%@",responseObj.response);
        
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

/*
        if([responseObj.response isKindOfClass:[NSArray class]])
        {
            
            NSArray *array=(NSArray *)responseObj.response;
            
            NSDictionary *pUser;
            
            for(int i=0;i<[array count];i++)
            {
                NSDictionary *dict=[array objectAtIndex:i];
                
                if([[dict valueForKey:@"username"] isEqualToString:emailUserId])
                {
                    pUser=dict;
                    NSLog(@"UserInfo \n\n%@",dict);
                    break;
                }
            }
            
            [self saveSession:pUser];
            [self redirectForSuccess:nil];

        }
        */
        

    }

}
-(void)saveSession:(NSDictionary *)dict;
{
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
