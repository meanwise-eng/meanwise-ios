//
//  APIResponseObj.h
//  MeanWiseUX
//
//  Created by Hardik on 09/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIResponseObj : NSObject
{
    
}

@property (nonatomic) NSInteger statusCode;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDictionary *response;


@end
