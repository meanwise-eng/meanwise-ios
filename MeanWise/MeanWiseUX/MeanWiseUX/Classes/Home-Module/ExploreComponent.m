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
  //  [self setUpDataRecords];
    
    //    channelList=[[NSArray alloc] initWithObjects:@"Music",@"Travel",@"Lifestyle",@"Sports",@"Science & Technology",@"Politics",@"Fashion",@"Finance",@"Gamming",nil];

    
    channelList=[[[APIPoster alloc] init] getInterestData];
    
    self.backgroundColor=[UIColor blackColor];
    
    backgroundImageView=[[UIImageHM alloc] initWithFrame:self.bounds];
    backgroundImageView.image=[UIImage imageNamed:@"post_4.jpeg"];
    [self addSubview:backgroundImageView];
    backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    backgroundImageView.alpha=1;
    
    backgroundImageOverLayView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:backgroundImageOverLayView];
    backgroundImageOverLayView.alpha=0.3;
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width-40, 40)];
    [self addSubview:view];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.4f];
    view.layer.cornerRadius=2;
    view.clipsToBounds=YES;
    


    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    searchIcon.image=[UIImage imageNamed:@"ChannelSearchIcon.png"];
    [view addSubview:searchIcon];
    searchIcon.contentMode=UIViewContentModeScaleAspectFill;
    
    exploreTerm=[[UITextField alloc] initWithFrame:CGRectMake(50, 0, view.frame.size.width-50, 40)];
    [view addSubview:exploreTerm];
    exploreTerm.tintColor=[UIColor whiteColor];
    exploreTerm.textColor=[UIColor whiteColor];
    exploreTerm.delegate=self;
    
    
    
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
    //  ChannelList.pagingEnabled = YES;
    ChannelList.showsHorizontalScrollIndicator = NO;
    ChannelList.backgroundColor=[UIColor clearColor];
    [ChannelList registerClass:[ChannelExploreCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:ChannelList];
    

    collectionViewFrame = CGRectMake(0, 210, self.frame.size.width, 380);
    feedList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    feedList.delegate = self;
    feedList.dataSource = self;
    //  feedExpList.pagingEnabled = YES;
    feedList.showsHorizontalScrollIndicator = NO;
    feedList.backgroundColor=[UIColor clearColor];
    [feedList registerClass:[HomeFeedCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:feedList];

    selectedChannel=0;

    topicView=[[ExploreTopicView alloc] initWithFrame:CGRectMake(0, 210-35, self.frame.size.width, 30)];
    [self addSubview:topicView];
    [topicView setUp:40];
    [topicView setChannelId:selectedChannel];
   
    [self updateBackground];

    
    searchResultView=[[ExploreSearchComponent alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height-80)];
    [searchResultView setUp];
    [self addSubview:searchResultView];
    searchResultView.hidden=true;
    searchResultView.alpha=0;
    [exploreTerm addTarget:self
                  action:@selector(SearchTermChanged:)
        forControlEvents:UIControlEventEditingChanged];
    

    refreshControl=[[UIRefreshControl alloc] init];
    [feedList addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor=[UIColor clearColor];
    
    [self refreshAction];

}
-(void)refreshAction
{
    manager=[[APIManager alloc] init];
    [manager sendRequestHomeFeedFor_UserWithdelegate:self andSelector:@selector(UsersPostReceived:)];
    
    NSLog(@"Hello");
    NSLog(@"%@",NSStringFromCGRect(refreshControl.frame));
    // [feedList setContentOffset:CGPointMake(0, feedList.contentOffset.y-feedList.frame.size.height) animated:YES];
    
    
    
    //[self performSelector:@selector(endRefreshControl) withObject:nil afterDelay:1.0f];
}
-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
    
    NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    
    NSLog(@"%@",responseObj.response);
    
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    dataRecords=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    
    [feedList reloadData];
    //[self setUpDataRecords];
    
    [refreshControl endRefreshing];
    refreshControl.attributedTitle = nil;
    // [feedList setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
}

-(void)SearchTermChanged:(id)sender
{
    if([exploreTerm.text length]>0)
    {
        
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
        [cell setDataObj:[dataRecords objectAtIndex:indexPath.row]];

        
        // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //    cell.postIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"post_%d.jpeg",(int)indexPath.row%5+3]];
        //D   cell.postIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"thumb%d.png",(int)indexPath.row%5+1]];
       /* cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];
        int mediaType=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"postType"] intValue];
        int colorNumber=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"color"] intValue];
        [cell setUpMediaType:mediaType andColorNumber:colorNumber];
        
       
        if(mediaType!=0)
        {
            NSString *imgURL=[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"imageURL"];
            cell.postIMGVIEW.image=[UIImage imageNamed:imgURL];
        }
        else
        {
            
        }*/
        
        //cell.postIMGVIEW.image=[UIImage imageNamed:imgURL];
        
        
        
        
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
        return dataRecords.count;
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
    
    if(collectionView==feedList && 1==0)
    {
    [self hideBottomBar];

    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    
    detailPostView=[[DetailViewComponent alloc] initWithFrame:self.bounds];
    [self addSubview:detailPostView];
    
    HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
    [cell setHiddenCustom:true];
    
    [detailPostView setDataRecords:dataRecords];
    
    
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    
    
    
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    
    [detailPostView setUpWithCellRect:rect];
    
        
    
    //    UIImage *img=[cell screenshotOfVideo];
    
    
    int mediaType=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"postType"] intValue];
    
    if(mediaType!=0)
    {
        NSString *imgURL=[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"imageURL"];
        [detailPostView setImage:imgURL andNumber:indexPath];
    }
    else
    {
        int colorNumber=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"color"] intValue];
        
        [detailPostView setColorNumber:colorNumber];
        
        [detailPostView setImage:@"red" andNumber:indexPath];
        
        
    }
    
    
    // [detailPostView setUIImage:[cell screenshotOfVideo]];
    
    [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(downClicked:)];
    
    [detailPostView setForPostDetail];
    }
    else if(collectionView==feedList)
    {
        [self hideBottomBar];
        
        
        
        HomeFeedCell *cell=(HomeFeedCell *)[feedList cellForItemAtIndexPath:indexPath];
        cell.hidden=true;
        
        UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
        
        CGRect myRect = attributes.frame;
        
        

        
        
        CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
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
            int colorNumber=obj.colorNumber.intValue;
            [detailPostView setColorNumber:colorNumber];
            
            [detailPostView setImage:@"red" andNumber:indexPath];
        }
        
        
        
        [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(downClicked:)];
        
        [detailPostView setForPostDetail];
        
    }
    else
    {
        selectedChannel=(int)indexPath.row;
        [self updateBackground];

    }
    
}
-(void)updateBackground
{
    [topicView setChannelId:selectedChannel];

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
