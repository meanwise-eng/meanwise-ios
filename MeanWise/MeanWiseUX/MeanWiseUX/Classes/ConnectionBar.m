//
//  ConnectionBar.m
//  MeanWiseUX
//
//  Created by Hardik on 27/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ConnectionBar.h"
#import "FTIndicator.h"
#import "UIImage+animatedGIF.h"

@implementation ConnectionBar

-(void)setUp
{
    
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }


    
    internetErrorView=nil;
    
    [self setUpRechability];
    
    
    
    //hiddenRect=window.bounds;
    //showingRect=window.bounds;
}
-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");      self.hasInet=NO;   }
    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi");    self.hasInet=YES;  }
    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell");    self.hasInet=YES;  }
    
    
    [self sendMessage];

}


- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {NSLog(@"no");      self.hasInet=NO;   }
    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi");    self.hasInet=YES;  }
    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell");    self.hasInet=YES;  }
    
    [self sendMessage];
    
    

    
    
}
-(void)sendMessage
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    
    
    if(self.hasInet==false)
    {
        [self showErrorView];
      //  [FTIndicator showToastMessage:@"Internet connection not available."];
        
    }
    else
    {
        [self hideErrorView];
       // [FTIndicator showToastMessage:@"Internet connection available."];
        
    }
    
    
    
    
}
-(void)showErrorView
{
   
    
    if(internetErrorView==nil)
    {
        internetErrorView=[self setUpInternetErrorView];
        [window addSubview:internetErrorView];
        
        internetErrorView.transform=CGAffineTransformMakeScale(10, 10);
        internetErrorView.alpha=0;
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            
            internetErrorView.transform=CGAffineTransformMakeScale(1, 1);
            internetErrorView.alpha=1;

        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}
-(void)hideErrorView
{
    if(internetErrorView!=nil)
    {
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            
            internetErrorView.transform=CGAffineTransformMakeScale(10, 10);
            internetErrorView.alpha=0;
            
        } completion:^(BOOL finished) {
            
            [internetErrorView removeFromSuperview];
            internetErrorView=nil;

            
        }];
    }
   
    
}
-(UIView *)setUpInternetErrorView
{
    UIView *view=[[UIView alloc] initWithFrame:window.bounds];
    view.backgroundColor=[UIColor whiteColor];
    
    
    UIView *whiteView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 500)];
    [view addSubview:whiteView];
    whiteView.center=CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
    [whiteView addSubview:imageView];
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"wifi" ofType:@"gif"];
    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    imageView.image= [UIImage animatedImageWithAnimatedGIFURL:url];

    
    
    UILabel *errorTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 200, 400, 50)];
    [whiteView addSubview:errorTitle];
    errorTitle.font=[UIFont fontWithName:@"Avenir-Roman" size:30];
    errorTitle.textAlignment=NSTextAlignmentCenter;
    errorTitle.textColor=[UIColor grayColor];
    errorTitle.text=@"Whoops!";
    
    UILabel *errorMessage=[[UILabel alloc] initWithFrame:CGRectMake(0, 250, 400, 50)];
    [whiteView addSubview:errorMessage];
    errorMessage.font=[UIFont fontWithName:@"Avenir-Roman" size:18];
    errorMessage.textAlignment=NSTextAlignmentCenter;
    errorMessage.numberOfLines=2;
    
    errorMessage.textColor=[UIColor lightGrayColor];
    errorMessage.text=@"No internet connection found.\nCheck your connection or try again.";

    
    
    
    return view;
}
@end
