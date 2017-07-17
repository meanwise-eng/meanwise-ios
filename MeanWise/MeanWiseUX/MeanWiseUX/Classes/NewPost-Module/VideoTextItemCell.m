//
//  VideoTextItemCell.m
//  ExactResearch
//
//  Created by Hardik on 14/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "VideoTextItemCell.h"

@implementation VideoTextItemCell

-(void)setTarget:(id)targetM andtextchangeFunc:(SEL)selector andDeleteBtnClicked:(SEL)selector2;
{
    targetTextChange=targetM;
    textChangeFunc=selector;
    deleteBtnClickedFunc=selector2;
}
-(void)setTextValue:(NSString *)str andIndexPath:(int)path
{
    textView.text=str;
    pathMain=path;
    
}
-(void)updateIndexPath:(int)path
{
    pathMain=path;
}
-(void)setUpMainWithFrame:(CGRect)frame
{
    pathMain=-1;
    
    mainAreaView=[[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, 75+10)];
    [self addSubview:mainAreaView];
    mainAreaView.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.6f];
    
    
    textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width-50, 75)];
    [self addSubview:textView];
    textView.clipsToBounds=YES;
    
    self.backgroundColor=[UIColor clearColor];
    
    textView.backgroundColor=[UIColor clearColor];
    
    textView.textColor=[UIColor whiteColor];
    
    textView.font=[UIFont fontWithName:@"Avenir-Black" size:22];
    textView.delegate=self;
    
    self.clipsToBounds=YES;

    
    deleteDoneBtn=[self setUpBtnWithTitle:@"x" andSel:@selector(deleteBtnClicked:)];
    [self addSubview:deleteDoneBtn];
    deleteDoneBtn.center=CGPointMake(frame.size.width-25,2+25/2);
    
    counterLBL=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-40, 60, 25, 15)];
    [self addSubview:counterLBL];
    counterLBL.textAlignment=NSTextAlignmentCenter;
    counterLBL.text=@"100";
    counterLBL.textColor=[UIColor whiteColor];
    counterLBL.font=[UIFont fontWithName:@"Avenir-Black" size:10];

   // textView.userInteractionEnabled=false;
    
    isInEditMode=false;
}


-(void)deleteBtnClicked:(id)sender
{
    [targetTextChange performSelector:deleteBtnClickedFunc withObject:[NSNumber numberWithInt:pathMain] afterDelay:0.01];
}



-(UIButton *)setUpBtnWithTitle:(NSString *)str andSel:(SEL)selector
{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btn.titleLabel.font=[UIFont fontWithName:@"Avenir-Roman" size:12];
    btn.backgroundColor=[UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)setFrameX:(CGRect)rect
{
    textView.frame=CGRectMake(0, 2, rect.size.width-50, 75);
    mainAreaView.frame=CGRectMake(0, 2, rect.size.width, 75+10);
    
}
-(void)textViewDidChange:(UITextView *)textView1
{
    
    int number=100-(int)textView1.text.length;
    
    counterLBL.text=[NSString stringWithFormat:@"%d",number];
    
    if(number<0)
    {
        counterLBL.textColor=[UIColor whiteColor];
        counterLBL.backgroundColor=[UIColor redColor];
    }
    else
    {
        counterLBL.textColor=[UIColor whiteColor];
        counterLBL.backgroundColor=[UIColor clearColor];
    }

    CGSize size = [textView sizeThatFits:CGSizeMake(self.frame.size.width-50, FLT_MAX)];
    float height=size.height;
    
    if(height<75)
    {
        height=75;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        textView.frame=CGRectMake(0, 2, self.frame.size.width-50, height);
        mainAreaView.frame=CGRectMake(0, 2, self.frame.size.width, height+10);
        
    }];
    
    
    NSArray *array=[NSArray arrayWithObjects:[NSNumber numberWithInt:pathMain],textView.text,[NSNumber numberWithFloat:height],nil];
    [targetTextChange performSelector:textChangeFunc withObject:array afterDelay:0.01];
}


@end
