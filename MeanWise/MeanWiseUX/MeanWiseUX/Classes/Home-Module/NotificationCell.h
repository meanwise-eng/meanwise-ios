//
//  NotificationCell.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "APIObjects_NotificationObj.h"
#import "UIImageHM.h"

@interface NotificationCell : UITableViewCell
{
    APIObjects_NotificationObj *dataObj;
    
}
@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UILabel *contactNameLBL;
@property (nonatomic, strong) UILabel *messageSubTextLBL;
@property (nonatomic, strong) UILabel *timeLBL;
@property (nonatomic, strong) UIImageHM *postImageView;

@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *cancelBtn;




-(void)setUpObj:(APIObjects_NotificationObj *)obj;

@end
