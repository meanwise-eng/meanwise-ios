//
//  EditStoryComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "EditStoryComponent.h"
#import "ViewController.h"
#import "FTIndicator.h"


@implementation EditStoryComponent

-(void)setUp
{
    
   // UITextView *storyDescTV;
  //  UIView *storyDescBGV;
    
    [self setUpNavBarAndAll];
    
    noOfCharacters=350;
    
    limitIndicatorLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 66+70, self.frame.size.width, 20)];
    [self addSubview:limitIndicatorLBL];
    limitIndicatorLBL.textAlignment=NSTextAlignmentCenter;
    limitIndicatorLBL.font=[UIFont fontWithName:k_fontBold size:15];
    limitIndicatorLBL.textColor=[UIColor blackColor];
    

    
    
    
    
    storyDescBGV=[[UIView alloc] initWithFrame:CGRectMake(0, 66+90, self.frame.size.width, 100)];
    [self addSubview:storyDescBGV];
    storyDescBGV.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    storyDescTV=[[SAMTextView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 100)];
    storyDescTV.backgroundColor=[UIColor clearColor];
    storyDescTV.textColor=[UIColor blackColor];
    storyDescTV.font=[UIFont fontWithName:k_fontRegular size:18];
    [storyDescBGV addSubview:storyDescTV];
    storyDescTV.delegate=self;
    storyDescTV.scrollEnabled=false;
    storyDescTV.placeholder=@"Type here..";
    
    
    NSString *storyDesc=[UserSession getProfileStoryDesc];
    
    [storyDescTV becomeFirstResponder];
  
    if(storyDesc.class!=[NSNull class])
    {
    storyDescTV.text=storyDesc;
    }

    // msgContactTable.bounces=false;
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    //CGRect frame=textView.frame;
    
    int len =(int)textView.text.length;
    noOfCharacters=350-len;
    limitIndicatorLBL.text=[NSString stringWithFormat:@"%i",noOfCharacters];
    //
    if(noOfCharacters<0)
    {
        textView.textColor=[UIColor redColor];
        limitIndicatorLBL.textColor=[UIColor redColor];
    }
    else
    {
        textView.textColor=[UIColor blackColor];
        limitIndicatorLBL.textColor=[UIColor blackColor];
    }

    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    
    int height=100;
    if(newSize.height>100)
    {
        height=newSize.height;
    }
    
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), height);
    textView.frame = newFrame;
    
   
    
    
    storyDescBGV.frame=CGRectMake(0, 66+90, self.frame.size.width, newFrame.size.height);
    
    
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
    navBarTitle.text=@"Story";
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
    instructionField.text=@"Tell the world who you are what you are good at.\nBragging is allowed";
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
    
    int len =(int)storyDescTV.text.length;
    
    if(len>350)
    {
        [FTIndicator showToastMessage:@"Sorry you are exceeding the limit of characters."];
    }
    else
    {
    
    NSDictionary *dict=@{
                         @"profile_story_title":@"",
                         @"profile_story_description":storyDescTV.text,
                         
                         };
    
    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
    ViewController *t=(ViewController *)vc.topViewController;
    [t updateProfileWithDict:dict];
    }

}

-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
        [storyDescTV resignFirstResponder];
    
    [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}





@end
