//
//  MessageComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageComponent.h"
#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "GUIScaleManager.h"



@implementation MessageComponent

-(void)setUp
{
    
    chatMessages=[[NSMutableArray alloc] init];
    
    
    NSArray *randomMessages=[[NSArray alloc] initWithObjects:
                             @"yeah",
                             @"ok",
                             @"That's amazing!!.",
                             @"Hey How are you?",
                             @"Oh My god fine.",
                             @"So where are you now?",
                             @"for them, you are not even bound by the above copyright.", nil];
    
    NSArray *nameOfPeople=[[NSArray alloc] initWithObjects:
                           @"Timothy Johnson",
                             @"Alfredo Miles",
                             @"David Hargrove",
                             @"Gerald Park",
                             @"Michelle Cross",
                             @"Roslyn Wolfe",
                             @"Royce Andrews", nil];
    
    
    
    for(int i=0;i<20;i++)
    {
        
        int peopleName=arc4random()%(nameOfPeople.count);
        
        NSString *msg=[randomMessages objectAtIndex:arc4random()%(randomMessages.count)];

        NSString *name=[nameOfPeople objectAtIndex:peopleName];
        NSString *imageName=[NSString stringWithFormat:@"profile%d.jpg",peopleName+1];
        

        
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:msg,@"msg",
                            name,@"name",
                            imageName,@"image",
                            [NSNumber numberWithInt:arc4random()%2],@"sender",
                            nil];
        
        [chatMessages addObject:dict];
        
        
        
    }
    
    
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;

    
   
    
    msgContactTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 65+30+10, self.frame.size.width, self.frame.size.height-65-30-10)];
    [self addSubview:msgContactTable];
    msgContactTable.delegate=self;
    msgContactTable.dataSource=self;
    msgContactTable.backgroundColor=[UIColor whiteColor];

    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Message";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10, 65+5, self.frame.size.width-20, 30)];
    [self addSubview:view];
    view.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    view.layer.cornerRadius=2;
    view.clipsToBounds=YES;
    
    
    
    UIImageView *searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    searchIcon.image=[UIImage imageNamed:@"ChannelSearchIcon.png"];
    [view addSubview:searchIcon];
    searchIcon.contentMode=UIViewContentModeScaleAspectFill;
    
    UITextField *exploreTerm=[[UITextField alloc] initWithFrame:CGRectMake(50, 5, view.frame.size.width-50, 20)];
    [view addSubview:exploreTerm];
    exploreTerm.tintColor=[UIColor blackColor];
    exploreTerm.textColor=[UIColor blackColor];
    
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];

    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);

   // msgContactTable.bounces=false;

}
-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chatMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   return 80;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    
    MessageContactCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MessageContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.messageSubTextLBL.text=[[chatMessages valueForKey:@"msg"] objectAtIndex:indexPath.row];
    cell.contactNameLBL.text=[[chatMessages valueForKey:@"name"] objectAtIndex:indexPath.row];
    
    
    cell.profileIMGVIEW.image=[UIImage imageNamed:[[chatMessages valueForKey:@"image"] objectAtIndex:indexPath.row]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setAccessoryType:UITableViewCellAccessoryNone];


    
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageContactCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    CGRect myRect = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect=CGRectMake(0, tableView.frame.origin.y+myRect.origin.y+self.frame.origin.y, myRect.size.width, myRect.size.height);
    rect = CGRectOffset(rect, -tableView.contentOffset.x, -tableView.contentOffset.y);

    CGRect rectFull=RX_mainScreenBounds;
    rectFull=CGRectMake(rectFull.origin.x,-self.frame.origin.y, rectFull.size.width, rectFull.size.height);
    
    ChatThreadComponent *t=[[ChatThreadComponent alloc] initWithFrame:rectFull];
    [self addSubview:t];
    [t setUpFrame:rect andImage:cell.profileIMGVIEW.image];
    
}



@end
