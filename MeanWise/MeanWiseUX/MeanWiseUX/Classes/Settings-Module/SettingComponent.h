//
//  SettingComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"

@interface SettingComponent : UIView  <UITableViewDataSource,UITableViewDelegate>
{
    
    int passed;
    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    
    UITableView *listOfItems;
    
    NSArray *items1;
    NSArray *items2;
}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end

/*
 intro - bio
 skills - skills
 profession - profession
 location-location
   Name- first,namelastname
 Birthday-birthday
 mobile number- mobilenumber
 
 
edit profile: appi- story not in input, city not in back, password not in api
 username, email needs to remove from screen,
 
 
 */
