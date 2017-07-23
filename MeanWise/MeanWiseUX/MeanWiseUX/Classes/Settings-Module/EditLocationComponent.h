//
//  EditLocationComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"

@interface EditLocationComponent : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    
    
    UITextField *locationTXT;

    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    
    UILabel *instructionField;
    UIButton *saveBtn;
    
    
    UIView *resultContainerView;
    UITableView *resultListView;
    UIImageView *poweredByLogo;
    float logoHeight;
    NSString *searchString;
    UIActivityIndicatorView *activityIndicator;

    
    
}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
