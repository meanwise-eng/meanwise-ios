//
//  FriendList.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "FriendList.h"
#import "FriendListCell.h"
#import "UserSession.h"
#import "APIObjectsParser.h"
#import "APIObjects_ProfileObj.h"
#import "FTIndicator.h"



@implementation FriendList

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
    navBarTitle.text=@"My Friends";
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

    pManager=[[API_PAGESManager alloc] initWithRequestCount:9 isVertical:YES];

    [self refreshAction];

    // msgContactTable.bounces=false;
    
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
    return finalArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    FriendListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    APIObjects_ProfileObj *obj=[finalArray objectAtIndex:indexPath.row];
    
    [cell setDataDict:obj];
        
    //name, username, picture, proffesion, location,

    //    cell.textLabel.text = @"hello";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    FriendListCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:false animated:true];
    
}
#pragma mark - API Pagination

-(void)refreshAction
{
    
    [finalArray removeAllObjects];
    finalArray=[[NSMutableArray alloc] init];
    [friendListTableView reloadData];
    
    
    manager=[pManager getFreshAPIManager];
     [manager sendRequestGettingUsersFriends:[UserSession getUserId] status:1 delegate:self andSelector:@selector(updateTheData:)];
    
    [FTIndicator showProgressWithmessage:@"Loading.."];
}
-(BOOL)checkIfUpdateValid:(NSArray *)update
{
//    NSMutableArray *temp=[[NSMutableArray alloc] init];
//    
//    [temp addObjectsFromArray:update];
//    
//    for(int i=0;i<[finalArray count];i++)
//    {
//        [temp addObject:[[finalArray objectAtIndex:i] valueForKey:@"id"]];
//    }
//    
//    
//    NSSet *setAll=[NSSet setWithArray:temp];
//    //NSLog(@"%ld-%ld",temp.count,setAll.count);
//    
//    if(setAll.count==temp.count)
//    {
//        return true;
//    }
//    else
//    {
//        return false;
//    }
    return true;
}
-(void)updateTheData:(APIResponseObj *)obj
{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [FTIndicator dismissProgress];

            NSLog(@"NEW DATA RECEIVED");
            
            if(obj.inputPageNo==pManager.AP_lastPageNumberRequested && obj.statusCode==200)
            {
                

                NSArray *response;
                
                if([[obj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    response=(NSArray *)[obj.response valueForKey:@"data"];
                    
                    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
                    response=[NSMutableArray arrayWithArray:[parser parseObjects_PROFILES:response]];

                }
                
              
                

                
                if(obj.statusCode==200 && [self checkIfUpdateValid:response])
                {
                    [pManager updateTheData:obj.totalNumOfPagesAvailable andLastReceived:obj.inputPageNo];
                    
                    //[FTIndicator showToastMessage:@"New Data Recevied"];
                    
                    
                    
                    
                    
                    if([friendListTableView isKindOfClass:[UITableView class]])
                    {
                        
                        UITableView *tableView=(UITableView *)friendListTableView;
                        
                        [tableView beginUpdates];
                        NSMutableArray *newIndexs=[[NSMutableArray alloc] init];
                        
                        for(int i=(int)finalArray.count;i<(finalArray.count+response.count);i++)
                        {
                            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                            [newIndexs addObject:indexPath];
                        }
                        
                        [finalArray addObjectsFromArray:response];
                        
                        NSArray *paths = [NSArray arrayWithArray:newIndexs];
                        [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
                        [tableView endUpdates];
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //        //Full Reload
                    //        NSArray *response=[obj.response valueForKey:@"data"];
                    //        NSMutableArray *array=[NSMutableArray arrayWithArray:finalArray];
                    //        [array addObjectsFromArray:response];
                    //        finalArray=[NSArray arrayWithArray:array];
                    //        [listView reloadData];
                    //
                    
                    NSMutableArray *temp=[[NSMutableArray alloc] init];
                    for(int i=0;i<[finalArray count];i++)
                    {
                        APIObjects_ProfileObj *po=[finalArray objectAtIndex:i];
                        [temp addObject:po.userId];
                    }
                    
                    
                    NSSet *setAll=[NSSet setWithArray:temp];
                    //NSLog(@"%ld-%ld",temp.count,setAll.count);
                    
                    if(temp.count!=setAll.count)
                    {
                        int breakMax=0;
                    }
                    else
                    {
                        NSLog(@"%ld",finalArray.count);
                        
                        
                    }
                    
                    
                }
                else
                {
                    if(obj.statusCode!=200)
                    {
                        [FTIndicator showToastMessage:obj.message];
                    }
                    else
                    {
                        [FTIndicator showToastMessage:@"Something Went Wrong.."];
                        
                    }
                    [pManager failedLastRequest];
                }
            }
            else
            {
                
                int p=0;
            }
            
            if(finalArray.count==0)
            {
                emptyView.hidden=false;
                friendListTableView.hidden=true;
            }
            else
            {
                emptyView.hidden=true;
                friendListTableView.hidden=false;
            }
            
        });
    });
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([pManager ifNewCallRequired:scrollView withCellHeight:friendListTableView.rowHeight])
    {
        [self callNewData];
    }
}
-(void)callNewData
{
    [FTIndicator showProgressWithmessage:@"Loading.."];
    
    manager=[pManager getNewAPImanagerForNextPage];
    [manager sendRequestGettingUsersFriends:[UserSession getUserId] status:1 delegate:self andSelector:@selector(updateTheData:)];
    
}
-(void)userFriendsReceived:(APIResponseObj *)responseObj
{
    //  NSLog(@"%@",responseObj.response);
    
    if([[responseObj.response valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        NSArray *array=[(NSArray *)responseObj.response valueForKey:@"data"];
        APIObjectsParser *parser=[[APIObjectsParser alloc] init];
        finalArray=[NSMutableArray arrayWithArray:[parser parseObjects_PROFILES:array]];
        
        [friendListTableView reloadData];
    }
    
    if(finalArray.count==0)
    {
        emptyView.hidden=false;
        friendListTableView.hidden=true;
    }
    else
    {
        emptyView.hidden=true;
        friendListTableView.hidden=false;
        
    }
    
    [FTIndicator dismissProgress];
}

@end
