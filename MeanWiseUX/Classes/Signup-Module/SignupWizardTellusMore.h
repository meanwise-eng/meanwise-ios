//
//  SignupWizardTellusMore.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DataSession.h"
#import "SDiOSVersion.h"

@interface popUpCalendar : UIView
{
    id target;
    SEL dateSelected;
    UIButton *doneBtn;
    UIDatePicker *datePicker;
}
-(void)setUp;

-(void)setTarget:(id)delegate andFunc:(SEL)func;

@end

@interface SignupWizardTellusMore : UIView<UITextFieldDelegate>
{
    NSDate *dataSelectedDate;
    
    int isDateSelected;
    UIButton *nextBtn;
    
    UILabel *headLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UILabel *passHeadLBL;
    UIView *passBaseView;
    UIView *emailBaseView;
    UILabel *emailHeadLBL;
    
    UIScrollView *mainView;
    
    UILabel *emailValidationLBL;

    UILabel *dobHeadLBL;
    
    UIImageView *emailValidationSign;
    UIImageView *passValidationSign;
    
    UIButton *dateValueBtn;
    UIButton *monthValueBtn;
    UIButton *yearValueBtn;
    
    
    
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_nextBtnClicked;
    
    UITextField *emailField;
    UITextField *passField;
    
}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignupWizardTellusMore *c=[[SignupWizardTellusMore alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
