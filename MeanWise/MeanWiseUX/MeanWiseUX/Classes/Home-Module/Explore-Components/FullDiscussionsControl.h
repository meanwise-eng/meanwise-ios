//
//  FullDiscussionsControl.h
//  MeanWiseUX
//
//  Created by Hardik on 11/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APIExplorePageManager.h"
#import "DetailViewComponent.h"

@interface FullDiscussionsControl : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *commentsView;
    NSMutableArray *dataArray;
    int typeOfSearch;
    NSDictionary *searchDict;

    UIImageView *baseShadow;
    UIButton *closeBtn;
    
    id target;
    SEL closeBtnClicked;
    
    APIExplorePageManager *pageManager;
    APIManager *manager;
    
    DetailViewComponent *detailPostView;


}
-(void)setUp;
-(void)setSearchDict:(NSDictionary *)dict;
-(void)setSearchType:(int)searchType;
-(void)setTarget:(id)tReceived onClose:(SEL)func;

@end


