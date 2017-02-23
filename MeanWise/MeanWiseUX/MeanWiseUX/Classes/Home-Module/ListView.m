//
//  ListView.m
//  MeanWiseUX
//
//  Created by Hardik on 31/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ListView.h"
#import "ListCell.h"

@implementation ListView

-(void)setUp
{
    self.opaque=YES;
    videoURLarray=[NSArray arrayWithObjects:
                   @"https://vt.media.tumblr.com/tumblr_oj0m71nxZF1r57o71_480.mp4",
                   @"https://vt.media.tumblr.com/tumblr_oj15owqcRo1s5s7gr.mp4",
                   @"https://vt.media.tumblr.com/tumblr_oj05x8kZBG1ukym19_480.mp4",
                   @"https://vt.media.tumblr.com/tumblr_oiz8jhunbt1r5tm64_480.mp4",
                   @"https://scontent-sin6-1.cdninstagram.com/t50.2886-16/15786218_918767174919977_1730613082868154368_n.mp4",
                   @"https://scontent-sit4-1.cdninstagram.com/t50.2886-16/15819652_703033149871975_9059795892399243264_n.mp4",
                   @"https://scontent-sit4-1.cdninstagram.com/t50.2886-16/15819903_626409450880225_121169926592397312_n.mp4",
                   @"https://scontent-sit4-1.cdninstagram.com/t50.2886-16/15786197_1842546685960185_8973017117565648896_n.mp4",
                   
                   
                   nil];
    self.backgroundColor=[UIColor blackColor];
    
    
    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 0;
    layout1.minimumLineSpacing = 0;
    layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    listView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout1];
    listView.delegate = self;
    listView.dataSource = self;
    listView.showsHorizontalScrollIndicator = NO;
    listView.backgroundColor=[UIColor clearColor];
    [listView registerClass:[ListCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:listView];
   // listView.pagingEnabled=true;

    listView.opaque=YES;
    
    refreshControl=[[UIRefreshControl alloc] init];
    [listView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor=[UIColor blueColor];
    

}
-(AppDelegate *)getAppDelegate
{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}
-(NSOperationQueue *)getVideoQueue
{
    return [self getAppDelegate].MeanWise_VideoQueue;
}
-(void)refreshAction
{
    NSLog(@"Hello");
    NSLog(@"%@",NSStringFromCGRect(refreshControl.frame));
    [refreshControl endRefreshing];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return videoURLarray.count;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(ListCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self highPriority];

    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==false)
    {
        [self highPriority];
    }
}
-(void)highPriority
{
   
    NSArray *visibleRows=[listView visibleCells];
    
    NSMutableArray *arrayVisibleURL=[[NSMutableArray alloc] init];
    for(int i=0;i<visibleRows.count;i++)
    {
        [arrayVisibleURL addObject:[(ListCell *)[visibleRows objectAtIndex:i] getURLPath]];
    }

    NSArray *requestedOperation=[self getVideoQueue].operations;

    for(int i=0;i<requestedOperation.count;i++)
    {
        NSOperation *op=[requestedOperation objectAtIndex:i];

        if([arrayVisibleURL containsObject:op.name])
        {
            op.qualityOfService=NSQualityOfServiceUserInitiated;
            op.queuePriority=NSOperationQueuePriorityVeryHigh;

        }
        else
        {
            op.qualityOfService=NSQualityOfServiceBackground;
            op.queuePriority=NSOperationQueuePriorityVeryLow;

            
        }

    }
    
    /*NSArray *visibleRows=[listView visibleCells];
    NSMutableArray *arrayVisibleURL=[[NSMutableArray alloc] init];
    for(int i=0;i<visibleRows.count;i++)
    {
        [arrayVisibleURL addObject:[(ListCell *)[visibleRows objectAtIndex:i] getURLPath]];
    }

    
    
    NSArray *requestedOperation=[self getVideoQueue].operations;

    NSMutableArray *hiddenButRequestedOperations=[[NSMutableArray alloc] init];
    NSMutableArray *visibleRequestedOperations=[[NSMutableArray alloc] init];
    
    
    for(int i=0;i<requestedOperation.count;i++)
    {
        
        NSOperation *op=[requestedOperation objectAtIndex:i];
        
        if([arrayVisibleURL containsObject:op.name])
        {
            [visibleRequestedOperations addObject:op];

        }
        else
        {
            [hiddenButRequestedOperations addObject:op];

        }
        
      
    }
    
    NSLog(@"%ld",visibleRequestedOperations.count);
    NSLog(@"%ld",hiddenButRequestedOperations.count);
    
    
    for(int i=0;i<[visibleRequestedOperations count];i++)
    {
        
        NSOperation *op=[visibleRequestedOperations objectAtIndex:i];
        op.qualityOfService=NSQualityOfServiceUserInitiated;
        op.queuePriority=NSOperationQueuePriorityVeryHigh;
        
        for(int j=0;j<hiddenButRequestedOperations.count;j++)
        {
            NSOperation *pq=[hiddenButRequestedOperations objectAtIndex:j];
            pq.qualityOfService=NSQualityOfServiceUtility;
            pq.queuePriority=NSOperationQueuePriorityVeryLow;

        }


        
    }
    

    */
    
    

}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(ListCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

  
//    [cell cleanUp];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(listView.frame.size.width, listView.frame.size.height*0.7);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    

    [cell setURL:[videoURLarray objectAtIndex:indexPath.row]];

    
    
    return cell;
    
}

@end
