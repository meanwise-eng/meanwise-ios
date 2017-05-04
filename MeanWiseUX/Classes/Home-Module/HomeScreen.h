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
#import "APIObjects_ProfileObj.h"

@interface HomeScreen : UIView <UIScrollViewDelegate>

{
    
    UIButton *searchBtn;
    UIButton *postBtn;
    UIButton *exploreBtn;
    UIButton *backBtn;
    UIButton *backBtnSearch;

    UIScrollView *masterControl;
    
    ExploreComponent *exploreComp;
    SearchComponent *searchComp;
    HomeComponent *homeComp;

    
    int visibleComp;
    
    id target;
    SEL newPostFunc;
    
    
}

@property (nonatomic, strong) APIObjects_ProfileObj *sessionMain;

-(void)setUp;
-(void)seMainSession:(APIObjects_ProfileObj*)session;
-(void)setTarget:(id)delegate setNewPost:(SEL)func1;

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
