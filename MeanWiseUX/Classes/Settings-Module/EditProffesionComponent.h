//
//  EditProffesionComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"


@interface EditProffesionComponent : UIView <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
    NSArray *searchResult;
    
    UITextField *proffesionTXT;
    
    
    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    
    UILabel *instructionField;
    UIButton *saveBtn;
    
    UITableView *optionsTable;
    NSString *selectedProffesionId;
    
}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
