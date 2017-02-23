//
//  ExploreSearchComponent.m
//  ExactResearch
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreSearchComponent.h"
#import "ExploreSearchItemCell.h"

@implementation ExploreSearchComponent


-(void)setUp
{
    segmentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:segmentView];
    segmentView.backgroundColor=[UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = segmentView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [segmentView addSubview:blurEffectView];
    

//    UIButton *segmentPostsBtn;
 //   UIButton *segmentTopicsBtn;
  //  UIButton *segmentHashtagsBtn;
    
    segmentPostsBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, 40)];
    [self addSubview:segmentPostsBtn];
    [segmentPostsBtn setTitle:@"POSTS" forState:UIControlStateNormal];
    segmentPostsBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:11];
    
    segmentTopicsBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, 40)];
    [self addSubview:segmentTopicsBtn];
    [segmentTopicsBtn setTitle:@"TOPICS" forState:UIControlStateNormal];
    [segmentTopicsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    segmentTopicsBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:11];
    
    segmentHashtagsBtn=[[UIButton alloc] initWithFrame:CGRectMake(2*self.frame.size.width/3, 0, self.frame.size.width/3, 40)];
    [self addSubview:segmentHashtagsBtn];
    [segmentHashtagsBtn setTitle:@"HASHTAGS" forState:UIControlStateNormal];
    [segmentHashtagsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
    segmentHashtagsBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:11];
    
    segmentPostsBtn.tag=0;
    segmentTopicsBtn.tag=1;
    segmentHashtagsBtn.tag=2;
    
    [segmentPostsBtn addTarget:self action:@selector(setSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    [segmentTopicsBtn addTarget:self action:@selector(setSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    [segmentHashtagsBtn addTarget:self action:@selector(setSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self setSegmentIndex:segmentPostsBtn];
    
    
    tableViewBgView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
    [self addSubview:tableViewBgView];
    

    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = tableViewBgView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [tableViewBgView addSubview:blurEffectView];
        
    }
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    
    CGRect collectionViewFrame = tableViewBgView.frame;
    listofItems = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    listofItems.delegate = self;
    listofItems.dataSource = self;
    //  listofItems.pagingEnabled = YES;
    listofItems.showsHorizontalScrollIndicator = NO;
    listofItems.backgroundColor=[UIColor clearColor];
    [listofItems registerClass:[ExploreSearchItemCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:listofItems];


}
-(void)setSegmentIndex:(UIButton *)button
{
    selectedSegmentIndex=(int)button.tag;
    
    [segmentPostsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    [segmentTopicsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    [segmentHashtagsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];

    [listofItems reloadData];
    [listofItems scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExploreSearchItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setType:selectedSegmentIndex];
    
    if(selectedSegmentIndex==1)
    {
    cell.hashtagOrTopic.text=@"@topics";
        cell.bgView.backgroundColor=[Constant colorGlobal:(indexPath.row%10)];

    }
    else if(selectedSegmentIndex==2)
    {
    cell.hashtagOrTopic.text=@"#hashtags";
        cell.bgView.backgroundColor=[Constant colorGlobal:(indexPath.row%10)];

    }
    else
    {
        cell.hashtagOrTopic.text=@"";
        cell.bgView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];

    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedSegmentIndex!=0)
    {
    return CGSizeMake(self.frame.size.width,50);
    }
    else
    {
        return CGSizeMake(self.frame.size.width, 110);
    }
}


@end
