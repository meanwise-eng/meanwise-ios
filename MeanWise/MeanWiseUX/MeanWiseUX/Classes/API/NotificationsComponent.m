//
//  NotificationScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NotificationScreen.h"
#import "NotificationCell.h"
#import "FTIndicator.h"

@implementation NotificationScreen

-(void)setUp:(NSArray *)array;
{

    dataFeeds=array;

    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pqr1.jpg"]];

    
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
    

    listTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65)];
    [self addSubview:listTable];
    listTable.backgroundColor=[UIColor clearColor];
    listTable.delegate=self;
    listTable.dataSource=self;
    
    if([listTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        listTable.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    listTable.separatorColor=[UIColor colorWithWhite:1 alpha:0.2];

    [self setUpData];
    
    [self showOneNotification];
   
}
-(void)setUpData
{
   
    notifiationsData=[[NSMutableArray alloc] init];
    
    
}

-(void)showOneNotification
{
    APIObjects_NotificationObj *obj=[dataFeeds objectAtIndex:0];
    NSString *string=[NSString stringWithFormat:@"%@ %@",obj.notifier_userFirstName,obj.notifier_userLastName];
    

    [FTIndicator setIndicatorStyle:UIBlurEffectStyleExtraLight];
    
    [FTIndicator showNotificationWithImage:[UIImage imageNamed:@"profile1.jpg"]
                                     title:string
                                   message:obj.msgText
                                tapHandler:^{
                                    // handle user tap
                                } completion:^{
                                    // handle completion
                                }];
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
            height=70;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
