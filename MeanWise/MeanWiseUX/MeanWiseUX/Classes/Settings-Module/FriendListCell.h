//
//  FriendListCell.h
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"
#import "APIObjects_ProfileObj.h"

@interface FriendListCell : UITableViewCell
{
    APIObjects_ProfileObj *dataObj;
    
}
-(void)setDataDict:(APIObjects_ProfileObj *)obj;

@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UILabel *contactNameLBL;
@property (nonatomic, strong) UILabel *proType;

@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *rejectBtn;

@end
