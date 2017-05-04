//
//  FriendRequestList.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "FriendRequestList.h"
#import "FriendListCell.h"

#import "APIObjectsParser.h"
#import "APIObjects_ProfileObj.h"
#import "UserSession.h"
#import "FTIndicator.h"


@implementation FriendRequestList

-(void)setUp
{
    
    
    
    
    
    
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;
    
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Friendship Request";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    
    friendListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65+25+40, self.frame.size.width, self.frame.size.height-65-25-40)];
    [self addSubview:friendListTableView];
    friendListTableView.delegate=self;
    friendListTableView.dataSource=self;
    friendListTableView.tableFooterView = [[UIView alloc] init];

    UIView *searchBox=[[UIView alloc] initWithFrame:CGRectMake(10, 65+10, self.frame.size.width-20, 40)];
    searchBox.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1.0f];
    [self addSubview:searchBox];
    searchBox.layer.cornerRadius=10;
    
    UIView *sep=[[UIView alloc] initWithFrame:CGRectMake(0, 65+25+40-1, self.frame.size.width, 1)];
    sep.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.1f];
    [self addSubview:sep];
    
    
    UITextField *searchField=[[UITextField alloc] initWithFrame:searchBox.bounds];
    searchField.backgroundColor=[UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00];
    searchField.layer.cornerRadius=10;
    [searchBox addSubview:searchField];
    searchField.placeholder=@"  Search";
    searchField.textColor=[UIColor grayColor];
    searchField.font=[UIFont fontWithName:k_fontSemiBold size:15];
    
    
    emptyView=[[EmptyView alloc] initWithFrame:friendListTableView.frame];
    [self addSubview:emptyView];
    emptyView.hidden=true;
    [emptyView setUIForWhite];
    [emptyView setDelegate:self onReload:@selector(refreshAction)];
    emptyView.msgLBL.text=@"No Pending Requests";
    

    
    [self refreshAction];
    
    
    // msgContactTable.bounces=false;
    
}
-(void)refreshAction
{
    manager=[[APIManager alloc] init];
    
    [manager sendRequestGettingUsersFriends:[UserSession getUserId] status:-1 delegate:self andSelector:@selector(userFriendsReceived:)];

    [FTIndicator showProgressWithmessage:@"Loading.."];

}
-(void)userFriendsReceived:(APIResponseObj *)responseObj
{
  //  NSLog(@"%@",responseObj.response);
    
    if([responseObj.response isKindOfClass:[NSArray class]])
    {
        NSArray *array=(NSArray *)responseObj.response;
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        resultData=[parser parseObjects_PROFILES:array];
        
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        for(int i=0;i<[resultData count];i++)
        {
            
            APIObjects_ProfileObj *obj=[resultData objectAtIndex:i];
            
            if([obj.friendShipStatus isEqualToString:@"Pending"])
            {
            [resultArray addObject:obj];
            }
        }
        
        resultData=[NSArray arrayWithArray:resultArray];
        
        
        //   int p=0;
        [friendListTableView reloadData];
    }
    [FTIndicator dismissProgress];

    if(resultData.count==0)
    {
        emptyView.hidden=false;
        friendListTableView.hidden=true;
    }
    else
    {
        emptyView.hidden=true;
        friendListTableView.hidden=false;
        
    }
}


-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
    [FTIndicator dismissProgress];

    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];

        [self removeFromSuperview];
        
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    FriendListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    APIObjects_ProfileObj *obj=[resultData objectAtIndex:indexPath.row];
    
    [cell setDataDict:obj];
    
    cell.acceptBtn.hidden=false;
    cell.rejectBtn.hidden=false;
    
    [cell setTargetCaller:self];
    [cell setCallBackForAccept:@selector(FriendShipAccepted:)];
    [cell setCallBackForReject:@selector(FriendShipRejected:)];
    
    
    //    cell.textLabel.text = @"hello";
    
    return cell;
}
-(void)FriendShipAccepted:(NSString *)str
{
    //'{"friend_id":2, "status":"accepted"}'
    
    NSDictionary *dict=@{@"friend_id":str,@"status":@"accepted"};

    
    
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForUpdateFriendshipStatus:dict delegate:self andSelector:@selector(updateFriendshipStatus:)];
    

    
}
-(void)FriendShipRejected:(NSString *)str
{

    NSDictionary *dict=@{@"friend_id":str,@"status":@"rejected"};

   // {"friend_id":12, "status":"rejected"}
    manager=[[APIManager alloc] init];
    
    [manager sendRequestForUpdateFriendshipStatus:dict delegate:self andSelector:@selector(updateFriendshipStatus:)];
    

}
-(void)updateFriendshipStatus:(APIResponseObj *)responseObj
{
    NSString *msg=(NSString *)responseObj.response;
    
    [FTIndicator showSuccessWithMessage:msg];
    
    [self refreshAction];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendListCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:false animated:true];
    
}


@end
