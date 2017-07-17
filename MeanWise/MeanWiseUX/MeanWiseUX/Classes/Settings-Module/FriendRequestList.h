//
//  FriendRequestList.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"
#import "APIManager.h"
#import "EmptyView.h"
#import "API_PAGESManager.h"

@interface FriendRequestList : UIView <UITableViewDelegate,UITableViewDataSource>
{
    
    APIManager *manager;
    
    NSArray *resultData;

    
    
    
    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    UITableView *friendListTableView;

    EmptyView *emptyView;
    API_PAGESManager *pManager;

}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
