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
@property(nonatomic) NSInteger totalNumOfPagesAvailable;
@property(nonatomic) NSInteger inputPageNo;

@property (strong,nonatomic) NSString *forwardURLStr;
@property (strong,nonatomic) NSString *backwardURLStr;

@property(nonatomic) NSInteger totalRecords;

@property (strong,nonatomic) id apiInputInfo;

@end
