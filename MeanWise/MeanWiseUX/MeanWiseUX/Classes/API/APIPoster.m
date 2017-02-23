//
//  APIPosterView.m
//  MeanWiseUX
//
//  Created by Hardik on 22/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIPoster.h"

@implementation APIPoster

-(void)setUp
{
    
}

#pragma mark - Statics APIs
-(void)callStaticAPIs
{
    [self SkillCall];
    [self ProffesionCall];
    [self InterestCall];
    
}
-(void)ProffesionCall
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForProffesionsWithDelegate:self andSelector:@selector(proffesionDataReceived:)];
    
}
-(void)proffesionDataReceived:(APIResponseObj *)responseObj
{
    
   // NSLog(@"--------- Professtions");
   // NSLog(@"%@",responseObj.response);
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        
        
//        for(int i=0;i<array.count;i++)
//        {
//            NSLog(@"%@",[[array objectAtIndex:i] valueForKey:@"text"]);
//        }
//
        
        [self saveDataAs:array andKey:@"DATA_PROFFESION"];

    }
}
-(void)SkillCall
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForSkillsWithDelegate:self andSelector:@selector(SkillDataReceived:)];
    
    
    
}
-(void)SkillDataReceived:(APIResponseObj *)responseObj
{
   // NSLog(@"--------- Skills");
   // NSLog(@"%@",responseObj.response);
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        
       /* for(int i=0;i<array.count;i++)
        {
            NSLog(@"%@",[[array objectAtIndex:i] valueForKey:@"text"]);
        }*/
        [self saveDataAs:array andKey:@"DATA_SKILLS"];

    }
}
-(void)InterestCall
{
    manager=[[APIManager alloc] init];
    [manager sendRequestForInterestWithDelegate:self andSelector:@selector(InterestDataReceived:)];
    
}
-(void)InterestDataReceived:(APIResponseObj *)responseObj
{
    //NSLog(@"--------- Interest");
    
    // NSLog(@"%@",responseObj.response);


    if([responseObj.response isKindOfClass:[NSArray class]])
        {
            NSArray *array=(NSArray *)responseObj.response;
            
            [self saveDataAs:array andKey:@"DATA_INTEREST"];
        }
    
}
-(void)saveDataAs:(NSArray *)array andKey:(NSString *)key
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    [ud setObject:array forKey:key];
    
    [ud synchronize];
    
    
}
-(NSArray *)getDataForKey:(NSString *)key
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    return [ud objectForKey:key];

}

#pragma mark - Get Data
-(NSArray *)getInterestData
{
    return [self getDataForKey:@"DATA_INTEREST"];
}
-(NSArray *)getSkillsData
{
    return [self getDataForKey:@"DATA_SKILLS"];
}
-(NSArray *)getProffesionData
{
    return [self getDataForKey:@"DATA_PROFFESION"];

}
@end
