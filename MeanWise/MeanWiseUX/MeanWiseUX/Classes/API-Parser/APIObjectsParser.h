//
//  APIManager.h
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APIObjectsParser : NSObject

-(NSArray *)parseObjects_FEEDPOST:(NSArray *)array;
-(NSArray *)parseObjects_COMMENTS:(NSArray *)array;
-(NSArray *)parseObjects_PROFILES:(NSArray *)array;

@end
