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
#import "HomeFeedCell.h"
#import "APIObjectsParser.h"
#import "DataSession.h"
#import "HMPlayerManager.h"
#import "SDiOSVersion.h"

@implementation ExploreComponent

-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2
{
    delegate=target;
    hideBottomBarFunc=func1;
    showBottomBarFunc=func2;
    
}
-(void)hideBottomBar
{
    [delegate performSelector:hideBottomBarFunc withObject:nil afterDelay:0.01];
}
-(void)showBottomBar
{
    [delegate performSelector:showBottomBarFunc withObject:nil afterDelay:0.01];
}

-(void)setUp
{
    
    
    topicNameForChannel=@"";
    typeOfSearch=1;
    currentSearchTerm=@"";
  //  [self setUpDataRecords];
    
    //    channelList=[[NSArray alloc] initWithObjects:@"Music",@"Travel",@"Lifestyle",@"Sports",@"Science & Technology",@"Politics",@"Fashion",@"Finance",@"Gamming",nil];

    
    channelList=[[[APIPoster alloc] init] getInterestData];
    
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
    
    mainView = [[UIScrollView alloc]initWithFrame:self.bounds];
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [self addSubview:mainView];
    
    
    exploreTermBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width-40, 40)];
    [mainView addSubview:exploreTermBaseView];
    exploreTermBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    exploreTermBaseView.layer.cornerRadius=2;
    exploreTermBaseView.clipsToBounds=YES;
    


    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    searchIcon.image=[UIImage imageNamed:@"ChannelSearchIcon.png"];
    [exploreTermBaseView addSubview:searchIcon];
    searchIcon.contentMode=UIViewContentModeScaleAspectFill;
    
    
    
    exploreTerm=[[UITextField alloc] initWithFrame:CGRectMake(50, 0, exploreTermBaseView.frame.size.width-50, 40)];
    [exploreTermBaseView addSubview:exploreTerm];
    exploreTerm.tintColor=[UIColor whiteColor];
    exploreTerm.textColor=[UIColor whiteColor];
    exploreTerm.delegate = self;
    
    searchClearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searchClearBtn setFrame:CGRectMake(exploreTermBaseView.frame.size.width-30, 10, 20, 20)];
    [searchClearBtn setBackgroundImage:[UIImage imageNamed:@"2_cancelBtn.png"] forState:UIControlStateNormal];
    [exploreTermBaseView addSubview:searchClearBtn];
    [searchClearBtn addTarget:self action:@selector(clearSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 20;
    layout1.minimumLineSpacing = 10;
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout1.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);

    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 20;
    layout2.minimumLineSpacing = 20;
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);

    CGRect collectionViewFrame = CGRectMake(0, 70, self.frame.size.width, 100);
    ChannelList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout1];
    ChannelList.delegate = self;
    ChannelList.dataSource = self;
    //  ChannelList.pagingEnabled = YES;or heavy
    ChannelList.showsHorizontalScrollIndicator = NO;
    ChannelList.backgroundColor=[UIColor clearColor];
    [ChannelList registerClass:[ChannelExploreCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [mainView addSubview:ChannelList];
    
    
    collectionViewFrame = CGRectMake(0, 210, self.frame.size.width, 380);

    
    feedList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    feedList.delegate = self;
    feedList.dataSource = self;
    //  feedExpList.pagingEnabled = YES;
    feedList.showsHorizontalScrollIndicator = NO;
    feedList.backgroundColor=[UIColor clearColor];
    [feedList registerClass:[HomeFeedCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [mainView addSubview:feedList];
    feedList.alwaysBounceHorizontal=YES;
    feedList.bounces=true;
    
    if ([SDiOSVersion deviceSize] == Screen4inch){
        mainView.alwaysBounceVertical = YES;
        mainView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height + 100);
    }
    else{
        mainView.alwaysBounceVertical = NO;
        mainView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }

    selectedChannel=0;

    topicView=[[ExploreTopicView alloc] initWithFrame:CGRectMake(0, 210-40, self.frame.size.width, 30)];
    [mainView addSubview:topicView];
    [topicView setUp:40];
    [topicView setChannelId:selectedChannel];
    [topicView setTarget:self OnTopicSelectCallBack:@selector(onTopicForChannelChanged:)];
   
    [self updateBackground];
    
    
    

    
    searchResultView=[[ExploreSearchComponent alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height-80)];
    [searchResultView setUp];
    [mainView addSubview:searchResultView];
    searchResultView.hidden=true;
    searchResultView.alpha=0;
    [searchResultView setTarget:self OnSearchItemSelectedFunc:@selector(searchAndAPICall:)];
    
    [exploreTerm addTarget:self
                  action:@selector(SearchTermChanged:)
        forControlEvents:UIControlEventEditingChanged];
    
    emptyView=[[EmptyView alloc] initWithFrame:feedList.frame];
    [mainView addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForBlack];
    [emptyView setDelegate:self onReload:@selector(refreshAction)];
    emptyView.msgLBL.text=@"Nothing to display";
    emptyView.reloadBtn.hidden=true;

    searchResultTitleLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width-40, 20)];
    searchResultContentLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 125, self.frame.size.width-40, 35)];
    [mainView addSubview:searchResultContentLBL];
    [mainView addSubview:searchResultTitleLBL];
    searchResultTitleLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    searchResultContentLBL.font=[UIFont fontWithName:k_fontSemiBold size:30];
    searchResultTitleLBL.text=@"YOU SEARCHED FOR";
    searchResultContentLBL.text=@"MECHANISM";
    searchResultTitleLBL.textColor=[UIColor whiteColor];
    searchResultContentLBL.textColor=[UIColor whiteColor];
    searchResultTitleLBL.hidden=true;
    searchResultContentLBL.hidden=true;
    
    
/*    exploreTerm.hidden=true;
    exploreTermBaseView.hidden=true;
    ChannelList.hidden=true;
    topicView.hidden=true;*/

    
    
    backCloseBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 10, 50, 50)];
    [self addSubview:backCloseBtn];
    [backCloseBtn addTarget:self action:@selector(backToChannelSearch) forControlEvents:UIControlEventTouchUpInside];
    [backCloseBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];

    backCloseBtn.hidden=true;
    [self refreshAction];

}

-(void)clearSearch:(id)sender
{
    NSLog(@"CLICKED");
    exploreTerm.text = @"";
    [self SearchTermChanged:searchClearBtn];
}

-(void)onTopicForChannelChanged:(NSString *)topicName
{
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
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f",scrollView.contentOffset.x);
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        NSLog(@"%f",scrollView.contentOffset.x);
}


-(void)refreshAction
{
    if([currentSearchTerm isEqualToString:@""])
    {
        if([topicNameForChannel isEqualToString:@""])
        {
            typeOfSearch=1;
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
    //[manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(UsersPostReceived:)];
    
    // [feedList setContentOffset:CGPointMake(0, feedList.contentOffset.y-feedList.frame.size.height) animated:YES];
    
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
    
    
    
    [manager sendRequestExploreFeedWithKey:dict Withdelegate:self andSelector:@selector(UsersPostReceived:)];
    
    //[self performSelector:@selector(endRefreshControl) withObject:nil afterDelay:1.0f];
}
-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
    
    NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    
   // NSLog(@"%@",responseObj.response);
    
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    [DataSession sharedInstance].exploreFeedResults=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    
    [feedList reloadData];
    //[self setUpDataRecords];
    
    if([DataSession sharedInstance].exploreFeedResults.count==0)
    {
        emptyView.hidden=false;
    }
    else
    {
        emptyView.hidden=true;
    }
    
     [feedList setContentOffset:CGPointMake(0, 0) animated:false];
    
    
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



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==ChannelList)
    {
        

    ChannelExploreCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        

   // cell.backgroundColor=[UIColor clearColor];
    cell.nameLBL.text=[[channelList objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        
        
        cell.overLayView.backgroundColor=[Constant colorGlobal:(indexPath.row%13)];


        
        //cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"post_%d.jpeg",(int)indexPath.row%5+3]];

        NSString *urlString=[[channelList objectAtIndex:indexPath.row] valueForKey:@"photo"];
    
        [cell setURLString:urlString];
        
        
    return cell;
    }
    else
    {
        HomeFeedCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        [cell setFrameX:CGRectMake(0, 0, 250, 380)];
        [cell setDataObj:[[DataSession sharedInstance].exploreFeedResults objectAtIndex:indexPath.row]];
        
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
        NSLog(@"THE COUNTY IS %lu", (unsigned long)[DataSession sharedInstance].exploreFeedResults.count);
        return [DataSession sharedInstance].exploreFeedResults.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==ChannelList)
    {
        
        return CGSizeMake(90, 70);
    }
    else
    {
        return CGSizeMake(250, 370);
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [exploreTerm resignFirstResponder];
    
   if(collectionView==feedList)
    {
        NSLog(@"THE INDEXPATH IS %@", indexPath);
 
      //  [[HMPlayerManager sharedInstance] StopKeepKillingExploreFeedVideosIfAvaialble];
        
        [self hideBottomBar];
        
        
        
        HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
        cell.hidden=true;
        
        //UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
        
        CGRect myRect = cell.frame;

        
        CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
        rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);

        
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
        
    }
    else
    {
        topicNameForChannel=@"";
        selectedChannel=(int)indexPath.row;
        [self updateBackground];
        [self refreshAction];
        
    }
    
}
-(void)updateBackground
{
    [topicView setChannelId:selectedChannel];
    
    [topicView setSearchTerm:[[channelList objectAtIndex:selectedChannel] valueForKey:@"name"]];

//    backgroundImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"post_%d.jpeg",selectedChannel%5+3]];
    
    NSString *urlString=[[channelList objectAtIndex:selectedChannel] valueForKey:@"photo"];
    [backgroundImageView setUp:urlString];

    
    backgroundImageOverLayView.backgroundColor=[Constant colorGlobal:(selectedChannel%13)];
    
   // backgroundImageOverLayView.backgroundColor=[UIColor colorWithRed:(selectedChannel%2)*0.3+0.5 green:(selectedChannel%3)*0.3+0.2 blue:(selectedChannel%4)*0.2+0.2 alpha:1.0f];

}

-(void)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    [self MakeAllCellVisible];
    
   [feedList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    // CGRect myRect = [feedList rectForRowAtIndexPath:indexPath];
    
    HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
    [cell setHiddenCustom:true];
    
    //    [cell setKeepPlaying:true];
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);

    
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    
    [detailPostView setUpNewScrolledRect:rect];
    
    
}



-(void)downClicked:(NSIndexPath *)indexPath
{
    
    detailPostView=nil;
    
    [[HMPlayerManager sharedInstance] StartKeepKillingExploreFeedVideosIfAvaialble];
    
    [self showBottomBar];
    
    HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
    [cell setHiddenCustom:false];
}
-(void)MakeAllCellVisible
{
    NSArray *array=[feedList visibleCells];
    for(int i=0;i<[array count];i++)
    {
        HomeFeedCell *cell=[array objectAtIndex:i];
        [cell setHiddenCustom:false];
    }
}
@end