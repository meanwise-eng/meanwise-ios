//
//  SignUpWizardSkillsComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DataSession.h"
#import "EditSCTagListControl.h"
#import "EditSCSuggestionsComponent.h"


@interface SignUpWizardSkillsComponent : UIView <UITextFieldDelegate>
{
    
    UIButton *nextBtn;
    UILabel *headLBL,*subHeadLBL;
    UIButton *backBtn;
    UIButton *addSkillBtn;
    UIView *skillBaseView;
    UILabel *skillHeadLBL;
    
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_nextBtnClicked;
    
    UITextField *skillField;

    
    

    EditSCTagListControl *tagListControl;
    EditSCSuggestionsComponent *suggestionBox;

    
    
    
    
}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignUpWizardSkillsComponent *c=[[SignUpWizardSkillsComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
