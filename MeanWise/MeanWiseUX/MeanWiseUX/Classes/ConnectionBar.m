//
//  ConnectionBar.m
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ConnectionBar.h"

@implementation ConnectionBar

-(void)setUp
{
    statusBarNotifierView=nil;
    statusBarNotifierText=nil;
    
    [self setUpRechability];
    
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }

    
    hiddenRect=CGRectMake(20, window.frame.size.height+100, window.frame.size.width-40, 50);
    showingRect=CGRectMake(20, window.frame.size.height/2, window.frame.size.width-40, 50);
    
}
-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");      self.hasInet-=NO;   }
    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi");    self.hasInet-=YES;  }
    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell");    self.hasInet-=YES;  }
    
    [self sendMessage];

}
-(void)sendMessage
{
    if(statusBarNotifierView!=nil)
    {
        [statusBarNotifierText removeFromSuperview];
        [statusBarNotifierView removeFromSuperview];
        statusBarNotifierView=nil;
        statusBarNotifierText=nil;
        
    }
    
    statusBarNotifierView=[[UIView alloc] initWithFrame:hiddenRect];
    [window addSubview:statusBarNotifierView];
    
    statusBarNotifierText=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, statusBarNotifierView.frame.size.width-10, 50-20)];
    [statusBarNotifierView addSubview:statusBarNotifierText];
    statusBarNotifierText.textColor=[UIColor whiteColor];
    statusBarNotifierText.backgroundColor=[UIColor clearColor];
    statusBarNotifierText.textAlignment=NSTextAlignmentCenter;
    
    statusBarNotifierView.layer.cornerRadius=25;
    statusBarNotifierView.clipsToBounds=YES;
    statusBarNotifierView.alpha=0;
    
    
    
    [window bringSubviewToFront:statusBarNotifierView];
    
    
    if(self.hasInet==false)
    {
        
        statusBarNotifierView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.8];
        statusBarNotifierText.text=@"Internet connection available.";
    }
    else
    {
        statusBarNotifierText.text=@"Internet connection not available.";
        statusBarNotifierView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.8];
        
    }
    
    
    [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        statusBarNotifierView.alpha=1;
        statusBarNotifierView.frame=showingRect;
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(updateStatusBarNotifier:) withObject:nil afterDelay:4.0f];
        
    }];
    

    
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");      self.hasInet-=NO;   }
    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi");    self.hasInet-=YES;  }
    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell");    self.hasInet-=YES;  }
    
    [self sendMessage];
    
    
    //    if (self.hasInet) {
    //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Net avail" message:@"" delegate:self cancelButtonTitle:OK_EN otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
    
    
}
-(void)updateStatusBarNotifier:(id)sender
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
            
            
        }];
        
    }
    
}

@end
