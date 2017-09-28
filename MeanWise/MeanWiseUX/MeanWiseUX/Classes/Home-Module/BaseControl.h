//
//  BaseControl.h
//  MeanWiseUX
//
//  Created by Hardik on 26/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ExploreComponent.h"
#import "NewPostComponent.h"
#import "TutorialComponent.h"
#import "InviteCodeComponent.h"
#import "ProfileFullScreen.h"
#import "SearchGraphComponent.h"
#import "NewExploreComponent.h"

@interface BaseControl : UIView <UIScrollViewDelegate>
{
    
//    UIScrollView *masterControl;

    UIImageView *baseShadow;
    
    UIButton *userBtn;
    UIButton *newPostBtn;
    UIButton *searchBtn;
    
    NewExploreComponent *exploreComp;

    SearchGraphComponent *searchComp;
    
    int visibleComp;
    TutorialComponent *tutorialCmp;
    InviteCodeComponent *inviteCodeComp;

    MyAccountComponent *myAccountCompo;

    UILabel *label;

    
}

-(void)setUp;

@end
