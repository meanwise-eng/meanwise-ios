//
//  LineProgressBar.m
//  ExactApp
//
//  Created by Hardik on 11/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "LineProgressBar.h"

@implementation LineProgressBar

-(void)setUp
{
    
    baseProgressView1=[[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, 8)];
    baseProgressView1.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.5];
    [self addSubview:baseProgressView1];
    baseProgressView1.layer.cornerRadius=4;
    
   
    progressView1=[[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, 8)];
    progressView1.backgroundColor=[UIColor yellowColor];
    [self addSubview:progressView1];
    progressView1.layer.cornerRadius=4;
   // self.layer.cornerRadius=2;
    
    
    labelMark1=[[UILabel alloc] initWithFrame:CGRectMake(0, 8, 40, 15)];
    [labelMark1 setText:@"30s"];
    labelMark1.adjustsFontSizeToFitWidth=YES;
    [self addSubview:labelMark1];
    labelMark1.backgroundColor=[UIColor blackColor];
    labelMark1.textAlignment=NSTextAlignmentCenter;
    labelMark1.font=[UIFont fontWithName:@"Avenir-Black" size:10];
    labelMark1.layer.cornerRadius=4;
    labelMark1.clipsToBounds=YES;
    labelMark1.textColor=[UIColor whiteColor];
    [self resetZero];
    [self setProValue:0.5];
    
}
-(void)resetZero;
{
    valueP=0;
    [self updateUI];
}

-(void)setProValue:(float)value
{
    
    
    valueP=value;
    [self updateUI];
}
-(float)getProValue;
{
    return valueP;
}




-(void)updateUI
{
    if(valueP==0)
    {
        [labelMark1 setText:@"0s"];
    }
    else
    {
        float value=valueP*25.0f;
        NSString *string=@"";
        if(value<=9)
        {
            string=[NSString stringWithFormat:@"00:0%1.0f",value];
        }
        else
        {
            string=[NSString stringWithFormat:@"00:%1.0f",value];
        }
        
        [labelMark1 setText:[NSString stringWithFormat:@"%@",string]];

    }
    
    progressView1.frame=CGRectMake(0, 0, self.bounds.size.width*valueP, 8);
    labelMark1.frame=CGRectMake(self.bounds.size.width*(valueP)-20, 9, 40, 15);
}







@end
