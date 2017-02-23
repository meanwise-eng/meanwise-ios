//
//  LoginScreenComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "LoginScreenComponent.h"

@implementation LoginScreenComponent

-(void)setUp
{
    
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:2];

    

    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Login";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontBold size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    forgetPassBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-190, 20,180, 50)];
    [forgetPassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetPassBtn setTitle:@"FORGOT PASSWORD?" forState:UIControlStateNormal];
    forgetPassBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];
    [forgetPassBtn addTarget:self action:@selector(forgetPassBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetPassBtn];
    
    
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
    
    emailField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:emailField];
    emailField.center=CGPointMake(self.frame.size.width/2, 230+45);
    emailField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    emailField.autocorrectionType=UITextAutocorrectionTypeNo;
    

    emailValidationSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:emailValidationSign];
    emailValidationSign.center=CGPointMake(self.frame.size.width-40, 230+45);
    emailValidationSign.image=[UIImage imageNamed:@"Checkmark.png"];
    emailValidationSign.hidden=true;
    
    
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
    passField.secureTextEntry=true;
    

    emailBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    emailBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:emailBaseView];
    emailBaseView.center=CGPointMake(self.frame.size.width/2, 300);

    passBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    passBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:passBaseView];
    passBaseView.center=CGPointMake(self.frame.size.width/2, 420);

    [emailField setReturnKeyType:UIReturnKeyNext];
    [passField setReturnKeyType:UIReturnKeyContinue];

    [emailField becomeFirstResponder];
    
    emailField.delegate=self;
    passField.delegate=self;
    
    [emailField addTarget:self
                    action:@selector(emailTextChange:)
          forControlEvents:UIControlEventEditingChanged];

}
-(void)emailTextChange:(id)sender
{
    if([self NSStringIsValidEmail:emailField.text])
    {
        emailValidationSign.hidden=false;
    }
    else
    {
        emailValidationSign.hidden=true;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==emailField)
    {
        [emailField resignFirstResponder];
        [passField becomeFirstResponder];
    }
    else if(passField==textField)
    {
        [passField resignFirstResponder];
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
    Func_forgetPassBtnClicked=func;
}
-(void)setTarget:(id)target andFunc3:(SEL)func;
{
    delegate=target;
    Func_successFullLoginBtnClicked=func;
    
}
-(void)nextBtnClicked:(id)sender
{
    
    
    allSubviews=[[NSMutableArray alloc] init];

    [UIView animateKeyframesWithDuration:0.2f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        
       // emailField.text=@"max9xs";
       // passField.text=@"pass123456";
        
        
            for (UIView *subview in self.subviews)
            {
                subview.alpha=0;
            }
        
    } completion:^(BOOL finished) {
        
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:emailField.text,@"email",passField.text,@"password", nil];
        
        loader=[[LoginTransitionScreen alloc] initWithFrame:self.bounds];
        [loader setUpForLogin:self andFunc1:@selector(loginSuccessfully:) andFunc2:@selector(loginFailed:) andDict:dict];
        [self addSubview:loader];

    }];
 

  
    
    
    

    
}
-(void)loginSuccessfully:(id)sender
{
    
    

    [delegate performSelector:Func_successFullLoginBtnClicked withObject:nil afterDelay:0.01];

    
}
-(void)loginFailed:(NSDictionary *)dict
{
    [UIView animateKeyframesWithDuration:2.0f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        
        
        for (UIView *subview in self.subviews)
        {
            if(subview!=loader)
            {
                subview.alpha=1;
            }
        }
        loader.alpha=0;
        
    } completion:^(BOOL finished) {
        
        
        [loader removeFromSuperview];
        
    }];
    
}


-(void)backBtnClicked:(id)sender
{
    
    [emailField resignFirstResponder];
    [passField resignFirstResponder];
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}

-(void)forgetPassBtnClicked:(id)sender
{
    [delegate performSelector:Func_forgetPassBtnClicked withObject:nil afterDelay:0.01];

}

@end
