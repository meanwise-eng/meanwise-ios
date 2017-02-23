//
//  SignUpWizardInterestComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DataSession.h"

@interface SignUpWizardInterestComponent : UIView <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    NSArray *arrayData1;
    
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
    SEL Func_nextBtnClicked;
    
    
    UICollectionView *interestCollectionView;
    int numberOfItemSelected;
    UILabel *counterLBL;
    
    NSMutableArray *selectedArray;

}

-(void)setUp;
-(void)setTarget:(id)target andFunc1:(SEL)func;
-(void)setTarget:(id)target andFunc2:(SEL)func;

@end

/*
 
 SignUpWizardInterestComponent *c=[[SignUpWizardInterestComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:c];
 [c setUp];
 
 */
