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
#import "DataSession.h"
#import "HMPlayerManager.h"


@implementation DetailViewComponent

-(void)setDataRecords:(NSMutableArray *)array;
{
  //  [galleryView reloadData];
}
-(void)setDelegate:(id)target andPageChangeCallBackFunc:(SEL)function1 andDownCallBackFunc:(SEL)function2;
{
    delegate=target;
    pageChangeCallBackFunc=function1;
    downCallBackFunc=function2;
    
}
-(void)setUpWithCellRect:(CGRect)rect
{
    [AnalyticsMXManager PushAnalyticsEvent:@"Explore Screen Expand"];

    screenIdentifier=@"EXPLORE";

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
    


    [self feedReloadViaAutoPlay];


    [self zoomDownGestureDetected];
    [self setUpCellRectResizerAnimate];

    
}
-(void)setColorNumber:(int)number
{
    colorNumber=number;
    
}
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
-(void)DetailViewScreenGoesBack
{
    NSLog(@"Home screen back");
    [HMPlayerManager sharedInstance].Explore_isPaused=true;
    
}
-(void)DetailViewScreenComesToFront
{
    NSLog(@"Home screen front");
    [HMPlayerManager sharedInstance].Explore_isPaused=false;
    
}


-(void)zoomDownGestureDetected
{
    galleryView.hidden=true;

    postIMGVIEW.hidden=false;
    
}
-(void)zoomDownGestureEnded
{
    galleryView.hidden=false;
    postIMGVIEW.hidden=true;
    

    [self performSelector:@selector(feedReloadViaAutoPlay) withObject:nil afterDelay:0.5];

}
-(void)zoomDownOut
{
    

    
    [galleryView setDelegate:nil];
    [galleryView setDataSource:nil];
    [galleryView removeFromSuperview];
    [delegate performSelector:downCallBackFunc withObject:globalPath afterDelay:0.0001];

 
    

}
-(void)feedReloadViaAutoPlay
{
    [HMPlayerManager sharedInstance].Explore_urlIdentifier=@"";
    [galleryView reloadData];
    [galleryView performBatchUpdates:^{}
                       completion:^(BOOL finished) {
                           
                           if(finished==true)
                           {
                           [self stoppedScrolling];
                           }
                           /// collection-view finished reload
                       }];
    
    
}


#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    

    [cell setDataObj:[[DataSession sharedInstance].exploreFeedResults objectAtIndex:indexPath.row]];
    [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];

    [cell setCallBackForCommentWrite:@selector(commentWriteBtnClicked:)];
    cell.commentWriteBtn.hidden=false;
    
    [cell setPlayerScreenIdeantifier:screenIdentifier];
//    cell.player.screenIdentifier=screenIdentifier;

    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return [DataSession sharedInstance].exploreFeedResults.count;
   
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
    APIObjects_FeedObj *obj=[[DataSession sharedInstance].exploreFeedResults objectAtIndex:indexPath.row];

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
            NSArray *array=[DataSession sharedInstance].exploreFeedResults;
            APIObjects_FeedObj *obj=[array objectAtIndex:indexPath.row];
            NSString *url=obj.video_url;
            
            
            if(![obj.video_url isEqualToString:[HMPlayerManager sharedInstance].Explore_urlIdentifier])
            {
                
                PostFullCell *cell=(PostFullCell *)[galleryView cellForItemAtIndexPath:visibleIndexPath];
                [cell playVideoIfAvaialble];
                
                [HMPlayerManager sharedInstance].Explore_screenIdentifier=screenIdentifier;
                [HMPlayerManager sharedInstance].Explore_urlIdentifier=url;
                
            }
            
            
        }
    }
    

    
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
