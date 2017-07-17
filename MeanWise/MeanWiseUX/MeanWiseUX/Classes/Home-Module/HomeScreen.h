//
//  HomeScreen.h
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExploreComponent.h"
#import "SearchComponent.h"
#import "NewPostComponent.h"
#import "HomeComponent.h"
#import "InviteCodeComponent.h"
#import "TutorialComponent.h"

@interface HomeScreen : UIView <UIScrollViewDelegate>

{
    
    UIButton *searchBtn;
    UIButton *postBtn;
    UIButton *exploreBtn;
    UIButton *backBtn;

    UIScrollView *masterControl;
    
    ExploreComponent *exploreComp;
    SearchComponent *searchComp;
    HomeComponent *homeComp;

    
    int visibleComp;
    TutorialComponent *tutorialCmp;
    InviteCodeComponent *inviteCodeComp;
}
-(void)setUp;

@end

/*
 //
 //  HomeScreen.h
 //  MeanWiseUX
 //
 //  Created by Hardik on 17/12/16.
 //  Copyright © 2016 Hardik. All rights reserved.
 //
 
 #import <UIKit/UIKit.h>
 #import "ExploreComponent.h"
 #import "SearchComponent.h"
 #import "NewPostComponent.h"
 #import "HomeComponent.h"
 
 @interface HomeScreen : UIView
 
 {
 
 UIButton *searchBtn;
 UIButton *postBtn;
 UIButton *exploreBtn;
 UIButton *backBtn;
 
 UIView *masterControl;
 
 ExploreComponent *exploreComp;
 SearchComponent *searchComp;
 HomeComponent *homeComp;
 
 
 int visibleComp;
 
 
 }
 -(void)setUp;
 
 @end
*/
