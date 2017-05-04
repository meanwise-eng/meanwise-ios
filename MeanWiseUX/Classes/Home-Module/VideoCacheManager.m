//
//  VideoCacheManager.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "VideoCacheManager.h"

@implementation VideoCacheManager

+(void)setUp
{
    
    if([self firstTime])
    {
        [self createEmptyArray];
    }
}
+(NSUserDefaults *)userDefault
{
    return [NSUserDefaults standardUserDefaults];
}

+(NSString *)getCachePathIfExists:(NSString *)urlToSearch
{
    NSString *temp=nil;
    int isPending=0;
    
    NSArray *list=[self getArray];
    
    
    NSArray *filtered = [list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(url == %@)", urlToSearch]];
    
    if(filtered.count==1)
    {
    NSDictionary *item = [filtered objectAtIndex:0];

    if([[item valueForKey:@"status"] isEqualToString:@"DONE"])
    {
        temp=[item valueForKey:@"localPath"];
        
        NSString *documentsDirectory=[self getDocumentPath];
        temp = [NSString stringWithFormat:@"%@/%@", documentsDirectory,temp];
        
        NSLog(@"Video from cache");

        
    }
    else
    {
        
       

      //  NSLog(@"Video request sent Already");
        isPending=1;

        
    }
    }
    
    /*
    for (int i=0; i<list.count; i++) {
        NSString *global=[[list objectAtIndex:i] valueForKey:@"url"];
        NSString *status=[[list objectAtIndex:i] valueForKey:@"status"];
        
        if([urlToSearch isEqualToString:global] && [status isEqualToString:@"DONE"])
        {
            temp=[[list objectAtIndex:i] valueForKey:@"localPath"];
            
            NSString *documentsDirectory=[self getDocumentPath];
            temp = [NSString stringWithFormat:@"%@/%@", documentsDirectory,temp];

            NSLog(@"Video from cache");
            
            break;
        }
        if([urlToSearch isEqualToString:global] && [status isEqualToString:@"PENDING"])
        {
            
            NSLog(@"Video request sent Already");
            isPending=1;
            break;
        }

        
    }
    */
    

    if(temp==nil && isPending==0)
    {
       // NSLog(@"New request sent");

        [self addVideoURLDone:urlToSearch];

    }
    return temp;
}
+(AppDelegate *)getAppDelegate
{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}
+(NSOperationQueue *)getVideoQueue
{
    return [self getAppDelegate].MeanWise_VideoQueue;
}
+(void)addVideoURLDone:(NSString *)videoUrl
{
  //  NSLog(@"New request received");


    NSString *PathTime=[NSString stringWithFormat:@"VideoCache_%@.mp4",[NSDate date]];
    
    NSString *documentsDirectory=[self getDocumentPath];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,PathTime];
    //NSLog(@"%@",filePath);
    NSDictionary *dict=@{@"url":videoUrl,@"localPath":PathTime,@"date":[NSDate date],@"status":@"PENDING"};

    [self addVideo:dict];
    
   // NSLog(@"file path - %@",filePath);

    
    

    
    
    
    
    NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSData *yourVideoData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
        
        if (yourVideoData) {
            
            NSString *PathTime1=[NSString stringWithFormat:@"VideoCache_%@.mp4",[NSDate date]];
            NSString  *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,PathTime1];
            
            
            if([yourVideoData writeToFile:filePath1 atomically:YES])
            {
                
                NSLog(@"One video downloaded");
                
                [self removeVideo:dict];
                
                NSDictionary *dict1=@{@"url":videoUrl,@"localPath":PathTime1,@"date":[NSDate date],@"status":@"DONE"};
                
                [self addVideo:dict1];
                
                
                NSLog(@"write successfull");
            }
            else{
                NSLog(@"write failed");
            }
        }

    }];
    completionOperation.queuePriority=NSOperationQueuePriorityHigh;
    completionOperation.name=videoUrl;
 
    [[self getVideoQueue] addOperation:completionOperation];
   

    
}
+(void)removeVideo:(NSDictionary *)dict
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[self getArray]];
    [array removeObject:dict];
    NSUserDefaults *default1=[self userDefault];
    [default1 setObject:array forKey:@"videoCacheArray"];
    [default1 synchronize];


}
+(void)addVideo:(NSDictionary *)dict
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[self getArray]];
    [array addObject:dict];
    
    NSUserDefaults *default1=[self userDefault];
    [default1 setObject:array forKey:@"videoCacheArray"];
    [default1 synchronize];
    
   // NSLog(@"%ld",array.count);
    
}
+(BOOL)firstTime
{
    if([[self userDefault] valueForKey:@"videoCacheArray"]==nil)
    {
       return true;
    }
    else
    {
        return false;
    }
}


+(void)createEmptyArray
{
    NSArray *array=[[NSArray alloc] init];
    NSUserDefaults *default1=[self userDefault];
    [default1 setObject:array forKey:@"videoCacheArray"];
    [default1 synchronize];

    
}
+(NSArray *)getArray
{
    return [[self userDefault] valueForKey:@"videoCacheArray"];
    
}
+(int)getNumberOfCacheItems
{
    return (int)[self getArray].count;
    
}
+(void)clearCache;
{
    NSArray *list=[self getArray];
    
    for (int i=0; i<list.count; i++) {
        
        NSString *localPath=[[list objectAtIndex:i] valueForKey:@"localPath"];
        
        NSString *documentsDirectory=[self getDocumentPath];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,localPath];
        
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [self createEmptyArray];
}
+(NSString *)getDocumentPath
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
    
}
@end
