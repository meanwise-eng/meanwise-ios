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
    
    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=[(NSArray *)responseObj.response valueForKey:@"data"];
        
        
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
    
    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=[(NSArray *)responseObj.response valueForKey:@"data"];
        
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


    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=[(NSArray *)responseObj.response valueForKey:@"data"];
        
        
//        NSMutableArray *arrayT=[[NSMutableArray alloc] initWithArray:array];
//        
//        for(int m=0;m<15;m++)
//        {
//            int no1=arc4random()%arrayT.count;
//            int no2=arc4random()%arrayT.count;
//            if(no1!=no2)
//            {
//                [arrayT exchangeObjectAtIndex:no1 withObjectAtIndex:no2];
//            }
//        }
//        
//            array=[NSArray arrayWithArray:arrayT];
//        
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
-(NSArray *)getInterestDataForExploreScreen
{
    NSArray *array=[self getDataForKey:@"DATA_INTEREST"];
    
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:-1],@"id",@"",@"name", @"",@"photo",nil];
    
        NSMutableArray *mutable=[[NSMutableArray alloc] initWithArray:array];
        [mutable insertObject:dict atIndex:0];
    
        array=[NSArray arrayWithArray:mutable];
    
    return array;
    
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
