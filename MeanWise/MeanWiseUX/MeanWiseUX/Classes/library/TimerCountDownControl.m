//
//  TimerCountDownControl.m
//  Exacto
//
//  Created by Hardik on 23/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "TimerCountDownControl.h"

@implementation TimerCountDownControl

-(void)setTarget:(id)tReceived callBack:(SEL)callBack;
{
    target=tReceived;
    callBackFunc=callBack;

}
-(void)setUpWithTime:(int)seconds
{
    totalTime=seconds+1;
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2f];
    label=[[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:label];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:@"DINAlternate-Bold" size:80];
    label.text=[NSString stringWithFormat:@"%d",totalTime];
    label.alpha=0;
    label.textColor=[UIColor whiteColor];
    
    [self performSelector:@selector(coundDownIterate:) withObject:nil afterDelay:1.0f];
    
}
-(void)coundDownIterate:(id)sender
{
    totalTime--;

    if(totalTime!=0)
    {
        label.alpha=1;
        label.transform=CGAffineTransformMakeScale(1, 1);

        [UIView animateWithDuration:0.5 animations:^{
            label.alpha=0.5;
            label.transform=CGAffineTransformMakeScale(1.2, 1.2);

        }];

        label.text=[NSString stringWithFormat:@"%d",totalTime];

    [self performSelector:@selector(coundDownIterate:) withObject:nil afterDelay:1.0f];
    }
    else
    {
        [target performSelector:callBackFunc withObject:nil afterDelay:1.0f];

    }

}



@end
