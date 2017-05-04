//
//  SignUpWizardProfileComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "ProffesionComponent.h"

@interface SignUpWizardProfileComponent : UIView <UITextFieldDelegate,UITextViewDelegate>
{
    
    UIButton *nextBtn;
    
    UILabel *headLBL,*subHeadLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UILabel *passHeadLBL,*bioHeadLBL;
    UIView *passBaseView;
    UIView *emailBaseView,*bioBaseView1,*bioBaseView2,*bioBaseView3;
    UILabel *emailHeadLBL;
    
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_nextBtnClicked;
    
    ProffesionComponent *proffesionPicker;
    
    UITextField *userNameField;
    UIButton *profFieldBtn;
    UITextView *bioTXT;
    int bioBaseHeight;
}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignUpWizardProfileComponent *c=[[SignUpWizardProfileComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
