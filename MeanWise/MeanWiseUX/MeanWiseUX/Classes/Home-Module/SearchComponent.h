//
//  SearchComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomGestureView.h"
#import "Constant.h"
#import "ProfileComponent.h"
#import "APIManager.h"
#import "SearchSuggestionsView.h"
#import "EmptyView.h"


@interface SearchComponent : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    
    APIManager *manager;
    NSArray *resultData;

    UITextField *searchFieldTXT;
    SearchSuggestionsView *suggestionBox;
 
    UILabel *searchTypeLBL;
    UIView *searchBaseView;
    
    
    UICollectionView *galleryView;


    UILabel *statusLabel;
    
    UIButton *backBtn;

    NSArray *array;
    NSArray *nameArray;

    id delegate;
    SEL hideBottomBarFunc;
    SEL showBottomBarFunc;
    
    EmptyView *emptyView;

}
-(void)setUp;
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2;


@end



