//
//  HCDropDown.m
//  Exacto
//
//  Created by Hardik on 23/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HCDropDown.h"


@implementation HCDropDown
-(void)setPopUpPoint:(CGPoint)point
{
    popUpView.frame=CGRectMake(point.x-popUpView.frame.size.width/2, point.y-popUpView.frame.size.height, popUpView.frame.size.width, popUpView.frame.size.height);
}
-(void)setUp:(NSArray *)valueArray target:(id)tReceived callBack:(SEL)callBack;
{
    touchEnabled=1;
    self.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
    
    int btnHeight=50;
    popUpView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, btnHeight*valueArray.count)];
    [self addSubview:popUpView];
    popUpView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    popUpView.backgroundColor=[UIColor blackColor];
    
    
    values=valueArray;
    target=tReceived;
    callBackFunc=callBack;
    
    popUpView.clipsToBounds=YES;
    popUpView.layer.cornerRadius=5;
    
    
    
    
    for(int i=0;i<values.count;i++)
    {
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, btnHeight*i, popUpView.frame.size.width, btnHeight)];
    [popUpView addSubview:btn];
        [btn setTitle:[values objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont fontWithName:@"DINAlternate-Bold" size:15];
        btn.showsTouchWhenHighlighted=YES;
        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(touchEnabled==1)
    {
        touchEnabled=0;
    NSNumber *bum=[NSNumber numberWithInt:-1];

    [target performSelector:callBackFunc withObject:bum afterDelay:0.01];
    }

}
-(void)itemSelected:(UIButton *)sender
{
    NSNumber *bum=[NSNumber numberWithInt:(int)sender.tag];
    [target performSelector:callBackFunc withObject:bum afterDelay:0.01];
}
@end
