//
//  ExploreTopicView.m
//  ExactResearch
//
//  Created by Hardik on 20/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreTopicView.h"
#import "TopicListCell.h"
#import "APIManager.h"

@implementation ExploreTopicView

-(void)setTarget:(id)targetReceived OnTopicSelectCallBack:(SEL)func
{
    target=targetReceived;
    onTopicSelectCallBack=func;
    
}
-(void)setSearchTerm:(NSString *)string;
{
    searchTerm=string;
    [topicListView reloadData];
}
-(void)setUp:(int)height 
{
    searchTerm=@"";
    
    //arrayTopics=[NSArray arrayWithObjects:@"List",@"Idea",@"Fun",@"Work",@"Game",@"Workout",@"Play", nil];
    arrayTopics=[[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);

    CGRect collectionViewFrame = self.bounds;
    topicListView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    topicListView.delegate = self;
    topicListView.dataSource = self;
    //  topicListView.pagingEnabled = YES;
    topicListView.showsHorizontalScrollIndicator = NO;
    topicListView.backgroundColor=[UIColor clearColor];
    [topicListView registerClass:[TopicListCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:topicListView];
    

    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:activityView];
    activityView.frame=CGRectMake(20, 10, 20, 20);
    activityView.userInteractionEnabled=false;
    

}
-(void)setChannelId:(int)channelId
{
    selectedChannel=channelId;
    [topicListView reloadData];
 
    [self callTrendingTopicsForChannelId:selectedChannel];
    
}
-(void)callTrendingTopicsForChannelId:(int)channelNo
{
    
    NSArray *channelList=[[[APIPoster alloc] init] getInterestData];
    
    
    int channelId=[[[channelList objectAtIndex:channelNo] valueForKey:@"id"] intValue];

    
    arrayTopics=[NSMutableArray array];
    [topicListView reloadData];
    [topicListView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];


    [self showActivity];
    
    APIManager *manager=[[APIManager alloc] init];
    
    [manager sendRequestExploreTopTrendingTopicsForChannel:[NSString stringWithFormat:@"%d",channelId] Withdelegate:self andSelector:@selector(responseReceived:)];
    
    
}
-(void)responseReceived:(APIResponseObj *)obj
{
    [self hideActivity];
    
    if([obj.response isKindOfClass:[NSArray class]])
    {
        
        NSString *wild = @"*";
        
        arrayTopics=[NSMutableArray arrayWithArray:(NSArray *)obj.response];
        [arrayTopics insertObject:wild atIndex:0];

        
        
        [topicListView reloadData];
        [topicListView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];
    }
    
    NSLog(@"%@",obj.response);
}
-(void)showActivity
{
    activityView.hidden=false;
        [activityView startAnimating];
}
-(void)hideActivity
{
     activityView.hidden=false;
    [activityView stopAnimating];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicListCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSString *string;
    
    if([[arrayTopics objectAtIndex:indexPath.row] isEqualToString:@"*"])
    {
        string = @"*";
        cell.nameLBL.font = [UIFont fontWithName:k_fontRegular size:16];
    }
    else{
        string=[NSString stringWithFormat:@"@%@",[arrayTopics objectAtIndex:indexPath.row]];
        cell.nameLBL.font = [UIFont fontWithName:k_fontRegular size:16];

    }
    
    cell.nameLBL.text=string;
    
    cell.bgView.backgroundColor=[Constant colorGlobal:(selectedChannel%13)];
    cell.topicColor=[Constant colorGlobal:(selectedChannel%13)];
    
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayTopics.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictAttributes=@{NSFontAttributeName:[UIFont fontWithName:k_fontSemiBold size:16]};
    
    NSString *dict=[NSString stringWithFormat:@"@%@",[arrayTopics objectAtIndex:indexPath.row]];
    CGSize calCulateSizze =[dict sizeWithAttributes:dictAttributes];

    
    return CGSizeMake(calCulateSizze.width+20, self.frame.size.height);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [target performSelector:onTopicSelectCallBack withObject:[arrayTopics objectAtIndex:indexPath.row] afterDelay:0.01];
}

@end
