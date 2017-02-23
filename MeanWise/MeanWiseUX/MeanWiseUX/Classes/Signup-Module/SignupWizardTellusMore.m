//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignupWizardTellusMore.h"


@implementation SignupWizardTellusMore

-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:5];
    
    
    isDateSelected=0;
    dataSelectedDate=nil;
    
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Tell us a bit more";
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
    
    
    
    emailHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:emailHeadLBL];
    emailHeadLBL.text=@"EMAIL";
    emailHeadLBL.textColor=[UIColor whiteColor];
    emailHeadLBL.textAlignment=NSTextAlignmentLeft;
    emailHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    emailHeadLBL.center=CGPointMake(self.frame.size.width/2, 230);
    
    emailValidationSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:emailValidationSign];
    emailValidationSign.center=CGPointMake(self.frame.size.width-40, 230+45);
    emailValidationSign.image=[UIImage imageNamed:@"Checkmark.png"];
    emailValidationSign.hidden=true;


    emailField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:emailField];
    emailField.center=CGPointMake(self.frame.size.width/2, 230+45);
    emailField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    emailField.autocorrectionType=UITextAutocorrectionTypeNo;

    emailValidationLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 20)];
    [self addSubview:emailValidationLBL];
    emailValidationLBL.center=CGPointMake(self.frame.size.width/2, 310);
    emailValidationLBL.font=[UIFont fontWithName:k_fontExtraBold size:12];
    emailValidationLBL.textAlignment=NSTextAlignmentLeft;
    emailValidationLBL.text=@"Email already in use.";
    emailValidationLBL.textColor=[UIColor yellowColor];
    emailValidationLBL.hidden=true;
    

    
    
    passHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:passHeadLBL];
    passHeadLBL.text=@"PASSWORD";
    passHeadLBL.textColor=[UIColor whiteColor];
    passHeadLBL.textAlignment=NSTextAlignmentLeft;
    passHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    passHeadLBL.center=CGPointMake(self.frame.size.width/2, 350);
    
    
    
    
    passField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:passField];
    passField.center=CGPointMake(self.frame.size.width/2, 350+45);
    passField.secureTextEntry=YES;
    
    passValidationSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:passValidationSign];
    passValidationSign.center=CGPointMake(self.frame.size.width-40, 350+45);
    passValidationSign.image=[UIImage imageNamed:@"Checkmark.png"];
    passValidationSign.hidden=true;

    
    dobHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:dobHeadLBL];
    dobHeadLBL.text=@"DATE OF BIRTH";
    dobHeadLBL.textColor=[UIColor whiteColor];
    dobHeadLBL.textAlignment=NSTextAlignmentLeft;
    dobHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    dobHeadLBL.center=CGPointMake(self.frame.size.width/2, 350+120);
    
    
    dateValueBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [dateValueBtn setTitle:@"Day" forState:UIControlStateNormal];
    [self addSubview:dateValueBtn];
    [self setDOBStyleToLBL:dateValueBtn];

    monthValueBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [monthValueBtn setTitle:@"Month" forState:UIControlStateNormal];
    [self addSubview:monthValueBtn];
    [self setDOBStyleToLBL:monthValueBtn];

    yearValueBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [yearValueBtn setTitle:@"Year" forState:UIControlStateNormal];
    [self addSubview:yearValueBtn];
    [self setDOBStyleToLBL:yearValueBtn];

    float ratio=(self.frame.size.width-20)/3;
    

    dateValueBtn.center=CGPointMake(5+ratio/2, 350+120+45);
    monthValueBtn.center=CGPointMake(5+ratio+5+ratio/2, 350+120+45);
    yearValueBtn.center=CGPointMake(5+ratio+5+ratio+5+ratio/2, 350+120+45);

    
    
    emailBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    emailBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:emailBaseView];
    emailBaseView.center=CGPointMake(self.frame.size.width/2, 300);
    
    
    passBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    passBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:passBaseView];
    passBaseView.center=CGPointMake(self.frame.size.width/2, 420);
    
    
    
    
    emailField.returnKeyType=UIReturnKeyNext;
    passField.returnKeyType=UIReturnKeyContinue;
    
    [emailField becomeFirstResponder];
    
    emailField.delegate=self;
    passField.delegate=self;
    
    [emailField addTarget:self
                   action:@selector(validationCheck:)
         forControlEvents:UIControlEventEditingChanged];


    [passField addTarget:self
action:@selector(validationCheck:)
forControlEvents:UIControlEventEditingChanged];
    
    
}

-(void)validationCheck:(id)sender
{
    int valid1=0;
    int valid2=0;
    int valid3=0;
    
    if([self NSStringIsValidEmail:emailField.text])
    {
        valid1=1;
        emailValidationSign.hidden=false;
    }
    else
    {
        emailValidationSign.hidden=true;
    }
    
    if([passField.text isEqualToString:@""])
    {
        passValidationSign.hidden=true;
    }
    else if([passField.text length]<8)
    {
        passValidationSign.hidden=true;
    }
    else if([passField.text containsString:@" "])
    {
        passValidationSign.hidden=true;
    }
    else
    {
        valid2=1;

        passValidationSign.hidden=false;
    }
    
    if(isDateSelected==1)
    {
        valid3=1;
    }
    
    
    if(valid1+valid2+valid3==3)
    {
        nextBtn.hidden=false;
    }
    else
    {
        nextBtn.hidden=true;
    }
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)setDOBStyleToLBL:(UIButton *)button
{
    [button setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:k_fontRegular size:25]];
    [button addTarget:self action:@selector(openCalendar:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(emailField==textField)
    {
        [emailField resignFirstResponder];
        [passField becomeFirstResponder];
    }
    else if(passField==textField)
    {
        [passField resignFirstResponder];
        [self openCalendar:nil];
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
    Func_nextBtnClicked=func;
    
}

-(void)nextBtnClicked:(id)sender
{
    if(nextBtn.hidden==false)
    {
     
        nextBtn.enabled=false;
        
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestTocheckIfUserExistWithEmail:[emailField.text lowercaseString] withDelegate:self andSelector:@selector(performNextIfPossible:)];
        
      
      
    }

}
-(void)performNextIfPossible:(APIResponseObj *)responseObj
{
 
    
    NSString *string=[responseObj.response valueForKey:@"exists"];
    if([[string lowercaseString] isEqualToString:@"true"])
    {
        NSLog(@"User Already Exists");
        
        
        emailValidationLBL.hidden=false;
        [emailField becomeFirstResponder];
        emailValidationLBL.text=[NSString stringWithFormat:@"'%@' already in use.",[emailField.text lowercaseString]];
        
        nextBtn.enabled=true;

    }
    else
    {
        
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormat setDateFormat:@"dd"];
    NSString *str1=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:dataSelectedDate]];
    
    
    [dateFormat setDateFormat:@"M"];
    NSString *str2=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:dataSelectedDate]];
    
    [dateFormat setDateFormat:@"yyyy"];
    NSString *str3=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:dataSelectedDate]];
    
    NSString *finalDate=[NSString stringWithFormat:@"%@-%@-%@",str3,str2,str1];
    
    
    [DataSession sharedInstance].signupObject.email=[emailField.text lowercaseString];
    [DataSession sharedInstance].signupObject.password=passField.text;
    [DataSession sharedInstance].signupObject.dob=finalDate;
    //2000-10-10
    
    [delegate performSelector:Func_nextBtnClicked withObject:nil afterDelay:0.01];
    }
}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];
    
}

-(void)forgetPassBtnClicked:(id)sender
{
    
}
-(void)openCalendar:(id)sender
{
    [passField resignFirstResponder];
    [emailField resignFirstResponder];

    
    popUpCalendar *c=[[popUpCalendar alloc] initWithFrame:self.bounds];
    [self addSubview:c];
    [c setTarget:self andFunc:@selector(dateSelected:)];
    [c setUp];
    
}
-(void)dateSelected:(NSDate *)date
{
    dataSelectedDate=date;
    
    isDateSelected=1;
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    
    [dateFormat setDateFormat:@"dd"];
    NSString *str1=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];

    
    [dateFormat setDateFormat:@"MMM"];
    NSString *str2=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];

    [dateFormat setDateFormat:@"yyyy"];
    NSString *str3=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:date]];

    [dateValueBtn setTitle:str1 forState:UIControlStateNormal];
    [monthValueBtn setTitle:str2 forState:UIControlStateNormal];
    [yearValueBtn setTitle:str3 forState:UIControlStateNormal];
    
    [dateValueBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateNormal];
    [monthValueBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateNormal];
    [yearValueBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateNormal];

    [self validationCheck:nil];
    

}
@end
@implementation popUpCalendar
-(void)setTarget:(id)delegate andFunc:(SEL)func
{
    target=delegate;
    dateSelected=func;
    
}
-(void)setUp
{
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:-1];

    
    datePicker =[[UIDatePicker alloc]initWithFrame:self.bounds];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.maximumDate=[NSDate date];
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePicker];
  //  datePicker.tintColor=[UIColor purpleColor];
    
    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    [self addSubview:doneBtn];
    doneBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:20];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"Submit" forState:UIControlStateNormal];
    doneBtn.backgroundColor=[UIColor redColor];
    [doneBtn addTarget:self action:@selector(dateSumbitted:) forControlEvents:UIControlEventTouchUpInside];


    self.alpha=0;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha=1;
    }];
    
}
-(void)dateSumbitted:(id)sender
{
    [target performSelector:dateSelected withObject:datePicker.date afterDelay:0.001];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)dateChanged:(id)sender
{
    
}

@end