//
//  ChannelExploreCell.h
//  MeanWiseUX
//
//  Created by Hardik on 02/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"

@interface ChannelExploreCell : UICollectionViewCell
{
    
    
}
-(void)setURLString:(NSString *)string;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageHM *profileIMGVIEW;

@property (nonatomic, strong) UILabel *nameLBL;

@end
