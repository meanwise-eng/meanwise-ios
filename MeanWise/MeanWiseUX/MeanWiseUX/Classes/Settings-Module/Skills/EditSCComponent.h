//
//  EditSCComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWNavBar.h"
#import "APIManager.h"
#import "EditSCSuggestionsComponent.h"
#import "EditSCTagListControl.h"

@interface EditSCComponent : UIView <UITextFieldDelegate>
{
    
    UITextField *tagSearchField;
    
    UIView *navBar;
    UILabel *navBarTitle;
    
    id delegate;
    SEL backBtnClicked;
    
    UILabel *instructionField;
    UIButton *saveBtn;
    
    
    EditSCSuggestionsComponent *suggestionBox;
    EditSCTagListControl *tagListControl;
    UIButton *AddCustomBtn;
    
    
}
@property (nonatomic, strong) UIImageView *blackOverLayView;

-(void)setUp;
-(void)setTarget:(id)target andBackFunc:(SEL)func;

@end
