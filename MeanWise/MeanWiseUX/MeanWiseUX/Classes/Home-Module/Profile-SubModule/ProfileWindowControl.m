//
//  ProfileWindowControl.m
//  MeanWiseUX
//
//  Created by Hardik on 08/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileWindowControl.h"
#import "GUIScaleManager.h"
#import "ResolutionVersion.h"
#import "Constant.h"
#import "APIManager.h"
#import "ProfileFullScreen.h"
#import "FTIndicator.h"
#import "ProfileWindowFullControl.h"

@implementation ProfileWindowControl 




-(void)setTarget:(id)targetReceived onClose:(SEL)func;
{
    target=targetReceived;
    onCloseFunc=func;
    
}
-(void)setUp:(NSDictionary *)dict andSourceFrame:(CGRect)frame
{
    
    isAnimationFinished=0;
    isDataReceived=0;
    isProfileOpened=0;
    
    NSString *cover_photo_URL=[dict valueForKey:@"cover_photo"];
    
    sourceFrame=frame;

    self.frame=[UIScreen mainScreen].bounds;

    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:self];
    
    
    
    self.clipsToBounds=YES;
    
    self.backgroundColor=[UIColor clearColor];
    
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    
    [GUIScaleManager setTransform:self];
    
    
    self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    NSLog(@"%@",NSStringFromCGRect(self.frame));

    if(RX_isiPhone4Res)
    {
        self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    
    containerView=[[UIView alloc] initWithFrame:RX_mainScreenBounds];
    [self addSubview:containerView];
    
    coverPhoto=[[UIImageHM alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:coverPhoto];
    [coverPhoto setUp:cover_photo_URL];
    coverPhoto.alpha=0;
    coverPhoto.backgroundColor=[UIColor lightGrayColor];

    
    animationView=[[UIView alloc] initWithFrame:sourceFrame];
    [self addSubview:animationView];
    animationView.layer.cornerRadius=sourceFrame.size.width/2;
    animationView.backgroundColor=[UIColor whiteColor];

    
    [FTIndicator showProgressWithmessage:@".." userInteractionEnable:false];
   
   
    
    [UIView animateWithDuration:0.5f animations:^{
        
        animationView.transform=CGAffineTransformMakeScale(50, 50);
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
        animationView.alpha=0;
        coverPhoto.alpha=1;

    } completion:^(BOOL finished)
    {
    
        isAnimationFinished=1;
        [self openUpMainProfile];

    }];

    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForUserData:[UserSession getAccessToken] andUserId:[dict valueForKey:@"user_id"] delegate:self andSelector:@selector(UserDataReceived:)];
    
    
}
-(void)UserDataReceived:(APIResponseObj *)obj
{
    if(obj.statusCode==200)
    {
        isDataReceived=1;
        userData=[[APIObjects_ProfileObj alloc] init];
        [userData setUpWithDict:obj.response];
    
        [self openUpMainProfile];
    }

}
-(void)openUpMainProfile
{
    if(isDataReceived==1 && isProfileOpened==0 && isAnimationFinished==1)
    {
        isProfileOpened=1;
        coverPhoto.hidden=true;
        animationView.hidden=true;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

        [FTIndicator dismissProgress];
        
        
        ProfileWindowFullControl *demo=[[ProfileWindowFullControl alloc] initWithFrame:RX_mainScreenBounds];
        [demo setUpProfileObj:userData];
        [demo setUpCustom:sourceFrame];
        [self addSubview:demo];
        [demo setTarget:self onCloseFunc:@selector(closeBtnClicked:)];
        
    }

}

-(void)closeBtnClicked:(id)sender
{
    
    [UIView animateWithDuration:0.01 animations:^{
        
        animationView.transform=CGAffineTransformMakeScale(1, 1);
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [target performSelector:onCloseFunc withObject:nil afterDelay:0.01];
        [self removeFromSuperview];
        
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
   
}
@end
