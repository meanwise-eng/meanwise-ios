//
//  HMPlayerManager.m
//  VideoPlayerDemo
//
//  Created by Hardik on 11/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HMPlayerManager.h"

@implementation HMPlayerManager


+ (instancetype)sharedInstance
{
    static HMPlayerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HMPlayerManager alloc] init];
        
        

        sharedInstance.HM_screenIdentifier=@"";
        sharedInstance.HM_urlIdentifier=@"";
        sharedInstance.HM_isPaused=FALSE;
        sharedInstance.HM_isFullScreen=false;
        sharedInstance.MX_StackArray=[[NSMutableArray alloc] init];
        sharedInstance.MX_DeletedArray=[[NSMutableArray alloc] init];

        
        
        sharedInstance.Home_screenIdentifier=@"";
        sharedInstance.Home_urlIdentifier=@"";
        sharedInstance.Home_isPaused=FALSE;
        sharedInstance.Home_isVisibleBounds=false;
        sharedInstance.Home_RefreshIdentifier=[NSNumber numberWithLong:1];

        sharedInstance.Explore_isPaused=false;
        sharedInstance.Explore_isVisibleBounds=true;
        sharedInstance.Explore_screenIdentifier=@"";
        sharedInstance.Explore_urlIdentifier=@"";
        sharedInstance.Explore_isKilling=false;
        
        sharedInstance.Profile_screenIdentifier=@"";
        sharedInstance.Profile_urlIdentifier=@"";
        sharedInstance.Profile_isPaused=false;
        sharedInstance.Profile_isVisibleBounds=TRUE;
        sharedInstance.Profile_isKilling=false;
        sharedInstance.Profile_RefreshIdentifier=[NSNumber numberWithLong:1];
        
        sharedInstance.NotificationPost_isPaused=false;
        sharedInstance.NotificationPost_isVisibleBounds=TRUE;
        sharedInstance.NotificationPost_screenIdentifier=@"";
        sharedInstance.NotificationPost_urlIdentifier=@"";
        sharedInstance.NotificationPost_isKilling=false;
        
        sharedInstance.DeepLinkPost_isPaused=false;
        sharedInstance.DeepLinkPost_isVisibleBounds=TRUE;
        sharedInstance.DeepLinkPost_screenIdentifier=@"";
        sharedInstance.DeepLinkPost_urlIdentifier=@"";
        sharedInstance.DeepLinkPost_isKilling=false;
        sharedInstance.DeepLink_RefreshIdentifier=[NSNumber numberWithLong:1];
        

        sharedInstance.AllVideosURLIdentifiers=[[NSMutableArray alloc] init];
        
        sharedInstance.All_isPaused=false;
        
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
#pragma mark - New Engine

-(NSString *)MX_getNewIdentifierRow;
{
 
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSString *identifier=[NSString stringWithFormat:@"%f",seconds];
    NSDictionary *dict=@{@"ID":identifier,@"PAUSED":@(false),@"FULLMODE":@(false),@"URL":@""};
    
    
    [self.MX_StackArray addObject:dict];
    return identifier;
}
-(void)MX_setLastPlayerPaused:(BOOL)flag
{
    NSDictionary *dict=[self.MX_StackArray lastObject];
    
    dict=@{@"ID":[dict valueForKey:@"ID"],@"PAUSED":@(flag),@"FULLMODE":[dict valueForKey:@"FULLMODE"],@"URL":[dict valueForKey:@"URL"]};
    [self.MX_StackArray replaceObjectAtIndex:self.MX_StackArray.count-1 withObject:dict];

}
-(void)MX_setLastPlayerFullMode:(BOOL)flag
{
    NSDictionary *dict=[self.MX_StackArray lastObject];
    
    
    dict=@{@"ID":[dict valueForKey:@"ID"],@"PAUSED":[dict valueForKey:@"PAUSED"],@"FULLMODE":@(flag),@"URL":[dict valueForKey:@"URL"]};
    
    [self.MX_StackArray replaceObjectAtIndex:self.MX_StackArray.count-1 withObject:dict];
    
}

-(void)MX_KillLastPlayerRow
{
    NSDictionary *dict=[self.MX_StackArray lastObject];
    [self.MX_StackArray removeObject:dict];
    [self.MX_DeletedArray addObject:dict];

}
-(void)MX_setURL:(NSString *)urlStr forIdentifier:(NSString *)identifier
{
  
    int getId=-1;
    for(int i=0;i<self.MX_StackArray.count;i++)
    {
        NSDictionary *dict=[self.MX_StackArray objectAtIndex:i];
        if([[dict valueForKey:@"ID"] isEqualToString:identifier])
        {
            getId=i;
        }
    }
    
    if(getId==-1)
    {
        NSAssert(getId!=-1,@"Screenidentifier not exists");

    }
    
    NSDictionary *dict=[self.MX_StackArray objectAtIndex:getId];
    
    
    dict=@{@"ID":[dict valueForKey:@"ID"],@"PAUSED":[dict valueForKey:@"PAUSED"],@"FULLMODE":[dict valueForKey:@"FULLMODE"],@"URL":urlStr};

    [self.MX_StackArray replaceObjectAtIndex:getId withObject:dict];
    
}
-(BOOL)MX_ifLastURLisAlready:(NSString *)string
{
    NSDictionary *dict=[self.MX_StackArray lastObject];
    
    if([[dict valueForKey:@"URL"] isEqualToString:string])
    {
        return true;
    }
    else
    {
        return false;
    }
}
-(BOOL)MX_shouldKillThePlayerForIdentifier:(NSString *)string
{
    NSArray *filtered = [self.MX_DeletedArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ID == %@)", string]];

    if(filtered.count>0)
    {
        return true;
    }
    else
    {
        return false;
    }
}
-(BOOL)MX_shouldPlayPlayerForURL:(NSString *)urlString withIdentifier:(NSString *)identifier
{
//    isPaused, screenIdentifier, urlIdentifier, fullscreen
    
    /*       [HMPlayerManager sharedInstance].HM_isPaused==false
     && [screenIdentifier isEqualToString:[HMPlayerManager sharedInstance].HM_screenIdentifier]
     && [urlStr isEqualToString:[HMPlayerManager sharedInstance].HM_urlIdentifier]
     && [HMPlayerManager sharedInstance].HM_isFullScreen==true
*/
    NSDictionary *dict=[self.MX_StackArray lastObject];

    if([[dict valueForKey:@"FULLMODE"] boolValue]==false)
    {
        return false;
    }
    if([[dict valueForKey:@"PAUSED"] boolValue]==true)
    {
        return false;
    }
    if(![[dict valueForKey:@"ID"] isEqualToString:identifier])
    {
        return false;
    }
    if(![[dict valueForKey:@"URL"] isEqualToString:urlString])
    {
        return false;
    }
    
    
    
    return true;
}












#pragma mark - Old Engine



-(NSNumber *)generateNewDeepLinkRefreshIdentifier
{
    NSNumber *number=[NSNumber numberWithLong:[self.DeepLink_RefreshIdentifier intValue]+1];
    
    self.DeepLink_RefreshIdentifier=number;
    
    return number;

}
-(NSNumber *)generateNewProfileRefreshIdentifier
{

    NSNumber *number=[NSNumber numberWithLong:[self.Profile_RefreshIdentifier intValue]+1];
    
    self.Profile_RefreshIdentifier=number;
    
    return number;
    
}
-(NSNumber *)generateHomeRefreshIdentifier
{
    
    NSNumber *number=[NSNumber numberWithLong:[self.Home_RefreshIdentifier intValue]+1];
    
    self.Home_RefreshIdentifier=number;
    
    return number;
    
}


-(void)StartKeepKillingExploreFeedVideosIfAvaialble;
{
    self.Explore_isKilling=true;
}
-(void)StopKeepKillingExploreFeedVideosIfAvaialble;
{
    self.Explore_isKilling=false;
}

-(void)StartKeepKillingProfileFeedVideosIfAvaialble
{
    self.Profile_isKilling=true;
}
-(void)StopKeepKillingProfileFeedVideosIfAvaialble
{
    self.Profile_isKilling=false;
}
-(void)StartKeepKillingNotificationVideosIfAvaialble
{
    self.NotificationPost_isKilling=true;
}
-(void)StopKeepKillingNotificationVideosIfAvaialble
{
    self.NotificationPost_isKilling=false;
}

-(void)StartKeepKillingDeepLinkVideosIfAvaialble
{
    self.DeepLinkPost_isKilling=true;
}
-(void)StopKeepKillingDeepLinkVideosIfAvaialble
{
    self.DeepLinkPost_isKilling=false;

}

-(void)StartKeepKillingHMLinkVideosIfAvaialble
{
 
    self.HM_isKilling=true;
}
-(void)StopKeepKillingHMLinkVideosIfAvaialble
{
    self.HM_isKilling=false;
}


-(void)setNotificationPost_urlIdentifier:(NSString *)NotificationPost_urlIdentifier
{
    _NotificationPost_urlIdentifier=NotificationPost_urlIdentifier;
}
-(void)setHome_urlIdentifier:(NSString *)Home_urlIdentifier
{
    _Home_urlIdentifier=Home_urlIdentifier;
}
-(void)setExplore_urlIdentifier:(NSString *)Explore_urlIdentifier
{
    _Explore_urlIdentifier=Explore_urlIdentifier;
}
-(void)setProfile_urlIdentifier:(NSString *)Profile_urlIdentifier
{
    _Profile_urlIdentifier=Profile_urlIdentifier;
}
-(void)addNewURLIntoStack:(NSString *)string
{

    
    [self.AllVideosURLIdentifiers addObject:string];
 
    
}
@end
