//
//  SignUpWizardNameComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DataSession.h"

@interface SignUpWizardNameComponent : UIView <UITextFieldDelegate>
{
    
    UIButton *nextBtn;
    
    UILabel *headLBL;
    UIButton *backBtn;

    UIView *lastNameBaseView;
    UIView *firstNameBaseView;

    UILabel *passHeadLBL;
    UILabel *firstNameHeadLBL;
    
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_NextBtnClicked;
    
    UITextField *firstNameField;
    UITextField *lastNameField;
    
    UIImageView *firstNameValidationSign;
    UIImageView *lastNameValidationSign;

}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignUpWizardNameComponent *c=[[SignUpWizardNameComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
