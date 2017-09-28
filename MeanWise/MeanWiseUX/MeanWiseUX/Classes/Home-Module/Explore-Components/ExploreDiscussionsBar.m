//
//  ExploreDiscussionsBar.m
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExploreDiscussionsBar.h"
#import "DiscussionCell.h"
#import "APIManager.h"
#import "APIObjectsParser.h"
#import "APIObjects_DiscussionObj.h"

@implementation ExploreDiscussionsBar
-(void)setTarget:(id)targetReceived onTapEvent:(SEL)tap andWhenSizeChange:(SEL)func;
{
    target=targetReceived;
    onTapButtonClick=tap;
    onSizeChangeEvent=func;
}
-(void)setUp
{
    typeOfSearch=1;

    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 0;
    layout2.minimumLineSpacing = 5;
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout2.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGRect collectionViewFrame = CGRectMake(18, 0, self.frame.size.width-36, self.frame.size.height);
    commentsView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    commentsView.delegate = self;
    commentsView.dataSource = self;
    commentsView.showsHorizontalScrollIndicator = NO;
    [commentsView registerClass:[DiscussionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:commentsView];
    commentsView.backgroundColor=[UIColor clearColor];
    
    dataArray=[[NSMutableArray alloc] init];

    
    //710+20+240
    viewMoreBtn=[[UIButton alloc] initWithFrame:CGRectMake(18,0, self.frame.size.width-36, 32)];
    [viewMoreBtn setTitle:@"More Conversations" forState:UIControlStateNormal];
    [viewMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    viewMoreBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:11];
    viewMoreBtn.layer.cornerRadius=2.5;
    viewMoreBtn.clipsToBounds=YES;
    viewMoreBtn.layer.borderWidth=1;
    viewMoreBtn.layer.borderColor=[UIColor colorWithWhite:1 alpha:0.25f].CGColor;
    [self addSubview:viewMoreBtn];
    viewMoreBtn.showsTouchWhenHighlighted=YES;
    [viewMoreBtn addTarget:self action:@selector(viewMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    emptyView=[[EmptyView alloc] initWithFrame:commentsView.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForBlack];
    [emptyView setDelegate:self onReload:@selector(refreshAction:)];
    emptyView.msgLBL.text=@"No Conversations";
    emptyView.msgLBL.font=[UIFont fontWithName:emptyView.msgLBL.font.fontName size:10];
    emptyView.reloadBtn.hidden=true;

}
-(void)viewMoreBtnClicked:(id)sender
{
    [target performSelector:onTapButtonClick withObject:@(-1) afterDelay:0.01];

}
-(void)setSearchType:(int)searchType;
{
    typeOfSearch=searchType;
}
-(int)getTypeOfSearch
{
    return typeOfSearch;
}
-(NSDictionary *)getSearchDict
{
    return searchDict;
}


-(void)refreshAction:(NSDictionary *)dict;
{
    searchDict=dict;
    
    dataArray=[[NSMutableArray alloc] init];
    [self reloadData];
    
    if(typeOfSearch==-1 || typeOfSearch==1)
    {
        
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForGetDiscussions:dict delegate:self andSelector:@selector(discussionDataReceived:)];
    }
    else
    {
        
    }
    
}
-(void)discussionDataReceived:(APIResponseObj *)responseObj
{
    [commentsView setContentOffset:CGPointMake(0, 0) animated:false];

    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        
        NSArray *arrayTemp=(NSArray *)responseObj.response;
        
        
        
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        dataArray=[NSMutableArray arrayWithArray:[parser parseObjects_DISCUSSIONS:arrayTemp]];
        [commentsView reloadData];
        
        
        [self reloadData];
        
        
   
    }
    
}
-(void)reloadData
{
    [commentsView reloadData];

    [commentsView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        
        if(dataArray.count!=0)
        {
            emptyView.hidden=true;
            viewMoreBtn.hidden=false;
            
            CGSize size=commentsView.contentSize;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height+32+10);
            CGRect collectionViewFrame = CGRectMake(18, 0, self.frame.size.width-36, size.height);
            commentsView.frame=collectionViewFrame;
            viewMoreBtn.frame=CGRectMake(18,size.height+10, self.frame.size.width-36, 32);
        }
        else
        {
            viewMoreBtn.hidden=true;
            emptyView.hidden=false;
            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 120);
            emptyView.frame=CGRectMake(18,20, self.frame.size.width-36, 100);
            
        }
        
        [target performSelector:onSizeChangeEvent withObject:nil afterDelay:0.01];
    }];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    DiscussionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
        APIObjects_DiscussionObj *obj=[dataArray objectAtIndex:indexPath.row];

    cell.shortNameLBL.text=[NSString stringWithFormat:@"%@ %@.",obj.userprofile_first_name,obj.userprofile_last_name];
    
    cell.postTextLBL.text=obj.text;
    [cell.profPicImgView setUp:obj.userprofile_profile_photo_thumbnail_url];
    [cell.postImgView setUp:obj.post_image_url];
    
    cell.timeLBL.text=obj.datetime;
    
//    @property (nonatomic, strong) UILabel *shortNameLBL;
//    @property (nonatomic, strong) UILabel *timeLBL;
//    @property (nonatomic, strong) UILabel *postTextLBL;
//    
//    @property (nonatomic, strong) UIImageHM *profPicImgView;
//    @property (nonatomic, strong) UIImageHM *postImgView;
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(dataArray.count<3)
    {
    return dataArray.count;
    }
    else
    {
        return 3;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width-36, 148/2);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    APIObjects_DiscussionObj *obj=[dataArray objectAtIndex:indexPath.row];

    [target performSelector:onTapButtonClick withObject:obj.post_id afterDelay:0.01];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
