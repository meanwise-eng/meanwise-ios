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


//Friendlist, profile, posts


@implementation APIObjectsParser

-(NSArray *)parseObjects_FEEDPOST:(NSArray *)array
{
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<[array count];i++)
    {
        
        APIObjects_FeedObj *obj=[[APIObjects_FeedObj alloc] init];
        [obj setUpWithDict:[array objectAtIndex:i]];
        [resultArray addObject:obj];
        
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

-(void)printData:(NSArray *)array
{
    
    for(int i=0;i<[array count];i++)
    {
     
        NSLog(@"%@",[array objectAtIndex:i]);
        
        
    }
}


@end
