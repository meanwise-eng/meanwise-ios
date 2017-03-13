//
//  NotificationScreen.h
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "APIObjects_NotificationObj.h"

@interface NotificationScreen : UIView <UITableViewDataSource,UITableViewDelegate>
{
    
    UILabel *navBarTitle;
    NSArray *dataFeeds;
    
    UITableView *listTable;
    
    NSMutableArray *notifiationsData;
}
-(void)setUp:(NSArray *)array;

@end
