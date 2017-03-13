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
#import "APIObjects_NotificationObj.h"
#import "EmptyView.h"

@interface NotificationsComponent : UIView <UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *dataFeeds;
    NSString *lastNotificationReceived;

    
    UILabel *navBarTitle;

    UITableView *listTable;
    
    NSMutableArray *notifiationsData;
    
    UIButton *backBtn;
    id delegate;
    SEL backBtnClickedFunc;
    
    EmptyView *emptyView;

}
-(void)setUp:(NSArray *)array;
-(void)setTarget:(id)target andBackBtnFunc:(SEL)func1;


@end
