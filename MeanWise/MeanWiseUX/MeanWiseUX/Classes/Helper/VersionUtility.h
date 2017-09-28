//
//  VersionUtility.h
//  MeanWiseUX
//
//  Created by Hardik on 09/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

@interface VersionUtility : NSObject
{
    id target;
    SEL callBackFunc;
    APIManager *mg;
}
-(void)setUpWithTarget:(id)tReceived onCallBack:(SEL)func;
-(void)requestForCall;


@end
