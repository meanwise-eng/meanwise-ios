//
//  DeepLinkViewer.m
//  MeanWiseUX
//
//  Created by Hardik on 12/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "DeepLinkViewer.h"
#import "FTIndicator.h"
#import "APIManager.h"
#import "GUIScaleManager.h"

@implementation DeepLinkViewer


-(void)setUpWithPostId:(NSString *)postId
{
    
    profileIdentifier=[HMPlayerManager sharedInstance].Profile_urlIdentifier;
    homeIdentifier=[HMPlayerManager sharedInstance].Home_urlIdentifier;
    exploreIdentifier=[HMPlayerManager sharedInstance].Explore_urlIdentifier;
    notificationIdentifier=[HMPlayerManager sharedInstance].NotificationPost_urlIdentifier;
    
    [AnalyticsMXManager PushAnalyticsEventAction:@"DeepLinkViewer"];


    [HMPlayerManager sharedInstance].Profile_urlIdentifier=@"";
    [HMPlayerManager sharedInstance].Home_urlIdentifier=@"";
    [HMPlayerManager sharedInstance].Explore_urlIdentifier=@"";
    [HMPlayerManager sharedInstance].NotificationPost_urlIdentifier=@"";
    
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    CGRect screenRect=RX_mainScreenBounds;

//    self.frame=screenRect;

    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
    [GUIScaleManager setTransform:self];
    
    self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    
    
    
    [self getPostInfo:postId];
    
    
}
-(void)getPostInfo:(NSString *)postId
{
    
    [FTIndicator showProgressWithmessage:@"Retriving.."];

    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForPostInfoWithId:postId Withdelegate:self andSelector:@selector(postInfoReceived:)];
    
    
}
-(void)postInfoReceived:(APIResponseObj *)obj
{
    
    CGRect screenRect=self.bounds;

    if(obj.statusCode==200)
    {
        [FTIndicator dismissProgress];

        postView=[[DeepLinkPostViewer alloc] initWithFrame:screenRect];
        [self addSubview:postView];
        [postView setUpWithPostId:obj.response withComment:false];
        
        [postView setTarget:self backBtnCallBack:@selector(backToDeepLinkManager:)];
        

    }
    else
    {
     
        [FTIndicator dismissProgress];
        [FTIndicator showErrorWithMessage:@"Post Not Found"];

        [self hideDone];
    }

    
}
-(void)backToDeepLinkManager:(id)sender
{
    [self hideDone];
}
-(void)setDelegate:(id)target onCleanUp:(SEL)func
{
    delegate=target;
    onCleanupCallBack=func;
}
-(void)cleanUp
{

    [HMPlayerManager sharedInstance].Profile_urlIdentifier=profileIdentifier;
    [HMPlayerManager sharedInstance].Home_urlIdentifier=homeIdentifier;
    [HMPlayerManager sharedInstance].Explore_urlIdentifier=exploreIdentifier;
    [HMPlayerManager sharedInstance].NotificationPost_urlIdentifier=notificationIdentifier;
    
    [postView removeFromSuperview];
    postView=nil;
    
    [self removeFromSuperview];


}
-(void)hideDone
{

    [delegate performSelector:onCleanupCallBack withObject:nil afterDelay:0.01];
    
    [HMPlayerManager sharedInstance].Profile_urlIdentifier=profileIdentifier;
    [HMPlayerManager sharedInstance].Home_urlIdentifier=homeIdentifier;
    [HMPlayerManager sharedInstance].Explore_urlIdentifier=exploreIdentifier;
    [HMPlayerManager sharedInstance].NotificationPost_urlIdentifier=notificationIdentifier;

    
        
    
        [postView removeFromSuperview];
        postView=nil;
        
        [self removeFromSuperview];
       
        
        
    
    
}

@end
