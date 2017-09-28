//
//  ExploreChannelsBar.m
//  MeanWiseUX
//
//  Created by Hardik on 05/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreChannelsBar.h"
#import "ChannelExploreCell.h"


@implementation ExploreChannelsBar

-(void)setTarget:(id)targetReceived onChannelSelectCall:(SEL)func;
{
    target=targetReceived;
    onChannelSelect=func;
    
}
-(void)setUp
{
    channelList=[[[APIPoster alloc] init] getInterestDataForExploreScreen];

    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 5;
    layout1.minimumLineSpacing = 5;
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout1.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
    
    CGRect collectionViewFrame = self.bounds;
    ChannelList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout1];
    ChannelList.delegate = self;
    ChannelList.dataSource = self;
    ChannelList.showsHorizontalScrollIndicator = NO;
    ChannelList.backgroundColor=[UIColor clearColor];
    [ChannelList registerClass:[ChannelExploreCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:ChannelList];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTopicChannels)
                                                 name:@"REFRESH_EXPLORE_INTERESTS"
                                               object:nil];
     */

}
#pragma mark - Refresh

-(void)dealloc

{
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    */
    
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
        
       
        APIPoster *poster=[[APIPoster alloc] init];
        [poster saveDataAs:array andKey:@"DATA_INTEREST"];
    }
    channelList=[[[APIPoster alloc] init] getInterestDataForExploreScreen];
    [ChannelList reloadData];
    
    
}

#pragma mark - CollectionView Delegates / Sources
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        
        
        ChannelExploreCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
        cell.nameLBL.text=[[channelList objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        
        if([cell.nameLBL.text isEqualToString:@""])
        {
            cell.nameLBL.text=@"Explore";
        }
        
    
        NSString *urlString=[[channelList objectAtIndex:indexPath.row] valueForKey:@"photo"];
        [cell setURLString:urlString];
        
    
        return cell;
   
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        
        
//        cell.transform=CGAffineTransformMakeScale(0.7, 0.7);
//        cell.alpha=1;
//        
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             
//                             cell.transform=CGAffineTransformMakeScale(1, 1);
//                             cell.alpha=1;
//                             
//                             
//                         }
//                         completion:^(BOOL finished) {
//                             
//                         }];
    
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
        return channelList.count;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        return CGSizeMake(200/2, 130/2);
   
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [target performSelector:onChannelSelect withObject:indexPath afterDelay:0.01];
         
    
}
@end
