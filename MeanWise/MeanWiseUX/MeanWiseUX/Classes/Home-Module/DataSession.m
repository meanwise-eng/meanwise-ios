//
//  DataSession.m
//  MeanWiseUX
//
//  Created by Hardik on 19/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "DataSession.h"
#import "APIObjects_FeedObj.h"

@implementation DataSession

+ (instancetype)sharedInstance
{
    static DataSession *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataSession alloc] init];
        
        sharedInstance.homeFeedResults=[[NSMutableArray alloc] init];
        sharedInstance.exploreFeedResults=[[NSMutableArray alloc] init];
        sharedInstance.signupObject=[[SignupDataObjects alloc] init];
        sharedInstance.notificationsResults=[[NSMutableArray alloc] init];
        sharedInstance.noOfNewNotificationReceived=[NSNumber numberWithInt:0];
        sharedInstance.noOfInstantNotificationReceived=[NSNumber numberWithInt:0];
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(void)postLiked:(NSString *)postId
{
    

    for(int i=0;i<self.homeFeedResults.count;i++)
    {
        APIObjects_FeedObj *obj=[self.homeFeedResults objectAtIndex:i];
        if([obj.postId isEqualToString:postId])
        {
            obj.IsUserLiked=[NSNumber numberWithInt:1];
            obj.num_likes=[NSNumber numberWithInt:[obj.num_likes intValue]+1];
            
            [self.homeFeedResults replaceObjectAtIndex:i withObject:obj];

        }
        
    }
   
    for(int i=0;i<self.exploreFeedResults.count;i++)
    {
        APIObjects_FeedObj *obj=[self.exploreFeedResults objectAtIndex:i];
        if([obj.postId isEqualToString:postId])
        {
            obj.IsUserLiked=[NSNumber numberWithInt:1];
            obj.num_likes=[NSNumber numberWithInt:[obj.num_likes intValue]+1];
            
            [self.exploreFeedResults replaceObjectAtIndex:i withObject:obj];
            
        }
        
    }
    
    
}
-(void)postUnliked:(NSString *)postId
{
    for(int i=0;i<self.homeFeedResults.count;i++)
    {
        APIObjects_FeedObj *obj=[self.homeFeedResults objectAtIndex:i];
        if([obj.postId isEqualToString:postId])
        {
            obj.IsUserLiked=[NSNumber numberWithInt:0];
            obj.num_likes=[NSNumber numberWithInt:[obj.num_likes intValue]-1];
            
            [self.homeFeedResults replaceObjectAtIndex:i withObject:obj];
            
        }
        
    }
    for(int i=0;i<self.exploreFeedResults.count;i++)
    {
        APIObjects_FeedObj *obj=[self.exploreFeedResults objectAtIndex:i];
        if([obj.postId isEqualToString:postId])
        {
            obj.IsUserLiked=[NSNumber numberWithInt:0];
            obj.num_likes=[NSNumber numberWithInt:[obj.num_likes intValue]-1];
            
            [self.exploreFeedResults replaceObjectAtIndex:i withObject:obj];
            
        }
        
    }
    
}



@end

@implementation SignupDataObjects 

-(void)clearAllData
{
    self.username=nil;
    self.email=nil;
    self.password=nil;
    self.first_name=nil;
    self.last_name=nil;
    self.skills=nil;
    self.dob=nil;
    self.cover_photo=nil;
    self.profile_photo=nil;
    self.interests=nil;
    
  }
@end