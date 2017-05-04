//
//  VideoCacheManager.h
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "AppDelegate.h"

@interface VideoCacheManager : NSObject
{
    NSUserDefaults *userDefaults;
    
    
}
+(void)setUp;

//Delete All videos and Clear Cache
+(void)clearCache;

//Add URL if exists
+(NSString *)getCachePathIfExists:(NSString *)urlToSearch;


//Count Number Of Data
+(int)getNumberOfCacheItems;




@end
