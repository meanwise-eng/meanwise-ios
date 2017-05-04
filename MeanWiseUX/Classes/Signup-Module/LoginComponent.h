//
//  LoginComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "TTTAttributedLabel.h"

@interface LoginComponent : UIView <TTTAttributedLabelDelegate>
{
    UIImageView *logoImg;
    UILabel *subTitleLBL;
    UIButton *topLogin;
    UIButton *fbLoginBtn;
    UIButton *emLoginBtn;
    UIButton *loginWithEmailBtn;
    UIButton *createAccountBtn;
    TTTAttributedLabel *infoLabel;


    id delegate;
    SEL Func_normalLoginBtnClicked;
    SEL Func_signUpBtnClicked;
    
    
    
}
-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 LoginComponent *c=[[LoginComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
