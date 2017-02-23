//
//  HomeFeedCell.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"
#import "APIObjects_FeedObj.h"
#import "APIManager.h"

@interface HomeFeedCell : UICollectionViewCell
{
    int mediaType;
    UIView *hiddenView;
    
    APIObjects_FeedObj *dataObj;
    
    int liked;
}
-(void)setUpMediaType:(int)mediaType andColorNumber:(int)Cnumber;

-(void)setHiddenCustom:(BOOL)flag;
-(void)setDataObj:(APIObjects_FeedObj *)dict;


@property (nonatomic, strong) UIImageView *shadowImage;

@property (nonatomic, strong) UILabel *statusLBL;
@property (nonatomic, strong) UIImageHM *postIMGVIEW;

@property (nonatomic, strong) UIImageHM *profileIMGVIEW;

@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UILabel *profLBL;


@property (nonatomic, strong) UILabel *tagName;
@property (nonatomic, strong) UILabel *timeLBL;


@property (nonatomic, strong) UILabel *likeCountLBL;
@property (nonatomic, strong) UILabel *commentCountLBL;

@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;



-(void)setFrameX:(CGRect)frame;

@end
