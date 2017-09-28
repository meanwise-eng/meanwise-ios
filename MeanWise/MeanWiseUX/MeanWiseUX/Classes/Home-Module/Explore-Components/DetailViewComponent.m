//
//  DetailViewComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 28/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "DetailViewComponent.h"
#import "PostFullCell.h"
#import "APIObjects_FeedObj.h"
#import "HMPlayerManager.h"
#import "PostTrackSeenHelper.h"
#import "FTIndicator.h"
#import "APIManager.h"
#import "GUIScaleManager.h"


@implementation DetailViewComponent

#define IMAGE_OFFSET_SPEED RX_mainScreenBounds.size.width*0.3

-(void)setUpWithCellRect:(CGRect)rect
{
    ifItsForExplore=false;
    shouldOpenCommentDirectly=false;
    [AnalyticsMXManager PushAnalyticsEventAction:@"Explore Screen Expand"];

    screenIdentifier=[[HMPlayerManager sharedInstance] MX_getNewIdentifierRow];

    

    self.backgroundColor=[UIColor clearColor];
    

    [self setUpCellRectResizer:rect];

    containerView.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
   
       postIMGVIEW=[[UIImageHM alloc] initWithFrame:containerView.bounds];
      //  postIMGVIEW.image=[UIImage imageNamed:@"post_3.jpeg"];
        postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        [containerView addSubview:postIMGVIEW];
    
        postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        postIMGVIEW.clipsToBounds=YES;
    
    
    containerView.clipsToBounds=YES;
    NSLog(@"%@",NSStringFromCGRect(containerView.frame));
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    CGRect collectionViewFrame = self.bounds;
    galleryView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    galleryView.delegate = self;
    galleryView.dataSource = self;
    galleryView.pagingEnabled = YES;
    galleryView.showsHorizontalScrollIndicator = NO;
    
    [galleryView registerClass:[PostFullCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [containerView addSubview:galleryView];
    
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [containerView addSubview:backBtn];
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    backBtn.hidden=true;

    [self feedReloadViaAutoPlay];
    [self zoomDownGestureDetected];
    [self setUpCellRectResizerAnimate];
    
}

#pragma mark - Player State
-(void)DetailViewScreenGoesBack
{
    NSLog(@"Home screen back");
    [[HMPlayerManager sharedInstance] MX_setLastPlayerPaused:YES];
    
}
-(void)DetailViewScreenComesToFront
{
    NSLog(@"Home screen front");
    [[HMPlayerManager sharedInstance] MX_setLastPlayerPaused:FALSE];
    
}
-(void)zoomDownGestureDetected
{
    galleryView.hidden=true;

    postIMGVIEW.hidden=false;
    
    [[HMPlayerManager sharedInstance] MX_setLastPlayerFullMode:FALSE];

    int p=0;

}
-(void)zoomDownGestureEnded
{
    galleryView.hidden=false;
    postIMGVIEW.hidden=true;
    
}
-(void)zoomDownOut
{
    [[HMPlayerManager sharedInstance] MX_KillLastPlayerRow];
    
    
  //  [galleryView setDelegate:nil];
   // [galleryView setDataSource:nil];
    [galleryView removeFromSuperview];
    galleryView=nil;
    [delegate performSelector:downCallBackFunc withObject:globalPath afterDelay:0.0001];

 
    

}
-(void)viewWillBecomeFullScreen
{
    int p=0;
    [[HMPlayerManager sharedInstance] MX_setLastPlayerFullMode:TRUE];

}
#pragma mark - Reload
-(void)feedReloadViaAutoPlay
{

    [galleryView performBatchUpdates:^{
                                        }
    
                          completion:^(BOOL finished) {
                           
                           if(finished==true)
                           {
                               [self performSelector:@selector(openCommentBoxIfRequired) withObject:nil afterDelay:0.5];
                           }
                       }];
}
-(void)openCommentBoxIfRequired
{
    
    [self stoppedScrolling];
    
    if(shouldOpenCommentDirectly==true)
    {
        shouldOpenCommentDirectly=false;
        
        APIObjects_FeedObj *obj=[dataRecords objectAtIndex:0];
        
        [self commentBtnClicked:[NSString stringWithFormat:@"%@",obj.postId]];
        
    }
}


#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    

    [cell setDataObj:[dataRecords objectAtIndex:indexPath.row]];
    [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];

    [cell setCallBackForCommentWrite:@selector(commentWriteBtnClicked:)];
    cell.commentWriteBtn.hidden=false;
    cell.shouldHideCommentWriteBtn=false;
    
    [cell setPlayerScreenIdeantifier:screenIdentifier];
   
    if(isUserCanDeletePost==true)
    {
        cell.deleteBtn.hidden=false;
        cell.deleteBtn.userInteractionEnabled=true;
        [cell onDeleteEvent:@selector(deleteAPost:)];
    }
    else
    {
        cell.deleteBtn.userInteractionEnabled=false;
         cell.deleteBtn.hidden=true;
    }

    CGFloat xOffset = ((galleryView.contentOffset.x - cell.frame.origin.x) / self.bounds.size.width) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(xOffset, 0);


    
    APIObjects_FeedObj *FeedObj=[dataRecords objectAtIndex:indexPath.row];
    NSDictionary *dict1=@{
                          @"post_id":[NSNumber numberWithInt:[FeedObj.postId intValue]],
                          @"user_id":[NSNumber numberWithInt:[[UserSession getUserId] intValue]],
                          @"poster":[NSNumber numberWithInt:[FeedObj.user_id intValue]],
                          @"page_no":[NSNumber numberWithInt:((int)(indexPath.row)/30)+1],
                          @"no_in_sequence":[NSNumber numberWithInt:(int)indexPath.row+1],
                          @"is_expanded":[NSNumber numberWithBool:true],
                          @"datetime":[[PostTrackSeenHelper sharedInstance] getCurrentTime],
                          };
    [[PostTrackSeenHelper sharedInstance] PS_NewPost:dict1];

    
//    cell.player.screenIdentifier=screenIdentifier;

    return cell;
    
}
-(void)deleteAPost:(APIObjects_FeedObj *)obj
{
    
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForDeletePost:obj.postId delegate:self andSelector:@selector(postDeletedCallBack:)];
    
    
    [FTIndicator showToastMessage:@"Deleting.."];
    
    
}
-(void)postDeletedCallBack:(NSArray *)responseArray
{
    
    
    APIResponseObj *responseObj=[responseArray objectAtIndex:0];
    NSString *postId=[responseArray objectAtIndex:1];
    
    if(responseObj.statusCode==200)
    {
        
        [delegate performSelector:onDeletePost withObject:postId afterDelay:0.001];
        [self backBtnClicked:nil];
        
        [FTIndicator showToastMessage:@"Deleted"];
        
    }
    else
    {
        [FTIndicator showToastMessage:@"Something went wrong"];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return dataRecords.count;
   
}

-(void)addNewDataViaReload
{
   // [galleryView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

-(void)setUpNewScrolledRect:(CGRect)rect
{
    cellRect=rect;
}


#pragma mark - Scroll Manage
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    for(PostFullCell *view in galleryView.visibleCells) {
        CGFloat xOffset = ((galleryView.contentOffset.x - view.frame.origin.x) / self.bounds.size.width) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(xOffset, 0);
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = galleryView.frame.size.width;
    float currentPage = galleryView.contentOffset.x / pageWidth;
    
    int pageNumber;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
       pageNumber = currentPage + 1;
    }
    else
    {
       pageNumber= currentPage;
    }
    
    NSLog(@"Page Number : %d", pageNumber);
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:pageNumber inSection:0];
    APIObjects_FeedObj *obj=[dataRecords objectAtIndex:indexPath.row];

    [postIMGVIEW clearImageAll];
    
    
    int mediaType=[obj.mediaType intValue];

    if(mediaType!=0)
    {
        NSString *imgURL=obj.image_url;
        [postIMGVIEW setUp:imgURL];
        postIMGVIEW.backgroundColor=[UIColor whiteColor];
    }
    else
    {
       // int colorNumber1=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"color"] intValue];
        
        int colorNumber1=[obj.colorNumber intValue];
        [postIMGVIEW clearImageAll];
        postIMGVIEW.backgroundColor=[Constant colorGlobal:colorNumber1];
        
    }

    
    globalPath=indexPath;

    [delegate performSelector:pageChangeCallBackFunc withObject:indexPath afterDelay:0.01];
    
   
    [self stoppedScrolling];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==false)
    {
        [self stoppedScrolling];
    }
    
}

-(void)stoppedScrolling
{
    
        NSLog(@"cell Changed");
    CGRect visibleRect = (CGRect){.origin = galleryView.contentOffset, .size = galleryView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [galleryView indexPathForItemAtPoint:visiblePoint];
    
    NSLog(@"Visible center - %d\n",(int)visibleIndexPath.row);
    
    NSArray *array=[galleryView visibleCells];
    
    for(UICollectionViewCell *cell in [galleryView visibleCells])
    {
        
        NSIndexPath *indexPath = [galleryView indexPathForCell:cell];
        NSLog(@"visibleCells %d",(int)indexPath.row);
        
        if(indexPath==visibleIndexPath)
        {
            NSArray *array=[NSArray arrayWithArray:dataRecords];
            APIObjects_FeedObj *obj=[array objectAtIndex:indexPath.row];
            NSString *url=obj.video_url;
            
            if(![[HMPlayerManager sharedInstance] MX_ifLastURLisAlready:obj.video_url])
            {
                
                PostFullCell *cell=(PostFullCell *)[galleryView cellForItemAtIndexPath:visibleIndexPath];
                [cell playVideoIfAvaialble];
                
                [[HMPlayerManager sharedInstance] MX_setURL:url forIdentifier:screenIdentifier];
            }
           
            
        }
    }
    

    
}

#pragma mark - SET GET
-(void)setImage:(NSString *)string andNumber:(NSIndexPath *)indexPath
{
    if([string isEqualToString:@"red"])
    {
        
        postIMGVIEW.backgroundColor=[Constant colorGlobal:colorNumber];
        [postIMGVIEW clearImageAll];
        
    }
    else
    {
        postIMGVIEW.backgroundColor=[UIColor whiteColor];
        [postIMGVIEW clearImageAll];
        
        [postIMGVIEW setUp:string];
        
    }
    
    globalPath=indexPath;
    [galleryView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    
    
}
-(void)setIfItsForExplore:(BOOL)flag
{
    ifItsForExplore=flag;
}
-(void)showBackBtn
{
    backBtn.hidden=false;
    [self setGestureEnabled:false];
}
-(void)backBtnClicked:(id)sender
{
    backBtn.hidden=true;
    [self closeThisView];
    
}
-(void)setColorNumber:(int)number
{
    colorNumber=number;
    
}
-(void)setIfUserCanDeletePost:(BOOL)flag withDeleteCallBack:(SEL)callBack;
{
    isUserCanDeletePost=flag;
    onDeletePost=callBack;
}
-(void)openCommentDirectly:(BOOL)flag;
{
    shouldOpenCommentDirectly=flag;
}
-(void)setDataRecords:(NSMutableArray *)array;
{
    dataRecords=array;
}
-(void)setDelegate:(id)target andPageChangeCallBackFunc:(SEL)function1 andDownCallBackFunc:(SEL)function2;
{
    delegate=target;
    pageChangeCallBackFunc=function1;
    downCallBackFunc=function2;
    
}

#pragma mark - Actions
-(void)shareBtnClicked:(NSString *)senderId
{
    if(sharecompo==nil)
    {
        [self DetailViewScreenGoesBack];
        
        sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
        [sharecompo setUp];
                [sharecompo setPostId:senderId];
        [sharecompo setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        [sharecompo setIfItsForExplore:ifItsForExplore];
        [self addSubview:sharecompo];
    }
    
}
-(void)commentWriteBtnClicked:(NSString *)senderId
{
    if(commentDisplay==nil)
    {
        
        [self DetailViewScreenGoesBack];
        
        commentDisplay=[[FullCommentDisplay alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [commentDisplay setUpWithPostId:[NSString stringWithFormat:@"%@",senderId]];
        [self addSubview:commentDisplay];
        [commentDisplay setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            
            commentDisplay.frame=self.bounds;
            
        } completion:^(BOOL finished) {
            
            [commentDisplay setUpToWriteComment];
            
            
        }];
    }
    
}
-(void)commentBtnClicked:(NSString *)senderId
{
    if(commentDisplay==nil)
    {
        [self DetailViewScreenGoesBack];
        
        
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
    [self updateTheCommentCountsForVisibleRows];

    [self DetailViewScreenComesToFront];
    
    commentDisplay=nil;
    sharecompo=nil;
}
-(void)updateTheCommentCountsForVisibleRows
{
    NSArray *arrayVisible=[galleryView visibleCells];
    
    for(int i=0;i<arrayVisible.count;i++)
    {
        PostFullCell *cell=(PostFullCell *)[arrayVisible objectAtIndex:i];
        [cell UpdateCommentCountIfRequired];
    }
    
}



@end
