//
//  NewPostStoryCell.h
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "APIObjects_FeedObj.h"

@interface NewPostStoryCell : UICollectionViewCell
{
    ASNetworkImageNode *post;
    UILabel *statusLBL;
    UIView *overLay;
    int mediaType;
}

-(void)setDataObj:(APIObjects_FeedObj *)dict;

@end
