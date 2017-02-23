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

@interface ExploreComponent : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
    
    APIManager *manager;

    NSArray *channelList;

    
    
    int selectedChannel;
    
    NSMutableArray *dataRecords;
    DetailViewComponent *detailPostView;

    UIImageHM *backgroundImageView;
    UIView *backgroundImageOverLayView;
    
    ExploreTopicView *topicView;
    
    UITextField *exploreTerm;
    
    UICollectionView *ChannelList;
    UICollectionView *feedList;
 
    id delegate;
    SEL hideBottomBarFunc;
    SEL showBottomBarFunc;
    
    ExploreSearchComponent *searchResultView;
    UIRefreshControl *refreshControl;

}
-(void)setUp;
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2;

@end
