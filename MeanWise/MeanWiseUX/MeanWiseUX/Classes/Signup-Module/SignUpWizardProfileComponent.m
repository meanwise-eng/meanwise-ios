//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardProfileComponent.h"

@implementation SignUpWizardProfileComponent

-(void)setUp
{
    proffesionPicker=nil;
    self.backgroundColor=[UIColor clearColor];
    [Constant setUpGradient:self style:8];

    
    int heightx1=25;
    int heightx2=50;
    int heightx3=45;
    
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Profile";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    subHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 60)];
    [self addSubview:subHeadLBL];
    subHeadLBL.numberOfLines=2;
    subHeadLBL.text=@"Make yourself stand out from the crowd.";
    subHeadLBL.textColor=[UIColor whiteColor];
    subHeadLBL.textAlignment=NSTextAlignmentLeft;
    subHeadLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    subHeadLBL.center=CGPointMake(self.frame.size.width/2, 180);
    
    
    
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
    
    
    
    int YHeight=220;

    
    emailHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:emailHeadLBL];
    emailHeadLBL.text=@"USERNAME";
    emailHeadLBL.textColor=[UIColor whiteColor];
    emailHeadLBL.textAlignment=NSTextAlignmentLeft;
    emailHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    emailHeadLBL.center=CGPointMake(self.frame.size.width/2, YHeight);
    
    YHeight=YHeight+heightx2;
    
    userNameField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:userNameField];
    userNameField.center=CGPointMake(self.frame.size.width/2, YHeight);

    YHeight=YHeight+heightx1;

    emailBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    emailBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:emailBaseView];
    emailBaseView.center=CGPointMake(self.frame.size.width/2, 300);

    YHeight=YHeight+heightx3;
    
    
    passHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:passHeadLBL];
    passHeadLBL.text=@"PROFESSION";
    passHeadLBL.textColor=[UIColor whiteColor];
    passHeadLBL.textAlignment=NSTextAlignmentLeft;
    passHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    passHeadLBL.center=CGPointMake(self.frame.size.width/2, YHeight);
    
    YHeight=YHeight+heightx2;

    
    profFieldBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:profFieldBtn];
    profFieldBtn.center=CGPointMake(self.frame.size.width/2, YHeight);
    [profFieldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [profFieldBtn setBackgroundColor:[UIColor clearColor]];
    profFieldBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:25];
    profFieldBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [profFieldBtn setTitle:@"Hello" forState:UIControlStateNormal];
    [profFieldBtn addTarget:self action:@selector(proffesionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    /*profField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:profField];
    profField.center=CGPointMake(self.frame.size.width/2, YHeight);*/

    YHeight=YHeight+heightx1;

    
    passBaseView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    passBaseView.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:passBaseView];
    passBaseView.center=CGPointMake(self.frame.size.width/2, YHeight);
    
    YHeight=YHeight+heightx3;

   // YHeight=YHeight-10;
    
    bioHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 15)];
    [self addSubview:bioHeadLBL];
    bioHeadLBL.text=@"BIO";
    bioHeadLBL.textColor=[UIColor whiteColor];
    bioHeadLBL.textAlignment=NSTextAlignmentLeft;
    bioHeadLBL.font=[UIFont fontWithName:k_fontBold size:15];
    bioHeadLBL.center=CGPointMake(self.frame.size.width/2, YHeight);
    
//    UITextField *bioField=[Constant textField_Style1_WithRect:CGRectMake(20, 0, self.frame.size.width-40, 50)];
//    [self addSubview:bioField];
//    bioField.center=CGPointMake(self.frame.size.width/2, 470+45);

    YHeight=YHeight+20+15;

    
    bioTXT=[[UITextView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 50)];
    [self addSubview:bioTXT];
    
    bioTXT.center=CGPointMake(self.frame.size.width/2, YHeight);
    bioTXT.tintColor=[UIColor whiteColor];
    bioTXT.textColor=[UIColor whiteColor];
    bioTXT.font=[UIFont fontWithName:k_fontRegular size:25];
    bioTXT.keyboardAppearance=UIKeyboardAppearanceDark;
    bioTXT.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
   // bioTXT.text=@"This is the idea to think what we can do";
    bioTXT.delegate=self;
    
    YHeight=YHeight-30+45;
    
    bioBaseHeight=YHeight;
    
    bioBaseView1=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    bioBaseView1.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:bioBaseView1];
    bioBaseView1.center=CGPointMake(self.frame.size.width/2, YHeight);

  /*  YHeight=YHeight+35;

    bioBaseView2=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    bioBaseView2.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:bioBaseView2];
    bioBaseView2.center=CGPointMake(self.frame.size.width/2, YHeight);

    YHeight=YHeight+35;
    
    bioBaseView3=[[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 1)];
    bioBaseView3.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    [self addSubview:bioBaseView3];
    bioBaseView3.center=CGPointMake(self.frame.size.width/2, YHeight);*/

    userNameField.delegate=self;
    
    userNameField.returnKeyType=UIReturnKeyNext;
    bioTXT.returnKeyType=UIReturnKeyDefault;
    bioTXT.enablesReturnKeyAutomatically=YES;
    
    [userNameField becomeFirstResponder];
    
    

    
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
   // CGRect frame=textView.frame;
    

    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;

    
    
    bioBaseView1.center=CGPointMake(self.frame.size.width/2, bioBaseHeight+newFrame.size.height-50);

    
/*    //Access the textView Content
    //From here you can get the last text entered by the user
    NSArray *stringsSeparatedBySpace = [textView.text componentsSeparatedByString:@" "];
    //then you can check whether its one of your userstrings and trigger the event
    NSString *lastString = [stringsSeparatedBySpace lastObject];
    if([lastString isEqualToString:@"http://www.stackoverflow.com"]) //add more conditions here
    {
        [self callActionMethod];
    }*/
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==userNameField)
    {
        
        [userNameField resignFirstResponder];
        [self proffesionBtnClicked:nil];
        
    }
   /* else if(profField==textField)
    {
        [profField resignFirstResponder];
        [bioTXT becomeFirstResponder];
    }*/
    
    return true;
}
-(void)proffesionBtnClicked:(id)sender
{
    if(proffesionPicker==nil)
    {
        proffesionPicker=[[ProffesionComponent alloc] initWithFrame:self.bounds];
        [self addSubview:proffesionPicker];
        [proffesionPicker setUp];
        [proffesionPicker setTarge:self andOnProffSelect:@selector(proffesionSelected:)];


        
    }
    
}
-(void)proffesionSelected:(NSDictionary *)object
{
    
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
    [delegate performSelector:Func_nextBtnClicked withObject:nil afterDelay:0.01];

}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];
    
}

-(void)forgetPassBtnClicked:(id)sender
{
    
}

@end
