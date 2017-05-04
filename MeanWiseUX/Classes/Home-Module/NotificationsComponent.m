//
//  NotificationsComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NotificationsComponent.h"
#import "NotificationCell.h"
#import "FTIndicator.h"
#import "DataSession.h"

@implementation NotificationsComponent

-(void)setTarget:(id)target andBackBtnFunc:(SEL)func1;
{
    delegate=target;
    backBtnClickedFunc=func1;
}
-(void)setUp:(NSArray *)array;
{

    postView=nil;
    friendListCompo=nil;
    friendRequestListCompo=nil;
    
    
    if(array==nil)
    {
        array=[DataSession sharedInstance].notificationsResults;
    }
    dataFeeds=[NSMutableArray arrayWithArray:array];


    [self setUpWatchForNotifications];
    



   // self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pqr1.jpg"]];

    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];

    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [self addSubview:navBarTitle];
    navBarTitle.text=@"Notifications";
    navBarTitle.textColor=[UIColor whiteColor];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 40, 40)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(self.frame.size.width-10-25/2, 20+65/2-10);
    

    listTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65)];
    [self addSubview:listTable];
    listTable.backgroundColor=[UIColor clearColor];
    listTable.delegate=self;
    listTable.dataSource=self;
    listTable.tableFooterView = [[UIView alloc] init];

    
    
    //listTable.separatorColor=[UIColor clearColor];
    
    listTable.separatorColor=[UIColor colorWithWhite:1 alpha:0.2];

    
    emptyView=[[EmptyView alloc] initWithFrame:listTable.frame];
    [self addSubview:emptyView];
    [emptyView setUIForBlack];
    emptyView.reloadBtn.hidden=true;
    emptyView.msgLBL.text=@"No New Notifications";
    
    if([dataFeeds count]==0)
    {
       emptyView.hidden=false;
    }
    else
    {
        emptyView.hidden=true;
    }
    

   

   
   

}

-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:backBtnClickedFunc withObject:nil afterDelay:0.01];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.frame=CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

    }];
    
}
#pragma mark - New Notifications Watch


-(void)setUpWatchForNotifications
{
    if(dataFeeds.count>0)
    {
        APIObjects_NotificationObj *obj=[dataFeeds objectAtIndex:0];
        
        lastNotificationReceived=[NSString stringWithFormat:@"%@",obj.notificationId];
    }
    else
    {
        lastNotificationReceived=@"0";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkIfNewNotificationReceived)
                                                 name:@"NewNotificationDataReceived"
                                               object:nil];
    
}
-(void)checkIfNewNotificationReceived
{

    NSArray *array=[DataSession sharedInstance].notificationsResults;
  
    if(array.count!=0)
    {
        emptyView.hidden=true;

    APIObjects_NotificationObj *obj=[array objectAtIndex:0];
    
    NSString *currentLastId=[NSString stringWithFormat:@"%@",obj.notificationId];
    
    if(array.count!=dataFeeds.count || currentLastId!=lastNotificationReceived)
    {
        
        int number=(int)array.count-(int)dataFeeds.count;
        dataFeeds=[NSMutableArray arrayWithArray:array];
        lastNotificationReceived=[NSString stringWithFormat:@"%@",obj.notificationId];


      
        
        ///Update UI
        
        if(number>0)
        {
            

            NSMutableArray *indexPathArray=[[NSMutableArray alloc] init];
            for(int i=0;i<number;i++)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPathArray addObject:indexPath];
            }
            
            [listTable beginUpdates];
            [listTable insertRowsAtIndexPaths:[NSArray arrayWithArray:indexPathArray] withRowAnimation:UITableViewRowAnimationTop];
            [listTable endUpdates];

            

        }
        else
        {
            dataFeeds=[NSMutableArray arrayWithArray:array];
            [listTable reloadData];
        }

        //Update UI End
        
        
        

        
    }
    }
    else
    {
            emptyView.hidden=false;
      
    }
    [DataSession sharedInstance].noOfNewNotificationReceived=[NSNumber numberWithInt:0];

    //[self performSelector:@selector(checkIfNewNotificationReceived) withObject:nil afterDelay:2.0f];

}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataFeeds.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APIObjects_NotificationObj *obj=[dataFeeds objectAtIndex:indexPath.row];

    int typeNo=obj.notification_typeNo.intValue;
    
    int height=100;
    
    if(typeNo==1) //like
    {
        if(![obj.postType isEqualToString:@"1"])
        {
            height=100;
        }
        else
        {
            height=70;
        }
    }
    if(typeNo==2) //comment
    {
        if(![obj.postType isEqualToString:@"1"])
        {
            height=100;
        }
        else
        {
            height=100;
        }
    }
    if(typeNo==3) //accept
    {
        height=70;
    }
    if(typeNo==4) //request
    {
        height=70;
    }
    
    
    
    
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    NotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    APIObjects_NotificationObj *obj=[dataFeeds objectAtIndex:indexPath.row];
    
    [cell setUpObj:obj];
    
    
    //cell.textLabel.text = @"hello";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APIObjects_NotificationObj *obj=[dataFeeds objectAtIndex:indexPath.row];
    int typeNo=obj.notification_typeNo.intValue;
    
    if(typeNo==1) //like
    {
        NSDictionary *dict=obj.postFeedObj;
        [self openPost:dict withComment:false];
        
    }
    if(typeNo==2) //comment
    {
        NSDictionary *dict=obj.postFeedObj;
        [self openPost:dict withComment:YES];
        
    }
    if(typeNo==3) //accept
    {
        [self openFriendList];
    }
    if(typeNo==4) //request
    {
        [self openFriendRequestList];
    }
    
}
-(void)openPost:(NSDictionary *)postObj withComment:(BOOL)flag
{
    postView=[[NotificationPostView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:postView];
    [postView setUpWithPostId:postObj withComment:flag];
    
    [postView setTarget:self backBtnCallBack:@selector(backToNotifications:)];
    
    [UIView animateWithDuration:0.3 animations:^{
        postView.frame=self.bounds;
        postView.backgroundColor=[UIColor whiteColor];
    }];
    
}
-(void)openFriendList
{
    friendListCompo=[[FriendList alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [friendListCompo setUp];
    [friendListCompo setTarget:self andBackFunc:@selector(backToNotifications:)];
    [self addSubview:friendListCompo];
    
    [UIView animateWithDuration:0.3 animations:^{
        friendListCompo.frame=self.bounds;
        friendListCompo.backgroundColor=[UIColor whiteColor];
    }];
}
-(void)openFriendRequestList
{
    friendRequestListCompo=[[FriendRequestList alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [friendRequestListCompo setUp];
    [friendRequestListCompo setTarget:self andBackFunc:@selector(backToNotifications:)];
    [self addSubview:friendRequestListCompo];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        friendRequestListCompo.frame=self.bounds;
        friendRequestListCompo.backgroundColor=[UIColor whiteColor];
    }];
    
}
-(void)backToNotifications:(id)sender
{
    [postView removeFromSuperview];
    [friendListCompo removeFromSuperview];
    [friendRequestListCompo removeFromSuperview];
    
    friendListCompo=nil;
    friendRequestListCompo=nil;
    postView=nil;
    
    
}

@end
