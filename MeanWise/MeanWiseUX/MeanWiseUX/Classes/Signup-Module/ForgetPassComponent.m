//
//  ForgetPassComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ForgetPassComponent.h"

@implementation ForgetPassComponent

-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:3];
    
    
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Forgot Password";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontBold size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];

    
    
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    nextBtn.layer.cornerRadius=20;
    nextBtn.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.6f];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextArrow.png"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    nextBtn.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    
    emailHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:emailHeadLBL];
    emailHeadLBL.text=@"EMAIL";
    emailHeadLBL.textColor=[UIColor whiteColor];
    emailHeadLBL.textAlignment=NSTextAlignmentLeft;
    emailHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    emailHeadLBL.center=CGPointMake(self.frame.size.width/2, 230);
    
    
    UITextField *emailField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:emailField];
    emailField.center=CGPointMake(self.frame.size.width/2, 230+45);

    
    emailBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    emailBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:emailBaseView];
    emailBaseView.center=CGPointMake(self.frame.size.width/2, 300);
    
    
       
    
}
-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    Func_backBtnClicked=func;
    
}

-(void)nextBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];
   
}

-(void)forgetPassBtnClicked:(id)sender
{
    
}

@end
