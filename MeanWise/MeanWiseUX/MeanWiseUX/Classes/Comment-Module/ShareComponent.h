//
//  ShareComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 26/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ShareComponent : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    UIView *blackOverLay;
        UIView *containerView;
    
    UIButton *cancelBtn;
    
    UICollectionView *peopleList;

    UILabel *shareTitle;
    
    UIView *seperator1;
    UIView *seperator2;
    UIView *seperator3;
    
    NSMutableArray *socialBtnArray;

    id delegate;
    SEL closeBtnClicked;

    
}
-(void)setUp;
-(void)setTarget:(id)target andCloseBtnClicked:(SEL)func1;

@end

/*

 ShareComponent *sharecompo;

 [sharecompo removeFromSuperview];
 sharecompo=nil;
 
 
 sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
 [sharecompo setUp];
 [self.contentView addSubview:sharecompo];
 
*/