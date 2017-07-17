//
//  LoginScreenComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "LoginTransitionScreen.h"

@interface LoginScreenComponent : UIView <UITextFieldDelegate>
{
   
    
    UIButton *nextBtn;
    
    UILabel *headLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UILabel *passHeadLBL;
    UIView *passBaseView;
    UIView *emailBaseView;
    UILabel *emailHeadLBL;

    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_forgetPassBtnClicked;
    SEL Func_successFullLoginBtnClicked;

    UITextField *emailField;
    UIImageView *emailValidationSign;
    
    UITextField *passField;
    
    
    LoginTransitionScreen *loader;
    NSMutableArray *allSubviews;

}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;
-(void)setTarget:(id)target andFunc3:(SEL)func;

@end

/*
 
 LoginScreenComponent *c=[[LoginScreenComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
