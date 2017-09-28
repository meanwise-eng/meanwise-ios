//
//  PostTrackSeenHelper.m
//  VideoPlayerDemo
//
//  Created by Hardik on 12/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PostTrackSeenHelper.h"
#import "APIManager.h"

@implementation PostTrackSeenHelper

+ (instancetype)sharedInstance
{
    static PostTrackSeenHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PostTrackSeenHelper alloc] init];

        
    });
    return sharedInstance;
}

#pragma mark - Post Seen
-(void)PS_setNewURL:(NSString *)urlstr;
{
 
    analyticsPath=[self getAnalyticsDocPath];
    
    [self PS_clearPreviousRecords];
    currentURL=urlstr;
    currentURLTime=[self getCurrentTime];
    allRecords=[[NSMutableArray alloc] init];
}
-(void)PS_NewPost:(NSDictionary *)dict
{
    if(currentURL!=nil)
    {
    [allRecords addObject:dict];
    
    if(allRecords.count>10)
    {
        [self PS_setNewURL:currentURL];
    }
    }
}
-(void)PS_clearPreviousRecords
{
    if(allRecords.count>0)
    {
        [self PS_createJson:currentURLTime];
        currentURL=nil;
        currentURLTime=nil;
        [allRecords removeAllObjects];
    }
}

-(void)PS_createJson:(NSString *)fileNamePrefix
{
    NSDictionary *dict=@{
                         @"seen_posts":
                        @{
                         @"url":currentURL,
                         @"datetime":currentURLTime,
                         @"posts":allRecords,
                         }
                         };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
        
        NSString *filePath = [NSString stringWithFormat:@"%@/log-%@.json", analyticsPath,fileNamePrefix];

        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath] && 1==2)
        {
            NSError *error;
            [jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if(error==nil)
            {
             
                [self postAllJsonFiles];
            }
        }

    }
    

    
}

#pragma mark - Post Files
-(void)postAllJsonFiles
{
    analyticsPath=[self getAnalyticsDocPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:analyticsPath error:nil];
    NSMutableArray *subpredicates = [NSMutableArray array];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.json'"]];
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    NSArray *jsonFiles = [directoryContents filteredArrayUsingPredicate:filter];
    
    
  
    for(int i=0;i<jsonFiles.count;i++)
    {
    [self readFile:[NSString stringWithFormat:@"%@/%@",analyticsPath,[jsonFiles objectAtIndex:i]]];
    }
    
    

    
}
-(void)readFile:(NSString *)path
{
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
   // NSLog(@"%@",content);
 
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForPostAnalytics:json withFileName:path delegate:self andSelector:@selector(postSend:)];
    
    

}
-(void)postSend:(APIResponseObj *)obj
{
    if(obj.statusCode==200)
    {
     
        if([obj.apiInputInfo isKindOfClass:[NSString class]])
        {
            NSString *filePath=(NSString *)obj.apiInputInfo;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

        }
    
        
    }
    else
    {
        
    }
    

}

#pragma mark Helper

-(NSString *)getCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [dateFormatter setLenient:false];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}
-(NSString *)getAnalyticsDocPath
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory=[documentsDirectory stringByAppendingPathComponent:@"/Analytics"];
    
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }

    return documentsDirectory;
    
}

#pragma mark Tests
-(void)createSeenPostDict
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [dateFormatter setLenient:false];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    
    
    NSDictionary *dict1=@{
                          @"post_id":@1,
                          @"user_id":@1,
                          @"page_no":@1,
                          @"datetime":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]],
                          @"poster":@2,
                          @"no_in_sequence":@10,
                          @"is_expanded":[NSNumber numberWithBool:true],
                          };
    
    NSDictionary *dict2=@{
                          @"post_id":@1,
                          @"user_id":@1,
                          @"page_no":@1,
                          @"datetime":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]],
                          @"poster":@2,
                          @"no_in_sequence":@10,
                          @"is_expanded":[NSNumber numberWithBool:true],
                          };
    
    
    
    NSDictionary *dict=@{
                         @"url":@"http://localhost:8000/admin/analytics/seenpostbatch/add/",
                         @"datetime":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]],
                         @"posts":[NSArray arrayWithObjects:dict1, nil],
                         };
    
    NSDictionary *mainDict=@{
                             @"seen_posts":[NSArray arrayWithObjects:dict, nil],
                             
                             };
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mainDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
    }
    
    
    
}


@end
