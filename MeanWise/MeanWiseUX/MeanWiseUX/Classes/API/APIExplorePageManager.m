//
//  APIExplorePageManager.m
//  VideoPlayerDemo
//
//  Created by Hardik on 09/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "APIExplorePageManager.h"

@implementation APIExplorePageManager

-(void)reset
{
    self.previousRecordURLstr=nil;
    self.endReached=false;
    self.isRequesting=true;
}
-(void)setOutPutParameters:(APIResponseObj *)obj
{
    if([obj.backwardURLStr isKindOfClass:[NSNull class]])
    {
        self.endReached=true;
    }
    else
    {
        int p=0;
    }
    
    self.previousRecordURLstr=obj.backwardURLStr;
    self.isRequesting=false;
    
}
-(BOOL)ifNewCallRequired:(UIScrollView *)scrollView inY:(float)cellHeight
{
    CGPoint curPosition=scrollView.contentOffset;
    CGSize totalSize=scrollView.contentSize;
    
    if(self.endReached==false && self.isRequesting==false)
    {
        if(curPosition.y>(totalSize.height-scrollView.frame.size.height)*0.6)
        {
            
            self.isRequesting=true;
            
            return true;
        }
        else
        {
            //not at end
            return false;
        }
    }
    else
    {
        //already an api call or requesting..
        return false;
    }

}
-(BOOL)ifNewCallRequired:(UIScrollView *)scrollView withCellHeight:(float)cellHeight
{
    
    CGPoint curPosition=scrollView.contentOffset;
    CGSize totalSize=scrollView.contentSize;
    
    if(self.endReached==false && self.isRequesting==false)
    {
        if(curPosition.x>(totalSize.width-scrollView.frame.size.width)*0.6)
        {
            
            self.isRequesting=true;
            
            return true;
        }
        else
        {
            //not at end
            return false;
        }
    }
    else
    {
        //already an api call or requesting..
        return false;
    }
}
@end
