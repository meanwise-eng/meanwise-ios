//
//  ExplorePostsBar.h
//  MeanWiseUX
//
//  Created by Hardik on 06/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyView.h"
#import "APIExplorePageManager.h"

@interface ExplorePostsBar : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    NSString *identifier;
    
    int typeOfSearch;

    NSMutableArray *allDataArray;
    NSMutableArray *filterDataArray;

    UICollectionView *feedList;
    UICollectionView *loadingList;
    
    EmptyView *emptyView;
    
    CGSize cellSize;
    
    APIExplorePageManager *pageManager;
    APIManager *manager;
    

    id target;
    SEL onExpandPost;
    
    
    //Portfolio
    BOOL isPortfolioLayout;
    SEL onFilterUpdateCallBack;
    BOOL isFilterOn;
    NSString *filterText;
    NSString *userId;
    
    NSInteger numOfTotalPosts;
    
}
-(void)setFilterOn:(BOOL)flag andWithFilterText:(NSString *)term;

-(void)setIsPortfolioLayout:(BOOL)flag onFilterUpdate:(SEL)func withUserId:(NSString *)string;
-(void)setUp;
-(void)refreshAction:(NSDictionary *)dict;
-(void)setSearchType:(int)searchType;
-(void)setIdentifier:(NSString *)identifier;


#pragma mark - detail

-(void)setTarget:(id)sender andOnOpen:(SEL)open;

-(void)MakeAllCellVisible;
-(CGRect)openingTableViewAtPath:(NSIndexPath *)indexPath;
-(CGRect)getTheRectOfCurrentCell:(NSIndexPath *)indexPath;
-(void)setCellHide:(BOOL)flag atIndexPath:(NSIndexPath *)indexPath;
-(void)deletePostWithPostId:(NSString *)postId;

@end
