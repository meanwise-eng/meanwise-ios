//
//  API_PAGESManager.m
//  MeanWiseUX
//
//  Created by Hardik on 09/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "API_PAGESManager.h"

@implementation API_PAGESManager


- (id) initWithRequestCount:(int)pageCount isVertical:(BOOL)vertical
{
    if (self = [super init])
    {
        self.AP_countForRequest = pageCount; // do your own initialisation here
        self.AP_isVertical = vertical;
        self.AP_isPageBasedOnRecords=false;
    }
    return self;
}


-(void)resetAll
{
    self.AP_lastPageNumberRequested=1;
    self.AP_lastPageNumberReceived=0;
    self.AP_totalNumberOfPageAvailble=0;
    
}
-(BOOL)ifNewCallRequired:(UIScrollView *)scrollView withCellHeight:(float)cellHeight
{
    CGPoint curPosition=scrollView.contentOffset;
    CGSize totalSize=scrollView.contentSize;
    
    
    if(self.AP_isVertical==true)
    {
        
        if(self.AP_isPageBasedOnRecords==false)
        {
            if(curPosition.y>(totalSize.height-scrollView.frame.size.height)*0.7)
            {
                if(self.AP_totalNumberOfPageAvailble>self.AP_lastPageNumberReceived && self.AP_lastPageNumberRequested==self.AP_lastPageNumberReceived)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        else
        {
            if(curPosition.y>(totalSize.height-cellHeight*5))
            {
                if(self.AP_totalNumberOfPageAvailble>self.AP_lastPageNumberReceived && self.AP_lastPageNumberRequested==self.AP_lastPageNumberReceived)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
            
        }
    }
    else
    {
        if(curPosition.x>(totalSize.width-scrollView.frame.size.width)*0.3)
        {
            
            if(self.AP_totalNumberOfPageAvailble>self.AP_lastPageNumberReceived && self.AP_lastPageNumberRequested==self.AP_lastPageNumberReceived)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            
            
            return false;
        }
    }
    
}
-(void)updateTheData:(NSInteger)NoOFPages andLastReceived:(NSInteger)lastReceived
{
    self.AP_totalNumberOfPageAvailble=NoOFPages;
    self.AP_lastPageNumberReceived=lastReceived;
    
}
-(NSInteger)getNewRequestId
{
    self.AP_lastPageNumberRequested=self.AP_lastPageNumberReceived+1;
    return self.AP_lastPageNumberRequested;
    
}
-(APIManager *)getFreshAPIManager
{
    [self resetAll];
    
    APIManager *manager=[[APIManager alloc] init];
    
    manager.pageNoRequested=self.AP_lastPageNumberRequested;
    manager.countRequested=self.AP_countForRequest;
    
    return manager;
    
}
-(APIManager *)getNewAPImanagerForNextPage;
{
    APIManager *manager=[[APIManager alloc] init];
    
    manager.pageNoRequested=[self getNewRequestId];
    manager.countRequested=self.AP_countForRequest;
    
    
    return manager;
}
-(void)failedLastRequest
{
    self.AP_lastPageNumberRequested=self.AP_lastPageNumberReceived;
    
}

@end
