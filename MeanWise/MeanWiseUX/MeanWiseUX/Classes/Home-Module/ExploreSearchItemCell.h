//
//  ExploreSearchItemCell.h
//  ExactResearch
//
//  Created by Hardik on 24/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"


@interface ExploreSearchItemCell : UICollectionViewCell
{
    int type;
    
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *hashtagOrTopic;

@property (nonatomic, strong) UIImageView *post_profilePhoto;
@property (nonatomic, strong) UILabel *post_UserNameLBL;
@property (nonatomic, strong) UILabel *post_channelNameLBL;
@property (nonatomic, strong) UILabel *post_topicNameLBL;
@property (nonatomic, strong) UILabel *post_textLBL;


-(void)setType:(int)number;

@end