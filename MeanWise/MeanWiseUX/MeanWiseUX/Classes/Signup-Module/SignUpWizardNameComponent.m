//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardNameComponent.h"

@implementation SignUpWizardNameComponent


-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:4];
    
    
    [self addSubview:[Constant createProgressSignupViewWithWidth:self.frame.size.width andProgress:0.0 toPercentage:0.2]];;
    
    
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"What's your name?";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
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
    nextBtn.hidden=true;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    view.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:view];
    view.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-60);
    
    


    
    firstNameHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:firstNameHeadLBL];
    firstNameHeadLBL.text=@"FIRST NAME";
    firstNameHeadLBL.textColor=[UIColor whiteColor];
    firstNameHeadLBL.textAlignment=NSTextAlignmentLeft;
    firstNameHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    firstNameHeadLBL.center=CGPointMake(self.frame.size.width/2, 230);
    
    
    firstNameField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:firstNameField];
    firstNameField.center=CGPointMake(self.frame.size.width/2, 230+45);
    firstNameField.autocorrectionType=UITextAutocorrectionTypeNo;
    firstNameField.spellCheckingType=UITextSpellCheckingTypeNo;



    
    
    passHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:passHeadLBL];
    passHeadLBL.text=@"LAST NAME";
    passHeadLBL.textColor=[UIColor whiteColor];
    passHeadLBL.textAlignment=NSTextAlignmentLeft;
    passHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    passHeadLBL.center=CGPointMake(self.frame.size.width/2, 350);

    
    lastNameField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:lastNameField];
    lastNameField.center=CGPointMake(self.frame.size.width/2, 350+45);
    lastNameField.autocorrectionType=UITextAutocorrectionTypeNo;
    lastNameField.spellCheckingType=UITextSpellCheckingTypeNo;

    
    firstNameValidationSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:firstNameValidationSign];
    firstNameValidationSign.center=CGPointMake(self.frame.size.width-40, 230+45);
    firstNameValidationSign.image=[UIImage imageNamed:@"Checkmark.png"];
    firstNameValidationSign.hidden=true;
    
    lastNameValidationSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:lastNameValidationSign];
    lastNameValidationSign.center=CGPointMake(self.frame.size.width-40, 350+45);
    lastNameValidationSign.image=[UIImage imageNamed:@"Checkmark.png"];
    lastNameValidationSign.hidden=true;
    
    
    
    
    firstNameBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    firstNameBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:firstNameBaseView];
    firstNameBaseView.center=CGPointMake(self.frame.size.width/2, 300);
    
    
    lastNameBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    lastNameBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:lastNameBaseView];
    lastNameBaseView.center=CGPointMake(self.frame.size.width/2, 420);
    

    
    firstNameField.returnKeyType=UIReturnKeyNext;
    lastNameField.returnKeyType=UIReturnKeyContinue;
    firstNameField.delegate=self;
    lastNameField.delegate=self;
    [firstNameField becomeFirstResponder];
    
    
    [firstNameField addTarget:self
                   action:@selector(firstNameFieldChange:)
         forControlEvents:UIControlEventEditingChanged];
    
    [lastNameField addTarget:self
                       action:@selector(firstNameFieldChange:)
             forControlEvents:UIControlEventEditingChanged];

    
}
-(void)firstNameFieldChange:(id)sender
{
    int valid1=1,valid2=1;
    
    if([firstNameField.text isEqualToString:@""])
    {
        valid1=0;
    }
    if([lastNameField.text isEqualToString:@""])
    {
        valid2=0;
    }
    if(firstNameField.text.length<3)
    {
        valid1=0;
    }
    if(lastNameField.text.length<3)
    {
        valid2=0;
    }
    if([firstNameField.text containsString:@" "])
    {
        valid1=0;
    }
    if([lastNameField.text containsString:@" "])
    {
        valid2=0;
    }
    

    if(valid1==1)
    {
        firstNameValidationSign.hidden=false;
    }
    else
    {
        firstNameValidationSign.hidden=true;
    }
    if(valid2==1)
    {
        lastNameValidationSign.hidden=false;
    }
    else
    {
        lastNameValidationSign.hidden=true;
    }
    
    if(valid1==1 && valid2==1)
    {
        nextBtn.hidden=false;
    }
    else
    {
        nextBtn.hidden=true;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(firstNameField==textField)
    {
        [firstNameField resignFirstResponder];
        [lastNameField becomeFirstResponder];
    }
    else if(lastNameField==textField)
    {
        [lastNameField resignFirstResponder];
        [self nextBtnClicked:nil];
    }
    
    
    return true;
}

-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    Func_backBtnClicked=func;
    
}
-(void)setTarget:(id)target andFunc2:(SEL)func;
{
    delegate=target;
    Func_NextBtnClicked=func;
    
}

-(void)nextBtnClicked:(id)sender
{
    if(nextBtn.hidden==false)
    {
        [[DataSession sharedInstance].signupObject clearAllData];
        [DataSession sharedInstance].signupObject.first_name=firstNameField.text;
        [DataSession sharedInstance].signupObject.last_name=lastNameField.text;
        
        
    [delegate performSelector:Func_NextBtnClicked withObject:nil afterDelay:0.01];
    }

}

-(void)backBtnClicked:(id)sender
{
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}


@end
