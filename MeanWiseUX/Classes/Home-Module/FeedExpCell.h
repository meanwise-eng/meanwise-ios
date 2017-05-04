//
//  feedExpCell.h
//  MeanWiseUX
//
//  Created by Hardik on 03/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface FeedExpCell : UICollectionViewCell
{
    
    
}
@property (nonatomic, strong) UIImageView *postIMGVIEW;

@property (nonatomic, strong) UIImageView *profileIMGVIEW;
@property (nonatomic, strong) UIImageView *shadowImage;

@property (nonatomic, strong) UILabel *statusLBL;


@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UILabel *profLBL;


@property (nonatomic, strong) UILabel *tagName;
@property (nonatomic, strong) UILabel *timeLBL;

@property (nonatomic, strong) UILabel *likeCountLBL;
@property (nonatomic, strong) UILabel *commentCountLBL;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;


-(void)hasMedia:(BOOL)flag;

@end