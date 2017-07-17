//
//  NotificationBadgeView.m
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NotificationBadgeView.h"
#import "NotificationsComponent.h"
#import "FTIndicator.h"
#import "GUIScaleManager.h"

@implementation NotificationBadgeView

-(void)setDelegate:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2
{
    delegate=target;
    showFunc=func1;
    hideFunc=func2;
    
}
-(void)setUp:(id)dataObj
{
    objMain=dataObj;
    ifnotificationExpanded=false;
    statusBarNotifierView=nil;
    
   
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    

    
    float padding=4;
    

    
    hiddenRect=CGRectMake(padding, -60, window.frame.size.width-padding*2, 55);
    showingRect=CGRectMake(padding, padding, window.frame.size.width-padding*2, 55);
    
    [AnalyticsMXManager PushAnalyticsEvent:@"NotifyBadge"];


    
    statusBarNotifierView=[[UIView alloc] initWithFrame:hiddenRect];
    
    //statusBarNotifierView.backgroundColor=[UIColor colorWithRed:0.27 green:0.80 blue:1.00 alpha:1.00];
    statusBarNotifierView.backgroundColor=[UIColor whiteColor];
    
    statusBarNotifierView.clipsToBounds=YES;
    statusBarNotifierView.layer.cornerRadius=4;
    
   

    
    [window addSubview:statusBarNotifierView];
    [window bringSubviewToFront:statusBarNotifierView];
    
    int innerPadding=12;
    int thumbSizeWidth=showingRect.size.height-innerPadding*2;
    
   
    
    if([dataObj isKindOfClass:[APIObjects_NotificationObj class]])
    {
        APIObjects_NotificationObj *obj=(APIObjects_NotificationObj *)dataObj;
        
        NSString *thumbURL=obj.notifier_userThumbURL;
        NSString *userFullName=[NSString stringWithFormat:@"%@ %@",obj.notifier_userFirstName,obj.notifier_userLastName];
        NSString *notificationTime=obj.created_on;
        NSString *message=@"";
        
        if(obj.notification_typeNo.intValue==1)
        {
            message=@"Liked your post!";
        }
        if(obj.notification_typeNo.intValue==2)
        {
            message=@"Left a comment!";
        }
        if(obj.notification_typeNo.intValue==3)
        {
            message=@"Accepted your friend request!";
        }
        if(obj.notification_typeNo.intValue==4)
        {
            message=@"Added you as a friend!";
        }
        
        
        
      
        
        
        profilePic=[[UIImageHM alloc] initWithFrame:CGRectMake(10, innerPadding, thumbSizeWidth, thumbSizeWidth)];
        profilePic.layer.cornerRadius=(thumbSizeWidth)/2;
        [profilePic setUp:thumbURL];
        [statusBarNotifierView addSubview:profilePic];
        
        
        notifierFullNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(20+thumbSizeWidth, innerPadding, 200,thumbSizeWidth/2)];
        [notifierFullNameLBL setTextColor:[UIColor darkGrayColor]];
        notifierFullNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        [statusBarNotifierView addSubview:notifierFullNameLBL];
        notifierFullNameLBL.text=userFullName;
        
        notifierMsgLBL=[[UILabel alloc] initWithFrame:CGRectMake(20+thumbSizeWidth, innerPadding+thumbSizeWidth/2, 200, thumbSizeWidth/2)];
        
        [notifierMsgLBL setTextColor:[UIColor lightGrayColor]];
        notifierMsgLBL.font=[UIFont fontWithName:k_fontRegular size:12];
        [statusBarNotifierView addSubview:notifierMsgLBL];
        notifierMsgLBL.text=message;
        
        
        timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(showingRect.size.width-50-10, innerPadding, 50,thumbSizeWidth/2)];
        [timeLBL setTextColor:[UIColor darkGrayColor]];
        timeLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        [statusBarNotifierView addSubview:timeLBL];
        timeLBL.text=notificationTime;
        timeLBL.textAlignment=NSTextAlignmentRight;

        // do somthing
    }
    else
    {
       
        
        NSNumber *number=(NSNumber *)dataObj;
        
        notifierFullNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, innerPadding, 200,thumbSizeWidth/2)];
        [notifierFullNameLBL setTextColor:[UIColor darkGrayColor]];
        notifierFullNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        [statusBarNotifierView addSubview:notifierFullNameLBL];
        notifierFullNameLBL.text=[NSString stringWithFormat:@"You have %d notifications!",number.intValue];
        
        
        notifierMsgLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, innerPadding+thumbSizeWidth/2, 200, thumbSizeWidth/2)];
        
        [notifierMsgLBL setTextColor:[UIColor lightGrayColor]];
        notifierMsgLBL.font=[UIFont fontWithName:k_fontRegular size:12];
        [statusBarNotifierView addSubview:notifierMsgLBL];
        notifierMsgLBL.text=@"Tap to view";
        
    }
    
 

    fullSizeBtn=[[UIButton alloc] initWithFrame:statusBarNotifierView.bounds];
    [statusBarNotifierView addSubview:fullSizeBtn];
    [fullSizeBtn addTarget:self action:@selector(TapToViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    fullSizeBtn.enabled=true;
    

    if([dataObj isKindOfClass:[APIObjects_NotificationObj class]])
    {

        APIObjects_NotificationObj *obj=(APIObjects_NotificationObj *)dataObj;
        if(obj.notification_typeNo.intValue==4)
        {
        buttonAccept=[[UIButton alloc] initWithFrame:CGRectMake(statusBarNotifierView.frame.size.width-100, 15, 80, statusBarNotifierView.frame.size.height-30)];
        [statusBarNotifierView addSubview:buttonAccept];
        buttonAccept.backgroundColor=[UIColor whiteColor];
        buttonAccept.clipsToBounds=YES;
        buttonAccept.layer.cornerRadius=10;
        buttonAccept.layer.borderWidth=1;
        buttonAccept.titleLabel.font=[UIFont fontWithName:k_fontRegular size:12];
        [buttonAccept setTitle:@"Accept" forState:UIControlStateNormal];
        [buttonAccept setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonAccept addTarget:self action:@selector(AcceptRequestBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            timeLBL.hidden=true;
        }
    }
    [self showProgress];
    
}
-(void)AcceptRequestBtnClicked:(id)sender
{
    [self performSelector:@selector(hideDone) withObject:nil afterDelay:0.2];

    APIObjects_NotificationObj *obj=(APIObjects_NotificationObj *)objMain;
    NSDictionary *dict=@{@"friend_id":obj.notifier_userId,@"status":@"accepted"};
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForUpdateFriendshipStatus:dict delegate:self andSelector:@selector(updateFriendshipStatus:)];
    
}


-(void)updateFriendshipStatus:(APIResponseObj *)responseObj
{
    NSString *msg=(NSString *)responseObj.response;
    
    [FTIndicator showSuccessWithMessage:msg];
    
    
}
-(void)TapToViewPressed:(id)sender
{
    CGRect rect=RX_mainScreenBounds;
    
    mainView=[[UIView alloc] initWithFrame:RX_mainScreenBounds];
    [window addSubview:mainView];
    [GUIScaleManager setTransform:mainView];
    mainView.frame=mainView.bounds;

    ifnotificationExpanded=true;
    
    profileIdentifier=[HMPlayerManager sharedInstance].Profile_urlIdentifier;
    homeIdentifier=[HMPlayerManager sharedInstance].Home_urlIdentifier;
    exploreIdentifier=[HMPlayerManager sharedInstance].Explore_urlIdentifier;
    
    
    [HMPlayerManager sharedInstance].Profile_urlIdentifier=@"";
    [HMPlayerManager sharedInstance].Home_urlIdentifier=@"";
    [HMPlayerManager sharedInstance].Explore_urlIdentifier=@"";


    if(RX_isiPhone7PlusRes)
    {
        mainView.frame=[UIScreen mainScreen].bounds;
    }
    
    expandedView=[[NotificationsComponent alloc] initWithFrame:CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height)];
    
    [mainView addSubview:expandedView];
    [expandedView setUp:nil];
    [expandedView setTarget:self andBackBtnFunc:@selector(backBtnFunc:)];
    
    
    
    if(sender==nil)
    {
        [window bringSubviewToFront:statusBarNotifierView];

    }
    
    expandedView.alpha=0;

 
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
            expandedView.alpha=1;
        
        expandedView.frame=rect;
        
    } completion:^(BOOL finished) {
        [self hideProgress];
        
    }];
    
}
-(void)backBtnFunc:(id)sender
{
    [HMPlayerManager sharedInstance].Profile_urlIdentifier=profileIdentifier;
    [HMPlayerManager sharedInstance].Home_urlIdentifier=homeIdentifier;
    [HMPlayerManager sharedInstance].Explore_urlIdentifier=exploreIdentifier;
    
    [expandedView removeFromSuperview];
    [mainView removeFromSuperview];
    mainView=nil;
    
    expandedView=nil;

}
-(void)showProgress
{
    [delegate performSelector:hideFunc withObject:nil afterDelay:0.0001];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        statusBarNotifierView.frame=showingRect;

    } completion:^(BOOL finished) {
        [self hideProgress];

    }];
    
}
-(void)hideProgress
{
    
    
    
    float duration=2.0f;
    if([objMain isKindOfClass:[APIObjects_NotificationObj class]])
    {
        
        APIObjects_NotificationObj *obj=(APIObjects_NotificationObj *)objMain;
        if(obj.notification_typeNo.intValue==4)
        {
            duration=5.0f;
        }
    }
    else
    {
        
        
    }
    
    [self performSelector:@selector(hideDone) withObject:nil afterDelay:duration];
    
}
-(void)hideDone
{
 
    
    
    fullSizeBtn.enabled=false;
    
        [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            statusBarNotifierView.frame=hiddenRect;
            
            
        } completion:^(BOOL finished) {
            
            [statusBarNotifierView removeFromSuperview];
        


            [delegate performSelector:showFunc withObject:nil afterDelay:0.0001];
            
        }];
        
    
}

@end
