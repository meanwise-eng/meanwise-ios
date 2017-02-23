//
//  DataSession.m
//  MeanWiseUX
//
//  Created by Hardik on 19/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "DataSession.h"

@implementation DataSession

+ (instancetype)sharedInstance
{
    static DataSession *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataSession alloc] init];
        
        
        sharedInstance.signupObject=[[SignupDataObjects alloc] init];
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
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