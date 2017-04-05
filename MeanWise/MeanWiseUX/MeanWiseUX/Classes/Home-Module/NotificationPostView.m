//
//  NotificationPostView.m
//  MeanWiseUX
//
//  Created by Hardik on 02/04/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NotificationPostView.h"
#import "PostFullCell.h"
#import "APIObjects_FeedObj.h"

@implementation NotificationPostView

-(void)setTarget:(id)targetReceived backBtnCallBack:(SEL)func
{
    target=targetReceived;
    backBtnCallBack=func;
    
}
-(void)setUpWithPostId:(NSDictionary *)postFeedObj withComment:(BOOL)commentFlag
{
    [[HMPlayerManager sharedInstance] StopKeepKillingNotificationVideosIfAvaialble];

    screenIdentifier=@"NOTIFICATIONPOST";
    [HMPlayerManager sharedInstance].NotificationPost_urlIdentifier=@"";

    sharecompo=nil;
    commentDisplay=nil;
    
    APIObjects_FeedObj *obj=[[APIObjects_FeedObj alloc] init];
    [obj setUpWithDict:postFeedObj];
    
    arrayData=[NSArray arrayWithObject:obj];
    
    UICollectionViewFlowLayout* layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 0;
    layout1.minimumLineSpacing = 0;
    layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    feedList = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout1];
    feedList.delegate = self;
    feedList.dataSource = self;
    //  ChannelList.pagingEnabled = YES;
    feedList.showsHorizontalScrollIndicator = NO;
    feedList.backgroundColor=[UIColor clearColor];
    [feedList registerClass:[PostFullCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self addSubview:feedList];
    feedList.pagingEnabled=YES;

    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);

    
    
    
   /* fullModeBtnDone=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];
    
    [fullModeBtnDone setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    
    fullModeBtnDone.center=CGPointMake(10+25/2-200, 20+65/2-10);
    
    [fullModeBtnDone addTarget:self
                        action:@selector(closeFullMode:) forControlEvents:UIControlEventTouchUpInside];*/
    

    [feedList performBatchUpdates:^{
        
        
    } completion:^(BOOL finished) {
       
        
        
        [self playAutomatically];
    }];
    

    if(commentFlag==true)
    {
        [self commentBtnClicked:obj.postId];
    }
    
    
}
-(void)backBtnClicked:(id)sender
{
    
    [[HMPlayerManager sharedInstance] StartKeepKillingNotificationVideosIfAvaialble];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        
        feedList.delegate=nil;
        feedList.dataSource=nil;
        [feedList removeFromSuperview];
        
        
        [target performSelector:backBtnCallBack withObject:nil afterDelay:0.01];
        
        [self removeFromSuperview];
        
    }];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayData.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setDataObj:[arrayData objectAtIndex:indexPath.row]];
    
    
    
    [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];
    
    //cell.player.screenIdentifier=screenIdentifier;
    [cell setPlayerScreenIdeantifier:screenIdentifier];
    
    
    
    
    
    
    return cell;
    
}
-(void)playAutomatically
{
    APIObjects_FeedObj *obj=[arrayData objectAtIndex:0];
    NSString *url=obj.video_url;
    
    NSIndexPath *visibleIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    
    
    if(![obj.video_url isEqualToString:[HMPlayerManager sharedInstance].NotificationPost_urlIdentifier])
    {
        
        PostFullCell *cell=(PostFullCell *)[feedList cellForItemAtIndexPath:visibleIndexPath];
        [cell playVideoIfAvaialble];
        
        [HMPlayerManager sharedInstance].NotificationPost_screenIdentifier=screenIdentifier;
        [HMPlayerManager sharedInstance].NotificationPost_urlIdentifier=url;
        
    }

}

-(void)NotificationPostGoesBack
{
    NSLog(@"Home screen back");
    [HMPlayerManager sharedInstance].NotificationPost_isPaused=true;
    
}
-(void)NotificationPostToFront
{
    NSLog(@"Home screen front");
    [HMPlayerManager sharedInstance].NotificationPost_isPaused=false;
    
}

-(void)shareBtnClicked:(NSString *)senderId
{
    
    
    if(sharecompo==nil)
    {
        
        [self NotificationPostGoesBack];
        
        sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
        [sharecompo setUp];
        [sharecompo setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        [self addSubview:sharecompo];
    }
    
}
-(void)commentBtnClicked:(NSString *)senderId
{
    
    
    if(commentDisplay==nil)
    {
        [self NotificationPostGoesBack];
        
        
        
        commentDisplay=[[FullCommentDisplay alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [commentDisplay setUpWithPostId:[NSString stringWithFormat:@"%@",senderId]];
        [self addSubview:commentDisplay];
        [commentDisplay setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            
            commentDisplay.frame=self.bounds;
            
        } completion:^(BOOL finished) {
            
            
            
        }];
    }
    
}
-(void)commentFullClosed:(id)sender
{
    [self NotificationPostToFront];
    
    
    commentDisplay=nil;
    sharecompo=nil;
}
@end
