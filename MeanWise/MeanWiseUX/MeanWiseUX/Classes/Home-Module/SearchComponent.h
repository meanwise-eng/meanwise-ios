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


@interface SearchComponent : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    
    APIManager *manager;
    NSArray *resultData;

    
    UICollectionView *galleryView;

    UITextField *exploreTerm;

    UILabel *statusLabel;
    
    UIButton *backBtn;

    NSArray *array;
    NSArray *nameArray;

    id delegate;
    SEL hideBottomBarFunc;
    SEL showBottomBarFunc;
    

}
-(void)setUp;
-(void)setTarget:(id)target andHide:(SEL)func1 andShow:(SEL)func2;

@end
