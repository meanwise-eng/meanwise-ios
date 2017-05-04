//
//  ForgetPassComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ForgetPassComponent : UIView <UITextFieldDelegate>
{
    
    UIButton *nextBtn;
    
    UILabel *headLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UILabel *passHeadLBL;
    UIView *passBaseView;
    UIView *emailBaseView;
    UILabel *emailHeadLBL;
    
    UITextField *emailField;
    UIImageView *emailValidationSign;
    
    id delegate;
    SEL Func_backBtnClicked;

    
}
-(void)setTarget:(id)target andFunc1:(SEL)func;


-(void)setUp;
@end

/*
 
 ForgetPassComponent *c=[[ForgetPassComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
