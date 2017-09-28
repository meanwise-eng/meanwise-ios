//
//  NewExploreComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 05/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NewExploreComponent.h"
#import "DataSession.h"
#import "ViewController.h"
#import "ResolutionVersion.h"
#import "ProfileWindowControl.h"
#import "SinglePostViewer.h"


@implementation NewExploreComponent

-(void)setMasterScrollYPos:(float)posY;
{
    masterScrollYPos=posY;
}
-(void)setUp
{
    selectedChannel=-1;
    typeOfSearch=1;
    currentSearchTerm=@"";
    topicNameForChannel=@"";

    masterScrollYPos=0;
    
    [self setUpBackground];
    

    masterScrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:masterScrollView];
    masterScrollView.contentSize=CGSizeMake(0, self.frame.size.height*2);
    masterScrollView.delegate=self;
    
    
    
    [self setUpChannelBar];
    [self setUpTopicBar];
    

    [self setUpPostBar];
    [self setUpInfluencersBar];
    [self setUpDiscussionBar];
    
    
    
    
    [self setUpSearchBar];
    [self setUpNotificationsAndMyAccounts];
    [self setUpWatchForNotifications];
    
    
    
    [self refreshAction];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAction)
                                                 name:@"REFRESH_HOME"
                                               object:nil];
    

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void)setLabelAtHeight:(float)height withTitle:(NSString *)string
{
    UILabel *headLineLBL=[[UILabel alloc] initWithFrame:CGRectMake(18,height, self.frame.size.width-18, 15)];
    [masterScrollView addSubview:headLineLBL];
    headLineLBL.textColor=[UIColor whiteColor];
    headLineLBL.backgroundColor=[UIColor clearColor];
    headLineLBL.textAlignment=NSTextAlignmentLeft;
    headLineLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
    headLineLBL.text=string;
}

#pragma mark - Influencers and Discussion

-(void)setUpDiscussionBar
{
    [self setLabelAtHeight:710 withTitle:@"DISCUSSIONS"];
    fullDiscussionsControl=nil;
    discussionSinglePostControl=nil;

    discussionBar=[[ExploreDiscussionsBar alloc] initWithFrame:CGRectMake(0, 710+20, self.frame.size.width, 240)];
    [masterScrollView addSubview:discussionBar];
    [discussionBar setUp];
    [discussionBar setTarget:self onTapEvent:@selector(onDiscussionBarTap:) andWhenSizeChange:@selector(discussionBarSizeChange:)];
    
    
    
    
    
    
}
-(void)discussionBarSizeChange:(id)sender
{
    NSLog(@"%@",NSStringFromCGRect(discussionBar.frame));
    masterScrollView.contentSize=CGSizeMake(0, discussionBar.frame.origin.y+discussionBar.frame.size.height+self.frame.size.height/2+80);
    int p=0;
}

-(void)setUpInfluencersBar
{
    [self setLabelAtHeight:570 withTitle:@"INFLUENCERS"];
    
    UIButton *viewAllBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 570-5, 100-18, 15+10)];
    [masterScrollView addSubview:viewAllBtn];
    [viewAllBtn setTitle:@"View All" forState:UIControlStateNormal];
    [viewAllBtn addTarget:self action:@selector(showFullInfluencersScreen:) forControlEvents:UIControlEventTouchUpInside];
    viewAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    viewAllBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];

    //viewAllBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    

    fullInfluencersControl=nil;
    influencersControl=[[ExploreInfluencersBar alloc] initWithFrame:CGRectMake(0, 570+20, self.frame.size.width, 100)];
    [masterScrollView addSubview:influencersControl];
    [influencersControl setUp];
    [influencersControl setTarget:self onTapEvent:@selector(onInfluencersControlUser:)];
    
}
-(void)onDiscussionBarTap:(NSNumber *)toOpenIndex
{
    
   
    if(fullDiscussionsControl==nil && discussionSinglePostControl==nil)
    {
        [self hideBottomBar];

        if([toOpenIndex intValue]==-1)
        {

            CGRect absoRect=CGRectMake(0, masterScrollYPos+RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
        
            fullDiscussionsControl=[[FullDiscussionsControl alloc] initWithFrame:absoRect];
            [fullDiscussionsControl setSearchType:[discussionBar getTypeOfSearch]];
            [fullDiscussionsControl setSearchDict:[discussionBar getSearchDict]];
            [fullDiscussionsControl setUp];
            [fullDiscussionsControl setTarget:self onClose:@selector(onFullDiscussionsClose:)];
            [self addSubview:fullDiscussionsControl];
        
            absoRect=CGRectMake(0, masterScrollYPos, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);

            [UIView animateWithDuration:0.3 animations:^{
            
                    fullDiscussionsControl.frame=absoRect;
            
            }];
        
        }
        else
        {
            CGRect absoRect=CGRectMake(0, masterScrollYPos+RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);

            discussionSinglePostControl=[[SinglePostViewer alloc] initWithFrame:absoRect];
            [discussionSinglePostControl setUpWithPostId:[NSString stringWithFormat:@"%@",toOpenIndex] withCommentOpen:YES];
            [self addSubview:discussionSinglePostControl];
            [discussionSinglePostControl setDelegate:self onCleanUp:@selector(onsingleDiscussionPostClose:)];

            absoRect=CGRectMake(0, masterScrollYPos, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
            discussionSinglePostControl.frame=absoRect;

            
        }
    }
    
}
-(void)onsingleDiscussionPostClose:(id)sender
{
    [self showBottomBar];
    
    CGRect absoRect=CGRectMake(0, masterScrollYPos+RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        discussionSinglePostControl.frame=absoRect;
        
    } completion:^(BOOL finished) {
        
        [discussionSinglePostControl removeFromSuperview];
        discussionSinglePostControl=nil;
        
    }];

}
-(void)onFullDiscussionsClose:(id)sender
{
    [self showBottomBar];
    
    CGRect absoRect=CGRectMake(0, masterScrollYPos+RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);

    [UIView animateWithDuration:0.3 animations:^{
        
        fullDiscussionsControl.frame=absoRect;

    } completion:^(BOOL finished) {
        
        [fullDiscussionsControl removeFromSuperview];
        fullDiscussionsControl=nil;

    }];

}
-(void)onInfluencersControlUser:(NSDictionary *)dictMain
{
    //    NSDictionary *dict=@{@"FRAME":[NSValue valueWithCGRect:cellFrameInSuperview],@"USER":userInfo};


    
    if(fullInfluencersControl==nil)
    {
        [self hideBottomBar];

        
        NSDictionary *userInfo=[dictMain valueForKey:@"USER"];

        CGRect frame=[[dictMain valueForKey:@"FRAME"] CGRectValue];
        
        frame=CGRectMake(frame.origin.x+influencersControl.frame.origin.x+25/2, frame.origin.y+influencersControl.frame.origin.y-masterScrollView.contentOffset.y+15, 50, 50);
        
        ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
        [control setUp:userInfo andSourceFrame:frame];
        [control setTarget:self onClose:@selector(onInfliencersUserClose:)];
        [self hideBottomBar];
        
     

    }
    
}
-(void)showFullInfluencersScreen:(id)sender
{
    if(fullInfluencersControl==nil)
    {
    [self hideBottomBar];
     CGRect absoRect=CGRectMake(0, masterScrollYPos+RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
     
     fullInfluencersControl=[[FullInfluencersControl alloc] initWithFrame:absoRect];
     [fullInfluencersControl setSearchType:[discussionBar getTypeOfSearch]];
     [fullInfluencersControl setSearchDict:[discussionBar getSearchDict]];
     
     [fullInfluencersControl setUp];
     [self addSubview:fullInfluencersControl];
     [fullInfluencersControl setTarget:self onClose:@selector(closeFullInfluencerScreen:)];
     
     absoRect=CGRectMake(0, masterScrollYPos, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
     
     [UIView animateWithDuration:0.3 animations:^{
     
     fullInfluencersControl.frame=absoRect;
     
     }];
    }
}
-(void)closeFullInfluencerScreen:(id)sender
{
    [self showBottomBar];

        CGRect absoRect=CGRectMake(0, masterScrollYPos+RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
    
        [UIView animateWithDuration:0.3 animations:^{
    
            fullInfluencersControl.frame=absoRect;
    
        } completion:^(BOOL finished) {
    
            [fullInfluencersControl removeFromSuperview];
            fullInfluencersControl=nil;
            
        }];

}
-(void)onInfliencersUserClose:(id)sender
{
    [self showBottomBar];
    
    
}

#pragma mark - Post Bar
-(void)setUpPostBar
{
    [self setLabelAtHeight:210 withTitle:@"RECENT"];

    recentPostsControl=[[ExplorePostsBar alloc] initWithFrame:CGRectMake(0, 210+20, self.frame.size.width, 270/2)];
    [recentPostsControl setUp];
    [masterScrollView addSubview:recentPostsControl];
    [recentPostsControl setIdentifier:@"recentPostsControl"];
    [recentPostsControl setTarget:self andOnOpen:@selector(onPostExpand:)];
    
    [self setLabelAtHeight:390 withTitle:@"TRENDING"];

    trendingPostsControl=[[ExplorePostsBar alloc] initWithFrame:CGRectMake(0, 390+20, self.frame.size.width, 270/2)];
    [trendingPostsControl setUp];
    [masterScrollView addSubview:trendingPostsControl];
    [trendingPostsControl setIdentifier:@"trendingPostsControl"];
    [trendingPostsControl setTarget:self andOnOpen:@selector(onPostExpand:)];
    
    
}
#pragma mark - Post Expand

-(void)onPostExpand:(NSDictionary *)dict
{
    
    exploreTerm.text=@"";
    [self SearchTermChanged:nil];
    [exploreTerm resignFirstResponder];

    [self hideBottomBar];
    [self hideStatusBar];
    
    
    [[HMPlayerManager sharedInstance] StopKeepKillingExploreFeedVideosIfAvaialble];

    NSIndexPath *path=[dict valueForKey:@"indexPath"];
    NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:[dict valueForKey:@"data"]];
    NSString *identifier=[dict valueForKey:@"identifier"];
    if([identifier isEqualToString:@"recentPostsControl"])
    {
        currentHolder=recentPostsControl;
    }
    else
    {
        currentHolder=trendingPostsControl;

    }
    
    [currentHolder setCellHide:YES atIndexPath:path];
    
    CGRect absoRect=CGRectMake(0, masterScrollYPos, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height);
    
    detailPostView=[[DetailViewComponent alloc] initWithFrame:absoRect];
    [self addSubview:detailPostView];
    [detailPostView setDataRecords:dataArray];
    
    
    CGRect cellRect=[currentHolder getTheRectOfCurrentCell:path];
    
    cellRect=CGRectMake(cellRect.origin.x, currentHolder.frame.origin.y+cellRect.origin.y-masterScrollYPos, cellRect.size.width, cellRect.size.height);
    
    
    [detailPostView setUpWithCellRect:cellRect];
    [detailPostView setIfItsForExplore:YES];

    
    APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[dataArray objectAtIndex:path.row];
    
    int mediaType = obj.mediaType.intValue;
    
    if(mediaType!=0)
    {
        NSString *imgURL=obj.image_url;
        [detailPostView setImage:imgURL andNumber:path];
    }
    else
    {
        int colorNumber=obj.colorNumber.intValue;
        [detailPostView setColorNumber:colorNumber];
        
        [detailPostView setImage:@"red" andNumber:path];
    }
    [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(onPostClose:)];
    
    [detailPostView setForPostDetail];


}
-(void)openingTableViewAtPath:(id)sender
{

    CGRect cellRect=[currentHolder openingTableViewAtPath:sender];
    
    
    cellRect=CGRectMake(cellRect.origin.x, currentHolder.frame.origin.y+cellRect.origin.y-masterScrollYPos, cellRect.size.width, cellRect.size.height);

    [detailPostView setUpNewScrolledRect:cellRect];

}
-(void)updateTheCommentCountsForVisibleRows
{
    
}

-(void)onPostClose:(NSIndexPath *)path
{
    detailPostView=nil;
    [self updateTheCommentCountsForVisibleRows];
    
    [[HMPlayerManager sharedInstance] StartKeepKillingExploreFeedVideosIfAvaialble];

    [self showBottomBar];
    [self showStatusBar];
    [currentHolder setCellHide:false atIndexPath:path];

    
}
#pragma mark - Search
-(void)setUpSearchBar
{
    menuBgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,80)];
    menuBgView.alpha=0.8;
    [menuBgView setImage:[UIImage imageNamed:@"menuShadow.png"]];
    //menuBgView.transform=CGAffineTransformMakeScale(1, -1);
    [self addSubview:menuBgView];
    menuBgView.userInteractionEnabled=false;
    menuBgView.contentMode=UIViewContentModeScaleToFill;
    menuBgView.alpha=0;
    
    exploreTermBaseView=[[UIView alloc] initWithFrame:CGRectMake(36/2, 60/2, self.frame.size.width-36/2-50-50, 40)];
    [self addSubview:exploreTermBaseView];
    exploreTermBaseView.layer.cornerRadius=2;
    exploreTermBaseView.clipsToBounds=YES;
    
    
    
    exploreTerm=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, exploreTermBaseView.frame.size.width, 40)];
    [exploreTermBaseView addSubview:exploreTerm];
    exploreTerm.tintColor=[UIColor whiteColor];
    exploreTerm.font=[UIFont fontWithName:k_fontRegular size:18];
    exploreTerm.clearButtonMode=UITextFieldViewModeAlways;
    exploreTerm.textColor=[UIColor whiteColor];
    exploreTerm.keyboardAppearance=UIKeyboardAppearanceDark;
    exploreTerm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type here to search" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5],NSFontAttributeName:[UIFont fontWithName:k_fontRegular size:18]}];
    

    searchResultView=[[ExploreSearchComponent alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height-80)];
    [searchResultView setUp];
    [self addSubview:searchResultView];
    searchResultView.hidden=true;
    searchResultView.alpha=0;
    [searchResultView setTarget:self OnSearchItemSelectedFunc:@selector(searchAndAPICall:)];
    
    [exploreTerm addTarget:self
                    action:@selector(SearchTermChanged:)
          forControlEvents:UIControlEventEditingChanged];

    
    searchResultTitleLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width-40, 20)];
    searchResultContentLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 125, self.frame.size.width-40, 35)];
    [self addSubview:searchResultContentLBL];
    [self addSubview:searchResultTitleLBL];
    searchResultTitleLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    searchResultContentLBL.font=[UIFont fontWithName:k_fontSemiBold size:30];
    searchResultTitleLBL.text=@"YOU SEARCHED FOR";
    searchResultContentLBL.text=@"MECHANISM";
    searchResultTitleLBL.textColor=[UIColor whiteColor];
    searchResultContentLBL.textColor=[UIColor whiteColor];
    searchResultTitleLBL.hidden=true;
    searchResultContentLBL.hidden=true;
    
    
    
    
    backCloseBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 10, 50, 50)];
    [self addSubview:backCloseBtn];
    [backCloseBtn addTarget:self action:@selector(backToChannelSearch) forControlEvents:UIControlEventTouchUpInside];
    [backCloseBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    
    backCloseBtn.hidden=true;

    
}
-(void)backToChannelSearch
{
    [masterScrollView setContentOffset:CGPointZero animated:YES];
    menuBgView.frame=CGRectMake(0, 0, self.frame.size.width,80);

    backCloseBtn.hidden=true;
    exploreTerm.hidden=false;
    settingsBtn.hidden=false;
    notificationBtn.hidden=false;
    exploreTermBaseView.hidden=false;
    currentSearchTerm=@"";
    channelBar.hidden=false;
    topicView.hidden=false;
    exploreTerm.text=@"";
    
    searchResultTitleLBL.hidden=true;
    searchResultContentLBL.hidden=true;
    
    [self SearchTermChanged:nil];
    [self refreshAction];

}
-(void)searchAndAPICall:(NSString *)searchTag
{
    [masterScrollView setContentOffset:CGPointZero animated:YES];
    menuBgView.frame=CGRectMake(0, 0, self.frame.size.width,200);


    NSLog(@"%@",searchTag);
    
    backCloseBtn.hidden=false;
    currentSearchTerm=searchTag;
    exploreTerm.hidden=true;
    settingsBtn.hidden=true;
    notificationBtn.hidden=true;
    exploreTermBaseView.hidden=true;
    exploreTerm.text=@"";
    [self SearchTermChanged:nil];
    channelBar.hidden=true;
    topicView.hidden=true;
    
    searchResultTitleLBL.hidden=false;
    searchResultContentLBL.hidden=false;
    searchResultContentLBL.text=currentSearchTerm;
    
    [self refreshAction];
    [exploreTerm resignFirstResponder];
    
}

-(void)SearchTermChanged:(id)sender
{
    if([exploreTerm.text length]>0)
    {
        
        [searchResultView setSearchTerm:exploreTerm.text];
        
        if(searchResultView.hidden==true)
        {
            
            
            searchResultView.hidden=false;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                searchResultView.alpha=1;
                
            } completion:^(BOOL finished) {
                
                [self hideBottomBar];
                
            }];
            
        }
        
    }
    else
    {
        [searchResultView setSearchTerm:exploreTerm.text];
        
        
        if(searchResultView.hidden==false)
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                searchResultView.alpha=0;
                
            } completion:^(BOOL finished) {
                
                
                searchResultView.hidden=true;
                [self showBottomBar];
                
            }];
            
        }
        
    }
    
}
#pragma mark - Detail View

#pragma mark -  General
-(void)refreshAction
{
 
    NSLog(@"Refresh Action Call");
    
    if([currentSearchTerm isEqualToString:@""])
    {
        if([topicNameForChannel isEqualToString:@""] && (selectedChannel!=-1 && selectedChannel!=0))
        {
            NSLog(@"Channel");
            typeOfSearch=1;
        }
        else if((selectedChannel==-1 || selectedChannel==0) && [topicNameForChannel isEqualToString:@""])
        {
            NSLog(@"Home");
            typeOfSearch=-1;
        }
        else if((selectedChannel==-1 || selectedChannel==0) && ![topicNameForChannel isEqualToString:@""])
        {
            NSLog(@"Home + Topic");
            typeOfSearch=5;

        }
        else
        {
            NSLog(@"Channel + topic only");
            typeOfSearch=4;
        }
    }
    else if([currentSearchTerm hasPrefix:@"#"])
    {
        NSLog(@"HashTag only");

        typeOfSearch=2;
    }
    else
    {
        NSLog(@"topic only");

        typeOfSearch=3;
    }
    
    
    NSArray *channelList=[[[APIPoster alloc] init] getInterestDataForExploreScreen];

    
    
    NSDictionary *dict;
    
    if(typeOfSearch==1)
    {
        NSString *channelName=[[channelList objectAtIndex:selectedChannel] valueForKey:@"name"];
        dict=@{@"type":[NSNumber numberWithInt:1],@"word":channelName};
    }
    if(typeOfSearch==2)
    {
        dict=@{@"type":[NSNumber numberWithInt:2],@"word":[currentSearchTerm substringFromIndex:1]};
        
    }
    if(typeOfSearch==3)
    {
        dict=@{@"type":[NSNumber numberWithInt:3],@"word":[currentSearchTerm substringFromIndex:1]};
        
    }
    if(typeOfSearch==4)
    {
        
        NSString *channelName=[[channelList objectAtIndex:selectedChannel] valueForKey:@"name"];
        dict=@{@"type":[NSNumber numberWithInt:4],@"word":channelName,@"topic":topicNameForChannel};
        
    }
    if(typeOfSearch==5)
    {
        dict=@{@"type":[NSNumber numberWithInt:5],@"topic":topicNameForChannel};
    }
    
        [recentPostsControl setSearchType:typeOfSearch];
        [trendingPostsControl setSearchType:typeOfSearch];
        
        [recentPostsControl refreshAction:dict];
        [trendingPostsControl refreshAction:dict];
//
    [influencersControl setSearchType:typeOfSearch];
    [influencersControl refreshAction:dict];
    
    [discussionBar setSearchType:typeOfSearch];
    [discussionBar refreshAction:dict];


    int p=0;
}


-(void)updateBackground
{
    [topicView setChannelId:selectedChannel];
   
    
    NSArray *channelList=[[[APIPoster alloc] init] getInterestDataForExploreScreen];

    NSString *urlString=[[channelList objectAtIndex:selectedChannel] valueForKey:@"photo"];
    if(![urlString isEqualToString:@""])
    {
       [backgroundImageView setUp:urlString];
        backgroundImageOverLayView.backgroundColor=[Constant colorGlobal:selectedChannel%13];
    }
    else
    {
        [backgroundImageView setUp:@"ExploreHome.jpg"];
        backgroundImageOverLayView.backgroundColor=[UIColor grayColor];
    }

}

#pragma mark - Topic Bar

-(void)setUpTopicBar
{
    topicView=[[ExploreTopicView alloc] initWithFrame:CGRectMake(0, 160, self.frame.size.width, 30)];
    [masterScrollView addSubview:topicView];
    [topicView setUp:40];
    [topicView setChannelId:selectedChannel];
    [topicView setTarget:self OnTopicSelectCallBack:@selector(onTopicForChannelChanged:)];
}
-(void)onTopicForChannelChanged:(NSString *)topicName
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Explore Topic Change"];
    topicNameForChannel=topicName;
    typeOfSearch=4;
    [self refreshAction];
}


#pragma mark - Channel Bar

-(void)setUpChannelBar
{
    channelBar=[[ExploreChannelsBar alloc] initWithFrame:CGRectMake(0, 79, self.frame.size.width, 130/2)];
    [masterScrollView addSubview:channelBar];
    [channelBar setUp];
    [channelBar setTarget:self onChannelSelectCall:@selector(onNewChannelSelect:)];
    
}
-(void)onNewChannelSelect:(NSIndexPath *)indexPath
{
    
    
    
    
    selectedChannel=(int)indexPath.row;
topicNameForChannel=@"";
    exploreTerm.text=@"";

    
     [self SearchTermChanged:nil];
     [exploreTerm resignFirstResponder];
    
    
     [self updateBackground];
     
    [self refreshAction];

    

}

#pragma mark - Hide Show Bottom Bar
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float y=masterScrollView.contentOffset.y;
    
    if(y<100)
    {
        menuBgView.alpha=y*0.01;
    }
    else
    {
        menuBgView.alpha=1.0f;
    }

    
}
-(void)hideBottomBar
{
    
    masterScrollView.scrollEnabled=false;
    [delegate performSelector:hideBottomBarFunc withObject:nil afterDelay:0.01];
}
-(void)scrollToTop
{
    [delegate performSelector:scrollToTop withObject:nil afterDelay:0.01];

}
-(void)showBottomBar
{
    masterScrollView.scrollEnabled=true;
    [delegate performSelector:showBottomBarFunc withObject:nil afterDelay:0.01];
}
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2 andScrollToTop:(SEL)func3;
{
    delegate=target;
    hideBottomBarFunc=func1;
    showBottomBarFunc=func2;
    scrollToTop=func3;
}
-(void)hideStatusBar
{
    
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t setStatusBarHide:YES];
}
-(void)showStatusBar
{
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t setStatusBarHide:false];
}

#pragma mark - Notifications + Notificaton Wakeup + My Accounts

-(void)setUpNotificationsAndMyAccounts
{
    
    
    
    settingsBtn=[[UIButton alloc] initWithFrame:CGRectMake(666/2, 73/2, 50/2, 50/2)];
    [self addSubview:settingsBtn];
    [settingsBtn setBackgroundImage:[UIImage imageNamed:@"Base_SettingsIcon.png"] forState:UIControlStateNormal];
    [settingsBtn addTarget:self action:@selector(settingsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    notificationBtn=[[UIButton alloc] initWithFrame:CGRectMake(666/2-45, 62/2, 70/2, 70/2)];
    [self addSubview:notificationBtn];
    [notificationBtn setBackgroundImage:[UIImage imageNamed:@"Base_NotificationIcon.png"] forState:UIControlStateNormal];
    [notificationBtn addTarget:self action:@selector(notificationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    notificationBadge=[[UILabel alloc] initWithFrame:CGRectMake(25/2,-5, 18, 18)];
    [notificationBtn addSubview:notificationBadge];
    notificationBadge.adjustsFontSizeToFitWidth=YES;
    notificationBadge.textColor=[UIColor whiteColor];
    notificationBadge.backgroundColor=[UIColor redColor];
    notificationBadge.textAlignment=NSTextAlignmentCenter;
    notificationBadge.font=[UIFont fontWithName:k_fontBold size:8];
    notificationBadge.layer.cornerRadius=18/2;
    notificationBadge.clipsToBounds=YES;
    [self setNotificationNumber:0];
    
    
    
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
        notificationBadge.text=[NSString stringWithFormat:@"%d",number];
        notificationBadge.hidden=false;
    }
    else
    {
        notificationBadge.text=@"";
        notificationBadge.hidden=true;
    }
    
}
-(void)notificationBtnClicked:(id)sender
{

    [self scrollToTop];
    
    notificationCompo=[[NotificationsComponent alloc] initWithFrame:CGRectMake(0, -RX_mainScreenBounds.size.height, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height)];
    
    [notificationCompo setUp:[DataSession sharedInstance].notificationsResults];
    [notificationCompo setTarget:self andBackBtnFunc:@selector(backFromMessage)];
    [self addSubview:notificationCompo];
    
    [UIView animateWithDuration:0.3 animations:^{
        notificationCompo.frame=RX_mainScreenBounds;
    }];
    
    [self endEditing:false];
    [self hideBottomBar];
}
-(void)settingsBtnClicked:(id)sender
{
    [self scrollToTop];
    
    myAccountCompo=[[MyAccountComponent alloc] initWithFrame:CGRectMake(RX_mainScreenBounds.size.width, 0, RX_mainScreenBounds.size.width, RX_mainScreenBounds.size.height)];
    [myAccountCompo setUp];
    myAccountCompo.blackOverLayView.image=[Constant takeScreenshot];
    myAccountCompo.blackOverLayView.alpha=1;
    
    [myAccountCompo setTarget:self andBackFunc:@selector(backFromMessage)];
    
    [self addSubview:myAccountCompo];
    
    [UIView animateWithDuration:0.3 animations:^{
        myAccountCompo.frame=RX_mainScreenBounds;
        myAccountCompo.backgroundColor=[UIColor whiteColor];
    }];
    
    [self endEditing:false];
    [self hideBottomBar];
    
}
-(void)backFromMessage
{
    notificationCompo=nil;
    
    myAccountCompo=nil;
    [self showBottomBar];
}
#pragma mark - Background setup
-(void)setUpBackground
{
    self.backgroundColor=[UIColor blackColor];
    
    backgroundImageView=[[UIImageHM alloc] initWithFrame:self.bounds];
    backgroundImageView.image=[UIImage imageNamed:@"ExploreHome.jpg"];
    [self addSubview:backgroundImageView];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    backgroundImageView.alpha=1;
    
  
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    backgroundImageOverLayView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:backgroundImageOverLayView];
    backgroundImageOverLayView.backgroundColor=[UIColor grayColor];
    backgroundImageOverLayView.alpha=0.1;
}

@end
