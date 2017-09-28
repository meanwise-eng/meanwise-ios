//
//  ExploreDiscussionsBar.h
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyView.h"

@interface ExploreDiscussionsBar : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    int typeOfSearch;
    NSDictionary *searchDict;
    
    
    NSMutableArray *dataArray;
    UICollectionView *commentsView;
    
    EmptyView *emptyView;

    UIButton *viewMoreBtn;
    
    id target;
    SEL onTapButtonClick;
    SEL onSizeChangeEvent;
    
    
}
-(void)setUp;
-(void)refreshAction:(NSDictionary *)dict;
-(void)setSearchType:(int)searchType;

-(void)setTarget:(id)targetReceived onTapEvent:(SEL)tap andWhenSizeChange:(SEL)func;

-(int)getTypeOfSearch;
-(NSDictionary *)getSearchDict;

@end
