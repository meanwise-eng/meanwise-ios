//
//  HomeComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "HomeComponent.h"
#import "HomeFeedCell.h"
#import "DetailPostComponent.h"
#import "NewPostComponent.h"
#import "SearchComponent.h"
#import "ExploreComponent.h"
#import "MessageComponent.h"
#import "APIObjectsParser.h"
#import "PostFullCell.h"
#import "APIObjects_ProfileObj.h"
#import "ProfileFullScreen.h"
#import "UserSession.h"
#import "DataSession.h"
#import "NewProfileView.h"
#import "AppDelegate.h"

#import "HMPlayerManager.h"

@implementation HomeComponent

-(void)setUp
{
    
    screenIdentifier=@"HOME";
    
    self.backgroundColor=[UIColor whiteColor];
    
    //    feedList=[[UITableView alloc] initWithFrame:self.bounds];
    //    [self addSubview:feedList];
    //    feedList.delegate=self;
    //    feedList.dataSource=self;
    //    feedList.backgroundColor=[UIColor clearColor];
    
    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 0;
    layout1.minimumLineSpacing = 0;
    layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    feedList = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout1];
    feedList.delegate = self;
    feedList.dataSource = self;
    //  ChannelList.pagingEnabled = YES;
    feedList.showsHorizontalScrollIndicator = NO;
    feedList.backgroundColor=[UIColor clearColor];
    [feedList registerClass:[PostFullCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:feedList];
    feedList.pagingEnabled=YES;
    
    
    refreshControl=[[UIRefreshControl alloc] init];
    [feedList addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    refreshControl.backgroundColor=[UIColor whiteColor];
    
    
    emptyView=[[EmptyView alloc] initWithFrame:feedList.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    
    [emptyView setDelegate:self onReload:@selector(manuallyRefresh)];
    
    
    
    UIImageView *shadowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50)];
    shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadowImage.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:shadowImage];
    shadowImage.alpha=0.5;
    
    navBar=[[MWNavBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 65)];
    [self addSubview:navBar];
    [navBar setUp];
    [navBar setTarget:self andRightOpen:@selector(messageBtnClicked:)];
    [navBar setTarget:self andLeftOpen:@selector(setttingBtnClicked:)];
    [navBar setTarget:self andCenterOpen:@selector(centerBtnClicked:)];
    
    
    messageCompo=nil;
    myAccountCompo=nil;
    
    
    //
    // [self setttingBtnClicked:nil];
    
    //[self messageBtnClicked:nil];
    // [self tableView:feedList didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [self manuallyRefresh];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(manuallyRefresh)
                                                 name:@"REFRESH_HOME"
                                               object:nil];
    
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)manuallyRefresh
{
    
    
    emptyView.hidden=true;
    [UIView animateWithDuration:0.25 delay:0.02 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        
        feedList.contentOffset = CGPointMake(0, -100);
        
    } completion:^(BOOL finished){
        
        [feedList setContentOffset:CGPointMake(0, feedList.contentOffset.y-feedList.frame.size.height) animated:YES];
        
        [refreshControl beginRefreshing];
        [self refreshAction];
        
    }];
    
    
}

-(void)refreshAction
{
    [HMPlayerManager sharedInstance].Home_urlIdentifier=@"";
    
    emptyView.hidden=true;
    
    [Constant setStatusBarColorWhite:false];
    
    manager=[[APIManager alloc] init];
    [manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(UsersPostReceived:)];
    
    NSLog(@"Hello Home");
    NSLog(@"%@",NSStringFromCGRect(refreshControl.frame));
    //[self performSelector:@selector(endRefreshControl) withObject:nil afterDelay:1.0f];
    
}
-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
    [Constant setStatusBarColorWhite:true];
    
    NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    
    //  NSLog(@"%@",responseObj.response);
    
    if(responseArray.count==0)
    {
        emptyView.hidden=false;
    }
    else
    {
        emptyView.hidden=true;
    }
    
    
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    
    [DataSession sharedInstance].homeFeedResults=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    
    
    //[self setUpDataRecords];
    
    [refreshControl endRefreshing];
    
    refreshControl.attributedTitle = nil;
    
    
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        
        [feedList setContentOffset:CGPointMake(0, 0) animated:false];
        
    } completion:^(BOOL finished){
        
        [self feedReloadViaAutoPlay];
        
        
    }];
    
}

-(void)feedReloadViaAutoPlay
{
    [HMPlayerManager sharedInstance].Home_urlIdentifier=@"";
    
    [feedList reloadData];
    [feedList performBatchUpdates:^{}
                       completion:^(BOOL finished) {
                           
                           if(finished==true)
                           {
                               [self stoppedScrolling];
                           }
                           /// collection-view finished reload
                       }];
    
    
}


#pragma mark - TableView


-(void)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    [self MakeAllCellVisible];
    
    [feedList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
    
    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    
    HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=true;
    
    
    CGRect rect=CGRectMake(0, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    
    
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    
    [detailPostView setUpNewScrolledRect:rect];
    
    
}


-(void)downClicked:(NSIndexPath *)indexPath
{
    HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=false;
    [self showBottomBar];
    // FeedCell *cell=[tableView cellForRowAtIndexPath:indexPath];
}
-(void)MakeAllCellVisible
{
    NSArray *array=[feedList visibleCells];
    for(int i=0;i<[array count];i++)
    {
        HomeFeedCell *cell=[array objectAtIndex:i];
        cell.hidden=false;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [DataSession sharedInstance].homeFeedResults.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    APIObjects_FeedObj * dict = [[DataSession sharedInstance].homeFeedResults objectAtIndex:indexPath.row] ;
    
    PostFullCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if(cell){
            [cell cleanUp];
            [cell setDataObj:dict];

            [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];
            [cell setPlayerScreenIdeantifier:screenIdentifier];
            [cell onDeleteEvent:@selector(deleteAPost:)];
            
            
            CGFloat yOffset = ((feedList.contentOffset.y - cell.frame.origin.y) / self.bounds.size.height) * IMAGE_OFFSET_SPEED;
            cell.imageOffset = CGPointMake(0.0f, yOffset);
    }
    
    return cell;
    
}
-(void)HomeScreenGoesBack
{
    NSLog(@"Home screen back");
    [HMPlayerManager sharedInstance].Home_isPaused=true;
    [self playContent];
    
}
-(void)HomeScreenComesToFront
{
    NSLog(@"Home screen front");
    [HMPlayerManager sharedInstance].Home_isPaused=false;
    [self pauseContent];
    
}

-(void)shareBtnClicked:(NSString *)senderId
{
    
    
    if(sharecompo==nil)
    {
        
        [self HomeScreenGoesBack];
        
        [self hideBottomBar];
        sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
        [sharecompo setUp];
        [sharecompo setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        [self addSubview:sharecompo];
    }
    
}
-(void)commentBtnClicked:(NSString *)senderId
{
    
    
    if(commentDisplay==nil)
    {
        [self HomeScreenGoesBack];
        
        
        [self hideBottomBar];
        
        commentDisplay=[[FullCommentDisplay alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [commentDisplay setUpWithPostId:[NSString stringWithFormat:@"%@",senderId]];
        [self addSubview:commentDisplay];
        [commentDisplay setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            
            commentDisplay.frame=self.bounds;
            
        } completion:^(BOOL finished) {
            
            
            
        }];
    }
    
}
-(void)commentFullClosed:(id)sender
{
    [self HomeScreenComesToFront];
    
    [self showBottomBar];
    
    commentDisplay=nil;
    sharecompo=nil;
}
-(void)deleteAPost:(APIObjects_FeedObj *)obj
{
    
    
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    /* [self hideBottomBar];
     
     
     
     HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
     cell.hidden=true;
     
     UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
     CGRect myRect = attributes.frame;
     
     
     
     
     
     CGRect rect=CGRectMake(0, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
     rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
     
     
     detailPostView=[[DetailViewComponent alloc] initWithFrame:self.bounds];
     [self addSubview:detailPostView];
     [detailPostView setDataRecords:dataRecords];
     
     [detailPostView setUpWithCellRect:rect];
     
     
     APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[dataRecords objectAtIndex:indexPath.row];
     
     int mediaType = obj.mediaType.intValue;
     
     if(mediaType!=0)
     {
     NSString *imgURL=obj.image_url;
     [detailPostView setImage:imgURL andNumber:indexPath];
     }
     else
     {
     int colorNumber=3;
     [detailPostView setColorNumber:colorNumber];
     [detailPostView setImage:@"red" andNumber:indexPath];
     }
     
     
     
     [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(downClicked:)];
     
     [detailPostView setForPostDetail];
     
     */
}

#pragma mark - scrollView

-(void)scrollViewDidBeginDragging:(UIScrollView *)scrollView
{
    [self pauseContent];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self pauseContent];
    
    for(PostFullCell *view in feedList.visibleCells) {
        CGFloat yOffset = ((feedList.contentOffset.y - view.frame.origin.y) / self.bounds.size.height) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

-(void)stoppedScrolling
{
    // REGISTER PUSH NOTIFICATIONS
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        // Register for push in iOS 8.
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    

    [self playContent];
    /*
    CGRect visibleRect = (CGRect){.origin = feedList.contentOffset, .size = feedList.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [feedList indexPathForItemAtPoint:visiblePoint];
    
    NSLog(@"Visible center - %d\n",(int)visibleIndexPath.row);
    
    
    
    for(UICollectionViewCell *cell in [feedList visibleCells])
    {
        
        NSIndexPath *indexPath = [feedList indexPathForCell:cell];
        NSLog(@"visibleCells %d",(int)indexPath.row);
        if(indexPath==visibleIndexPath)
        {
            NSArray *array=[DataSession sharedInstance].homeFeedResults;
            APIObjects_FeedObj *obj=[array objectAtIndex:indexPath.row];
            NSString *url=obj.video_url;
            
            
            if(![obj.video_url isEqualToString:[HMPlayerManager sharedInstance].Home_urlIdentifier])
            {
                
                PostFullCell *cell=(PostFullCell *)[feedList cellForItemAtIndexPath:visibleIndexPath];
                [cell playVideoIfAvaialble];
                
                [HMPlayerManager sharedInstance].Home_screenIdentifier=screenIdentifier;
                [HMPlayerManager sharedInstance].Home_urlIdentifier=url;
                
            }
            
            
        }
    }
    
    */
    
    // done, do whatever
}

-(void)registerDevice:(APIResponseObj *)responseObj
{
    if(responseObj.statusCode!=200)
    {
        NSLog(@"REGISTRATION FOR PUSH: FAILED");
        
    }
    else
    {
        NSLog(@"REGISTRATION FOR PUSH: SUCCESS");
    }
}

#pragma mark - Flow


-(void)pauseContent
{
    CGRect visibleRect = (CGRect){.origin = feedList.contentOffset, .size = feedList.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [feedList indexPathForItemAtPoint:visiblePoint];
    
    for(UICollectionViewCell *cell in [feedList visibleCells])
    {
        
        NSIndexPath *indexPath = [feedList indexPathForCell:cell];
        
        if(indexPath==visibleIndexPath)
        {
            
            PostFullCell * theCell = (PostFullCell *)cell;
            
            if([theCell isVideoContent]){
                [theCell pausePlayer];
            }
            
        }
    }
    
}

-(void)playContent
{
    CGRect visibleRect = (CGRect){.origin = feedList.contentOffset, .size = feedList.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [feedList indexPathForItemAtPoint:visiblePoint];
    
    for(UICollectionViewCell *cell in [feedList visibleCells])
    {
        
        NSIndexPath *indexPath = [feedList indexPathForCell:cell];
        
        if(indexPath==visibleIndexPath)
        {
            
            PostFullCell * theCell = (PostFullCell *)cell;
            
            if([theCell isVideoContent]){
                [theCell playVideoIfAvaialble];
            }
            
        }
    }
    
}

-(NSDictionary *)userDictFromPostDetail:(APIObjects_ProfileObj *)prof
{
    
    NSDictionary *dict=@{
                         @"user_id":prof.userId,
                         @"user_cover_photo":prof.cover_photo
                         };
    
    return dict;
}

-(void)centerBtnClicked:(id)sender
{
    [self HomeScreenGoesBack];
    
    
    //APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    
    APIObjects_ProfileObj *obj=[UserSession getUserObj];
    
    
    CGRect rect= CGRectMake((self.bounds.size.width - 40)/2, 10, 40, 40);
    
    NewProfileView *com=[[NewProfileView alloc] initWithFrame:rect];
    [self addSubview:com];
    [com setUpProfileObj:[self userDictFromPostDetail:obj]];
    [com setDelegate:self andFunc1:@selector(backFromCenterProfile:)];
    [com setUpFromView:@"logoButton"];
    
    //CGRect rect=CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 0);
    //[com setUpWithCellRect:rect];
    
    
    //[com setDelegate:self andPageChangeCallBackFunc:@selector(backFromCenterProfile:) andDownCallBackFunc:@selector(backFromCenterProfile:)];
    
    
    [self hideBottomBar];
    
}
-(void)backFromCenterProfile:(id)sender
{
    [self HomeScreenComesToFront];
    
    
    [self showBottomBar];
    
}
-(void)messageBtnClicked:(id)sender
{
    [self HomeScreenGoesBack];
    
    
    messageCompo=[[NotificationsComponent alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:messageCompo];
    [messageCompo setUp:[DataSession sharedInstance].notificationsResults];
    [messageCompo setTarget:self andBackBtnFunc:@selector(backFromMessage)];
    
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        messageCompo.alpha=1;
        messageCompo.frame=self.bounds;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    /*messageCompo=[[MessageComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
     [messageCompo setUp];
     messageCompo.blackOverLayView.image=[Constant takeScreenshot];
     messageCompo.blackOverLayView.alpha=1;
     
     [messageCompo setTarget:self andBackFunc:@selector(backFromMessage)];
     
     [self addSubview:messageCompo];
     
     
     
     [UIView animateWithDuration:0.3 animations:^{
     messageCompo.frame=self.bounds;
     messageCompo.backgroundColor=[UIColor whiteColor];
     }];*/
    
    
    [self hideBottomBar];
    
    
    
}
-(void)backFromMessage
{
    [self HomeScreenComesToFront];
    
    messageCompo=nil;
    [self showBottomBar];
}
-(void)setttingBtnClicked:(id)sender
{
    [self HomeScreenGoesBack];
    
    
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
    
    [self hideBottomBar];
    
    
    
}
-(void)backFromSetting
{
    [self HomeScreenComesToFront];
    
    [self showBottomBar];
}


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



@end