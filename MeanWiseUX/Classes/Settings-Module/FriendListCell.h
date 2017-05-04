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
    
    id targetCaller;
    SEL onAcceptCallBack;
    SEL onCancelCallBack;
    
}
-(void)setDataDict:(APIObjects_ProfileObj *)obj;

-(void)setTargetCaller:(id)targetReceived;
-(void)setCallBackForAccept:(SEL)func;
-(void)setCallBackForReject:(SEL)func;


@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UILabel *contactNameLBL;
@property (nonatomic, strong) UILabel *proType;

@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *rejectBtn;



@end
