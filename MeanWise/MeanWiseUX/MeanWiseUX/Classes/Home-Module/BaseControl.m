//
//  BaseControl.m
//  MeanWiseUX
//
//  Created by Hardik on 26/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "BaseControl.h"
#import "HMPlayerManager.h"
#import "ProfileWindowControl.h"

@implementation BaseControl


-(void)setUp
{
//    masterControl=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [self addSubview:masterControl];
//    [masterControl setContentSize:CGSizeMake(self.frame.size.width,self.frame.size.height*1.7)];
//    masterControl.pagingEnabled=false;
//    masterControl.showsHorizontalScrollIndicator=false;
//    masterControl.showsVerticalScrollIndicator=false;
//    masterControl.bounces=false;
//    masterControl.delegate=self;
//    masterControl.backgroundColor=[UIColor purpleColor];

    
    

  

    
    exploreComp=[self createExploreComponent];
    [exploreComp setUp];
    [exploreComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar) andScrollToTop:@selector(scrollToTop:)];
    [self addSubview:exploreComp];
    exploreComp.clipsToBounds=YES;

    
    
//    masterControl.contentOffset=CGPointMake(0,0);
    
    


    
    baseShadow=[[UIImageView alloc] initWithFrame:CGRectMake(0, 1190/2, 750/2, 144/2)];
    [self addSubview:baseShadow];
    [baseShadow setImage:[UIImage imageNamed:@"Base_Shadow.png"]];
    baseShadow.alpha=0.5;

    
    userBtn=[self setMenuItemWithImage:@"Base_ProfileIcon.png" onClick:@selector(userBtnClicked:) frame:CGRectMake(28/2, 1225/2, 35, 35)];

    newPostBtn=[self setMenuItemWithImage:@"Base_NewPostIcon.png" onClick:@selector(newPostBtnClicked:) frame:CGRectMake(325/2, 1210/2, 50, 50)];
    
    searchBtn=[self setMenuItemWithImage:@"Base_SearchIcon.png" onClick:@selector(searchBtnClicked:) frame:CGRectMake(501/2, 1225/2, 35, 35)];
    
    
    
    
    
    
    NSLog(@"homeFeedBtn.center = CGPointMake(%1.0f,%1.0f)",userBtn.center.x,userBtn.center.y);
    NSLog(@"3 = CGPointMake(%1.0f,%1.0f)",newPostBtn.center.x,newPostBtn.center.y);
    NSLog(@"notificationsBtn.center = CGPointMake(%1.0f,%1.0f)",searchBtn.center.x,searchBtn.center.y);
    
    
    userBtn.center = CGPointMake(108,630);
   // searchBtn.center = CGPointMake(344,630);
    
    searchBtn.center = CGPointMake(263,630);

    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        [AnalyticsMXManager PushAnalyticsEventAction:@"Push Notification Popup"];
        
        //ios 10
        //https://stackoverflow.com/questions/39382852/didreceiveremotenotification-not-called-ios-10/39383027#39383027
        
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    }


    [self addSubview:searchBtn];
    [self addSubview:newPostBtn];
    [self addSubview:userBtn];

    [self showTutorial];


}
-(void)scrollToTop:(id)sender
{
//    masterControl.contentOffset=CGPointMake(0, 0);
    
}
-(void)searchBtnClicked:(id)sender
{
    
    [self hideBottomBar];
    
    searchComp=[self createSearchComponent];
    [self addSubview:searchComp];
    [searchComp setUp];
    [searchComp setTarget:self onCloseFunc:@selector(searchComponentClosed:)];
    
    searchComp.clipsToBounds=YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        searchComp.frame=self.bounds;
        
    }];
    
}
-(void)searchComponentClosed:(id)sender
{
    [UIView animateWithDuration:0.7 animations:^{
        
        searchComp.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [searchComp removeFromSuperview];
        searchComp=nil;
        [self showBottomBar];
        
    }];

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [exploreComp setMasterScrollYPos:scrollView.contentOffset.y];
    
}
-(void)userBtnClicked:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"My Profile"];

    APIObjects_ProfileObj *obj=[UserSession getUserObj];
    
//    ProfileFullScreen *com=[[ProfileFullScreen alloc] initWithFrame:self.bounds];
//    [self addSubview:com];
//    [com setUpProfileObj:obj];
//    
//    CGRect rect=CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
//    [com setUpWithCellRect:rect];
//    
//    
//    [com setDelegate:self andPageChangeCallBackFunc:@selector(backFromCenterProfile:) andDownCallBackFunc:@selector(backFromCenterProfile:)];
//    
    
    
    CGRect frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
    frame=userBtn.frame;
    NSDictionary *dict=@{@"cover_photo":obj.cover_photo,@"user_id":obj.userId};
    ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
    [control setUp:dict andSourceFrame:frame];
    [control setTarget:self onClose:@selector(backFromCenterProfile:)];
    
    
    [self hideBottomBar];
    

}
-(void)backFromCenterProfile:(id)sender
{
    

    [self showBottomBar];
    
}


-(void)newPostBtnClicked:(id)sender
{
    NSUserDefaults *nud=[NSUserDefaults standardUserDefaults];
    [nud setValue:[NSNumber numberWithFloat:0.0f] forKey:@"GALLERY_SCROLLY"];
    [nud synchronize];
    
    
    if([[UserSession getUserType] intValue]==1)
    {
        
        [Constant setStatusBarColorWhite:true];
        
        [AnalyticsMXManager PushAnalyticsEventAction:@"New Post Screen"];
        
        
        NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.bounds];
        [self addSubview:cont];
        [cont setTarget:self onCloseEvent:@selector(newPostBackToHome:)];
        
        [cont setUpWithCellRect:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    }
    else
    {
        [Constant setStatusBarColorWhite:true];

        [AnalyticsMXManager PushAnalyticsEventAction:@"Invite Code screen"];
        
        
        inviteCodeComp=[[InviteCodeComponent alloc] initWithFrame:self.bounds];
        [self addSubview:inviteCodeComp];
        [inviteCodeComp setUp];
        [inviteCodeComp setTarget:self CallBackSuccess:@selector(inviteCodeSuccess:) andCallBackCance:@selector(inviteCodeCancel:)];
        
        
    }
    
    
}
-(void)inviteCodeCancel:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Invite Code Screen Cancel"];
    
    
    [inviteCodeComp removeFromSuperview];
    inviteCodeComp=nil;
}
-(void)inviteCodeSuccess:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Invite Code Screen Success"];
    
    [inviteCodeComp removeFromSuperview];
    inviteCodeComp=nil;
    [self newPostBtnClicked:nil];
    
}
-(void)newPostBackToHome:(id)sender
{
    int p=0;
}






-(UIButton *)setMenuItemWithImage:(NSString *)imgName onClick:(SEL)selector frame:(CGRect)rect
{
    
    UIButton *btn=[[UIButton alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

-(NewExploreComponent *)createExploreComponent
{
    
    return [[NewExploreComponent alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height*2)];
}
-(SearchGraphComponent *)createSearchComponent
{
    
    return [[SearchGraphComponent alloc] initWithFrame:CGRectMake(0,self.frame.size.height, self.frame.size.width, self.frame.size.height)];
}

-(void)hideBottomBar
{
    userBtn.hidden=true;
    newPostBtn.hidden=true;
    searchBtn.hidden=true;
//    masterControl.scrollEnabled = NO;
    baseShadow.hidden=true;
    
}
-(void)showBottomBar
{

    userBtn.hidden=false;
    newPostBtn.hidden=false;
    searchBtn.hidden=false;
//    masterControl.scrollEnabled = true;
     baseShadow.hidden=false;
}
-(void)showTutorial
{
    
    if([Constant isHomePageTutorialFinished]==false && 1==2)
    {
        [AnalyticsMXManager PushAnalyticsEventAction:@"Tutorial"];
        
        
        tutorialCmp=[[TutorialComponent alloc] initWithFrame:self.bounds];
        [self addSubview:tutorialCmp];
        [tutorialCmp setUp];
        [tutorialCmp setTarget:self andDoneBtnCallBack:@selector(hideTutorial:)];
    }
}
-(void)hideTutorial:(UIView *)view
{
    
    
    [tutorialCmp removeFromSuperview];
    tutorialCmp=nil;
    
    
    
}
@end
