//
//  ProfileWindowAditionalScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 13/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileWindowAditionalScreen.h"
#import "PostFullCell.h"
#import "DataSession.h"
#import "APIManager.h"
#import "FTIndicator.h"
#import "UIArcView.h"
#import "APIObjectsParser.h"
#import "QuickProfileEditComponent.h"
#import "QuickProfileColorComponent.h"
#import "UIColor+Hexadecimal.h"


#import "GUIScaleManager.h"


@implementation ProfileWindowAditionalScreen

-(void)setUp
{
    
    
    coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:coverView];
    
    shadowImage=[[UIImageView alloc] initWithFrame:self.bounds];
    [coverView addSubview:shadowImage];
    shadowImage.userInteractionEnabled=false;
    shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadowImage.contentMode=UIViewContentModeScaleToFill;
    
    
    masterScrollView=[[MasterScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:masterScrollView];
    masterScrollView.contentSize=CGSizeMake(0, self.frame.size.height*2);
    masterScrollView.bounces=false;
    masterScrollView.delegate=self;
    masterScrollView.pagingEnabled=true;
    masterScrollView.showsHorizontalScrollIndicator=false;
    masterScrollView.showsVerticalScrollIndicator=false;
    
    coverOverlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:coverOverlayView];
    
    
    storyView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:storyView];
    storyView.backgroundColor=[UIColor colorWithHexString:dataObj.profile_background_color];
    
    
    //    introVideoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*2, self.bounds.size.width, self.bounds.size.height)];
    //    [masterScrollView addSubview:introVideoView];
    //    introVideoView.backgroundColor=[Constant colorGlobal:1];
    
    postView=[[ProfileWindowFeedControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*2, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:postView];
    [postView setUp:[NSString stringWithFormat:@"%@",dataObj.userId]];
    postView.backgroundColor=[UIColor colorWithHexString:dataObj.profile_background_color];
    [postView setTarget:self andOnPostReceive:@selector(onPostDataReceived:)];

    
    
    
    
    
    shadowImage.alpha=0.2;
    
    [self addCoverViewItems];
    [self addStoryViewItems];
    [self setUpPostViewItems];
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    closeBtn.center=CGPointMake(RX_mainScreenBounds.size.width/2, RX_mainScreenBounds.size.height-50);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    closeProgressArcView=[[UIArcView alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    [closeProgressArcView setRadious:46/2];
    [closeProgressArcView setLineThicknessCustom:2];
    [closeProgressArcView setLineColorCustom:[UIColor whiteColor]];
    [self addSubview:closeProgressArcView];
    closeProgressArcView.center=closeBtn.center;
    [closeProgressArcView setProgress:0.25];
    closeProgressArcView.backgroundColor=[UIColor clearColor];
    closeProgressArcView.userInteractionEnabled=false;
    
    
    
    cover_addBtn=[[UIButton alloc] initWithFrame:CGRectMake(RX_mainScreenBounds.size.width-25, 25, 45, 45)];
    [self addSubview:cover_addBtn];
    cover_addBtn.center=CGPointMake(RX_mainScreenBounds.size.width-40, 58);
    [cover_addBtn setBackgroundImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
    [cover_addBtn addTarget:self
                     action:@selector(FriendShipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cover_addBtn.center=CGPointMake(RX_mainScreenBounds.size.width-40, 58);
    cover_addBtn.alpha=1;
    
    
    
    cover_completeProfileBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self addSubview:cover_completeProfileBtn];
    [cover_completeProfileBtn setBackgroundImage:[UIImage imageNamed:@"ProfileCompletePending.png"] forState:UIControlStateNormal];
    [cover_completeProfileBtn addTarget:self
                                 action:@selector(CompleteProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
    cover_completeProfileBtn.alpha=0;
    cover_completeProfileBtn.center=CGPointMake(RX_mainScreenBounds.size.width-40, 58);
    
    cover_ColorChangeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self addSubview:cover_ColorChangeBtn];
    [cover_ColorChangeBtn setBackgroundImage:[UIImage imageNamed:@"profileColorChangeBtn.png"] forState:UIControlStateNormal];
    [cover_ColorChangeBtn addTarget:self
                             action:@selector(ProfileColorChangeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cover_ColorChangeBtn.alpha=0;
    cover_ColorChangeBtn.center=CGPointMake(RX_mainScreenBounds.size.width-40, 58+58);
    
    
    if([[NSString stringWithFormat:@"%@",dataObj.userId] isEqualToString:[NSString stringWithFormat:@"%@",[UserSession getUserId]]])
    {
        //user-
        cover_addBtn.alpha=0;
        cover_addBtn.enabled=false;
        
        
        
        if(![dataObj.cover_photo isEqualToString:@""] && ![dataObj.profile_photo isEqualToString:@""] && ![dataObj.bio isEqualToString:@""] && ![dataObj.profile_story_description isEqualToString:@""] && ![dataObj.profession_text isEqualToString:@""] && ([dataObj.skill_List count] > 0) && ![dataObj.city isEqualToString:@""] && ![dataObj.dob isEqualToString:@""]){
            
            cover_completeProfileBtn.alpha = 1;
            cover_completeProfileBtn.enabled = true;
            
            cover_ColorChangeBtn.alpha=1;
            cover_ColorChangeBtn.enabled=true;
            
            
            [cover_completeProfileBtn setBackgroundImage:[UIImage imageNamed:@"ProfileCompleteDone.png"] forState:UIControlStateNormal];
            
            
        }
        else{
            cover_completeProfileBtn.alpha = 1;
            cover_completeProfileBtn.enabled = true;
            
            
            cover_ColorChangeBtn.alpha=1;
            cover_ColorChangeBtn.enabled=true;
            
        }
        
        
        
    }
    else if([[dataObj.friend_request_status lowercaseString] isEqualToString:@""])
    {
        
        //no
        cover_addBtn.alpha=1;
        cover_addBtn.enabled=true;
        cover_completeProfileBtn.enabled=false;
        cover_completeProfileBtn.alpha=0;
        
        cover_ColorChangeBtn.alpha=0;
        cover_ColorChangeBtn.enabled=false;
        
    }
    else
    {
        
        //rejected, accepted,pending
        cover_addBtn.alpha=0;
        cover_addBtn.enabled=false;
        cover_completeProfileBtn.enabled=false;
        cover_completeProfileBtn.alpha=0;
        
        cover_ColorChangeBtn.alpha=0;
        cover_ColorChangeBtn.enabled=false;
        
    }
    
    
    
    
    
}
-(void)onPostDataReceived:(NSNumber *)number
{
    long no=[number longValue];
    cover_profileViewCount.text=[NSString stringWithFormat:@"%ld",[number longValue]];
    
    if(no!=0)
    {
        masterScrollView.contentSize=CGSizeMake(0, self.frame.size.height*3);
    }
    else
    {
        masterScrollView.contentSize=CGSizeMake(0, self.frame.size.height*2);
    }
    
}
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
{
    dataObj=obj;
    
    firstNameStr=dataObj.first_name;
    
    noOfPosts=@"0";
    
    proffesionCityStr=[NSString stringWithFormat:@"%@\n%@",dataObj.profession_text,dataObj.city];
    
    
    
    
    
    connectionCountStr=[NSString stringWithFormat:@"%d",[dataObj.friend_count intValue]];
    storyTitleStr=dataObj.bio;
    storyDescStr=dataObj.profile_story_description;
    storySkillsArray=dataObj.skill_List;
    storyInterestsArray=dataObj.interests;
    
    
    NSMutableArray *listOfInterestsArray=[[NSMutableArray alloc] init];
    
    for(int i=0;i<storyInterestsArray.count;i++)
    {
        int interestId=[[storyInterestsArray objectAtIndex:i] intValue];
        
        NSString *interestName=[Constant static_getInterstFromId:interestId];
        
        [listOfInterestsArray addObject:interestName];
    }
    
    
    NSString *interestStr=[listOfInterestsArray componentsJoinedByString:@" #"];
    interestStr=[NSString stringWithFormat:@"#%@",interestStr];
    
    
 
    
    NSString *skillsStr=[storySkillsArray componentsJoinedByString:@" #"];
    skillsStr=[NSString stringWithFormat:@"#%@",skillsStr];
    
    
    storyInterestsStr=interestStr;
    storySkillsStr=skillsStr;
    
    tagsArray=[NSString stringWithFormat:@"%@ %@",storyInterestsStr,storySkillsStr];
    
    
    frienshipStatusStr=dataObj.friend_request_status;
    
    
    
}
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1;
{
    target=delegate;
    closeBtnClickedFunc=func1;
}

#pragma mark  - Profile color
-(void)ProfileColorChangeBtnClicked:(id)sender
{
    
    QuickProfileColorComponent *component =[[QuickProfileColorComponent alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:component];
    [component setUp:dataObj.profile_background_color];
    [component setTarget:self andBackBtnFunc:@selector(backFromColorChangeProfile:)];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect theBtn = cover_ColorChangeBtn.frame;
        
        component.alpha=1;
        component.frame=self.bounds;
        
        theBtn.origin.y = self.bounds.size.height;
        cover_ColorChangeBtn.frame = theBtn;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)backFromColorChangeProfile:(NSString *)sender
{
    
    storyView.backgroundColor=[UIColor colorWithHexString:sender];
    postView.backgroundColor=[UIColor colorWithHexString:sender];
    
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        cover_ColorChangeBtn.center=CGPointMake(RX_mainScreenBounds.size.width-40, 58+58);
        
    } completion:^(BOOL finished) {
        
        
        
    }];
}


#pragma mark  - Quick Profile edit
-(void)CompleteProfileClicked:(id)sender
{
    
    QuickProfileEditComponent *component =[[QuickProfileEditComponent alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:component];
    [component setUp];
    [component setTarget:self andBackBtnFunc:@selector(backFromQuickProfile:)];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect theBtn = cover_completeProfileBtn.frame;
        
        component.alpha=1;
        component.frame=self.bounds;
        
        theBtn.origin.y = self.bounds.size.height;
        cover_completeProfileBtn.frame = theBtn;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)backFromQuickProfile:(id)sender
{
    
    [self closeBtnClicked:nil];
    
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        cover_completeProfileBtn.center=CGPointMake(RX_mainScreenBounds.size.width-40, 58);
        
    } completion:^(BOOL finished) {
        
        
        
    }];
}
#pragma mark  - close Button

-(void)closeBtnClicked:(id)sender
{
    
    [target performSelector:closeBtnClickedFunc withObject:nil afterDelay:0.01];
    
}



-(void)addStoryViewItems
{
    
    
    if(![storyDescStr isEqualToString:@""] && ![storyTitleStr isEqualToString:@""])
    {
        
        int padding=20;
        
        story_titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(padding, 50, self.frame.size.width-padding*2, 100)];
        story_titleLBL.text=storyTitleStr;
        [storyView addSubview:story_titleLBL];
        story_titleLBL.numberOfLines=6;
        story_titleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:30];
        story_titleLBL.adjustsFontSizeToFitWidth=YES;
        story_titleLBL.textColor=[UIColor whiteColor];
        
        
        story_descLBL=[[UILabel alloc] initWithFrame:CGRectMake(padding, 160, self.frame.size.width-padding*2, 250)];
        story_descLBL.numberOfLines = 0;
        [storyView addSubview:story_descLBL];
        story_descLBL.textColor=[UIColor whiteColor];
        story_descLBL.text=storyDescStr;
        story_descLBL.adjustsFontSizeToFitWidth=YES;
        story_descLBL.font=[UIFont fontWithName:k_fontRegular size:18];
        
        
        
        story_tagsLBL=[[UILabel alloc] initWithFrame:CGRectMake(padding, 50+160+250, self.frame.size.width-padding*2, 150)];
        story_tagsLBL.text=tagsArray;
        [storyView addSubview:story_tagsLBL];
        story_tagsLBL.numberOfLines=0;
        story_tagsLBL.font=[UIFont fontWithName:k_fontBold size:16];
        story_tagsLBL.adjustsFontSizeToFitWidth=YES;
        story_tagsLBL.textColor=[UIColor whiteColor];
        
        
        
        
        story_tagsLBL.frame=CGRectMake(padding, story_descLBL.frame.origin.y+story_descLBL.frame.size.height+10, self.frame.size.width-padding*2, 150);
        
        
        
    }
    else if(![storyTitleStr isEqualToString:@""] && [storyDescStr isEqualToString:@""])
    {
        story_titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50, self.frame.size.width-50, 200)];
        story_titleLBL.text=storyTitleStr;
        [storyView addSubview:story_titleLBL];
        story_titleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:50];
        story_titleLBL.adjustsFontSizeToFitWidth=YES;
        story_titleLBL.textColor=[UIColor whiteColor];
        story_titleLBL.numberOfLines=6;
        
        
        story_tagsLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50+200, self.frame.size.width-50, 150)];
        story_tagsLBL.text=tagsArray;
        [storyView addSubview:story_tagsLBL];
        story_tagsLBL.numberOfLines=10;
        story_tagsLBL.font=[UIFont fontWithName:k_fontBold size:16];
        story_tagsLBL.adjustsFontSizeToFitWidth=YES;
        story_tagsLBL.textColor=[UIColor whiteColor];
        
    }
    else
    {
        
        NSString *storytags=[NSString stringWithFormat:@"Interests:\n%@\n\nSkills:\n%@",storyInterestsStr,storySkillsStr];
        
        
        NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:storytags];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:k_fontBold size:20]
                                 range:[storytags rangeOfString:@"Interests:"]];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:k_fontBold size:20]
                                 range:[storytags rangeOfString:@"Skills:"]];
        
        
        
        
        
        
        story_tagsLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50, self.frame.size.width-50, self.frame.size.height-100)];
        [storyView addSubview:story_tagsLBL];
        story_tagsLBL.numberOfLines=0;
        story_tagsLBL.font=[UIFont fontWithName:k_fontBold size:30];
        story_tagsLBL.adjustsFontSizeToFitWidth=YES;
        story_tagsLBL.textColor=[UIColor whiteColor];
        story_tagsLBL.attributedText=attributedString;
        
        
    }
    
    
    //    story_titleLBL.backgroundColor=[UIColor grayColor];
    //    story_descLBL.backgroundColor=[UIColor lightGrayColor];
    //    story_tagsLBL.backgroundColor=[UIColor darkGrayColor];
    //
    
    
}
-(void)addCoverViewItems
{
    
    cover_titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 250, self.frame.size.width-80, 200)];
    [coverView addSubview:cover_titleLBL];
    cover_titleLBL.numberOfLines=2;
    
    cover_titleLBL.text=[NSString stringWithFormat:@"Hey,\nI'm %@",firstNameStr];
    cover_titleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:80];
    cover_titleLBL.adjustsFontSizeToFitWidth=YES;
    cover_titleLBL.textColor=[UIColor whiteColor];
    
    cover_shortDescLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 250+200, self.frame.size.width-80, 50)];
    [coverView addSubview:cover_shortDescLBL];
    cover_shortDescLBL.numberOfLines=2;
    cover_shortDescLBL.text=proffesionCityStr;
    cover_shortDescLBL.font=[UIFont fontWithName:k_fontRegular size:20];
    cover_shortDescLBL.adjustsFontSizeToFitWidth=YES;
    cover_shortDescLBL.textColor=[UIColor whiteColor];
    
    
    
    cover_connectionCount=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    cover_connectionCount.textColor=[UIColor whiteColor];
    cover_connectionCount.textAlignment=NSTextAlignmentCenter;
    cover_connectionCount.text=connectionCountStr;
    [coverView addSubview:cover_connectionCount];
    cover_connectionCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    cover_connectionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    cover_connectionLabel.textColor=[UIColor whiteColor];
    cover_connectionLabel.textAlignment=NSTextAlignmentCenter;
    cover_connectionLabel.text=@"connections";
    [coverView addSubview:cover_connectionLabel];
    cover_connectionLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    cover_profileViewCount=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    cover_profileViewCount.textColor=[UIColor whiteColor];
    cover_profileViewCount.textAlignment=NSTextAlignmentCenter;
    cover_profileViewCount.text=noOfPosts;
    [coverView addSubview:cover_profileViewCount];
    cover_profileViewCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    cover_profileLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    cover_profileLabel.textColor=[UIColor whiteColor];
    cover_profileLabel.textAlignment=NSTextAlignmentCenter;
    cover_profileLabel.text=@"posts";
    [coverView addSubview:cover_profileLabel];
    cover_profileLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    
    
    cover_connectionCount.center=CGPointMake(RX_mainScreenBounds.size.width/2-85, RX_mainScreenBounds.size.height-95);
    cover_connectionLabel.center=CGPointMake(RX_mainScreenBounds.size.width/2-85, RX_mainScreenBounds.size.height-80);
    cover_profileViewCount.center=CGPointMake(RX_mainScreenBounds.size.width/2+85, RX_mainScreenBounds.size.height-95);
    cover_profileLabel.center=CGPointMake(RX_mainScreenBounds.size.width/2+85, RX_mainScreenBounds.size.height-80);
    
    
    cover_connectionCount.alpha=1;
    cover_connectionLabel.alpha=1;
    cover_profileViewCount.alpha=1;
    cover_profileLabel.alpha=1;
}



-(void)setUpPostViewItems
{
    
    
    
}

#pragma mark - API call



-(void)FriendShipBtnClicked:(id)sender
{
    
    
    
    NSDictionary *dict=@{@"friend_id":dataObj.userId,@"status":@"pending"};
    
    // {"friend_id":12, "status":"rejected"}
    APIManager *manager=[[APIManager alloc] init];
    
    [manager sendRequestForUpdateFriendshipStatus:dict delegate:self andSelector:@selector(updateFriendshipStatus:)];
    
    
    
}
-(void)updateFriendshipStatus:(APIResponseObj *)responseObj
{
    NSString *msg=(NSString *)responseObj.response;
    
    [FTIndicator showSuccessWithMessage:msg];
    
    
}

#pragma mark - Scroll

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView==masterScrollView)
    {
        float progress=scrollView.contentOffset.y/scrollView.contentSize.height+0.33;
        
        [closeProgressArcView setProgress:progress];
        
        if(scrollView.contentOffset.y>self.frame.size.height-50)
        {
            
            cover_addBtn.hidden=true;
            cover_completeProfileBtn.hidden = true;
            cover_ColorChangeBtn.hidden=true;
            
        }
        else
        {
            cover_addBtn.hidden=false;
            cover_completeProfileBtn.hidden = false;
            cover_ColorChangeBtn.hidden=false;
            
        }
        
        if(scrollView.contentOffset.y>self.frame.size.height)
        {
           closeBtn.hidden=true;
            closeProgressArcView.hidden=true;
        }
        else
        {
            closeBtn.hidden=false;
            closeProgressArcView.hidden=false;

        }
        
        
    }
    
    
}
-(void)removingComponent
{
    
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
}
@end
