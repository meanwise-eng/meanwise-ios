//
//  PostUploadLoader.m
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PostUploadLoader.h"

@implementation PostUploadLoader

-(void)setDelegate:(id)target andFunc1:(SEL)func1 andFunc2:(SEL)func2
{
    delegate=target;
    showFunc=func1;
    hideFunc=func2;
    
}
-(void)setUp
{
    statusBarNotifierView=nil;
    statusBarNotifierText=nil;
    
    
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    
    hiddenRect=CGRectMake(0, -20, window.frame.size.width, 20);
    showingRect=CGRectMake(0, 0, window.frame.size.width, 20);
    

}
-(void)showProgress
{
    [delegate performSelector:hideFunc withObject:nil afterDelay:0.0001];

    
    if(statusBarNotifierView!=nil)
    {
        [statusBarNotifierText removeFromSuperview];
        [statusBarNotifierView removeFromSuperview];
        statusBarNotifierView=nil;
        statusBarNotifierText=nil;
        
    }
    
    statusBarNotifierView=[[UIView alloc] initWithFrame:hiddenRect];
    [window addSubview:statusBarNotifierView];
    
    statusBarNotifierText=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, statusBarNotifierView.frame.size.width-10, 20)];
    [statusBarNotifierView addSubview:statusBarNotifierText];
    statusBarNotifierText.textColor=[UIColor whiteColor];
    statusBarNotifierText.backgroundColor=[UIColor clearColor];
    statusBarNotifierText.textAlignment=NSTextAlignmentCenter;
    
    statusBarNotifierView.clipsToBounds=YES;
    statusBarNotifierView.alpha=0;
    statusBarNotifierText.font=[UIFont fontWithName:@"Avenir-Black" size:12];
    
    
    
    [window bringSubviewToFront:statusBarNotifierView];
    
   
    statusBarNotifierView.backgroundColor=[UIColor colorWithRed:0.27 green:0.80 blue:1.00 alpha:1.00];
        statusBarNotifierText.text=@"Posting..";
    
    
    
    [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        statusBarNotifierView.alpha=1;
        statusBarNotifierView.frame=showingRect;
        
    } completion:^(BOOL finished) {
        
        
    }];
    

}
-(void)hideProgress
{
    
    statusBarNotifierView.backgroundColor=[UIColor colorWithRed:0.63 green:0.40 blue:0.82 alpha:1.00];
    statusBarNotifierText.text=@"Done!";
    
    
    [self performSelector:@selector(hideDone) withObject:nil afterDelay:2.0f];
    
  
    
}
-(void)FailedProgress
{
    
    statusBarNotifierView.backgroundColor=[UIColor redColor];
    statusBarNotifierText.text=@"Fail!";
    
    
    [self performSelector:@selector(hideDone) withObject:nil afterDelay:2.0f];
    
    
    
}
-(void)hideDone
{
    if(statusBarNotifierView!=nil)
    {
        
        [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            statusBarNotifierView.frame=hiddenRect;
            statusBarNotifierView.alpha=0;
            
        } completion:^(BOOL finished) {
            
            [statusBarNotifierText removeFromSuperview];
            [statusBarNotifierView removeFromSuperview];
            statusBarNotifierView=nil;
            statusBarNotifierText=nil;
            
            [delegate performSelector:showFunc withObject:nil afterDelay:0.0001];
            
        }];
        
    }
}

@end
