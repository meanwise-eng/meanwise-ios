//
//  MessageComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"

@interface MessageComponent : UIView <    UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *chatMessages;

    UIView *navBar;
    UILabel *navBarTitle;
    UITableView *msgContactTable;

    id delegate;
    SEL backBtnClicked;
    

}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
