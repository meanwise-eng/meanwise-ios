//
//  NotificationsComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "APIObjects_ProfileObj.h"
#import "EmptyView.h"

@interface ProfileCompleteComponent : UIView <UITableViewDataSource,UITableViewDelegate>
{
    BOOL blnCover, blnProfile, blnIntro, blnBio, blnProf, blnSkills, blnLocation, blnDOB;
    
    NSMutableArray *dataFeeds;
    NSString *lastNotificationReceived;

    UITableView *listTable;
    
    NSMutableArray *profileItems;
    
    UIButton *backBtn;
    id delegate;
    SEL backBtnClickedFunc;

}
-(void)setUp;
-(void)setTarget:(id)target andBackBtnFunc:(SEL)func1;


@end
