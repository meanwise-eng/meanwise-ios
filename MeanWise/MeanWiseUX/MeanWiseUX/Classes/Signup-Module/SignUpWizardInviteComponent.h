//
//  SignUpWizardInviteComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface SignUpWizardInviteComponent : UIView
{
    
    UIButton *nextBtn;
    
    UILabel *headLBL,*subHeadLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UILabel *passHeadLBL,*bioHeadLBL;
    UIView *passBaseView;
    UIView *emailBaseView,*bioBaseView;
    UILabel *emailHeadLBL;
    
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_successFullLoginBtnClicked;

}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignUpWizardInviteComponent *c=[[SignUpWizardInviteComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
