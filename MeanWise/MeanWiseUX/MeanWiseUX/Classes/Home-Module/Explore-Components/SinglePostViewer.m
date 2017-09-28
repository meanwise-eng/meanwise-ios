//
//  SinglePostViewer.m
//  MeanWiseUX
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "SinglePostViewer.h"
#import "APIManager.h"
#import "APIObjects_FeedObj.h"
#import "FTIndicator.h"
#import "DetailViewComponent.h"


@interface SinglePostViewer ()
{
    DetailViewComponent *postView;
}

@end

@implementation SinglePostViewer

-(void)setUpWithPostId:(NSString *)postId withCommentOpen:(BOOL)flag;
{
    isCommentOpen=flag;
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5f];

    [self getPostInfo:postId];

}
-(void)getPostInfo:(NSString *)postId
{
    
    [FTIndicator showProgressWithmessage:@"Retriving.."];
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForPostInfoWithId:postId Withdelegate:self andSelector:@selector(postInfoReceived:)];
    
    
}
-(void)setDelegate:(id)target onCleanUp:(SEL)func
{
    delegate=target;
    onCleanupCallBack=func;
}

-(void)postInfoReceived:(APIResponseObj *)obj
{
    
    CGRect screenRect=self.bounds;
    
    if(obj.statusCode==200)
    {
        [FTIndicator dismissProgress];
        
        
        
        APIObjects_FeedObj *obj1=[[APIObjects_FeedObj alloc] init];
        [obj1 setUpWithDict:obj.response];
        
        NSMutableArray *arrayData=[NSMutableArray arrayWithObject:obj1];
        
        
        CGRect screenRect=self.bounds;
        
        
        postView=[[DetailViewComponent alloc] initWithFrame:screenRect];
        [self addSubview:postView];
        [postView setDataRecords:arrayData];
        [postView setUpWithCellRect:CGRectMake(0, screenRect.size.height, screenRect.size.width, 5)];
        [postView openCommentDirectly:isCommentOpen];
        
        
        
        APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[arrayData objectAtIndex:0];
        
        int mediaType = obj.mediaType.intValue;
        
        if(mediaType!=0)
        {
            NSString *imgURL=obj.image_url;
            [postView setImage:imgURL andNumber:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        else
        {
            int colorNumber=obj.colorNumber.intValue;
            [postView setColorNumber:colorNumber];
            
            [postView setImage:@"red" andNumber:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        [postView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(onPostClose:)];
        
        [postView setForPostDetail];
        [postView showBackBtn];
        
    }
    else
    {
        
        [FTIndicator dismissProgress];
        [FTIndicator showErrorWithMessage:@"Post Not Found"];
        
        [self hideDone];
    }
    
    
}
-(void)openingTableViewAtPath:(id)sender
{
    
    
    
}
-(void)onPostClose:(NSIndexPath *)path
{
    [self hideDone];
}
-(void)hideDone
{
    
    [delegate performSelector:onCleanupCallBack withObject:nil afterDelay:0.01];
   
    
    
    [self removeFromSuperview];
    
    
    
    
    
}

@end
