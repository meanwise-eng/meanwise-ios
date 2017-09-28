//
//  NewExploreComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 05/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExploreChannelsBar.h"
#import "ExploreTopicView.h"
#import "UIImageHM.h"
#import "MyAccountComponent.h"
#import "NotificationsComponent.h"
#import "ExploreSearchComponent.h"
#import "ExplorePostsBar.h"
#import "DetailViewComponent.h"
#import "ExploreInfluencersBar.h"
#import "ExploreDiscussionsBar.h"

#import "FullDiscussionsControl.h"
#import "FullInfluencersControl.h"
#import "SinglePostViewer.h"

@interface NewExploreComponent : UIView <UIScrollViewDelegate>
{
    UIScrollView *masterScrollView;
    
    //Base
    UIImageHM *backgroundImageView;
    UIView *backgroundImageOverLayView;
    

    NSString *topicNameForChannel;
    int selectedChannel;
    int typeOfSearch;
    NSString *currentSearchTerm;

    
    //Channels and Topics
    ExploreChannelsBar *channelBar;
    ExploreTopicView *topicView;

    //Search Custom
    UITextField *exploreTerm;
    UIView *exploreTermBaseView;
    ExploreSearchComponent *searchResultView;
    UIButton *backCloseBtn;
    UILabel *searchResultTitleLBL;
    UILabel *searchResultContentLBL;

    
    //Notifications and Settings Flow
    UIButton *settingsBtn;
    UIButton *notificationBtn;
    UILabel *notificationBadge;
    MyAccountComponent *myAccountCompo;
    NotificationsComponent *notificationCompo;
    UIImageView *menuBgView;

    
    //Hide Show Bottom Bar
    id delegate;
    SEL hideBottomBarFunc;
    SEL showBottomBarFunc;
    SEL scrollToTop;

    
    
    //Explore Feed Rows
    ExplorePostsBar *recentPostsControl;
    ExplorePostsBar *trendingPostsControl;
    ExplorePostsBar *currentHolder;

    //Detail Post
    DetailViewComponent *detailPostView;
    
    //Explore Influencers
    ExploreInfluencersBar *influencersControl;
    ExploreDiscussionsBar *discussionBar;
    FullDiscussionsControl *fullDiscussionsControl;
    FullInfluencersControl *fullInfluencersControl;
    SinglePostViewer *discussionSinglePostControl;

    
    
    float masterScrollYPos;
}
-(void)setMasterScrollYPos:(float)posY;
-(void)setUp;
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2 andScrollToTop:(SEL)func3;



/*
 
 1. Channel Bar (done)
 2. Topic List based on channel (done)
 4. Refresh channel bar  (done)
 2. TextField (done)
 3. Notification and settings flow (done)
 5. Search component topic/Content (done)
 10. Hide show bottom bar (done)
 9. Background Modify (done)
 
 6. Post Screen
 7. Post screen open
 8. Post screen paging
 
 
 */
@end
