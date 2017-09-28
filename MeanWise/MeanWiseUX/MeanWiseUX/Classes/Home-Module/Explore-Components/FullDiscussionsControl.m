//
//  FullDiscussionsControl.m
//  MeanWiseUX
//
//  Created by Hardik on 11/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "FullDiscussionsControl.h"
#import "DiscussionCell.h"
#import "APIManager.h"
#import "APIObjectsParser.h"
#import "FTIndicator.h"
#import "APIObjects_DiscussionObj.h"

@implementation FullDiscussionsControl

-(void)setTarget:(id)tReceived onClose:(SEL)func;
{
    target=tReceived;
    closeBtnClicked=func;
}
-(void)setUp
{
    pageManager=[[APIExplorePageManager alloc] init];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumInteritemSpacing = 0;
    layout2.minimumLineSpacing = 5;
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout2.sectionInset = UIEdgeInsetsMake(20, 0, 150, 0);
    
    CGRect collectionViewFrame = CGRectMake(18, 30, self.frame.size.width-36, self.frame.size.height-30);
    commentsView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout2];
    commentsView.delegate = self;
    commentsView.dataSource = self;
    commentsView.showsHorizontalScrollIndicator = NO;
    [commentsView registerClass:[DiscussionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:commentsView];
    commentsView.backgroundColor=[UIColor clearColor];
    
    //Base_Shadow.png
    baseShadow=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-324/2, self.frame.size.width, 324/2)];
    [self addSubview:baseShadow];
    [baseShadow setImage:[UIImage imageNamed:@"Base_Shadow.png"]];
    baseShadow.contentMode=UIViewContentModeScaleToFill;
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [self addSubview:closeBtn];
    closeBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius=45/2;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    dataArray=[[NSMutableArray alloc] init];
    
    [self reloadData];

}
-(void)closeBtnClicked:(id)sender
{
    [FTIndicator dismissProgress];
    [target performSelector:closeBtnClicked withObject:nil afterDelay:0.001];
    
}
-(void)setSearchDict:(NSDictionary *)dict;
{
    searchDict=dict;
}
-(void)setSearchType:(int)searchType;
{
    typeOfSearch=searchType;
}
-(void)reloadData
{
    dataArray=[[NSMutableArray alloc] init];
    [commentsView reloadData];
    
    if(typeOfSearch==-1 || typeOfSearch==1)
    {
        [pageManager reset];

        [FTIndicator showProgressWithmessage:@"Loading.."];
        
        manager=[[APIManager alloc] init];
        [manager sendRequestForGetDiscussions:searchDict delegate:self andSelector:@selector(discussionDataReceived:)];
    }
    else
    {
        
    }

}
-(void)callPreviousData
{
    
    NSString *backURL=pageManager.previousRecordURLstr;
    
    manager=[[APIManager alloc] init];
    [manager sendRequestExploreFeedWithURL:backURL Withdelegate:self andSelector:@selector(discussionDataReceived:)];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
   
    
                if([pageManager ifNewCallRequired:scrollView inY:0])
                {
                    [self callPreviousData];
                }
                else
                {
                    int p=0;
                }
    
}

-(void)discussionDataReceived:(APIResponseObj *)responseObj
{
    [FTIndicator dismissProgress];

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
                
                [pageManager setOutPutParameters:responseObj];
                
                
                APIObjectsParser *parser=[[APIObjectsParser alloc] init];
                NSMutableArray *responseArray=[NSMutableArray arrayWithArray:[parser parseObjects_DISCUSSIONS:response]];
                
                
                
                UICollectionView *collectionView=(UICollectionView *)commentsView;
                
                
                [collectionView performBatchUpdates:^{
                    
                    NSMutableArray *newIndexs=[[NSMutableArray alloc] init];
                    for(int i=(int)dataArray.count;i<(dataArray.count+responseArray.count);i++)
                    {
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                        [newIndexs addObject:indexPath];
                    }
                    
                    
                    [collectionView insertItemsAtIndexPaths:newIndexs];
                    [dataArray addObjectsFromArray:responseArray];
                    
                    
                    
                } completion:^(BOOL finished) {
                    
                    
                }];
                
                
               
                
                
                
                
             
                
                
                
            }
            
            
        });
    });

}
-(void)discussionDataReceived1:(APIResponseObj *)responseObj
{
    [FTIndicator dismissProgress];

    [commentsView setContentOffset:CGPointMake(0, 0) animated:false];
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        
        NSArray *arrayTemp=(NSArray *)responseObj.response;
        
        
        
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        dataArray=[NSMutableArray arrayWithArray:[parser parseObjects_DISCUSSIONS:arrayTemp]];
        [commentsView reloadData];
        
        
        
    }
    
}
#pragma mark - Collection view

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.alpha=0;
    
    [UIView animateWithDuration:0.3f animations:^(void){
        cell.alpha=1;
    }];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    DiscussionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    APIObjects_DiscussionObj *obj=[dataArray objectAtIndex:indexPath.row];
    
    cell.shortNameLBL.text=[NSString stringWithFormat:@"%@ %@.",obj.userprofile_first_name,[obj.userprofile_last_name substringToIndex:1]];
    
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
        return dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width-36, 148/2);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [self openPostScreen:[dataArray objectAtIndex:indexPath.row]];
     
   // [target performSelector:onTapButtonClick withObject:nil afterDelay:0.01];
}
-(void)openPostScreen:(APIObjects_DiscussionObj *)dobj
{
    [FTIndicator showProgressWithmessage:@"Retriving.."];

    APIManager *manager1=[[APIManager alloc] init];
    [manager1 sendRequestForPostInfoWithId:[NSString stringWithFormat:@"%@",dobj.post_id] Withdelegate:self andSelector:@selector(postInfoReceived:)];

    NSLog(@"%@",dobj.post_id);
}
-(void)postInfoReceived:(APIResponseObj *)obj
{
    
    CGRect screenRect=self.bounds;
    
    if(obj.statusCode==200)
    {
        [FTIndicator dismissProgress];
        
        
        APIObjects_FeedObj *obj1=[[APIObjects_FeedObj alloc] init];
        [obj1 setUpWithDict:obj.response];
        
        NSMutableArray *arrayData=[NSMutableArray arrayWithObject:obj1];
        
        detailPostView=[[DetailViewComponent alloc] initWithFrame:screenRect];
        [self addSubview:detailPostView];
        [detailPostView setDataRecords:arrayData];
        [detailPostView setUpWithCellRect:CGRectMake(0, screenRect.size.height, screenRect.size.width, 5)];
        [detailPostView openCommentDirectly:true];
        
        APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[arrayData objectAtIndex:0];
        
        int mediaType = obj.mediaType.intValue;
        
        if(mediaType!=0)
        {
            NSString *imgURL=obj.image_url;
            [detailPostView setImage:imgURL andNumber:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        else
        {
            int colorNumber=obj.colorNumber.intValue;
            [detailPostView setColorNumber:colorNumber];
            
            [detailPostView setImage:@"red" andNumber:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(onPostClose:)];
        
        [detailPostView setForPostDetail];
        [detailPostView showBackBtn];



    }
    else
    {
        [FTIndicator dismissProgress];
        [FTIndicator showErrorWithMessage:@"Post Not Found"];
        
        
        
    }
    
    
}
-(void)openingTableViewAtPath:(id)sender
{
    
  
    
}
-(void)onPostClose:(NSIndexPath *)path
{
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


@end
