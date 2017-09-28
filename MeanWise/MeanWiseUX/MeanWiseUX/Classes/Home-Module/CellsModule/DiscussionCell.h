//
//  DiscussionCell.h
//  MeanWiseUX
//
//  Created by Hardik on 07/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageHM.h"

@interface DiscussionCell : UICollectionViewCell
{
    
}
@property (nonatomic, strong) UILabel *shortNameLBL;
@property (nonatomic, strong) UILabel *timeLBL;
@property (nonatomic, strong) UILabel *postTextLBL;

@property (nonatomic, strong) UIImageHM *profPicImgView;
@property (nonatomic, strong) UIImageHM *postImgView;

@end
