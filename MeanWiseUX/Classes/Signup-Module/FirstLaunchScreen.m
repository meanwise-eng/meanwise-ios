//
//  FirstLaunchControl.m
//  MeanWiseUX
//
//  Created by Hardik on 29/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "FirstLaunchScreen.h"
#import "WalkthroughControl.h"
#import "LoginComponent.h"
#import "LoginScreenComponent.h"
#import "SignUpWizardNameComponent.h"
#import "ForgetPassComponent.h"
#import "SignupWizardTellusMore.h"
#import "SignUpWizardProfileComponent.h"
#import "SignUpWizardInterestComponent.h"
#import "SignUpWizardAppearanceComponent.h"
#import "SignUpWizardInviteComponent.h"
#import "SignUpWizardSkillsComponent.h"



@implementation FirstLaunchScreen

-(void)setUp
{

    
  /*  WalkthroughControl *c=[self create_WalkthroughControl];
    [c setTarget:self andFunc1:@selector(walkthroughSkipped:)];
    
    [c setTarget:self andFunc01:@selector(normalLoginBtnClicked:)];
    [c setTarget:self andFunc02:@selector(signupNormalClicked:)];

    
*/
    LoginComponent *c=[self create_LoginComponent];
    [c setTarget:self andFunc1:@selector(normalLoginBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalClicked:)];
    [self transitionToNextScreen:c];

    
    arrayStack=[[NSMutableArray alloc] initWithObjects:c, nil];
    
   // [self signupNormalAppearanceBtnClicked:nil];
    
    
    //SignUpWizardInterestComponent *c=[self create_SignUpWizardInterestComponent];
    //c.frame=self.bounds;
    
    
}
-(void)setTarget:(id)target withFunction:(SEL)func
{
    delegate=target;
    Func_signInFinished=func;
    
}
-(void)gotoHomeScreen:(id)sender
{
    [delegate performSelector:Func_signInFinished withObject:nil afterDelay:0.01];
    
  
    

    
}
#pragma mark - Events

-(void)walkthroughSkipped:(id)sender
{
    LoginComponent *c=[self create_LoginComponent];
    [c setTarget:self andFunc1:@selector(normalLoginBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalClicked:)];
    [self transitionToNextScreen:c];
    
    /*
    SignUpWizardInterestComponent *c=[self create_SignUpWizardInterestComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    // [c setTarget:self andFunc2:@selector(signupNormalProfileBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalAppearanceBtnClicked:)];
    
    [self transitionToNextScreen:c];
     
     */
    
}
-(void)forgetPassBtnClicked:(id)sender
{
    ForgetPassComponent *c=[self create_ForgetPassComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [self transitionToNextScreen:c];
}

-(void)signupNormalClicked:(id)sender
{
    SignUpWizardNameComponent *c=[self create_SignUpWizardNameComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalTellusMoreBtnClicked:)];
    [self transitionToNextScreen:c];
    
}

-(void)normalLoginBtnClicked:(id)sender
{
    LoginScreenComponent *c=[self create_LoginScreenComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [c setTarget:self andFunc2:@selector(forgetPassBtnClicked:)];
    [c setTarget:self andFunc3:@selector(gotoHomeScreen:)];

    [self transitionToNextScreen:c];
}
-(void)signupNormalTellusMoreBtnClicked:(id)sender
{
    
    SignupWizardTellusMore *c=[self create_SignupWizardTellusMore];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalSkillBtnClicked:)];
    [self transitionToNextScreen:c];
    
    
}
-(void)signupNormalSkillBtnClicked:(id)sender
{
    SignUpWizardSkillsComponent *c=[self create_SignUpWizardSkillsComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalInterestBtnClicked:)];

    [self transitionToNextScreen:c];
    
}
-(void)signupNormalInterestBtnClicked:(id)sender
{
    SignUpWizardInterestComponent *c=[self create_SignUpWizardInterestComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
   // [c setTarget:self andFunc2:@selector(signupNormalProfileBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalAppearanceBtnClicked:)];

    [self transitionToNextScreen:c];
    
    
}

-(void)signupNormalProfileBtnClicked:(id)sender
{
    SignUpWizardProfileComponent *c=[self create_SignUpWizardProfileComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [c setTarget:self andFunc2:@selector(signupNormalAppearanceBtnClicked:)];

    [self transitionToNextScreen:c];

}

-(void)signupNormalAppearanceBtnClicked:(id)sender
{
    SignUpWizardAppearanceComponent *c=[self create_SignUpWizardAppearanceComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
  //  [c setTarget:self andFunc2:@selector(signupNormalInviteBtnClicked:)];
    [c setTarget:self andFunc2:@selector(gotoHomeScreen:)];

    [self transitionToNextScreen:c];

    
}
-(void)signupNormalInviteBtnClicked:(id)sender
{
    SignUpWizardInviteComponent *c=[self create_SignUpWizardInviteComponent];
    [c setTarget:self andFunc1:@selector(backBtnClicked:)];
    [c setTarget:self andFunc2:@selector(gotoHomeScreen:)];
    [self transitionToNextScreen:c];

}




-(void)backBtnClicked:(id)sender
{
    [self transitionToPrevScreen];
}

#pragma mark - Transition
-(void)transitionToPrevScreen
{
    
    UIView *currentView=[arrayStack objectAtIndex:arrayStack.count-1];
    UIView *prevView=[arrayStack objectAtIndex:arrayStack.count-2];
    
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:2 options:UIViewAnimationOptionCurveLinear animations:^{
        
        prevView.frame=self.bounds;
        currentView.frame=CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height);
        
    } completion:^(BOOL finished) {
        

        [currentView removeFromSuperview];
        [arrayStack removeLastObject];
        
    }];
    
    
    
}

-(void)showAlert
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert showAlertWithTitle:@"Alert Title"
                 withSubtitle:@"This is your alert's subtitle. Keep it short and concise. 😜👌"
              withCustomImage:nil
          withDoneButtonTitle:nil
                   andButtons:nil];
    
    
    [alert addButton:@"Button1" withActionBlock:^{
        // Put your action here
    }];
    
    [alert addButton:@"Button2" withActionBlock:^{
        // Put your action here
    }];
    
    alert.firstButtonTitleColor = [UIColor blueColor];
    alert.secondButtonTitleColor = [UIColor blueColor];
    
    alert.firstButtonBackgroundColor = [UIColor whiteColor];
    alert.secondButtonBackgroundColor = [UIColor blackColor];
    alert.blurBackground = YES;
    alert.fullCircleCustomImage = YES;
    alert.animateAlertInFromTop = YES; // Change "Top" to "Bottom", "Left", or "Right" as you desire
    alert.animateAlertOutToTop = YES; // Change "Top" to "Bottom", "Left", or "Right" as you desire
    [alert addTextFieldWithPlaceholder:@"Email Address" andTextReturnBlock:^(NSString *text) {
        NSLog(@"The Email Address is: %@", text); // Do what you'd like with the text returned from the field
    }];
    

}
-(void)transitionToNextScreen:(UIView *)c
{
   
    
    UIView *previousView=[arrayStack objectAtIndex:arrayStack.count-1];
    
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:2 options:UIViewAnimationOptionCurveLinear animations:^{
        
        c.frame=self.bounds;
        previousView.frame=CGRectMake(-self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height);

    } completion:^(BOOL finished) {
        
        [arrayStack addObject:c];

    }];
    
   
    
}

#pragma mark - Control Create

-(WalkthroughControl *)create_WalkthroughControl
{
    WalkthroughControl *c=[[WalkthroughControl alloc] initWithFrame:self.bounds];
    [self addSubview:c];
    [c setUp];
    return c;
}

-(LoginComponent *)create_LoginComponent
{
    LoginComponent *c=[[LoginComponent alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(LoginScreenComponent *)create_LoginScreenComponent
{
    LoginScreenComponent *c=[[LoginScreenComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignUpWizardNameComponent *)create_SignUpWizardNameComponent
{
    SignUpWizardNameComponent *c=[[SignUpWizardNameComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(ForgetPassComponent *)create_ForgetPassComponent
{
    ForgetPassComponent *c=[[ForgetPassComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignupWizardTellusMore *)create_SignupWizardTellusMore
{
    SignupWizardTellusMore *c=[[SignupWizardTellusMore alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignUpWizardSkillsComponent *)create_SignUpWizardSkillsComponent
{
    SignUpWizardSkillsComponent *c=[[SignUpWizardSkillsComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignUpWizardProfileComponent *)create_SignUpWizardProfileComponent
{
    SignUpWizardProfileComponent *c=[[SignUpWizardProfileComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignUpWizardAppearanceComponent *)create_SignUpWizardAppearanceComponent
{
    SignUpWizardAppearanceComponent *c=[[SignUpWizardAppearanceComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignUpWizardInviteComponent *)create_SignUpWizardInviteComponent
{
    SignUpWizardInviteComponent *c=[[SignUpWizardInviteComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}
-(SignUpWizardInterestComponent *)create_SignUpWizardInterestComponent
{
    SignUpWizardInterestComponent *c=[[SignUpWizardInterestComponent alloc] initWithFrame:CGRectMake(self.bounds.size.width,0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:c];
    [c setUp];
    return c;
}






@end
