//
//  ProfileCell.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"

@interface ProfileCell : UICollectionViewCell
{
 
//    UIImageView *profileIMGVIEW;
//    UILabel *nameLBL;
//    UIImageView *shadowImage
    
}
@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UIImageView *shadowImage;

@property (nonatomic, strong) UILabel *nameLBL;

-(void)setHiddenCustom:(BOOL)flag;



@end
