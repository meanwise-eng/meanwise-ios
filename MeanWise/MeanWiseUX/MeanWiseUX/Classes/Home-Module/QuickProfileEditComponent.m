//
//  NotificationsComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 05/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "QuickProfileEditComponent.h"
#import "ProfileCompleteCell.h"
#import "CompleteProfileItem.h"
#import "DataSession.h"

#import "EditBirthdayComponent.h"
#import "EditIntroBioComponent.h"
#import "EditLocationComponent.h"
#import "EditStoryComponent.h"
#import "MyAccountComponent.h"

#import "EditPCComponent.h"
#import "EditSCComponent.h"

@implementation QuickProfileEditComponent

-(void)setTarget:(id)target andBackBtnFunc:(SEL)func1;
{
    delegate=target;
    backBtnClickedFunc=func1;
}
-(void)setUp;
{
    [self setProfileDataCheck];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurEffectView];
    
    
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
    listTable.separatorColor=[UIColor clearColor];
    
}

-(void)setProfileDataCheck
{
    
    APIObjects_ProfileObj *obj=[UserSession getUserObj];
    
    if (![obj.cover_photo isEqualToString:@""]) {
        blnCover = YES;
    }
    else{
        blnCover = NO;
    }
    
    if (![obj.profile_photo isEqualToString:@""]) {
        blnProfile = YES;
    }
    else{
        blnProfile = NO;
    }
    
    if (![obj.bio isEqualToString:@""]) {
        blnIntro = YES;
    }
    else{
        blnIntro = NO;
    }
    
    if (![obj.profile_story_description isEqualToString:@""]) {
        blnBio = YES;
    }
    else{
        blnBio = NO;
    }
    
    if (![obj.profession_text isEqualToString:@""]) {
        blnProf = YES;
    }
    else{
        blnProf = NO;
    }
    
    if ([obj.skill_List count] > 0) {
        blnSkills = YES;
    }
    else{
        blnSkills = NO;
    }
    
    if (![obj.city isEqualToString:@""]) {
        blnLocation = YES;
    }
    else{
        blnLocation = NO;
    }
    
    if (![obj.dob isEqualToString:@""]) {
        blnDOB = YES;
    }
    else{
        blnDOB = NO;
    }
    
    CompleteProfileItem* cover = [[CompleteProfileItem alloc] initWithName:@"Cover Photo" setImage:[UIImage imageNamed:@"profileCoverPhotoBtn"] setStatus:blnCover];
    CompleteProfileItem* photo = [[CompleteProfileItem alloc] initWithName:@"Profile Photo" setImage:[UIImage imageNamed:@"profileBioBtn"] setStatus:blnProfile];
    CompleteProfileItem* intro = [[CompleteProfileItem alloc] initWithName:@"Intro" setImage:[UIImage imageNamed:@"profileIntroBtn"] setStatus:blnIntro];
    CompleteProfileItem* bio = [[CompleteProfileItem alloc] initWithName:@"Bio" setImage:[UIImage imageNamed:@"profileBioBtn"] setStatus:blnBio];
    CompleteProfileItem* profession = [[CompleteProfileItem alloc] initWithName:@"Profession" setImage:[UIImage imageNamed:@"profileProfessionBtn"] setStatus:blnProf];
    CompleteProfileItem* skills = [[CompleteProfileItem alloc] initWithName:@"Skills" setImage:[UIImage imageNamed:@"profileSkillsBtn"] setStatus:blnSkills];
    CompleteProfileItem* location = [[CompleteProfileItem alloc] initWithName:@"Location" setImage:[UIImage imageNamed:@"profileLocationBtn"] setStatus:blnLocation];
    CompleteProfileItem* dob = [[CompleteProfileItem alloc] initWithName:@"Date of Birth" setImage:[UIImage imageNamed:@"profileDOBBtn"] setStatus:blnDOB];
    
    profileItems = [[NSMutableArray alloc]initWithObjects:cover,photo,intro,bio,profession,skills,location,dob, nil];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [profileItems count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    back.backgroundColor = [UIColor clearColor];
    
    return back;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    back.backgroundColor = [UIColor clearColor];
    
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, self.bounds.size.width -40, 20)];
    footer.text = @"Complete your profile for more visibility";
    footer.textColor = [UIColor whiteColor];
    footer.font = [UIFont fontWithName:k_fontRegular size:14];
    footer.textAlignment = NSTextAlignmentLeft;
    [back addSubview:footer];
    
    return back;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"CellIdentifier";
    
    ProfileCompleteCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    CompleteProfileItem *item = [profileItems objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[ProfileCompleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.itemImage.image = item.icon;
        cell.itemLbl.text = item.name;
        
        if(item.status){
            cell.itemStatus.image = [UIImage imageNamed:@"profileItemDoneBtn"];
            [cell.itemStatus setFrame:CGRectMake(self.bounds.size.width - 50, 10, 23, 13)];
            
        }
        else{
            cell.itemStatus.image = [UIImage imageNamed:@"profleItemMissingBtn"];
            [cell.itemStatus setFrame:CGRectMake(self.bounds.size.width - 40, 10, 4, 21)];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 && indexPath.section==0)
    {
        MyAccountComponent *Compo=[[MyAccountComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    if(indexPath.row==1 && indexPath.section==0)
    {
        MyAccountComponent *Compo=[[MyAccountComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
        
    }
    
    
    if(indexPath.row==2 && indexPath.section==0)
    {
        
        EditIntroBioComponent *Compo=[[EditIntroBioComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    if(indexPath.row==3 && indexPath.section==0)
    {
        
        EditStoryComponent *Compo=[[EditStoryComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    if(indexPath.row==4 && indexPath.section==0)
    {
        
        EditPCComponent *Compo=[[EditPCComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    if(indexPath.row==5 && indexPath.section==0)
    {
        
        EditSCComponent *Compo=[[EditSCComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    if(indexPath.row==6 && indexPath.section==0)
    {
        
        EditLocationComponent *Compo=[[EditLocationComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    if(indexPath.row==7 && indexPath.section==0)
    {
        
        EditBirthdayComponent *Compo=[[EditBirthdayComponent alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [Compo setUp];
        [Compo setTarget:self andBackFunc:@selector(backFromSetting:)];
        
        [self addSubview:Compo];
        
        [UIView animateWithDuration:0.3 animations:^{
            Compo.frame=self.bounds;
            Compo.backgroundColor=[UIColor whiteColor];
        }];
    }
    
    
}


-(void)backFromSetting:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [AnalyticsMXManager PushAnalyticsEventAction:@"Profile-Quick Update"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [profileItems removeAllObjects];
            [listTable reloadData];
            [self setProfileDataCheck];
            listTable.delegate=nil;
            listTable.dataSource=nil;
            [listTable removeFromSuperview];

            listTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65)];
            [self addSubview:listTable];
            listTable.backgroundColor=[UIColor clearColor];
            listTable.delegate=self;
            listTable.dataSource=self;
            listTable.tableFooterView = [[UIView alloc] init];
            listTable.separatorColor=[UIColor clearColor];

            
//            [listTable reloadData];

            
        });
        
        
    });
    
}

@end
