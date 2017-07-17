//
//  SignUpWizardName.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SignUpWizardInviteComponent.h"

@implementation SignUpWizardInviteComponent

-(void)setUp
{
    self.backgroundColor=[UIColor colorWithRed:0.35 green:0.49 blue:0.55 alpha:1.00];
    
    
    
    headLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 40)];
    [self addSubview:headLBL];
    headLBL.text=@"Invite friends";
    headLBL.textColor=[UIColor whiteColor];
    headLBL.textAlignment=NSTextAlignmentLeft;
    headLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:28];
    headLBL.center=CGPointMake(self.frame.size.width/2, 140);
    
    subHeadLBL=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 60)];
    [self addSubview:subHeadLBL];
    subHeadLBL.numberOfLines=2;
    subHeadLBL.text=@"Let your friends know you are here.";
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
    
    NSArray *array=[[NSArray alloc] initWithObjects:@"ContactsIcon.png",@"FacebookIcon.png",@"TwitterIcon.png",@"GoogleIcon", nil];

    NSArray *arrayBtnTitle=[[NSArray alloc] initWithObjects:@"Invite friends from your Contacts",@"Invite Facebook friends",@"Invite your twitter friends",@"Invite your Gmail contacts", nil];

    
    
    for(int i=0;i<4;i++)
    {
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 250+i*80, self.frame.size.width-40, 60)];
        [self addSubview:btn];
        btn.backgroundColor=[UIColor whiteColor];
        
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        [btn addSubview:image];
        image.image=[UIImage imageNamed:[array objectAtIndex:i]];
        image.contentMode=UIViewContentModeScaleAspectFit;
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(80, 10, 300, 40)];
        [btn addSubview:label];
        label.text=[arrayBtnTitle objectAtIndex:i];
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont fontWithName:k_fontSemiBold size:13];

        if(i==0)
        {
            label.textColor=[UIColor colorWithRed:0.38 green:0.49 blue:0.55 alpha:1.00];
        }
        if(i==1)
        {
            label.textColor=[UIColor colorWithRed:0.36 green:0.42 blue:0.75 alpha:1.00];
        }
        if(i==2)
        {
            label.textColor=[UIColor colorWithRed:0.31 green:0.67 blue:0.95 alpha:1.00];
        }
        if(i==3)
        {
            label.textColor=[UIColor colorWithRed:0.24 green:0.51 blue:0.97 alpha:1.00];
        }
        
    }
    
    
    
}

-(void)setTarget:(id)target andFunc1:(SEL)func;
{
    delegate=target;
    Func_backBtnClicked=func;
    
}
-(void)setTarget:(id)target andFunc2:(SEL)func;
{
    delegate=target;
    Func_successFullLoginBtnClicked=func;
    
}

-(void)nextBtnClicked:(id)sender
{
   [delegate performSelector:Func_successFullLoginBtnClicked withObject:nil afterDelay:0.01];

}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:Func_backBtnClicked withObject:nil afterDelay:0.01];

}

-(void)forgetPassBtnClicked:(id)sender
{
    
}

@end
