//
//  SettingComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "SettingsComponent.h"
#import "ViewController.h"

#import "EditIntroBioComponent.h"
#import "EditBirthdayComponent.h"
#import "EditGenderComponent.h"
#import "EditIntroBioComponent.h"
#import "EditIntroVideoComponent.h"
#import "EditLocationComponent.h"
#import "EditMobileNoComponent.h"
#import "EditNameComponent.h"
#import "EditPasswordComponent.h"
#import "EditProffesionComponent.h"
#import "EditSkillsComponent.h"
#import "EditStoryComponent.h"

@implementation SettingsComponent

-(void)setUp
{
    


    passed=0;
    
    items1=[NSArray arrayWithObjects:@"Intro",@"Story",@"*Intro Video",@"*Skills",@"Profession",@"Location", nil];
    
    items2=[NSArray arrayWithObjects:@"Name",@"*UserName",@"Birthday",@"Mobile Number",@"*Email",@"Password",@"Logout", nil];

    
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;
    
    
    
    
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Settings";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    
    
    
   
    
    listOfItems=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65)];
    [self addSubview:listOfItems];
    listOfItems.delegate=self;
    listOfItems.dataSource=self;
    listOfItems.backgroundColor=[UIColor clearColor];
    listOfItems.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    listOfItems.separatorColor=[UIColor colorWithWhite:0 alpha:0.2];
    
    
    
    // msgContactTable.bounces=false;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
    return items1.count;
    }
    else
    {
    return items2.count;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return @"PROFILE SETTINGS";
    }
    else
    {
        return @"ACCOUNT SETTINGS";
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height=50;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, height)];
    label.font=[UIFont fontWithName:k_fontSemiBold size:11];
    NSString *string =[self tableView:tableView titleForHeaderInSection:section];
    [label setText:string];
    [view addSubview:label];
    label.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
       if(indexPath.section==0)
       {
           cell.textLabel.text = [items1 objectAtIndex:indexPath.row];

       }
       else
       {
           cell.textLabel.text = [items2 objectAtIndex:indexPath.row];

       }
    
    cell.textLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
  //  cell.textLabel.textColor=;
    cell.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor colorWithRed:0.42 green:0.80 blue:1.00 alpha:1.00];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(passed!=0)
    {
        return;
    }
    
    passed=1;
    
    
    if(indexPath.row==0 && indexPath.section==0)
    {
        
        EditIntroBioComponent *Compo=[[EditIntroBioComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
    
        [self addSubview:Compo];
    
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==1 && indexPath.section==0)
    {
        
        EditStoryComponent *Compo=[[EditStoryComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
        
    }
    if(indexPath.row==2 && indexPath.section==0)
    {
        
        EditIntroVideoComponent *Compo=[[EditIntroVideoComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==3 && indexPath.section==0)
    {
        
        EditSkillsComponent *Compo=[[EditSkillsComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==4 && indexPath.section==0)
    {
        
        EditProffesionComponent *Compo=[[EditProffesionComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==5 && indexPath.section==0)
    {
        
        EditLocationComponent *Compo=[[EditLocationComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];

        
      
    }
   
    
    
    if(indexPath.row==0 && indexPath.section==1)
    {
        
        EditNameComponent *Compo=[[EditNameComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==2 && indexPath.section==1)
    {
        
        EditBirthdayComponent *Compo=[[EditBirthdayComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==3 && indexPath.section==1)
    {
        
        EditMobileNoComponent *Compo=[[EditMobileNoComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==5 && indexPath.section==1)
    {
        
        EditPasswordComponent *Compo=[[EditPasswordComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        Compo.blackOverLayView.image=[Constant takeScreenshot];
        Compo.blackOverLayView.alpha=1;
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    if(indexPath.row==1 && indexPath.section==1)
    {
        passed=0;
    }
    if(indexPath.row==4 && indexPath.section==1)
    {
        passed=0;
    }
    if(indexPath.row==6 && indexPath.section==1)
    {
        UINavigationController *vc=(UINavigationController *)[Constant topMostController];
        ViewController *t=(ViewController *)vc.topViewController;
        [t MasterlogoutBtnClicked:nil];
    }
    
}
-(void)backFromSetting:(id)sender
{
    passed=0;
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





@end
