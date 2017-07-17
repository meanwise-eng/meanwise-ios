//
//  FlurryMXManager.m
//  MeanWiseUX
//
//  Created by Hardik on 25/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "AnalyticsMXManager.h"

@implementation AnalyticsMXManager

+(void)PushAnalyticsEventAPI:(NSString *)eventName;
{
    [CrashlyticsKit setObjectValue:eventName forKey:@"API-Call"];
    
    eventName=[NSString stringWithFormat:@"API-%@",eventName];

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:eventName
         properties:@{ @"API-Call": eventName }];

    
    
}
+(void)PushAnalyticsEvent:(NSString *)eventName;
{
    [CrashlyticsKit setObjectValue:eventName forKey:@"ActionEvent"];
    
    eventName=[NSString stringWithFormat:@"FLOW-%@",eventName];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:eventName
         properties:@{ @"ActionEvent": eventName }];

    
}

+(void)PushAnalyticsEventWithKey2:(NSString *)eventName forKey:(NSString *)key
{
    
    [CrashlyticsKit setObjectValue:eventName forKey:key];

    
}


+(void)PushAnalyticsStartup
{
    [Mixpanel sharedInstanceWithToken:@"b4011efa4b1632300f9fcc9776bb884b"];

        [Fabric with:@[[Crashlytics class]]];
    

    
//    NSString *version=[NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
//    
//    
//    [Flurry startSession:@"64TQHGZH7J86ZNXNCX7M"];
//    [Flurry setLogLevel:FlurryLogLevelAll];
//    [Flurry setCrashReportingEnabled:YES];
//    [Flurry setAppVersion:version];

}
@end
