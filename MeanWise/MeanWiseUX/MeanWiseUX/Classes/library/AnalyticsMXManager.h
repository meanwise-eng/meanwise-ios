//
//  FlurryMXManager.h
//  MeanWiseUX
//
//  Created by Hardik on 25/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Mixpanel/Mixpanel.h"

@interface AnalyticsMXManager : NSObject

+(void)PushAnalyticsEvent:(NSString *)eventName;
+(void)PushAnalyticsEventAPI:(NSString *)eventName;

+(void)PushAnalyticsEventWithKey2:(NSString *)eventName forKey:(NSString *)key;

+(void)PushAnalyticsStartup;

@end
