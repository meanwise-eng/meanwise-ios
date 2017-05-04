//
//  HomeComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "EmptyView.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DetailViewComponent.h"
#import <AVKit/AVKit.h>
#import "MyAccountComponent.h"
#import "MessageComponent.h"
#import "NotificationsComponent.h"
#import "MWNavBar.h"

#import "APIManager.h"
#import "FullCommentDisplay.h"
#import "ShareComponent.h"

@interface HomeComponent : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    APIManager *manager;
    
    FullCommentDisplay *commentDisplay;
    ShareComponent *sharecompo;
    
    // NSMutableArray *dataRecords;
    
    
    MWNavBar *navBar;
    
    DetailViewComponent *detailPostView;
    MyAccountComponent *myAccountCompo;
    NotificationsComponent *messageCompo;
    
    
    id delegate;
    SEL hideBottomBarFunc;
    SEL showBottomBarFunc;
    
    UICollectionView *feedList;
    
    UIRefreshControl *refreshControl;
    EmptyView *emptyView;
    
    NSString *screenIdentifier;
    
    
}
-(void)setUp;
-(void)pauseContent;
-(void)playContent;
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2;


@end


