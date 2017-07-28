//
//  BaseControl.h
//  MeanWiseUX
//
//  Created by Hardik on 26/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExploreComponent.h"
#import "HomeComponent.h"
#import "SearchComponent.h"
#import "NewPostComponent.h"
#import "TutorialComponent.h"
#import "InviteCodeComponent.h"
#import "ProfileFullScreen.h"

@interface BaseControl : UIView <UIScrollViewDelegate>
{
    
    UIScrollView *masterControl;

    UIImageView *baseShadow;
    
    UIButton *userBtn;
    UIButton *homeFeedBtn;
    UIButton *newPostBtn;
    UIButton *searchBtn;
    UIButton *notificationsBtn;
    UIButton *backBtn;
    
    ExploreComponent *exploreComp;

    HomeComponent *homeComp;
    SearchComponent *searchComp;
    
    int visibleComp;
    TutorialComponent *tutorialCmp;
    InviteCodeComponent *inviteCodeComp;

    MyAccountComponent *myAccountCompo;
    NotificationsComponent *messageCompo;

    UILabel *label;

    
}

-(void)setUp;

@end
