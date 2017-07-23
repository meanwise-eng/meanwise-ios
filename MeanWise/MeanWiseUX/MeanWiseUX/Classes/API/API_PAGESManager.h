//
//  API_PAGESManager.h
//  MeanWiseUX
//
//  Created by Hardik on 09/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APIManager.h"


@interface API_PAGESManager : NSObject
{
    
}
@property(nonatomic) NSInteger AP_totalNumberOfPageAvailble;
@property(nonatomic) NSInteger AP_lastPageNumberReceived;
@property(nonatomic) NSInteger AP_lastPageNumberRequested;
@property(nonatomic) NSInteger AP_countForRequest;
@property(nonatomic) BOOL AP_isVertical;
@property(nonatomic) BOOL AP_isPageBasedOnRecords;

- (id) initWithRequestCount:(int)pageCount isVertical:(BOOL)vertical;
-(void)resetAll;
-(BOOL)ifNewCallRequired:(UIScrollView *)scrollView withCellHeight:(float)height;
-(void)updateTheData:(NSInteger)NoOFPages andLastReceived:(NSInteger)lastReceived;
-(NSInteger)getNewRequestId;
-(APIManager *)getNewAPImanagerForNextPage;
-(APIManager *)getFreshAPIManager;
-(void)failedLastRequest;
@end
