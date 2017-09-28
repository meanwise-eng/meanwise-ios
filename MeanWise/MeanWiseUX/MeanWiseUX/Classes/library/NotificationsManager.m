//
//  NotificationsManager.m
//  MeanWiseUX
//
//  Created by Hardik on 02/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NotificationsManager.h"
#import "DataSession.h"
#import "AppDelegate.h"
#import "APIManager.h"
#import "NotificationBadgeView.h"
#import "APIObjectsParser.h"
#import "ViewController.h"


@implementation NotificationsManager

-(void)setUp
{
  
    
    [self UserNotificationAPI];
    
}
-(void)UserNotificationAPI
{
    
    int number=[[DataSession sharedInstance].SocialshareStatus intValue];
    
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if([DataSession sharedInstance].sessionMain!=nil && number==0 && delegate.deepLinkViewer==nil)
    {
        
        APIManager *manager=[[APIManager alloc] init];
        [manager sendRequestForMyNotificationsWithdelegate:self andSelector:@selector(UserNotificationAPIReceived:)];
        [self performSelector:@selector(UserNotificationAPI) withObject:nil afterDelay:300];
        
    }
    else
    {
        [self performSelector:@selector(UserNotificationAPI) withObject:nil afterDelay:5];
    }
}
-(void)UserNotificationAPIReceived:(APIResponseObj *)responseObj
{
    // NSLog(@"%@",responseObj.response);
    
    
    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)[responseObj.response valueForKey:@"data"];
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        [DataSession sharedInstance].notificationsResults=[NSMutableArray arrayWithArray:[parser parseObjects_NOTIFICATIONS:array]];
        
        
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewNotificationDataReceived"
         object:self];
        
        
        if(!RX_isiPhone4Res)
        {
            
            if([DataSession sharedInstance].notificationsResults.count>0)
            {
                int no=[DataSession sharedInstance].noOfInstantNotificationReceived.intValue;
                
                if(no>0)
                {
                    
                    
                    NotificationBadgeView *notificationBar=[[NotificationBadgeView alloc] init];
                    [notificationBar setDelegate:self andFunc1:@selector(showStatusBar) andFunc2:@selector(hideStatusBar)];
                    
                    
                    if(no==1)
                    {
                        
                        [notificationBar setUp:[[DataSession sharedInstance].notificationsResults objectAtIndex:0]];
                    }
                    else
                    {
                        [notificationBar setUp:[NSNumber numberWithInt:no]];
                    }
                }
                //
            }
        }
        
        //   [FTIndicator showNotificationWithTitle:@"Notifications" message:[NSString stringWithFormat:@"%d",(int)[DataSession sharedInstance].notificationsResults.count]];
        
        
        /*NotificationScreen *screen=[[NotificationScreen alloc] initWithFrame:self.frame];
         [self addSubview:screen];
         [screen setUp:result];*/
        
        
    }
    
    
    
    
    
    
}
-(void)showStatusBar
{
//    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
//    ViewController *t=(ViewController *)vc.topViewController;
//
//    if([t respondsToSelector:@selector(setStatusBarHide:)])
//    {
//        [t setStatusBarHide:false];
//    }
}
-(void)hideStatusBar
{
//    UINavigationController *vc=(UINavigationController *)[Constant topMostController];
//    ViewController *t=(ViewController *)vc.topViewController;
//
//    if([t respondsToSelector:@selector(setStatusBarHide:)])
//    {
//        [t setStatusBarHide:true];
//    }
}


@end
