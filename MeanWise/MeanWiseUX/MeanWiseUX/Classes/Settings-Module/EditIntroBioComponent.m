//
//  EditIntroBioComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditIntroBioComponent.h"
#import "UserSession.h"
#import "ViewController.h"


@implementation EditIntroBioComponent

-(void)setUp
{
    
    
    

   
  
    
    
    [self setUpNavBarAndAll];
    
    bioBgView=[[UIView alloc] initWithFrame:CGRectMake(0, 66+70, self.frame.size.width, 55)];
    [self addSubview:bioBgView];
    [self styleTextFieldStyle:bioBgView];
    
    bioTextView=[[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 55)];
    bioTextView.backgroundColor=[UIColor clearColor];
    bioTextView.textColor=[UIColor blackColor];
    bioTextView.font=[UIFont fontWithName:k_fontSemiBold size:18];
    [bioBgView addSubview:bioTextView];
    bioTextView.delegate=self;
    
    
    NSString *temp=[UserSession getBioText];
    
    if(temp.class!=[NSNull class])
    {
        bioTextView.text=temp;
    }
    
    
    // msgContactTable.bounces=false;
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    //CGRect frame=textView.frame;
    
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    
    bioBgView.frame=CGRectMake(0, 66+70, self.frame.size.width, newFrame.size.height);
  
    
}

-(void)styleTextFieldStyle:(UIView *)view
{

    view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
}
-(void)setUpNavBarAndAll
{
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;
    
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    UIView *seperator=[[UIView alloc] initWithFrame:CGRectMake(0,65,self.frame.size.width, 1)];
    [self addSubview:seperator];
    seperator.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0f];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Intro";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    instructionField=[[UILabel alloc] initWithFrame:CGRectMake(30, 66, self.frame.size.width-60, 70)];
    instructionField.backgroundColor=[UIColor whiteColor];
    instructionField.font=[UIFont fontWithName:k_fontBold size:11];
    instructionField.textAlignment=NSTextAlignmentCenter;
    instructionField.text=@"This is your elevator pitch. Tell the world what you are good at. Bragging is allowed.";
    instructionField.textColor=[UIColor lightGrayColor];
    [self addSubview:instructionField];
    instructionField.numberOfLines=3;
    
    saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    [self addSubview:saveBtn];
    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    saveBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:17];
    saveBtn.backgroundColor=[UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
    [saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)saveBtnClicked:(id)sender
{
    //NSString *bioText=bioTextView.text;
    
    NSDictionary *dict=@{
                          @"bio":bioTextView.text,
                          };
    
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t updateProfileWithDict:dict];

    
    
}


-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}





@end
