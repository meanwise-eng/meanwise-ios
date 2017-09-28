//
//  APIExplorePageManager.h
//  VideoPlayerDemo
//
//  Created by Hardik on 09/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "APIResponseObj.h"

@interface APIExplorePageManager : NSObject
{
    
}
@property (nonatomic) NSString *previousRecordURLstr;
@property (nonatomic) BOOL endReached;
@property (nonatomic) BOOL isRequesting;

-(BOOL)ifNewCallRequired:(UIScrollView *)scrollView withCellHeight:(float)cellHeight;
-(void)reset;
-(BOOL)ifNewCallRequired:(UIScrollView *)scrollView inY:(float)cellHeight;

-(void)setOutPutParameters:(APIResponseObj *)obj;

@end
