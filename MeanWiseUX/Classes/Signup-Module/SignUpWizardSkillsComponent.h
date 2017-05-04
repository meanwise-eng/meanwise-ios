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
#import "HMTagList.h"
#import "DataSession.h"

@interface SignUpWizardSkillsComponent : UIView <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UIButton *nextBtn;
    
    UILabel *headLBL,*subHeadLBL;
    UIButton *forgetPassBtn;
    UIButton *backBtn;
    
    UIButton *addSkillBtn;
    
    UILabel *passHeadLBL,*bioHeadLBL, *skillValidationLbl;
    UIView *passBaseView;
    UIView *emailBaseView,*bioBaseView;
    UILabel *emailHeadLBL;
    id delegate;
    SEL Func_backBtnClicked;
    SEL Func_nextBtnClicked;
    
    
    UITextField *skillField;
    UITableView *skillSearchTableView;
  //  NSArray *skillTagsArray;
    NSArray *skillDBTagsArray;
    NSArray *filteredTagsArray;
    
    HMTagList *selectedTagListView;
    
    
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
