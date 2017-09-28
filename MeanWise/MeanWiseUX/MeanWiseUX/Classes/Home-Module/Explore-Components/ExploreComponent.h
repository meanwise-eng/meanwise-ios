//
//  ExploreComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 27/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomGestureView.h"
#import "Constant.h"
#import "DetailViewComponent.h"
#import "ExploreTopicView.h"
#import "UIImageHM.h"
#import "ExploreSearchComponent.h"
#import "APIManager.h"
#import "MyAccountComponent.h"
#import "APIExplorePageManager.h"
#import "PostTrackSeenHelper.h"
#import "NotificationsComponent.h"


@interface ExploreComponent : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
    
    UICollectionView *ChannelList;
    NSArray *channelList;

    
    
    MyAccountComponent *myAccountCompo;
    NotificationsComponent *notificationCompo;
    UIButton *settingsBtn;
    UIButton *notificationBtn;
    UILabel *notificationBadge;
    
    UITextField *exploreTerm;
    UIView *exploreTermBaseView;
    
    
    

    
    int typeOfSearch;
    NSString *currentSearchTerm;
    NSString *topicNameForChannel;
    int selectedChannel;

    APIManager *manager;


    
    
    
    DetailViewComponent *detailPostView;

    UIImageHM *backgroundImageView;
    UIView *backgroundImageOverLayView;
    
    ExploreTopicView *topicView;
    
    
    UICollectionView *feedList1;
    EmptyView *emptyView;

    
    id delegate;
    SEL hideBottomBarFunc;
    SEL showBottomBarFunc;
    ExploreSearchComponent *searchResultView;
    UIButton *backCloseBtn;
    UILabel *searchResultTitleLBL;
    UILabel *searchResultContentLBL;
    
    
    APIExplorePageManager *pageManager;
}
-(void)setUp;
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2;

@end
