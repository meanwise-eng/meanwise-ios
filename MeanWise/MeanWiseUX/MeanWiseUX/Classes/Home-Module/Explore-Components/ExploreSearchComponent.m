//
//  ExploreSearchComponent.m
//  ExactResearch
//
//  Created by Hardik on 23/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreSearchComponent.h"
#import "ExploreSearchItemCell.h"
#import "APIManager.h"

@implementation ExploreSearchComponent

-(void)setTarget:(id)targetReceived OnSearchItemSelectedFunc:(SEL)func
{
    target=targetReceived;
    onSearchItemSelectedFunc=func;
}
-(void)setSearchTerm:(NSString *)string
{
    searchTerm=string;
    [self callAutoCompleteAPI];
}
-(void)callAutoCompleteAPI
{
    

    CGRect frame=CGRectMake(0, 0, 40, 40);
    
    
    APIManager *manager=[[APIManager alloc] init];
    
    NSString *keyValue=@"";
    if(selectedSegmentIndex==0)
    {
       /* CGRect tempRect=segmentPostsBtn.frame;
        
        frame=CGRectMake(tempRect.origin.x+tempRect.size.width-40, 10, 20, 20);
        
        keyValue=@"post";*/
    }
    else if(selectedSegmentIndex==1)
    {
        CGRect tempRect=segmentTopicsBtn.frame;
        frame=CGRectMake(tempRect.origin.x+tempRect.size.width-40, 10, 20, 20);
        
        keyValue=@"topic";
    }
    else
    {
        CGRect tempRect=segmentHashtagsBtn.frame;
        frame=CGRectMake(tempRect.origin.x+tempRect.size.width-40, 10, 20, 20);

        keyValue=@"tag";
    }
    
    if(![searchTerm isEqualToString:@""])
    {

        activityView.frame=frame;
                [self showLoader];
        
        suggestionArray=[NSArray array];
        [listofItems reloadData];
        [listofItems scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];

        
        NSDictionary *dict=@{keyValue:searchTerm};
        [manager sendRequestExploreAutoCompleteAPI:dict Withdelegate:self andSelector:@selector(AutoCompleteAPIReceived:)];
    }
    else
    {
        suggestionArray=[NSArray array];
        [listofItems reloadData];
        [listofItems scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];

    }
  
}
-(void)showLoader
{
    [activityView startAnimating];

}
-(void)hideLoader
{
    [activityView stopAnimating];

}
-(void)AutoCompleteAPIReceived:(APIResponseObj *)obj
{
    
    [self hideLoader];
    
    if([obj.response isKindOfClass:[NSArray class]])
    {
    suggestionArray=(NSArray *)obj.response;
    [listofItems reloadData];
    [listofItems scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];
    }

    
}

-(void)setUp
{
    searchTerm=@"";
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
    
//    segmentPostsBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, 40)];
//    [self addSubview:segmentPostsBtn];
//    [segmentPostsBtn setTitle:@"POSTS" forState:UIControlStateNormal];
//    segmentPostsBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:11];
//    
    segmentTopicsBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 40)];
    [self addSubview:segmentTopicsBtn];
    [segmentTopicsBtn setTitle:@"TOPICS" forState:UIControlStateNormal];
    [segmentTopicsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    segmentTopicsBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:11];
    
    segmentHashtagsBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 40)];
    [self addSubview:segmentHashtagsBtn];
    [segmentHashtagsBtn setTitle:@"TAGS" forState:UIControlStateNormal];
    [segmentHashtagsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
    segmentHashtagsBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:11];
    
    //segmentPostsBtn.tag=0;
    segmentTopicsBtn.tag=1;
    segmentHashtagsBtn.tag=2;
    
//    [segmentPostsBtn addTarget:self action:@selector(setSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    [segmentTopicsBtn addTarget:self action:@selector(setSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    [segmentHashtagsBtn addTarget:self action:@selector(setSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    loaderView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [self addSubview:loaderView];
//    loaderView.hidden=true;
//    loaderView.backgroundColor=[UIColor blackColor];
//    [loaderView setImage:[UIImage imageNamed:@"video-loader.png"]];
//    [loaderView setContentMode:UIViewContentModeScaleAspectFit];
//    loaderView.layer.cornerRadius=20;
    
    
    activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:activityView];

    
    [self setSegmentIndex:segmentTopicsBtn];
    
 //   segmentPostsBtn.hidden=true;
    
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
    
  //  [segmentPostsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    [segmentTopicsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    [segmentHashtagsBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];

    [self callAutoCompleteAPI];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExploreSearchItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setType:selectedSegmentIndex];
    
    NSString *title=[suggestionArray objectAtIndex:indexPath.row];

    if(selectedSegmentIndex==1)
    {
        cell.hashtagOrTopic.text=[NSString stringWithFormat:@"@%@",title];
        cell.bgView.backgroundColor=[Constant colorGlobal:(indexPath.row%10)];

    }
    else if(selectedSegmentIndex==2)
    {
        
        cell.hashtagOrTopic.text=[NSString stringWithFormat:@"#%@",title];
        cell.bgView.backgroundColor=[Constant colorGlobal:(indexPath.row%10)];

    }
    else
    {
        cell.hashtagOrTopic.text=@"";
        cell.bgView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];

    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExploreSearchItemCell *cell=(ExploreSearchItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [target performSelector:onSearchItemSelectedFunc withObject:cell.hashtagOrTopic.text afterDelay:0.01];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return suggestionArray.count;
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
