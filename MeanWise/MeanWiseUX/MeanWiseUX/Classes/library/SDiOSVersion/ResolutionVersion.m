//
//  ResolutionVersion.m
//  MeanWiseUX
//
//  Created by Hardik on 22/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ResolutionVersion.h"
#import "SDiOSVersion.h"

@implementation ResolutionVersion

+(BOOL)IfResIPhone5
{
    
    CGFloat screenHeight = 0;
    
    if ([SDiOSVersion versionGreaterThanOrEqualTo:@"8"]) {
        screenHeight = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    } else {
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
    }
    
 
    
    if (screenHeight == 568) {
        return true;
    } else
    {
        return false;
    }
        
}
+(BOOL)IfResiPhone7Plus
{
    CGFloat screenHeight = 0;
    
    if ([SDiOSVersion versionGreaterThanOrEqualTo:@"8"]) {
        screenHeight = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    } else {
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
    }
    
    
    
    if (screenHeight == 736) {
        return true;
    } else
    {
        return false;
    }
    
}
+(BOOL)IfResIPhone4
{
    
    CGFloat screenHeight = 0;
    
    if ([SDiOSVersion versionGreaterThanOrEqualTo:@"8"]) {
        screenHeight = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    } else {
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
    }
    
    
    
    if (screenHeight == 480) {
        return true;
    } else
    {
        return false;
    }
    
}
@end
