//
//  BaseControl.m
//  MeanWiseUX
//
//  Created by Hardik on 26/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "BaseControl.h"
#import "HMPlayerManager.h"

@implementation BaseControl

-(void)setUp
{
    masterControl=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:masterControl];
    [masterControl setContentSize:CGSizeMake(self.frame.size.width*3,0)];
    masterControl.pagingEnabled=true;
    masterControl.showsHorizontalScrollIndicator=false;
    masterControl.showsVerticalScrollIndicator=false;
    masterControl.bounces=false;
    masterControl.delegate=self;
    masterControl.backgroundColor=[UIColor purpleColor];

    
    homeComp=[[HomeComponent alloc] initWithFrame:CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height)];
    [homeComp setUp];
    [masterControl addSubview:homeComp];
    [homeComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
    

    
    searchComp=[self createSearchComponent];
    [masterControl addSubview:searchComp];
    [searchComp setUp];
    [searchComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
    searchComp.clipsToBounds=YES;

    
    exploreComp=[self createExploreComponent];
    [exploreComp setUp];
    [exploreComp setTarget:self andHide:@selector(hideBottomBar) andShow:@selector(showBottomBar)];
    [masterControl addSubview:exploreComp];
    exploreComp.clipsToBounds=YES;

    
    
    
    
    masterControl.pagingEnabled=YES;
    
//    
//   
//    userBtn=[[UIButton alloc] initWithFrame:CGRectMake(21/2, 971/2+245/2, 35, 35)];
//    
//    homeFeedBtn=[[UIButton alloc] initWithFrame:CGRectMake(179/2, 971/2+245/2, 35, 35)];
//    
//    newPostBtn=[[UIButton alloc] initWithFrame:CGRectMake(324/2, 955/2+245/2, 50, 50)];
//    
//    searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(500/2, 971/2+245/2, 35, 35)];
//
//    notificationsBtn=[[UIButton alloc] initWithFrame:CGRectMake(651/2, 971/2+245/2, 35, 35)];


    
    baseShadow=[[UIImageView alloc] initWithFrame:CGRectMake(0, 1190/2, 750/2, 144/2)];
    [self addSubview:baseShadow];
    [baseShadow setImage:[UIImage imageNamed:@"Base_Shadow.png"]];
    baseShadow.alpha=0.5;

    
    userBtn=[self setMenuItemWithImage:@"Base_ProfileIcon.png" onClick:@selector(userBtnClicked:) frame:CGRectMake(28/2, 1225/2, 35, 35)];
    homeFeedBtn=[self setMenuItemWithImage:@"Base_HomeIcon.png" onClick:@selector(homeFeedBtnClicked:) frame:CGRectMake(180/2, 1225/2, 35, 35)];

    newPostBtn=[self setMenuItemWithImage:@"Base_NewPostIcon.png" onClick:@selector(newPostBtnClicked:) frame:CGRectMake(325/2, 1210/2, 50, 50)];
    
    searchBtn=[self setMenuItemWithImage:@"Base_SearchIcon.png" onClick:@selector(searchBtnClicked:) frame:CGRectMake(501/2, 1225/2, 35, 35)];
    
    notificationsBtn=[self setMenuItemWithImage:@"Base_NotificationIcon.png" onClick:@selector(notificationsBtnClicked:) frame:CGRectMake(652/2, 1225/2, 35, 35)];
    
    
    backBtn=[self setMenuItemWithImage:@"Base_BackIcon.png" onClick:@selector(backBtnClicked:) frame:CGRectMake(345/2, 1239/2, 60/2, 40/2)];
    
    backBtn.alpha=0;
    

    label=[[UILabel alloc] initWithFrame:CGRectMake(25/2,-5, 18, 18)];
    [notificationsBtn addSubview:label];
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor redColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:k_fontBold size:8];
    label.layer.cornerRadius=18/2;
    label.clipsToBounds=YES;
    
    [self setNotificationNumber:0];

    [self addSubview:searchBtn];
    [self addSubview:newPostBtn];
    [self addSubview:homeFeedBtn];
    [self addSubview:userBtn];
    [self addSubview:notificationsBtn];
    [self addSubview:backBtn];

    [self showTutorial];

    [self setUpWatchForNotifications];
    
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)setUpWatchForNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkIfNewNotificationReceived)
                                                 name:@"NewNotificationDataReceived"
                                               object:nil];
    
}
-(void)checkIfNewNotificationReceived
{
    int no=[DataSession sharedInstance].noOfNewNotificationReceived.intValue;
    [self setNotificationNumber:no];
    
    
    
    
}

-(void)setNotificationNumber:(int)number
{
    if(number>0)
    {
        label.text=[NSString stringWithFormat:@"%d",number];
        label.hidden=false;
    }
    else
    {
        label.text=@"";
        label.hidden=true;
    }
    
}
-(void)backBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        
        masterControl.contentOffset=CGPointMake(0, 0);
        
    } completion:^(BOOL finished) {
                [self stoppedScrolling];
    }];
    
    
}
-(void)userBtnClicked:(id)sender
{
    APIObjects_ProfileObj *obj=[UserSession getUserObj];
    
    ProfileFullScreen *com=[[ProfileFullScreen alloc] initWithFrame:self.bounds];
    [self addSubview:com];
    [com setUpProfileObj:obj];
    
    CGRect rect=CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
    [com setUpWithCellRect:rect];
    
    
    [com setDelegate:self andPageChangeCallBackFunc:@selector(backFromCenterProfile:) andDownCallBackFunc:@selector(backFromCenterProfile:)];
    
    
    
    [self hideBottomBar];
    

}
-(void)backFromCenterProfile:(id)sender
{
    
    
    [self showBottomBar];
    
}

-(void)homeFeedBtnClicked:(id)sender
{
    
    [UIView animateWithDuration:0.5 animations:^{
        

        [masterControl setContentOffset:CGPointMake(self.frame.size.width, 0) animated:false];

    } completion:^(BOOL finished) {
        
        [self stoppedScrolling];
        
    }];
    
    
}
-(void)newPostBtnClicked:(id)sender
{
    NSUserDefaults *nud=[NSUserDefaults standardUserDefaults];
    [nud setValue:[NSNumber numberWithFloat:0.0f] forKey:@"GALLERY_SCROLLY"];
    [nud synchronize];
    
    
    if([[UserSession getUserType] intValue]==1)
    {
        
        [Constant setStatusBarColorWhite:true];
        
        [AnalyticsMXManager PushAnalyticsEvent:@"New Post Screen"];
        
        
        NewPostComponent *cont=[[NewPostComponent alloc] initWithFrame:self.bounds];
        [self addSubview:cont];
        [cont setTarget:self onCloseEvent:@selector(newPostBackToHome:)];
        
        [cont setUpWithCellRect:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    }
    else
    {
        [Constant setStatusBarColorWhite:true];

        [AnalyticsMXManager PushAnalyticsEvent:@"Invite Code screen"];
        
        
        inviteCodeComp=[[InviteCodeComponent alloc] initWithFrame:self.bounds];
        [self addSubview:inviteCodeComp];
        [inviteCodeComp setUp];
        [inviteCodeComp setTarget:self CallBackSuccess:@selector(inviteCodeSuccess:) andCallBackCance:@selector(inviteCodeCancel:)];
        
        
    }
    
    
}
-(void)inviteCodeCancel:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEvent:@"Invite Code Screen Cancel"];
    
    
    [inviteCodeComp removeFromSuperview];
    inviteCodeComp=nil;
}
-(void)inviteCodeSuccess:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEvent:@"Invite Code Screen Success"];
    
    [inviteCodeComp removeFromSuperview];
    inviteCodeComp=nil;
    [self newPostBtnClicked:nil];
    
}
-(void)newPostBackToHome:(id)sender
{
    
}
-(void)searchBtnClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        
        
        userBtn.alpha=0.0f;
        homeFeedBtn.alpha=0.0f;
        newPostBtn.alpha=0.0f;
        searchBtn.alpha=0.0f;
        notificationsBtn.alpha=0.0f;
        backBtn.alpha=1.0f;
        
        [masterControl setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:false];
        
    } completion:^(BOOL finished)
    {
                [self stoppedScrolling];
    }];
    
    
    
}
-(void)notificationsBtnClicked:(id)sender
{
    [self setNotificationNumber:0];

    CGRect rect=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);

    messageCompo=[[NotificationsComponent alloc] initWithFrame:rect];
    [self addSubview:messageCompo];
    [messageCompo setUp:[DataSession sharedInstance].notificationsResults];
    [messageCompo setTarget:self andBackBtnFunc:@selector(backFromMessage)];
    
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        messageCompo.alpha=1;
        messageCompo.frame=self.bounds;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self hideBottomBar];
}
-(void)backFromMessage
{
    
    messageCompo=nil;
    [self showBottomBar];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
   // NSLog(@"%f",scrollView.contentOffset.x);
    
    
    float screenWidth=self.frame.size.width;

    if(scrollView.contentOffset.x>screenWidth*2)
    {
        float extraPara=(scrollView.contentOffset.x-screenWidth*2)/screenWidth;
        backBtn.alpha=extraPara;

    }
    else if(scrollView.contentOffset.x>screenWidth)
    {
       // float extraPara=(scrollView.contentOffset.x-screenWidth)/screenWidth;
        
        
    }
    else
    {
        float extraPara=(scrollView.contentOffset.x)/screenWidth;
        
        
       // NSLog(@"%f",extraPara);
        userBtn.alpha=(1-extraPara);
        homeFeedBtn.alpha=(1-extraPara);
        newPostBtn.alpha=(1-extraPara);
        searchBtn.alpha=(1-extraPara);
        notificationsBtn.alpha=(1-extraPara);
        backBtn.alpha=extraPara;
    }
    
    
}

-(void)stoppedScrolling
{
    NSLog(@"\n\n\nScroll Event");
    
    
    CGRect visibleRect = (CGRect){.origin = masterControl.contentOffset, .size = masterControl.bounds.size};
    
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    
    
    if(visiblePoint.x<self.bounds.size.width)
    {
        NSLog(@"EXPLORE");
        userBtn.enabled=true;
        homeFeedBtn.enabled=true;
        newPostBtn.enabled=true;
        searchBtn.enabled=true;
        notificationsBtn.enabled=true;
        backBtn.enabled=false;

        userBtn.alpha=1.0f;
        homeFeedBtn.alpha=1.0f;
        newPostBtn.alpha=1.0f;
        searchBtn.alpha=1.0f;
        notificationsBtn.alpha=1.0f;
        backBtn.alpha=0.0f;

      

        [HMPlayerManager sharedInstance].Explore_isVisibleBounds=true;
        [HMPlayerManager sharedInstance].Home_isVisibleBounds=false;

        
    }
    else if(visiblePoint.x<self.bounds.size.width*2)
    {
        NSLog(@"HOME");
        userBtn.enabled=false;
        homeFeedBtn.enabled=false;
        newPostBtn.enabled=false;
        searchBtn.enabled=false;
        notificationsBtn.enabled=false;
        backBtn.enabled=true;
        
        userBtn.alpha=0.0f;
        homeFeedBtn.alpha=0.0f;
        newPostBtn.alpha=0.0f;
        searchBtn.alpha=0.0f;
        notificationsBtn.alpha=0.0f;
        backBtn.alpha=1.0f;
        [searchComp endEditing:YES];
        [exploreComp endEditing:YES];

        [HMPlayerManager sharedInstance].Home_isVisibleBounds=true;
        [HMPlayerManager sharedInstance].Explore_isVisibleBounds=false;

        [homeComp playVideoIfAvaialble];
        
    }
    else if(visiblePoint.x<self.bounds.size.width*3)
    {
     
        userBtn.enabled=false;
        homeFeedBtn.enabled=false;
        newPostBtn.enabled=false;
        searchBtn.enabled=false;
        notificationsBtn.enabled=false;
        backBtn.enabled=true;
        
        userBtn.alpha=0.0f;
        homeFeedBtn.alpha=0.0f;
        newPostBtn.alpha=0.0f;
        searchBtn.alpha=0.0f;
        notificationsBtn.alpha=0.0f;
        backBtn.alpha=1.0f;
        
        [HMPlayerManager sharedInstance].Home_isVisibleBounds=false;
        [HMPlayerManager sharedInstance].Explore_isVisibleBounds=false;

        
        NSLog(@"SEARCH");

    }
    
    
    //NSIndexPath *visibleIndexPath = [feedList indexPathForItemAtPoint:visiblePoint];
    
    //    NSLog(@"Visible center - %d\n",(int)visibleIndexPath.row);
}

-(UIButton *)setMenuItemWithImage:(NSString *)imgName onClick:(SEL)selector frame:(CGRect)rect
{
    
    UIButton *btn=[[UIButton alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    return btn;
}
-(ExploreComponent *)createExploreComponent
{
    
    return [[ExploreComponent alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
}
-(SearchComponent *)createSearchComponent
{
    
    return [[SearchComponent alloc] initWithFrame:CGRectMake(self.frame.size.width*2,0, self.frame.size.width, self.frame.size.height)];
}

-(void)hideBottomBar
{
    userBtn.hidden=true;
    homeFeedBtn.hidden=true;
    newPostBtn.hidden=true;
    searchBtn.hidden=true;
    notificationsBtn.hidden=true;
    backBtn.hidden=true;
    backBtn.hidden=true;
    masterControl.scrollEnabled = NO;
    baseShadow.hidden=true;
    
}
-(void)showBottomBar
{

    userBtn.hidden=false;
    homeFeedBtn.hidden=false;
    newPostBtn.hidden=false;
    searchBtn.hidden=false;
    notificationsBtn.hidden=false;
    backBtn.hidden=false;
    masterControl.scrollEnabled = true;
     baseShadow.hidden=false;
}
-(void)showTutorial
{
    
    if([Constant isHomePageTutorialFinished]==false)
    {
        [AnalyticsMXManager PushAnalyticsEvent:@"Tutorial"];
        
        
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
