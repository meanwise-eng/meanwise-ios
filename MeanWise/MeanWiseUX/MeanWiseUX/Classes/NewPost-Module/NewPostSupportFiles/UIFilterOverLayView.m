//
//  UIFilterOverLayView.m
//  VideoPlayerDemo
//
//  Created by Hardik on 27/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UIFilterOverLayView.h"
#import "FTIndicator.h"

@implementation UIFilterOverLayView

-(void)setUp
{
    mainViews=[[NSMutableArray alloc] init];
    
    
    effectNo=0;
    
    
}
-(void)cleanUp
{
    
}
-(void)removeFirstView:(CGPoint)point
{
    
   
}
-(void)generateNewEffectPoint:(CGPoint)point
{
    
}
-(void)generateNewEffectPoint1:(CGPoint)point
{
    
    
 //   [self removeFirstView:point];
    
   
    if(mainViews.count>0)
    {
        UIView *max=[mainViews firstObject];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            max.frame=CGRectMake(0, point.y, self.frame.size.width, 1);
            
        } completion:^(BOOL finished) {
            
            [max removeFromSuperview];
            [mainViews removeObjectAtIndex:0];

            UIView *tvoe=[[UIView alloc] initWithFrame:CGRectMake(0, point.y, self.frame.size.width, 1)];
            [self addSubview:tvoe];
            [self addGradientType:tvoe];

            
            [mainViews addObject:tvoe];
            
            [UIView animateWithDuration:0.5 animations:^{
                
                tvoe.frame=self.bounds;
            }];
            
            
        }];
        
        
        
        
        
        
    }
    else
    {
        UIView *tvoe=[[UIView alloc] initWithFrame:CGRectMake(0, point.y, self.frame.size.width, 1)];
        [self addGradientType:tvoe];
        [self addSubview:tvoe];
        
        [mainViews addObject:tvoe];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            tvoe.frame=self.bounds;
        }];
    }
    
    
}
-(void)addGradientType:(UIView *)view
{

    
    if(effectNo==-1)
    {
        
    }
    else
    {
    view.clipsToBounds=YES;
    UIView *gradientView=[[UIView alloc] initWithFrame:self.bounds];
    [view addSubview:gradientView];
    

    
    [self setUpGradient:gradientView style:effectNo+1];
    
    }
    [FTIndicator showToastMessage:[NSString stringWithFormat:@"Filter %d",effectNo+1]];

    
    effectNo++;
    
    if(effectNo>5)
    {
        effectNo=-1;
    }
    
    
}
-(void)setUpGradient:(UIView *)parentView style:(int)number;
{
    UIView *view=[[UIView alloc] initWithFrame:parentView.bounds];
    [parentView addSubview:view];
    
    if(number==1)
    {
    UIColor *color1=[UIColor colorWithRed:1.00 green:0.71 blue:0.64 alpha:1.00];
        UIColor *color2=[UIColor colorWithRed:1.00 green:0.68 blue:0.64 alpha:0.5f];
    UIColor *color3=[UIColor clearColor];
    UIColor *color4=[UIColor colorWithRed:1.00 green:0.15 blue:0.47 alpha:1.00];
        parentView.alpha=0.8;

    //1,3,4,5,6,
   
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = view.bounds;
    gradient.colors = @[(id)color1.CGColor,(id)color2.CGColor,(id)color3.CGColor,(id)color4.CGColor];
    gradient.startPoint=CGPointMake(0.0, 0.0f);
    gradient.endPoint=CGPointMake(1.0f, 1.0f);
    [view.layer insertSublayer:gradient atIndex:0];
    }
    else if(number==2)
    {
        UIColor *color1=[UIColor colorWithRed:0.93 green:0.15 blue:0.47 alpha:1.00];
        UIColor *color2=[UIColor clearColor];
        UIColor *color3=[UIColor clearColor];;
        UIColor *color4=[UIColor colorWithRed:0.94 green:0.54 blue:0.29 alpha:1.00];
        
        //1,3,4,5,6,
        parentView.alpha=0.8;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.frame = view.bounds;
        gradient.colors = @[(id)color1.CGColor,(id)color2.CGColor,(id)color4.CGColor];
        gradient.startPoint=CGPointMake(1.2f, 0.0f);
        gradient.endPoint=CGPointMake(1.2f, 1.1f);
        [view.layer insertSublayer:gradient atIndex:0];
    }
    else if(number==3)
    {
        UIColor *color1=[UIColor colorWithRed:1.0f green:0.15 blue:0.47 alpha:1.00];
        UIColor *color2=[UIColor clearColor];
        UIColor *color3=[UIColor colorWithRed:0.5f green:0.8f blue:0.47 alpha:1.00];
        UIColor *color4=[UIColor colorWithRed:1.0f green:0.54 blue:0.9f alpha:1.00];
        
        //1,3,4,5,6,
        parentView.alpha=0.8;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.frame = view.bounds;
        gradient.colors = @[(id)color1.CGColor,(id)color2.CGColor,(id)color3.CGColor,(id)color4.CGColor];
        gradient.startPoint=CGPointMake(0.0f, 0.0f);
        gradient.endPoint=CGPointMake(1.2f, 0.99f);
        [view.layer insertSublayer:gradient atIndex:0];
    }
    
    else
    {
        UIColor *color1=[UIColor greenColor];
        UIColor *color2=[UIColor clearColor];
        UIColor *color4=[UIColor yellowColor];
        
        //1,3,4,5,6,
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.frame = view.bounds;
        gradient.colors = @[(id)color1.CGColor,(id)color2.CGColor,(id)color4.CGColor];
        gradient.type=@"";
        gradient.startPoint=CGPointMake(0.0, 0.0f);
        gradient.endPoint=CGPointMake(1.0f, 1.0f);
        [view.layer insertSublayer:gradient atIndex:0];
    }
    
}

@end
