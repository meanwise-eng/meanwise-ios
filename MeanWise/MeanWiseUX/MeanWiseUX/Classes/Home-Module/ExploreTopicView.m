//
//  ExploreTopicView.m
//  ExactResearch
//
//  Created by Hardik on 20/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreTopicView.h"
#import "TopicListCell.h"

@implementation ExploreTopicView

-(void)setUp:(int)height 
{
    
    arrayTopics=[NSArray arrayWithObjects:@"@travelList",@"@travelIdea",@"@sportsIdeasportsIdea",@"@sportsList",@"@travelIdea",@"@sportsIdeasportsIdea",@"@sportsList",@"@travelList",@"@travelIdea",@"@sportsIdeasportsIdea",@"@sportsList",@"@travelIdea",@"@sportsIdeasportsIdea",@"@sportsList",@"@travelList",@"@travelIdea",@"@sportsIdeasportsIdea",@"@sportsList",@"@travelIdea",@"@sportsIdeasportsIdea",@"@sportsList", nil];
    
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

}
-(void)setChannelId:(int)channelId
{
    selectedChannel=channelId;
    [topicListView reloadData];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicListCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.nameLBL.text=[arrayTopics objectAtIndex:indexPath.row];
    cell.bgView.backgroundColor=[Constant colorGlobal:(selectedChannel%13)];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayTopics.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictAttributes=@{NSFontAttributeName:[UIFont fontWithName:k_fontSemiBold size:16]};
    
    
    NSString *dict = [arrayTopics objectAtIndex:indexPath.row];


    CGSize calCulateSizze =[dict sizeWithAttributes:dictAttributes];

    return CGSizeMake(calCulateSizze.width+20, self.frame.size.height);
}


@end
