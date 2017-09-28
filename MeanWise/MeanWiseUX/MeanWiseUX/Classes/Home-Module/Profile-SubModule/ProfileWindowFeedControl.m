//
//  ProfileWindowFeedControl.m
//  MeanWiseUX
//
//  Created by Hardik on 09/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileWindowFeedControl.h"
#import "GUIScaleManager.h"
#import "UserSession.h"

@implementation ProfileWindowFeedControl

-(void)setTarget:(id)targetReceived andOnPostReceive:(SEL)func;
{
    target=targetReceived;
    onPostReceivedCallBack=func;
}
-(void)setUp:(NSString *)userId
{
    if([[NSString stringWithFormat:@"%@",userId] isEqualToString:[NSString stringWithFormat:@"%@",[UserSession getUserId]]])
    {
        isUserCanDeletePost=true;
    }
    else
    {
        isUserCanDeletePost=false;
    }
    
    self.backgroundColor=[UIColor blackColor];
    
    filterControl=[[ProfileWindowFeedFilterControl alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
    [filterControl setUp];
    [self addSubview:filterControl];
    [filterControl setTarget:self onfilterSelect:@selector(onFilterSelect:)];
    
    recentPostsControl=[[ExplorePostsBar alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    [recentPostsControl setIsPortfolioLayout:YES onFilterUpdate:@selector(filterUpdate:) withUserId:userId];
    [recentPostsControl setUp];
    [self addSubview:recentPostsControl];
    [recentPostsControl setIdentifier:@"recentPostsControl"];
    [recentPostsControl setTarget:self andOnOpen:@selector(onPostExpand:)];

 
    
    [recentPostsControl setSearchType:-1];
    [recentPostsControl refreshAction:nil];
    
    

}

-(void)onFilterSelect:(NSString *)string
{
    NSLog(@"%@",string);
    
    [recentPostsControl setFilterOn:TRUE andWithFilterText:string];
    
}
-(void)filterUpdate:(NSDictionary *)filterUpdates
{
    NSLog(@"%@",filterUpdates);
    [filterControl setFilterData:[filterUpdates valueForKey:@"allRelatedInterests"]];
    NSInteger numOfTotalPosts=[[filterUpdates valueForKey:@"numOfTotalPosts"] integerValue];
    
    [target performSelector:onPostReceivedCallBack withObject:@(numOfTotalPosts) afterDelay:0.01];
    
}
-(void)onPostExpand:(NSDictionary *)dict
{
    
    [[HMPlayerManager sharedInstance] StopKeepKillingExploreFeedVideosIfAvaialble];
    
    NSIndexPath *path=[dict valueForKey:@"indexPath"];
    NSMutableArray *dataArray=[[NSMutableArray alloc] initWithArray:[dict valueForKey:@"data"]];
    NSString *identifier=[dict valueForKey:@"identifier"];
    
    if([identifier isEqualToString:@"recentPostsControl"])
    {
        currentHolder=recentPostsControl;
    }
    
    
    [currentHolder setCellHide:YES atIndexPath:path];
    
    detailPostView=[[DetailViewComponent alloc] initWithFrame:RX_mainScreenBounds];
    [self addSubview:detailPostView];
    [detailPostView setDataRecords:dataArray];
    
    
    CGRect cellRect=[currentHolder getTheRectOfCurrentCell:path];
    
    cellRect=CGRectMake(cellRect.origin.x, currentHolder.frame.origin.y+cellRect.origin.y, cellRect.size.width, cellRect.size.height);
    
    [detailPostView setIfUserCanDeletePost:isUserCanDeletePost withDeleteCallBack:@selector(onDeletePost:)];

    [detailPostView setUpWithCellRect:cellRect];

    
    APIObjects_FeedObj *obj=(APIObjects_FeedObj *)[dataArray objectAtIndex:path.row];
    
    int mediaType = obj.mediaType.intValue;
    
    if(mediaType!=0)
    {
        NSString *imgURL=obj.image_url;
        [detailPostView setImage:imgURL andNumber:path];
    }
    else
    {
        int colorNumber=obj.colorNumber.intValue;
        [detailPostView setColorNumber:colorNumber];
        
        [detailPostView setImage:@"red" andNumber:path];
    }
    [detailPostView setDelegate:self andPageChangeCallBackFunc:@selector(openingTableViewAtPath:) andDownCallBackFunc:@selector(onPostClose:)];
    

    [detailPostView setForPostDetail];

    
}
-(void)onDeletePost:(NSString *)postId
{
    [currentHolder deletePostWithPostId:postId];
    NSLog(@"post deleted %@",postId);
    
}
-(void)openingTableViewAtPath:(id)sender
{
    
    CGRect cellRect=[currentHolder openingTableViewAtPath:sender];
    
    
    cellRect=CGRectMake(cellRect.origin.x, currentHolder.frame.origin.y+cellRect.origin.y, cellRect.size.width, cellRect.size.height);
    
    [detailPostView setUpNewScrolledRect:cellRect];
    
}
-(void)onPostClose:(NSIndexPath *)path
{
    [[HMPlayerManager sharedInstance] StartKeepKillingExploreFeedVideosIfAvaialble];

    detailPostView=nil;
    [self updateTheCommentCountsForVisibleRows];
    
    
    [currentHolder setCellHide:false atIndexPath:path];
    
    
}
-(void)updateTheCommentCountsForVisibleRows
{
    
}

@end
