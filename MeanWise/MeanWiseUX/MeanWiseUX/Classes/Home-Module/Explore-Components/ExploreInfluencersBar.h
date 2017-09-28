//
//  ExploreInfluencersBar.h
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreInfluencersBar : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    int typeOfSearch;
    NSDictionary *searchDict;

    NSMutableArray *dataArray;
    UICollectionView *userLists;
    
    id target;
    SEL onTapButtonClick;

}
-(void)setUp;
-(void)setTarget:(id)targetReceived onTapEvent:(SEL)tap;


-(void)refreshAction:(NSDictionary *)dict;
-(void)setSearchType:(int)searchType;

-(int)getTypeOfSearch;
-(NSDictionary *)getSearchDict;

@end
