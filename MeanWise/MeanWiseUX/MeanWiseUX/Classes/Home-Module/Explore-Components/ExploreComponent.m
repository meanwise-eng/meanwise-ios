//
//  ExploreComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 27/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ExploreComponent.h"
#import "ChannelSearchView.h"
#import "ChannelExploreCell.h"
#import "APIObjectsParser.h"
#import "DataSession.h"
#import "HMPlayerManager.h"
#import "ViewController.h"
#import "PostMiniCell.h"

@implementation ExploreComponent


-(void)setUp
{
    topicNameForChannel=@"";
    typeOfSearch=1;
    currentSearchTerm=@"";

    
    channelList=[[[APIPoster alloc] init] getInterestDataForExploreScreen];
    
    self.backgroundColor=[UIColor blackColor];
    
    backgroundImageView=[[UIImageHM alloc] initWithFrame:self.bounds];
    backgroundImageView.image=[UIImage imageNamed:@"post_4.jpeg"];
    [self addSubview:backgroundImageView];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    backgroundImageView.alpha=1;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];

    
    
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

    
    
    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 5;
    layout1.minimumLineSpacing = 5;
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout1.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
   
    CGRect collectionViewFrame = CGRectMake(0, 70, self.frame.size.width, 100);
    ChannelList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout1];
    ChannelList.delegate = self;
    ChannelList.dataSource = self;
    ChannelList.showsHorizontalScrollIndicator = NO;
    ChannelList.backgroundColor=[UIColor clearColor];
    [ChannelList registerClass:[ChannelExploreCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:ChannelList];
    
    
    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 20;
    layout2.minimumLineSpacing = 20;
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
    collectionViewFrame = CGRectMake(0, 210, self.frame.size.width, 270/2);
    feedList1 = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    feedList1.delegate = self;
    feedList1.dataSource = self;
    feedList1.showsHorizontalScrollIndicator = NO;
    feedList1.backgroundColor=[UIColor grayColor];
    [feedList1 registerClass:[PostMiniCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:feedList1];
    feedList1.alwaysBounceHorizontal=YES;
    feedList1.bounces=true;
    
    
    
    selectedChannel=-1;

    topicView=[[ExploreTopicView alloc] initWithFrame:CGRectMake(0, 210-35, self.frame.size.width, 30)];
    [self addSubview:topicView];
    [topicView setUp:40];
    [topicView setChannelId:selectedChannel];
    [topicView setTarget:self OnTopicSelectCallBack:@selector(onTopicForChannelChanged:)];
   
    [self updateBackground];
    
    
    
    emptyView=[[EmptyView alloc] initWithFrame:feedList1.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForBlack];
    [emptyView setDelegate:self onReload:@selector(refreshAction)];
    emptyView.msgLBL.text=@"Nothing to display";
    emptyView.reloadBtn.hidden=true;
    
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
    
    pageManager=[[APIExplorePageManager alloc] init];

    [self refreshAction];

    [self setUpWatchForNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTopicChannels)
                                                 name:@"REFRESH_EXPLORE_INTERESTS"
                                               object:nil];

}

#pragma mark - Notification watch


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

#pragma mark - Feed API calls
-(void)refreshAction1
{
    if([currentSearchTerm isEqualToString:@""])
    {
        if([topicNameForChannel isEqualToString:@""] && (selectedChannel!=-1 && selectedChannel!=0))
        {
            typeOfSearch=1;
        }
        else if(selectedChannel==-1 || selectedChannel==0)
        {
            typeOfSearch=-1;
        }
        else
        {
            typeOfSearch=4;
        }
    }
    else if([currentSearchTerm hasPrefix:@"#"])
    {
        
        typeOfSearch=2;
    }
    else
    {
        typeOfSearch=3;
    }
    
    manager=[[APIManager alloc] init];

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
    
    [DataSession sharedInstance].exploreFeedResults=[[NSMutableArray alloc] init];
    [feedList1 reloadData];
    emptyView.hidden=false;
    emptyView.msgLBL.text=@"Loading..";
    
    if(typeOfSearch!=-1)
    {
        [manager sendRequestExploreFeedWithKey:dict Withdelegate:self andSelector:@selector(UsersPostReceived:)];
    }
    else
    {
        manager.pageNoRequested=1;
        manager.countRequested=-1;
        [manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(UsersPostReceived:)];
        
    }
    
    feedList1.userInteractionEnabled=false;
    
}
-(void)refreshAction
{
    if([currentSearchTerm isEqualToString:@""])
    {
        if([topicNameForChannel isEqualToString:@""] && (selectedChannel!=-1 && selectedChannel!=0))
        {
            typeOfSearch=1;
        }
        else if(selectedChannel==-1 || selectedChannel==0)
        {
            typeOfSearch=-1;
        }
        else
        {
            typeOfSearch=4;
        }
    }
    else if([currentSearchTerm hasPrefix:@"#"])
    {
        
        typeOfSearch=2;
    }
    else
    {
        typeOfSearch=3;
    }
    
    
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
    
    [DataSession sharedInstance].exploreFeedResults=[[NSMutableArray alloc] init];
    [feedList1 reloadData];
    emptyView.hidden=false;
    emptyView.msgLBL.text=@"Loading..";
    
    manager=[[APIManager alloc] init];
    [pageManager reset];

    if(typeOfSearch!=-1)
    {
       // NSDictionary *dict=@{@"type":[NSNumber numberWithInt:1],@"word":@"music"};
        
        [manager sendRequestExploreFeedWithDict:dict Withdelegate:self andSelector:@selector(updateTheData:)];
        [feedList1 setContentOffset:CGPointMake(0, 0) animated:false];

    }
    else
    {
        manager.pageNoRequested=1;
        manager.countRequested=-1;
        [manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(UsersPostReceived:)];
        
    }
    
    feedList1.userInteractionEnabled=false;
    
}
-(NSMutableArray *)removeDuplicatePosts:(NSMutableArray *)newRecords
{
    NSMutableArray *allPreviousRecords=[DataSession sharedInstance].exploreFeedResults;
    
    NSMutableArray *allPreviousRecordIds=[[NSMutableArray alloc] init];
    
    for(int i=0;i<allPreviousRecords.count;i++)
    {
            APIObjects_FeedObj *obj=[allPreviousRecords objectAtIndex:i];
            [allPreviousRecordIds addObject:obj.postId];

    }
    
    NSMutableArray *filteredRecords=[[NSMutableArray alloc] init];
    
    for(int i=0;i<newRecords.count;i++)
    {
        APIObjects_FeedObj *obj=[newRecords objectAtIndex:i];
        
        if(![allPreviousRecordIds containsObject:obj.postId])
        {
            [filteredRecords addObject:obj];
        }
        else
        {
            int p=0;
        }

    }
    
    return filteredRecords;
    

    
}
-(void)updateTheData:(APIResponseObj *)responseObj
{
    feedList1.userInteractionEnabled=true;

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            
            if(responseObj.statusCode==200)
            {
                NSArray *response;
                if([responseObj.response isKindOfClass:[NSArray class]])
                {
                    response=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
                }
                else
                {
                    response=[NSMutableArray arrayWithArray:[(NSArray *)responseObj.response valueForKey:@"data"]];
                }

                [pageManager setOutPutParameters:responseObj];

                
                APIObjectsParser *parser=[[APIObjectsParser alloc] init];
                NSMutableArray *responseArray=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:response]];

                
                
                responseArray=[self removeDuplicatePosts:responseArray];
                
                
                

                UICollectionView *collectionView=(UICollectionView *)feedList1;
                
                
                
                [collectionView performBatchUpdates:^{
                    
                    NSMutableArray *newIndexs=[[NSMutableArray alloc] init];
                    for(int i=(int)[DataSession sharedInstance].exploreFeedResults.count;i<([DataSession sharedInstance].exploreFeedResults.count+responseArray.count);i++)
                    {
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                        [newIndexs addObject:indexPath];
                    }
                    
                    
                    [collectionView insertItemsAtIndexPaths:newIndexs];
                    [[DataSession sharedInstance].exploreFeedResults addObjectsFromArray:responseArray];
                    
                    
                    
                } completion:^(BOOL finished) {
                    
                    [detailPostView addNewDataViaReload];
                    
                }];
                
                
              

                
                ////
                if([DataSession sharedInstance].exploreFeedResults.count==0)
                {
                    emptyView.hidden=false;
                    emptyView.msgLBL.text=@"Nothing to display";
                    
                }
                else
                {
                    emptyView.hidden=true;
                }
                
                

                
            }
            
            
        });
    });
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==feedList1)
    {
        if( typeOfSearch!=-1)
        {
            if([pageManager ifNewCallRequired:scrollView withCellHeight:0])
            {
                [self callPreviousData];
            }
            else
            {
                int p=0;
            }
        }
        else
        {
            int p=0;
        }
    }
    else
    {
        int p=0;
    }
}

-(void)callPreviousData
{
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestExploreFeedWithURL:pageManager.previousRecordURLstr Withdelegate:self andSelector:@selector(updateTheData:)];
    
    
}


-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
    feedList1.userInteractionEnabled=true;
    
    NSArray *responseArray;
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    }
    else
    {
        responseArray=[NSMutableArray arrayWithArray:[(NSArray *)responseObj.response valueForKey:@"data"]];
    }
    
    // NSLog(@"%@",responseObj.response);
    
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    [DataSession sharedInstance].exploreFeedResults=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    
    [feedList1 reloadData];
    //[self setUpDataRecords];
    
    if([DataSession sharedInstance].exploreFeedResults.count==0)
    {
        emptyView.hidden=false;
        emptyView.msgLBL.text=@"Nothing to display";
        
    }
    else
    {
        emptyView.hidden=true;
    }
    
    [feedList1 setContentOffset:CGPointMake(0, 0) animated:false];
    
    
}


#pragma mark - API calls and Actions

-(void)onTopicForChannelChanged:(NSString *)topicName
{
    [AnalyticsMXManager PushAnalyticsEventAction:@"Explore Topic Change"];
    topicNameForChannel=topicName;
    typeOfSearch=4;
    [self refreshAction];
}

-(void)searchAndAPICall:(NSString *)searchTag
{
    
    NSLog(@"%@",searchTag);
    
    backCloseBtn.hidden=false;
    currentSearchTerm=searchTag;
    exploreTerm.hidden=true;
    settingsBtn.hidden=true;
    notificationBtn.hidden=true;
    exploreTermBaseView.hidden=true;
    exploreTerm.text=@"";
    [self SearchTermChanged:nil];
    ChannelList.hidden=true;
    topicView.hidden=true;
    
    searchResultTitleLBL.hidden=false;
    searchResultContentLBL.hidden=false;
    searchResultContentLBL.text=currentSearchTerm;
    
    [self refreshAction];
    [exploreTerm resignFirstResponder];
    
}
-(void)backToChannelSearch
{
    backCloseBtn.hidden=true;
    exploreTerm.hidden=false;
    settingsBtn.hidden=false;
     notificationBtn.hidden=false;
    exploreTermBaseView.hidden=false;
    currentSearchTerm=@"";
    ChannelList.hidden=false;
    topicView.hidden=false;
    exploreTerm.text=@"";
    
    searchResultTitleLBL.hidden=true;
    searchResultContentLBL.hidden=true;
    
    [self SearchTermChanged:nil];
    [self refreshAction];
    
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



-(void)refreshTopicChannels
{
    
    APIManager *mg=[[APIManager alloc] init];
    [mg sendRequestForInterestWithDelegate:self andSelector:@selector(NewChannelListReceived:)];
}
-(void)NewChannelListReceived:(APIResponseObj *)responseObj
{
    
    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=[(NSArray *)responseObj.response valueForKey:@"data"];
        
        
        //        NSMutableArray *arrayT=[[NSMutableArray alloc] initWithArray:array];
        //
        //        for(int m=0;m<15;m++)
        //        {
        //            int no1=arc4random()%arrayT.count;
        //            int no2=arc4random()%arrayT.count;
        //            if(no1!=no2)
        //            {
        //                [arrayT exchangeObjectAtIndex:no1 withObjectAtIndex:no2];
        //            }
        //        }
        //
        //            array=[NSArray arrayWithArray:arrayT];
        //
        APIPoster *poster=[[APIPoster alloc] init];
        [poster saveDataAs:array andKey:@"DATA_INTEREST"];
    }
    channelList=[[[APIPoster alloc] init] getInterestDataForExploreScreen];
    [ChannelList reloadData];
    
    
}


#pragma mark - CollectionView Delegates / Sources


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==ChannelList)
    {
        
        
        ChannelExploreCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        
        
        cell.nameLBL.text=[[channelList objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        
        if([cell.nameLBL.text isEqualToString:@""])
        {
            cell.nameLBL.text=@"Explore";
        }
        
        
        
        
        
        
        NSString *urlString=[[channelList objectAtIndex:indexPath.row] valueForKey:@"photo"];
        [cell setURLString:urlString];

        if(![urlString isEqualToString:@""])
        {
            cell.bgView.backgroundColor=[UIColor blackColor];
            
            cell.bgView.hidden=false;
            cell.profileIMGVIEW.hidden=false;
            
            //cell.overLayView.backgroundColor=[Constant colorGlobal:((indexPath.row-1)%13)];
            cell.contentView.backgroundColor=[UIColor blackColor];
            cell.alpha=1;
            
        }
        else
        {
         
            cell.bgView.backgroundColor=[UIColor blackColor];
            
            cell.bgView.hidden=false;
            cell.profileIMGVIEW.hidden=false;
            
           // cell.overLayView.backgroundColor=[UIColor whiteColor];
            cell.contentView.backgroundColor=[UIColor blackColor];
            cell.alpha=1;
            

          
            
        }
       

        
        return cell;
    }
    else
    {
        PostMiniCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        APIObjects_FeedObj *obj=[[DataSession sharedInstance].exploreFeedResults objectAtIndex:indexPath.row];
        [cell setUpPostImageURL:obj.image_url andText:obj.text];
        
        
        APIObjects_FeedObj *FeedObj=[[DataSession sharedInstance].exploreFeedResults objectAtIndex:indexPath.row];
        NSDictionary *dict1=@{
                              @"post_id":[NSNumber numberWithInt:[FeedObj.postId intValue]],
                              @"user_id":[NSNumber numberWithInt:[[UserSession getUserId] intValue]],
                              @"poster":[NSNumber numberWithInt:[FeedObj.user_id intValue]],
                              @"page_no":[NSNumber numberWithInt:((int)(indexPath.row)/30)+1],
                              @"no_in_sequence":[NSNumber numberWithInt:(int)indexPath.row+1],
                              @"is_expanded":[NSNumber numberWithBool:false],
                              @"datetime":[[PostTrackSeenHelper sharedInstance] getCurrentTime],
                              };
        [[PostTrackSeenHelper sharedInstance] PS_NewPost:dict1];
        
        
        return cell;
        
    }
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==ChannelList)
    {
        
    }
    else
    {
        
        
        
        cell.transform=CGAffineTransformMakeScale(0.7, 0.7);
        cell.alpha=1;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             cell.transform=CGAffineTransformMakeScale(1, 1);
                             cell.alpha=1;
                             
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(collectionView==ChannelList)
    {
        return channelList.count;
    }
    else
    {
        return [DataSession sharedInstance].exploreFeedResults.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==ChannelList)
    {
        return CGSizeMake(200/2, 130/2);
    }
    else
    {
        return CGSizeMake(150/2, 268/2);
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    exploreTerm.text=@"";
    [self SearchTermChanged:nil];
    [exploreTerm resignFirstResponder];
    
    
    
    if(collectionView==feedList1)
    {
        
        [[HMPlayerManager sharedInstance] StopKeepKillingExploreFeedVideosIfAvaialble];
        
        [self hideBottomBar];
        
        
        
        PostMiniCell *cell=(PostMiniCell *)[feedList1 cellForItemAtIndexPath:indexPath];
        cell.hidden=true;
        
        UICollectionViewLayoutAttributes *attributes = [feedList1 layoutAttributesForItemAtIndexPath:indexPath];
        
        CGRect myRect = attributes.frame;
        
        
        
        
        
        CGRect rect=CGRectMake(myRect.origin.x, feedList1.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
        rect = CGRectOffset(rect, -feedList1.contentOffset.x, -feedList1.contentOffset.y);
        
        
        detailPostView=[[DetailViewComponent alloc] initWithFrame:self.bounds];
        [self addSubview:detailPostView];
        [detailPostView setDataRecords:[DataSession sharedInstance].exploreFeedResults];
        
        [detailPostView setUpWithCellRect:rect];
        
        
        APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[[DataSession sharedInstance].exploreFeedResults objectAtIndex:indexPath.row];
        
        int mediaType = obj.mediaType.intValue;
        
        if(mediaType!=0)
        {
            NSString *imgURL=obj.image_url;
            [detailPostView setImage:imgURL andNumber:indexPath];
        }
        else
        {
            int colorNumber=obj.colorNumber.intValue;
            [detailPostView setColorNumber:colorNumber];
            
            [detailPostView setImage:@"red" andNumber:indexPath];
        }
        
        
        
        [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(downClicked:)];
        
        [detailPostView setForPostDetail];
        
        
        UINavigationController *vc=(UINavigationController *)[Constant topMostController];
        ViewController *t=(ViewController *)vc.topViewController;
        [t setStatusBarHide:YES];
        
        
    }
    else
    {
        topicNameForChannel=@"";
        selectedChannel=(int)indexPath.row;
        [self updateBackground];
        [self refreshAction];
        
    }
    
}
#pragma mark - ScrollView Delegates

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f",scrollView.contentOffset.x);
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
}



#pragma mark -  Other Helper

-(void)updateBackground
{
    [topicView setChannelId:selectedChannel];
    
    
    if(selectedChannel!=-1)
    {
    [topicView setSearchTerm:[[channelList objectAtIndex:selectedChannel] valueForKey:@"name"]];
    
    //    backgroundImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"post_%d.jpeg",selectedChannel%5+3]];
    
    NSString *urlString=[[channelList objectAtIndex:selectedChannel] valueForKey:@"photo"];
    [backgroundImageView setUp:urlString];
    
    
    backgroundImageOverLayView.backgroundColor=[Constant colorGlobal:(selectedChannel%13)];
    }

    // backgroundImageOverLayView.backgroundColor=[UIColor colorWithRed:(selectedChannel%2)*0.3+0.5 green:(selectedChannel%3)*0.3+0.2 blue:(selectedChannel%4)*0.2+0.2 alpha:1.0f];
    
}

-(void)updateTheCommentCountsForVisibleRows
{
//    NSArray *arrayVisible=[feedList visibleCells];
//    
//    for(int i=0;i<arrayVisible.count;i++)
//    {
//        PostMiniCell *cell=(PostMiniCell *)[arrayVisible objectAtIndex:i];
//        [cell setHiddenCustom:false];
//
//    }
//    
}
-(void)downClicked:(NSIndexPath *)indexPath
{
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t setStatusBarHide:false];
    
    detailPostView=nil;
    [self updateTheCommentCountsForVisibleRows];
    
    [[HMPlayerManager sharedInstance] StartKeepKillingExploreFeedVideosIfAvaialble];
    
    [self showBottomBar];
    
    PostMiniCell *cell=(PostMiniCell *)[feedList1 cellForItemAtIndexPath:indexPath];
    cell.hidden=false;

}
-(void)MakeAllCellVisible
{
    NSArray *array=[feedList1 visibleCells];
    for(int i=0;i<[array count];i++)
    {
        PostMiniCell *cell=[array objectAtIndex:i];
        cell.hidden=false;

    }
}
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2
{
    delegate=target;
    hideBottomBarFunc=func1;
    showBottomBarFunc=func2;
    
}

-(void)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    [self MakeAllCellVisible];
    
    [feedList1 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    UICollectionViewLayoutAttributes *attributes = [feedList1 layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    
    PostMiniCell *cell=(PostMiniCell *)[feedList1 cellForItemAtIndexPath:indexPath];
    cell.hidden=true;
    
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList1.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    
    
    rect = CGRectOffset(rect, -feedList1.contentOffset.x, -feedList1.contentOffset.y);
    
    [detailPostView setUpNewScrolledRect:rect];
    
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - Flow
-(void)notificationBtnClicked:(id)sender
{
    notificationCompo=[[NotificationsComponent alloc] initWithFrame:CGRectMake(0, -self.frame.size.width, self.frame.size.width, self.frame.size.height)];
    
    [notificationCompo setUp:[DataSession sharedInstance].notificationsResults];
    [notificationCompo setTarget:self andBackBtnFunc:@selector(backFromMessage)];
    [self addSubview:notificationCompo];

    [UIView animateWithDuration:0.3 animations:^{
        notificationCompo.frame=self.bounds;
    }];
    
    [self endEditing:false];
    [self hideBottomBar];
}
-(void)settingsBtnClicked:(id)sender
{
    myAccountCompo=[[MyAccountComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [myAccountCompo setUp];
    myAccountCompo.blackOverLayView.image=[Constant takeScreenshot];
    myAccountCompo.blackOverLayView.alpha=1;
    
    [myAccountCompo setTarget:self andBackFunc:@selector(backFromMessage)];
    
    [self addSubview:myAccountCompo];
    
    [UIView animateWithDuration:0.3 animations:^{
        myAccountCompo.frame=self.bounds;
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

-(void)hideBottomBar
{
    
    [delegate performSelector:hideBottomBarFunc withObject:nil afterDelay:0.01];
}
-(void)showBottomBar
{
    [delegate performSelector:showBottomBarFunc withObject:nil afterDelay:0.01];
}


@end
