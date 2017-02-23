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

@implementation HomeComponent




-(void)setUp
{

    
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
    

    
    //[self messageBtnClicked:nil];
   // [self tableView:feedList didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
 
    [self manuallyRefresh];

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
    emptyView.hidden=true;

    [Constant setStatusBarColorWhite:false];
    
    manager=[[APIManager alloc] init];
    [manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(UsersPostReceived:)];
    
    NSLog(@"Hello");
    NSLog(@"%@",NSStringFromCGRect(refreshControl.frame));
    //[self performSelector:@selector(endRefreshControl) withObject:nil afterDelay:1.0f];
    
}
-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
    [Constant setStatusBarColorWhite:true];
    
    NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    
    NSLog(@"%@",responseObj.response);
    
    if(responseArray.count==0)
    {
        emptyView.hidden=false;
    }
    else
    {
        emptyView.hidden=true;
    }

    
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    dataRecords=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    
    [feedList reloadData];
    //[self setUpDataRecords];
    
    [refreshControl endRefreshing];
    refreshControl.attributedTitle = nil;
    
    
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){

        [feedList setContentOffset:CGPointMake(0, 0) animated:false];

    } completion:^(BOOL finished){
        
        
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
    return dataRecords.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell setDataObj:[dataRecords objectAtIndex:indexPath.row]];
     
    [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];
    
    
    
    
    
    

    
    
    return cell;

}

-(void)shareBtnClicked:(NSString *)senderId
{
    if(sharecompo==nil)
    {

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
    [self showBottomBar];

    commentDisplay=nil;
    sharecompo=nil;
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self playFirstVideo];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==false)
    {
        [self playFirstVideo];
    }
    
}
-(void)playFirstVideo
{
    NSLog(@"cell Changed");
    

    NSArray *visibleCells=[feedList visibleCells];
    
    for(int i=0;i<visibleCells.count;i++)
    {
        PostFullCell *cell=[visibleCells objectAtIndex:i];
        
        [cell pausePlayer];
        [cell setMute];
        
    }
    
    for(int i=0;i<visibleCells.count;i++)
    {
        PostFullCell *cell=[visibleCells objectAtIndex:i];
        
        CGRect rect=cell.frame;
        
        rect=CGRectMake(cell.frame.origin.x, cell.frame.origin.y-feedList.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
        
        
        if(rect.origin.y<10 && rect.origin.y>-10)
        {
            [cell setUnMute];
            
            
         //   [cell playVideoIfAvaialble];
            
            
//        UIView *view=[[UIView alloc] initWithFrame:rect];
//        [self addSubview:view];
//        view.backgroundColor=[UIColor blackColor];
//        view.alpha=0.5;
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            view.alpha=0;
//            
//        } completion:^(BOOL finished) {
//            [view removeFromSuperview];
//        }];
        }

        
    }
    
}


/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if(velocity.y>0)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            feedList.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            // navBar.frame=CGRectMake(0, 0, self.bounds.size.width, 65);
            
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            feedList.frame=CGRectMake(0, 65, self.bounds.size.width, self.bounds.size.height-65);
            // navBar.frame=CGRectMake(0, 0, self.bounds.size.width, 65);
            
        }];
        
    }
}*/


#pragma mark - Flow
-(void)centerBtnClicked:(id)sender
{
    //APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    
    APIObjects_ProfileObj *obj=[UserSession getUserObj];
    
    ProfileFullScreen *com=[[ProfileFullScreen alloc] initWithFrame:self.bounds];
    [self addSubview:com];
    [com setUpProfileObj:obj];
    
    CGRect rect=CGRectMake(0, 0, self.frame.size.width, 0);
    [com setUpWithCellRect:rect];
    
    
    [com setDelegate:self andPageChangeCallBackFunc:@selector(backFromCenterProfile:) andDownCallBackFunc:@selector(backFromCenterProfile:)];
    
    
    [self hideBottomBar];

}
-(void)backFromCenterProfile:(id)sender
{
    [self showBottomBar];

}
-(void)messageBtnClicked:(id)sender
{
    
    
    messageCompo=[[MessageComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [messageCompo setUp];
    messageCompo.blackOverLayView.image=[Constant takeScreenshot];
    messageCompo.blackOverLayView.alpha=1;
    
    [messageCompo setTarget:self andBackFunc:@selector(backFromMessage)];
    
    [self addSubview:messageCompo];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        messageCompo.frame=self.bounds;
        messageCompo.backgroundColor=[UIColor whiteColor];
    }];
    
    [self hideBottomBar];
    
    
    
}
-(void)backFromMessage
{
    [self showBottomBar];
}
-(void)setttingBtnClicked:(id)sender
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
    
    [self hideBottomBar];
    
    
    
}
-(void)backFromSetting
{
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

-(void)setUpDataRecords
{
    dataRecords=[[NSMutableArray alloc] init];
    
    
    for(int i=0;i<1;i++)
    {
        
        
        NSDictionary *dict1=@{@"postType":[NSNumber numberWithInt:1],
                              @"imageURL":@"post_3.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict1];
        
        NSDictionary *dict42=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr11.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_mxlga0gj0e1shsvoe.mp4"};
        
        [dataRecords addObject:dict42];
        
        
        
        
        NSDictionary *dict2=@{@"postType":[NSNumber numberWithInt:1],
                              @"imageURL":@"post_4.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict2];
        
        NSDictionary *dict5=@{@"postType":[NSNumber numberWithInt:0],
                              @"imageURL":@"post_5.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict5];
        
        
        NSDictionary *dict3=@{@"postType":[NSNumber numberWithInt:1],
                              @"imageURL":@"post_7.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict3];
        
        
        NSDictionary *dict41=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr1.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi00kfkvMq1vrn2g4_480.mp4"};
        
        [dataRecords addObject:dict41];
        
        NSDictionary *dict43=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr12.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi4mtbbrHS1vwm5np.mp4"};
        
        [dataRecords addObject:dict43];
        
        {
            NSDictionary *dict5=@{@"postType":[NSNumber numberWithInt:0],
                                  @"imageURL":@"post_5.jpeg",
                                  @"color":[NSNumber numberWithInt:arc4random()%14],
                                  @"videoURL":@""};
            
            [dataRecords addObject:dict5];
        }
        
        NSDictionary *dict44=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr7.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi3y37m7az1vo8xre_480.mp4"};
        
        [dataRecords addObject:dict44];
        
        
        
        NSDictionary *dict45=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr14.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_ohkwqixP5j1u3ehw5.mp4"};
        
        [dataRecords addObject:dict45];
        
        {
            NSDictionary *dict3=@{@"postType":[NSNumber numberWithInt:1],
                                  @"imageURL":@"post_5.jpeg",
                                  @"color":[NSNumber numberWithInt:arc4random()%14],
                                  @"videoURL":@""};
            
            [dataRecords addObject:dict3];
            
        }
        
        NSDictionary *dict46=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr8.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi3vig8Lqp1qbct3j.mp4"};
        
        [dataRecords addObject:dict46];
        
        
        NSDictionary *dict4=@{@"postType":[NSNumber numberWithInt:2],
                              @"imageURL":@"thumb1.png",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              
                              @"videoURL":@"https://player.vimeo.com/external/121377179.hd.mp4?s=383ab10c2c3229be7e818ccf30888ba8dbb59b26&profile_id=119&oauth2_token_id=57447761"};
        
        [dataRecords addObject:dict4];
        
        
    }
    
}

@end
