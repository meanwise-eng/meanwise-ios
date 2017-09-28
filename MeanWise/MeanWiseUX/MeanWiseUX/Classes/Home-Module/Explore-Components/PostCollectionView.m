//
//  PostCollectionView.m
//  MeanWiseUX
//
//  Created by Hardik on 04/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PostCollectionView.h"
#import "APIManager.h"
#import "APIObjectsParser.h"
#import "PostMiniCell.h"
#import "ViewController.h"
#import "DataSession.h"
#import "HMPlayerManager.h"



@implementation PostCollectionView

-(void)setUp
{
    cellSize=CGSizeMake(150/2, 268/2);

    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 20;
    layout2.minimumLineSpacing = 20;
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
    
    CGRect collectionViewFrame = CGRectMake(0, 210, self.frame.size.width, 270/2);
    feedList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    feedList.delegate = self;
    feedList.dataSource = self;
    feedList.showsHorizontalScrollIndicator = NO;
    feedList.backgroundColor=[UIColor grayColor];
    [feedList registerClass:[PostMiniCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:feedList];
    feedList.alwaysBounceHorizontal=YES;
    feedList.bounces=true;
    


    emptyView=[[EmptyView alloc] initWithFrame:feedList.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForBlack];
    [emptyView setDelegate:self onReload:@selector(refreshAction)];
    emptyView.msgLBL.text=@"Nothing to display";
    emptyView.reloadBtn.hidden=true;
    
    [self refreshAction];
}

#pragma mark - CollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    APIObjects_FeedObj *feedObj=[resultData objectAtIndex:indexPath.row];
    
    PostMiniCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSLog(@"%@",feedObj.image_url);
    
    cell.backgroundColor=[UIColor whiteColor];
    
    [cell setUpPostImageURL:feedObj.image_url andText:feedObj.text];

    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return resultData.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellSize;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //cell Rect, Array, indexpath, image,
    
    [[HMPlayerManager sharedInstance] StopKeepKillingExploreFeedVideosIfAvaialble];

    [self hideBottomBar];

    PostMiniCell *cell=(PostMiniCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=true;
    
    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];

    CGRect myRect = attributes.frame;
    
    
    
    
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    

    detailPostView=[[DetailViewComponent alloc] initWithFrame:self.bounds];
    [self addSubview:detailPostView];
    [detailPostView setDataRecords:resultData];
    
    [detailPostView setUpWithCellRect:rect];

    APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[resultData objectAtIndex:indexPath.row];
    
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
-(void)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    [self MakeAllCellVisible];
    
    [feedList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    // CGRect myRect = [feedList rectForRowAtIndexPath:indexPath];
    
    PostMiniCell *cell=(PostMiniCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=true;
    
    //    [cell setKeepPlaying:true];
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    
    
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    
    [detailPostView setUpNewScrolledRect:rect];
    
    
}
-(void)MakeAllCellVisible
{
    NSArray *array=[feedList visibleCells];
    for(int i=0;i<[array count];i++)
    {
        PostMiniCell *cell=[array objectAtIndex:i];
        cell.hidden=false;
        
    }
}
-(void)downClicked:(NSIndexPath *)indexPath
{
    [[HMPlayerManager sharedInstance] StartKeepKillingExploreFeedVideosIfAvaialble];

    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t setStatusBarHide:false];
    
    detailPostView=nil;
    [self updateTheCommentCountsForVisibleRows];
    
    [[HMPlayerManager sharedInstance] StartKeepKillingExploreFeedVideosIfAvaialble];
    
    [self showBottomBar];
    
    PostMiniCell *cell=(PostMiniCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=false;
    
}
-(void)updateTheCommentCountsForVisibleRows
{
   
}
-(void)showBottomBar
{
    
}
-(void)hideBottomBar
{
    
}
#pragma mark - API stuff

-(void)refreshAction
{
    NSDictionary *dict=@{@"type":[NSNumber numberWithInt:1],@"word":@"Music"};

    
    
    resultData=[[NSMutableArray alloc] init];
    [feedList reloadData];
    [feedList setContentOffset:CGPointMake(0, 0) animated:false];

    APIManager *manager=[[APIManager alloc] init];
    
    [manager sendRequestExploreFeedWithDict:dict Withdelegate:self andSelector:@selector(updateTheData:)];
    
    feedList.userInteractionEnabled=false;

    
}
-(void)updateTheData:(APIResponseObj *)responseObj
{
    feedList.userInteractionEnabled=true;
    
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
                
                
                
                APIObjectsParser *parser=[[APIObjectsParser alloc] init];
                NSMutableArray *responseArray=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:response]];
                
                
                [DataSession sharedInstance].exploreFeedResults=[[NSMutableArray alloc] initWithArray:responseArray];
                
                resultData=responseArray;
                
                
                
                [feedList reloadData];
                
                
                
                
              
                
                
            }
            
            
        });
    });
    
}

@end
