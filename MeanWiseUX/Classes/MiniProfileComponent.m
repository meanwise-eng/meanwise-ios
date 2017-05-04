//
//  MiniProfileComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 19/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "MiniProfileComponent.h"
#import "UserSession.h"
#import "ProfileFullScreen.h"
#import "FTIndicator.h"

@implementation MiniProfileComponent

-(void)setTarget:(id)targetReceived onClose:(SEL)func;
{
    target=targetReceived;
    onCloseFunc=func;
    
}
-(void)setUp:(NSDictionary *)dict
{
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    sourceFrame=self.frame;
    [window addSubview:self];
    self.frame=window.bounds;

    isDataReceived=0;
    isProfileOpened=0;
    isCoverLoaded = 0;
    
    self.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0];

    containerView=[[UIView alloc] initWithFrame:sourceFrame];
    [self addSubview:containerView];
    containerView.layer.cornerRadius=sourceFrame.size.width/2;
    containerView.backgroundColor=[UIColor whiteColor];
    containerView.clipsToBounds=YES;
    
    profileImageView=[[ASNetworkImageNode alloc] init];
    [profileImageView setFrame:self.bounds];
    [self addSubview:profileImageView.view];
    [profileImageView setURL:[NSURL URLWithString:[dict valueForKey:@"user_cover_photo"]]];
    profileImageView.alpha=0;
    profileImageView.delegate = self;

    profileDict = dict;
    
    isAnimationFinished=0;
    
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        profileImageView.alpha=1;
        
        containerView.transform=CGAffineTransformMakeScale(50, 50);
        profileImageView.view.center=self.center;
        
        
    } completion:^(BOOL finished) {
        
        [FTIndicator setIndicatorStyle:UIBlurEffectStyleDark];
        [FTIndicator showProgressWithmessage:@""];
        isAnimationFinished=1;
        
    }];
    
    



}

-(POPBasicAnimation *)fadeInIconAnimation:(CGFloat)duration {
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = duration;
    
    return animation;
    
}

-(void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image{
    
    if (image) {
        
        NSLog(@"DID LOAD IMAGE ");
        
        POPBasicAnimation *animation = [self fadeInIconAnimation:0.6];
        
        [imageNode pop_removeAllAnimations];
        [imageNode pop_addAnimation:animation forKey:@"fadeIn"];
        
    }
}

-(void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode
{
    isCoverLoaded = 1;
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForUserData:[UserSession getAccessToken] andUserId:[profileDict valueForKey:@"user_id"] delegate:self andSelector:@selector(UserDataReceived:)];

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
    
    NSLog(@"COVER = %d, DATA = %d, ANIM = %d", isCoverLoaded, isDataReceived, isAnimationFinished);
    
    
    if(isDataReceived==1 && isProfileOpened==0 && isAnimationFinished==1 && isCoverLoaded==1)
    {

    ProfileFullScreen *com=[[ProfileFullScreen alloc] initWithFrame:self.bounds];
    [self addSubview:com];
    [com setUpProfileObj:userData profileImage:profileImageView.image];
    [com setUpWithCellRect:self.bounds];
    [com setClosingFrame:sourceFrame];
    
    [com setDelegate:self andPageChangeCallBackFunc:@selector(closeBtnClicked:) andDownCallBackFunc:@selector(closeBtnClicked:)];
        
        isProfileOpened=1;
        
        //profileImageView.hidden=true;
        //containerView.hidden=true;
        
        [FTIndicator dismissProgress];
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            
            profileImageView.alpha=0;
            
            containerView.transform=CGAffineTransformMakeScale(1, 1);
            
            
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
    
}

-(void)closeBtnClicked:(id)sender
{
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        profileImageView.alpha=0;

        containerView.transform=CGAffineTransformMakeScale(1, 1);

        
        
    } completion:^(BOOL finished) {
        
        
   
            [self removeFromSuperview];
            [target performSelector:onCloseFunc withObject:nil afterDelay:0.01];
            
        
    }];
    
    
    
    
}


/*
-(void)setUp:(NSDictionary *)dict
{
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    sourceFrame=self.frame;
    
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    [window addSubview:self];
    self.frame=window.bounds;

    containerView=[[UIView alloc] initWithFrame:sourceFrame];
    [self addSubview:containerView];
    containerView.backgroundColor=[UIColor whiteColor];
    containerView.alpha=1;
    
    
    FullNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.center.x-100, self.center.y-50, 200, 200)];
    proffesionLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.center.x-100, self.center.y-75, 200, 200)];
    [self addSubview:FullNameLBL];
    [self addSubview:proffesionLBL];
    FullNameLBL.textAlignment=NSTextAlignmentCenter;
    proffesionLBL.textAlignment=NSTextAlignmentCenter;
    FullNameLBL.text=@"Hardik Mehta";
    proffesionLBL.text=@"IT Consultant";
    FullNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    proffesionLBL.font=[UIFont fontWithName:k_fontSemiBold size:14];
    FullNameLBL.alpha=0;
    proffesionLBL.alpha=0;
    
    
    
    
    
    profileImageView=[[UIImageHM alloc] initWithFrame:sourceFrame];
    [self addSubview:profileImageView];
    profileImageView.backgroundColor=[UIColor whiteColor];
    profileImageView.layer.cornerRadius=sourceFrame.size.width/2;
    profileImageView.clipsToBounds=YES;
    [profileImageView setUp:[dict valueForKey:@"user_profile_photo_small"]];
    

    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, -50, 30, 30)];
    [self addSubview:closeBtn];
    closeBtn.backgroundColor=[UIColor redColor];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];


    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        profileImageView.center=self.center;
        containerView.center=self.center;

        
        closeBtn.frame=CGRectMake(30, 30, 30, 30);
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.9];
        
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            
            
            profileImageView.transform=CGAffineTransformMakeScale(2, 2);
            profileImageView.center=CGPointMake(self.center.x, self.center.y-50);
            containerView.frame=CGRectMake(self.center.x-100, self.center.y-100, 200, 200);
            FullNameLBL.alpha=1;
            proffesionLBL.alpha=1;
            
            containerView.alpha=1;

            
            
        } completion:^(BOOL finished) {
            
            
            
            
        }];
        
        
        
    }];
    
}


-(void)closeBtnClicked:(id)sender
{
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
    
    
        containerView.alpha=0;
        containerView.frame=CGRectMake(self.center.x-sourceFrame.size.width/2, self.center.y-sourceFrame.size.height/2, sourceFrame.size.width, sourceFrame.size.height);
        
        profileImageView.transform=CGAffineTransformMakeScale(1, 1);
        profileImageView.center=self.center;

        
    } completion:^(BOOL finished) {
        
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            
            closeBtn.frame=CGRectMake(0, -50, 30, 30);
            self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
            profileImageView.frame=sourceFrame;
            

            
        } completion:^(BOOL finished) {
            
            
            [self removeFromSuperview];
            [target performSelector:onCloseFunc withObject:nil afterDelay:0.01];
            
        }];
        
    }];

    
    
    
}
*/
@end
