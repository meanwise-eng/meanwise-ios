//
//  InterestCell.h
//  MeanWiseUX
//
//  Created by Hardik on 05/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"

@interface InterestCell : UICollectionViewCell
{
    
    
}
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UIView *shadowImage;

@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UIButton *whiteBtn;
@property (nonatomic, strong) UIButton *blueBtn;

@end
