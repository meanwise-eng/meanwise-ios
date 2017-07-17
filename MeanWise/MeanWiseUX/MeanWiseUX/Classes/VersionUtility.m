//
//  VersionUtility.m
//  MeanWiseUX
//
//  Created by Hardik on 09/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "VersionUtility.h"
#import "APIManager.h"
#import "FCAlertView.h"

@implementation VersionUtility
-(void)setUpWithTarget:(id)tReceived onCallBack:(SEL)func
{
    
    if(func!=nil)
    {
    target=tReceived;
    callBackFunc=func;
    }
    
    
   
    
}
-(void)requestForCall
{
    mg=[[APIManager alloc] init];
    [mg sendRequestForDeviceVersion:self andSelector:@selector(versionChecking:)];
    
}


-(void)versionChecking:(APIResponseObj *)obj
{
    
    if(obj.statusCode==200)
    {
        
        if([obj.message isEqualToString:@"1"])
        {
        }
        
        else if([obj.message isEqualToString:@"2"])
        {
            
            NSString *newVersion=[[obj.response valueForKey:@"latest_version"] valueForKey:@"version"];
            [self showAlert:newVersion];
            
        }
        else if([obj.message isEqualToString:@"3"])
        {
           
            NSString *newVersion=[[obj.response valueForKey:@"latest_version"] valueForKey:@"version"];
            [self showAlertForce:newVersion];
         
            
        }
        
        
    }
    
    if(callBackFunc!=nil)
    {
    [target performSelector:callBackFunc withObject:nil afterDelay:0.0001];
    }
}
-(void)showAlert:(NSString *)newVersion
{
    BOOL toShow=false;
    int count=[self getPromptCount];
    if(count==0)
    {
        toShow=true;

    }

    count++;
    
    if(count==25)
    {
        count=0;
    }

    [self setPromptCount:count];
    
    if(toShow)
    {
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert makeAlertTypeSuccess];
    alert.colorScheme = alert.flatBlue;
    alert.detachButtons = YES;
    alert.bounceAnimations = YES;
    
    [alert showAlertWithTitle:[NSString stringWithFormat:@"New Version %@ !!",newVersion]
                 withSubtitle:[NSString stringWithFormat:@"New Version %@ is available!!",newVersion]
              withCustomImage:nil
          withDoneButtonTitle:@"Update"
                   andButtons:nil];
    
    [alert addButton:@"Cancel" withActionBlock:^{
        
    }];
    
    [alert doneActionBlock:^{
        
        NSURL *URL=[NSURL URLWithString:@"https://itunes.apple.com/app/id1159671281"];
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:URL options:@{} completionHandler:nil];
        
    }];
    }
    
}
-(void)showAlertForce:(NSString *)newVersion
{
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert makeAlertTypeSuccess];
    alert.detachButtons = YES;
    alert.bounceAnimations = YES;
    
    
    alert.colorScheme = alert.flatBlue;
    
    [alert showAlertWithTitle:[NSString stringWithFormat:@"New Version %@ !!",newVersion]
                 withSubtitle:[NSString stringWithFormat:@"New Version %@ is available!!",newVersion]
              withCustomImage:nil
          withDoneButtonTitle:@"Update"
                   andButtons:nil];
    
    
    [alert doneActionBlock:^{
        
        NSURL *URL=[NSURL URLWithString:@"https://itunes.apple.com/app/id1159671281"];
        
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:URL options:@{} completionHandler:nil];
        
    }];
}
-(void)setPromptCount:(int)number
{
    NSUserDefaults *udf=[NSUserDefaults standardUserDefaults];
    [udf setValue:[NSNumber numberWithInt:number] forKey:@"K_APPUPDATE_PROMPTCOUNT"];

    [udf synchronize];
}
-(int)getPromptCount
{
    NSUserDefaults *udf=[NSUserDefaults standardUserDefaults];
    int string=[[udf valueForKey:@"K_APPUPDATE_PROMPTCOUNT"] intValue];
    
    return string;
    
}
@end
