//
//  APIManager.m
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIObjectsParser.h"
#import <UIKit/UIKit.h>
#import "APIObjects_FeedObj.h"
#import "APIObjects_CommentObj.h"
#import "APIObjects_ProfileObj.h"
#import "APIObjects_NotificationObj.h"
#import "DataSession.h"

//Friendlist, profile, posts


@implementation APIObjectsParser

-(NSArray *)parseObjects_FEEDPOST:(NSArray *)array
{
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[array count];i++)
    {
        
        APIObjects_FeedObj *obj=[[APIObjects_FeedObj alloc] init];
        [obj setUpWithDict:[array objectAtIndex:i]];
        
      
            if(obj.postId.class!=[NSNull class])
            {
                [resultArray addObject:obj];
            }
        
    }
    
    NSArray *resultA=[NSArray arrayWithArray:resultArray];
    
 
  //  NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"postId" ascending:false];
    //resultA = [resultA sortedArrayUsingDescriptors:@[descriptor]];

    
    return resultA;
    
}
-(NSArray *)parseObjects_COMMENTS:(NSArray *)array
{
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[array count];i++)
    {
        
        APIObjects_CommentObj *obj=[[APIObjects_CommentObj alloc] init];
        [obj setUpWithDict:[array objectAtIndex:i]];
        [resultArray addObject:obj];
        
    }
    
    return [NSArray arrayWithArray:resultArray];
    
}

-(NSArray *)parseObjects_PROFILES:(NSArray *)array
{
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[array count];i++)
    {
        
        APIObjects_ProfileObj *obj=[[APIObjects_ProfileObj alloc] init];
        [obj setUpWithDict:[array objectAtIndex:i]];
        [resultArray addObject:obj];
        
    }
    
    return [NSArray arrayWithArray:resultArray];
    
}
-(NSArray *)parseObjects_NOTIFICATIONS:(NSArray *)array
{
    
    NSUserDefaults *nud=[NSUserDefaults standardUserDefaults];
    NSNumber *number=[nud valueForKey:@"LAST_NOTIFICATION_READ"];
    if(number==nil)
    {
        number=[NSNumber numberWithInt:0];
    }

    
    int countNew=0;

    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[array count];i++)
    {
        
        APIObjects_NotificationObj *obj=[[APIObjects_NotificationObj alloc] init];
        [obj setUpWithDict:[array objectAtIndex:i]];
        
        if([obj.notificationReceiverUserName isEqualToString:[UserSession getUserName]])
        {
            if(obj.notificationIdNo.intValue>number.intValue)
            {
                countNew++;
                obj.notificationIsNew=[NSNumber numberWithInt:1];
            }
            else
            {
                obj.notificationIsNew=[NSNumber numberWithInt:0];
            }
            
            [resultArray addObject:obj];

        }
        
        
    }
    
  
    int prevNoOfNotificatoins=[DataSession sharedInstance].noOfNewNotificationReceived.intValue;
    
    [DataSession sharedInstance].noOfInstantNotificationReceived=[NSNumber numberWithInt:countNew];
    [DataSession sharedInstance].noOfNewNotificationReceived=[NSNumber numberWithInt:countNew+prevNoOfNotificatoins];
  
    
    if(resultArray.count>0)
    {
        NSUserDefaults *nud=[NSUserDefaults standardUserDefaults];
        
        APIObjects_NotificationObj *obj=[resultArray objectAtIndex:0];
        
        [nud setValue:obj.notificationIdNo forKey:@"LAST_NOTIFICATION_READ"];
        [nud synchronize];
    }
    
    
    return [NSArray arrayWithArray:resultArray];
    
}

-(void)printData:(NSArray *)array
{
    
    for(int i=0;i<[array count];i++)
    {
     
        NSLog(@"%@",[array objectAtIndex:i]);
        
        
    }
}


@end
