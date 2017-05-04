//
//  LoginComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "LoginComponent.h"
#import "TermsOfUse.h"
#import "PrivacyPolicy.h"
#import "SDiOSVersion.h"

@implementation LoginComponent

-(void)setUp
{
    
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:1];


    logoImg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,90,90)];
    [self addSubview:logoImg];
    logoImg.image=[UIImage imageNamed:@"mean.png"];
    logoImg.contentMode=UIViewContentModeScaleAspectFit;
    logoImg.center=CGPointMake(self.frame.size.width/2, 160);
    
    
    
    
    subTitleLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    subTitleLBL.text=@"Work. Life. Balance.";
    subTitleLBL.textColor=[UIColor whiteColor];
    subTitleLBL.textAlignment=NSTextAlignmentCenter;
    subTitleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:30];

    
    if ([SDiOSVersion deviceSize] == Screen5Dot5inch){
        subTitleLBL.center=CGPointMake(self.frame.size.width/2, 260);
    }
    else if([SDiOSVersion deviceSize] == Screen4Dot7inch){
        subTitleLBL.center=CGPointMake(self.frame.size.width/2, 260);
    }
    else{
        subTitleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:24];
        subTitleLBL.center=CGPointMake(self.frame.size.width/2, 260);
    }
    
    
    [self addSubview:subTitleLBL];
    
    
    topLogin=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 20, 100, 50)];
    [topLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topLogin setTitle:@"LOG IN" forState:UIControlStateNormal];
    [topLogin setShowsTouchWhenHighlighted:YES];
    topLogin.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:13];
    [topLogin addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:topLogin];
    
    
    
    fbLoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-80, 50)];
    fbLoginBtn.backgroundColor=[UIColor whiteColor];
    [fbLoginBtn setTitleColor:[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    [fbLoginBtn setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [fbLoginBtn setShowsTouchWhenHighlighted:YES];
    fbLoginBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];
    fbLoginBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [fbLoginBtn addTarget:self action:@selector(fbLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   // [self addSubview:fbLoginBtn];
    fbLoginBtn.center=CGPointMake(self.frame.size.width/2, 360);
    fbLoginBtn.layer.cornerRadius=2.0;
    
    emLoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-80, 50)];
    emLoginBtn.backgroundColor=[UIColor whiteColor];
    [emLoginBtn setTitleColor:[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    [emLoginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [emLoginBtn setShowsTouchWhenHighlighted:YES];
    emLoginBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];
    emLoginBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [emLoginBtn addTarget:self action:@selector(loginWithEmailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emLoginBtn];
    emLoginBtn.center=CGPointMake(self.frame.size.width/2, 360);
    emLoginBtn.layer.cornerRadius=2.0;
    
    
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 26, 26)];
    imageView.image=[UIImage imageNamed:@"facebookSignupIcon.png"];
    [fbLoginBtn addSubview:imageView];
    imageView.userInteractionEnabled=false;
    
    
    createAccountBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-80, 50)];
    createAccountBtn.backgroundColor=[UIColor clearColor];
    [createAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createAccountBtn setTitle:@"Create Account" forState:UIControlStateNormal];
    [createAccountBtn setShowsTouchWhenHighlighted:YES];
    createAccountBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:15];
    createAccountBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [createAccountBtn addTarget:self action:@selector(createAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:createAccountBtn];
    createAccountBtn.layer.borderWidth=0.5;
    createAccountBtn.layer.cornerRadius=2.0;
    createAccountBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    createAccountBtn.center=CGPointMake(self.frame.size.width/2, 420);
    
    
    loginWithEmailBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-80, 50)];
    [loginWithEmailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginWithEmailBtn setTitle:@"Login with email" forState:UIControlStateNormal];
    [loginWithEmailBtn setShowsTouchWhenHighlighted:YES];
    loginWithEmailBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:15];
    loginWithEmailBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [loginWithEmailBtn addTarget:self action:@selector(loginWithEmailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   // [self addSubview:loginWithEmailBtn];
    loginWithEmailBtn.center=CGPointMake(self.frame.size.width/2, 480);


    
    infoLabel=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-80, 40)];
    [self addSubview:infoLabel];
    infoLabel.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-40);

    infoLabel.backgroundColor=[UIColor clearColor];
    infoLabel.font=[UIFont fontWithName:k_fontRegular size:12];
    infoLabel.textColor=[UIColor whiteColor];

   
    infoLabel.linkAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    infoLabel.lineBreakMode=NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;
    infoLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    infoLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(__bridge NSString *)kCTUnderlineStyleAttributeName];
    
    
    infoLabel.text = @"By signing up, I agree to Meanwise's Terms of Service and Privacy Policy"; // Repository URL will be automatically detected and linked
    
    {
    NSRange range = [infoLabel.text rangeOfString:@"Terms of Service"];
    [infoLabel addLinkToURL:[NSURL URLWithString:@"TERMS"] withRange:range]; // Embedding a custom link in a substring
    
    }
    
    {
        
        NSRange range = [infoLabel.text rangeOfString:@"Privacy Policy"];
        [infoLabel addLinkToURL:[NSURL URLWithString:@"PRIVACY"] withRange:range]; // Embedding a custom link in a substring
        
    }
    

    infoLabel.textColor=[UIColor whiteColor];


   /* NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"By Signing up, I agree to Meanwise's Terms of Service and Privacy Policy."];
*/

    
    infoLabel.delegate=self;
    
    

    
}
- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    
    NSLog(@"%@",url.absoluteString);
    
    if([url.absoluteString isEqualToString:@"TERMS"])
    {
        
        TermsOfUse *Compo=[[TermsOfUse alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
        
     
    }
    else if ([url.absoluteString isEqualToString:@"PRIVACY"])
    {
        PrivacyPolicy *Compo=[[PrivacyPolicy alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
        
    }
    
}
-(void)backFromSetting:(id)sender
{
    
}
-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    Func_normalLoginBtnClicked=func;
    
}
-(void)setTarget:(id)target andFunc2:(SEL)func;
{
    delegate=target;
    Func_signUpBtnClicked=func;
    
}

-(void)loginWithEmailBtnClicked:(id)sender
{
    [delegate performSelector:Func_normalLoginBtnClicked withObject:nil afterDelay:0.01];
}


-(void)createAccountBtnClicked:(id)sender
{
    [delegate performSelector:Func_signUpBtnClicked withObject:nil afterDelay:0.01];

}

-(void)fbLoginBtnClicked:(id)sender
{
    
}

-(void)loginBtnClicked:(id)sender
{
    [delegate performSelector:Func_normalLoginBtnClicked withObject:nil afterDelay:0.01];

    
}
@end
