//
//  ProfileCell.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "Constant.h"
#import "UIImageHM.h"

@interface ProfileCell : UICollectionViewCell
{
 
//    UIImageView *profileIMGVIEW;
//    UILabel *nameLBL;
//    UIImageView *shadowImage
    
}
@property (nonatomic, strong) ASNetworkImageNode *profileIMGVIEW;
@property (nonatomic, strong) ASDisplayNode *shadowImage;

@property (nonatomic, strong) UILabel *nameLBL;

-(void)setHiddenCustom:(BOOL)flag;



@end
