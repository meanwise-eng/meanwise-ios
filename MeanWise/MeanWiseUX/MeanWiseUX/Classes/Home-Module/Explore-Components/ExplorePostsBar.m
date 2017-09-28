//
//  ExplorePostsBar.m
//  MeanWiseUX
//
//  Created by Hardik on 06/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ExplorePostsBar.h"
#import "PostMiniCell.h"
#import "APIObjectsParser.h"
#import "HMMagLayout.h"

@implementation ExplorePostsBar

-(void)setIsPortfolioLayout:(BOOL)flag onFilterUpdate:(SEL)func withUserId:(NSString *)string;
{
    isPortfolioLayout=flag;
    onFilterUpdateCallBack=func;
    userId=string;
}
-(void)setIdentifier:(NSString *)name;
{
    identifier=name;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        isPortfolioLayout=false;
        isFilterOn=false;
        filterText=@"All";
        onFilterUpdateCallBack=nil;
        
        
    }
    return self;
}
#pragma mark - Filter
-(void)setFilterOn:(BOOL)flag andWithFilterText:(NSString *)term;
{
    isFilterOn=flag;
    filterText=term;
    
    [feedList setContentOffset:CGPointMake(0, 0) animated:false];

    [self filterTheData];
  
    [feedList reloadData];

}
-(void)filterTheData
{
    filterDataArray=[[NSMutableArray alloc] init];
    
    if([filterText isEqualToString:@"All"])
    {
        isFilterOn=true;
        [filterDataArray addObjectsFromArray:allDataArray];
    }
    else
    {
        
        for(int i=0;i<[allDataArray count];i++)
        {
            
            APIObjects_FeedObj *obj=[allDataArray objectAtIndex:i];
            
            if([obj.interest_name isEqualToString:filterText])
            {
                [filterDataArray addObject:obj];
            }
            
            
        }
        
        
    }
    
}
-(void)calculateFilterStats
{
    
    
    NSMutableArray *arrayOfInterests=[[NSMutableArray alloc] init];
    
    
    for(int i=0;i<allDataArray.count;i++)
    {
        
        APIObjects_FeedObj *obj=[allDataArray objectAtIndex:i];
        [arrayOfInterests addObject:obj.interest_name];
        
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayOfInterests];
    
    NSArray *uniqueArray = orderedSet.array;
    
    
    
    NSMutableArray *allRelatedInterests=[[NSMutableArray alloc] init];
    
    if(allDataArray.count!=0)
    {
        [allRelatedInterests addObject:@"All"];
    }
    [allRelatedInterests addObjectsFromArray:uniqueArray];
    
    NSLog(@"%@",allRelatedInterests);
    
    if(onFilterUpdateCallBack!=nil)
    {
        numOfTotalPosts=allDataArray.count;
    
        NSDictionary *dict=@{@"allRelatedInterests":allRelatedInterests,@"numOfTotalPosts":@(numOfTotalPosts)};
    [target performSelector:onFilterUpdateCallBack withObject:dict afterDelay:0.01];
    }
}

-(void)setUp
{
    typeOfSearch=1;

    pageManager=[[APIExplorePageManager alloc] init];


    if(isPortfolioLayout==false)
    {
    cellSize=CGSizeMake(150/2, 268/2);
    }
    else
    {
        cellSize=CGSizeMake(150/2, 268/2);
    }
    
    UICollectionViewLayout *layout=[self getLayout];
    
    CGRect collectionViewFrame = self.bounds;

    loadingList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    loadingList.delegate = self;
    loadingList.dataSource = self;
    loadingList.showsHorizontalScrollIndicator = NO;
    [loadingList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:loadingList];
    loadingList.backgroundColor=[UIColor clearColor];
    loadingList.userInteractionEnabled=false;
    loadingList.hidden=true;

    UICollectionViewLayout *layout1=[self getLayout];

    feedList = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout1];
    feedList.delegate = self;
    feedList.dataSource = self;
    feedList.showsHorizontalScrollIndicator = NO;
    [feedList registerClass:[PostMiniCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:feedList];
    feedList.backgroundColor=[UIColor clearColor];
    
    
    
    emptyView=[[EmptyView alloc] initWithFrame:feedList.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForBlack];
    [emptyView setDelegate:self onReload:@selector(refreshAction:)];
    emptyView.msgLBL.text=@"Nothing to display";
    emptyView.reloadBtn.hidden=true;
    
    
}
#pragma mark - API and Pages
-(void)setSearchType:(int)searchType;
{
    typeOfSearch=searchType;
}
-(void)refreshAction:(NSDictionary *)dict
{
    
    loadingList.hidden=false;
    allDataArray=[[NSMutableArray alloc] init];
    [feedList reloadData];
    [feedList setContentOffset:CGPointMake(0, 0) animated:false];
    
    
    
    manager=[[APIManager alloc] init];
    [pageManager reset];

    if(isPortfolioLayout==true)
    {
        [manager sendRequestForPostOfUsersId:userId delegate:self andSelector:@selector(updateTheData:)];
    }
    else 
    {
        if(dict!=nil)
        {
            NSMutableDictionary *postDict=[NSMutableDictionary dictionaryWithDictionary:dict];
            [postDict setValue:identifier forKey:@"exploreFeedType"];
            dict=[NSDictionary dictionaryWithDictionary:postDict];
        }
        else
        {
            dict=@{@"exploreFeedType":identifier,@"type":@(-1)};
        }
        
        [manager sendRequestExploreFeedWithDict:dict Withdelegate:self andSelector:@selector(updateTheData:)];
    }
   
    
    
    feedList.userInteractionEnabled=false;

}

-(void)UsersPostReceived:(APIResponseObj *)responseObj
{
    feedList.userInteractionEnabled=true;
    
    NSArray *responseArray;
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];
    }
    else
    {
        responseArray=[NSMutableArray arrayWithArray:[(NSArray *)responseObj.response valueForKey:@"data"]];
    }
    
    // NSLog(@"%@",responseObj.response);
    
    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    allDataArray=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    
    [feedList reloadData];
    
    if(allDataArray.count==0)
    {
        emptyView.hidden=false;
        emptyView.msgLBL.text=@"Nothing to display";
        
    }
    else
    {
        emptyView.hidden=true;
    }
    
    [feedList setContentOffset:CGPointMake(0, 0) animated:false];
    
    [self calculateFilterStats];


}

-(NSMutableArray *)removeDuplicatePosts:(NSMutableArray *)newRecords
{
    
    NSMutableArray *allPreviousRecords=allDataArray;
    
    NSMutableArray *allPreviousRecordIds=[[NSMutableArray alloc] init];
    
    for(int i=0;i<allPreviousRecords.count;i++)
    {
        APIObjects_FeedObj *obj=[allPreviousRecords objectAtIndex:i];
        [allPreviousRecordIds addObject:obj.postId];
        
    }
    
    NSMutableArray *filteredRecords=[[NSMutableArray alloc] init];
    
    for(int i=0;i<newRecords.count;i++)
    {
        APIObjects_FeedObj *obj=[newRecords objectAtIndex:i];
        
        if(![allPreviousRecordIds containsObject:obj.postId])
        {
            [filteredRecords addObject:obj];
        }
        else
        {
            int p=0;
        }
        
    }
    
    return filteredRecords;
    
    
    
}

-(void)updateTheData:(APIResponseObj *)responseObj
{
    feedList.userInteractionEnabled=true;
    
    loadingList.hidden=true;

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
                
                numOfTotalPosts=responseObj.totalRecords;
                
                [pageManager setOutPutParameters:responseObj];
                
                
                APIObjectsParser *parser=[[APIObjectsParser alloc] init];
                NSMutableArray *responseArray=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:response]];
                
                
                
                responseArray=[self removeDuplicatePosts:responseArray];
                
                
                
                
                UICollectionView *collectionView=(UICollectionView *)feedList;
                
                
                
                [collectionView performBatchUpdates:^{
                    
                    NSMutableArray *newIndexs=[[NSMutableArray alloc] init];
                    for(int i=(int)allDataArray.count;i<(allDataArray.count+responseArray.count);i++)
                    {
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                        [newIndexs addObject:indexPath];
                    }
                    
                    
                    [collectionView insertItemsAtIndexPaths:newIndexs];
                    [allDataArray addObjectsFromArray:responseArray];
                    
                    
                    
                } completion:^(BOOL finished) {
                    
                    
                }];
                
                
                
                [self calculateFilterStats];

                
                ////
                if(allDataArray==0)
                {
                    emptyView.hidden=false;
                    emptyView.msgLBL.text=@"Nothing to display";
                    
                }
                else
                {
                    emptyView.hidden=true;
                }
                
                
                
                
            }
            
            
        });
    });
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(isPortfolioLayout==false)
    {

            if([pageManager ifNewCallRequired:scrollView withCellHeight:0])
            {
                [self callPreviousData];
            }
            else
            {
                int p=0;
            }
        
    }
    else
    {
        if(isFilterOn==false)
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
        else
        {
            int p=0;
        }
    }
}
-(void)callPreviousData
{
    
    NSString *backURL=[pageManager.previousRecordURLstr lowercaseString];
//    backURL=[backURL stringByReplacingOccurrencesOfString:@"v4" withString:@"v1.2"];
//    backURL=@"http://api.meanwise.com/api/v1.2/posts/explore/?section=2&before=1504761673113&interest_name=travel";
    
    
   // backURL=@"https://api.meanwise.com/api/v1.2/posts/explore/?interest_name=travel";
    
    manager=[[APIManager alloc] init];
    [manager sendRequestExploreFeedWithURL:backURL Withdelegate:self andSelector:@selector(updateTheData:)];
    
    
}

#pragma mark - CollectionView callbacks

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==feedList)
    {
        APIObjects_FeedObj *feedObj;
    
        if(isFilterOn==false)
        {
            feedObj=[allDataArray objectAtIndex:indexPath.row];
        }
        else
        {
            feedObj=[filterDataArray objectAtIndex:indexPath.row];
        }
    
        PostMiniCell *cell=[feedList dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        NSLog(@"%@",feedObj.image_url);
        cell.backgroundColor=[UIColor whiteColor];
        cell.backgroundColor=[Constant colorGlobal:feedObj.colorNumber.intValue];
        [cell setUpPostImageURL:feedObj.image_url andText:feedObj.text];
        
        cell.hidden=false;

        if(isPortfolioLayout==false)
        {
            cell.layer.cornerRadius=2.5f;
        }
        return cell;
    }
    else
    {
        
        UICollectionViewCell *cell=[loadingList dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5f];
        
        if(isPortfolioLayout==false)
        {
            cell.layer.cornerRadius=2.5f;
        }
        
        return cell;
        
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(collectionView!=loadingList)
    {

    if(isPortfolioLayout==true)
    {
        cell.alpha=0;
    
        [UIView animateWithDuration:0.3f animations:^(void){
            cell.alpha=1;
        }];
    }
    }

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView!=loadingList)
    {

        if(isFilterOn==false)
        {
            return allDataArray.count;
        }
        else
        {
            return filterDataArray.count;
        }
    }
    else
    {
        return 10;
    }
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
  
    if(collectionView!=loadingList)
    {
 
    NSDictionary *dict;
    if(isFilterOn==false)
    {
        
        dict=[[NSDictionary alloc] initWithObjectsAndKeys:
                            indexPath,@"indexPath",
                            allDataArray,@"data",
                            identifier,@"identifier",
                            nil];
    }
    else
    {
        
        dict=[[NSDictionary alloc] initWithObjectsAndKeys:
                            indexPath,@"indexPath",
                            filterDataArray,@"data",
                            identifier,@"identifier",
                            nil];
    }
    
    //cell Rect, Array, indexpath, image,

   
    [target performSelector:onExpandPost withObject:dict afterDelay:0.001];
    }
}
-(void)setTarget:(id)sender andOnOpen:(SEL)open;
{
    target=sender;
     onExpandPost=open;
}
#pragma mark - Detail callbacks

-(CGRect)getTheRectOfCurrentCell:(NSIndexPath *)indexPath
{
    
    PostMiniCell *cell=(PostMiniCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=true;
    
    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    
    
    
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    
    
    return rect;
    
}
-(CGRect)openingTableViewAtPath:(NSIndexPath *)indexPath
{
    
    [self MakeAllCellVisible];
    
    
    if(isPortfolioLayout==false)
    {
    [feedList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    }
    else
    {
        [feedList scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];

    }
    
    UICollectionViewLayoutAttributes *attributes = [feedList layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect myRect = attributes.frame;
    
    
    PostMiniCell *cell=(PostMiniCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=true;
    
    
    CGRect rect=CGRectMake(myRect.origin.x, feedList.frame.origin.y+myRect.origin.y, myRect.size.width, myRect.size.height);
    
    
    rect = CGRectOffset(rect, -feedList.contentOffset.x, -feedList.contentOffset.y);
    
    return rect;
    
    
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
-(void)setCellHide:(BOOL)flag atIndexPath:(NSIndexPath *)indexPath
{
    PostMiniCell *cell=(PostMiniCell *)[feedList cellForItemAtIndexPath:indexPath];
    cell.hidden=flag;
}
-(void)deletePostWithPostId:(NSString *)postId;
{
    
//    NSMutableArray *allDataArray;
//    NSMutableArray *filterDataArray;

    for(int i=0;i<allDataArray.count;i++)
    {
        APIObjects_FeedObj *feedObj=[allDataArray objectAtIndex:i];
        
        if([[NSString stringWithFormat:@"%@",postId] isEqualToString:[NSString stringWithFormat:@"%@",feedObj.postId]])
        {
            
            [allDataArray removeObject:feedObj];
            break;
            
        }
        
    }
    for(int i=0;i<filterDataArray.count;i++)
    {
        APIObjects_FeedObj *feedObj=[filterDataArray objectAtIndex:i];
        
        if([[NSString stringWithFormat:@"%@",postId] isEqualToString:[NSString stringWithFormat:@"%@",feedObj.postId]])
        {
            
            [filterDataArray removeObject:feedObj];
            break;
            
        }
        
    }
    
    [feedList reloadData];
    [self calculateFilterStats];
}
#pragma mark - Helper
-(void)updateTheCommentCountsForVisibleRows
{
    
}
-(UICollectionViewLayout *)getLayout
{
    if(isPortfolioLayout==false)
    {
        UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
        layout2.minimumInteritemSpacing = 5;
        layout2.minimumLineSpacing = 5;
        layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout2.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
        
        return layout2;
    }
    else
    {
        HMMagLayout *layout2=[[HMMagLayout alloc] initWithSize:self.bounds.size];

//        UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc] init];
//        layout2.minimumInteritemSpacing = 20;
//        layout2.minimumLineSpacing = 20;
//        layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout2.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
//
        return layout2;
    }
}
@end
