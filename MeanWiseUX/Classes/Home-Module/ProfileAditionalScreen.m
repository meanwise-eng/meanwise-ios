//
//  ProfileAditionalScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 13/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileAditionalScreen.h"
#import "CGGeometryExtended.h"
#import "PostFullCell.h"
#import "DataSession.h"
#import "APIManager.h"
#import "FTIndicator.h"
#import "UIArcView.h"
#import "APIObjectsParser.h"
#import "ProfileCompleteComponent.h"


@implementation ProfileAditionalScreen

-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
{
    dataObj=obj;
    
    firstNameStr=dataObj.first_name;
    
    [self setUpDataRecordsForPosts];
    
    noOfPosts=[NSString stringWithFormat:@"%d",(int)[dataRecords count]];
    
    proffesionCityStr=[NSString stringWithFormat:@"%@\n%@",dataObj.profession,dataObj.city];
    
    
    
    
    connectionCountStr=[NSString stringWithFormat:@"%d",(int)dataObj.userFriends.count];
    storyTitleStr=dataObj.profile_story_title;
    storyDescStr=dataObj.profile_story_description;
    storySkillsArray=dataObj.skills;
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
    
    
    NSMutableArray *listOfSkillsArrays=[[NSMutableArray alloc] init];
    
    for(int i=0;i<storySkillsArray.count;i++)
    {
        int skillId=[[storySkillsArray objectAtIndex:i] intValue];
        
        NSString *skillName=[Constant static_getSKillFromId:skillId];
        
        [listOfSkillsArrays addObject:skillName];
    }
    
    
    NSString *skillsStr=[listOfSkillsArrays componentsJoinedByString:@" #"];
    skillsStr=[NSString stringWithFormat:@"#%@",skillsStr];
    
    
    storyInterestsStr=interestStr;
    storySkillsStr=skillsStr;
    
    tagsArray=[NSString stringWithFormat:@"%@\n\n%@",storyInterestsStr,storySkillsStr];
    
    
    frienshipStatusStr=dataObj.friendShipStatus;
    
}
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1;
{
    target=delegate;
    closeBtnClickedFunc=func1;
}
-(void)setUp
{
    commentDisplay=nil;
    sharecompo=nil;
    
    screenIdentifier=@"PROFILE";
    [HMPlayerManager sharedInstance].Profile_urlIdentifier=@"";
    
    coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:coverView];
    
    shadowImage=[[UIImageView alloc] initWithFrame:self.bounds];
    [coverView addSubview:shadowImage];
    shadowImage.userInteractionEnabled=false;
    shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadowImage.contentMode=UIViewContentModeScaleToFill;
    
    
    masterScrollView=[[MasterScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:masterScrollView];
    masterScrollView.contentSize=CGSizeMake(0, self.frame.size.height*3);
    //   masterScrollView.canCancelContentTouches=false;
    masterScrollView.bounces=false;
    masterScrollView.delegate=self;
    masterScrollView.pagingEnabled=true;
    // masterScrollView.decelerationRate=0;
    masterScrollView.showsHorizontalScrollIndicator=false;
    masterScrollView.showsVerticalScrollIndicator=false;
    //masterScrollView.directionalLockEnabled=YES;
    
    coverOverlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:coverOverlayView];
    
    
    storyView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:storyView];
    storyView.backgroundColor=[Constant colorGlobal:0];
    
    introVideoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*2, self.bounds.size.width, self.bounds.size.height)];
    //[masterScrollView addSubview:introVideoView];
    introVideoView.backgroundColor=[Constant colorGlobal:1];
    
    postView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*2, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:postView];
    postView.backgroundColor=[Constant colorGlobal:2];
    
    
    
    
    
    
    shadowImage.alpha=0.2;
    
    [self addCoverViewItems];
    [self addStoryViewItems];
   // [self setUpIntroVideoItems];
    [self setUpPostViewItems];
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-50);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CGX_scaleFactor();
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    closeProgressArcView=[[UIArcView alloc] initWithFrame:CGXRectMake(0, 0, 49, 49)];
    [closeProgressArcView setRadious:46/2*CGX_scaleFactor()];
    [closeProgressArcView setLineThicknessCustom:2];
    [closeProgressArcView setLineColorCustom:[UIColor whiteColor]];
    [self addSubview:closeProgressArcView];
    closeProgressArcView.center=closeBtn.center;
    [closeProgressArcView setProgress:0.25];
    closeProgressArcView.backgroundColor=[UIColor clearColor];
    closeProgressArcView.userInteractionEnabled=false;
    
    
    
    cover_addBtn=[[UIButton alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()-25, 25, 45, 45)];
    [self addSubview:cover_addBtn];
    cover_addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
    [cover_addBtn setBackgroundImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
    [cover_addBtn addTarget:self
                     action:@selector(FriendShipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cover_addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
    cover_addBtn.alpha=1;
    
    cover_completeProfileBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 50, 46)];
    [self addSubview:cover_completeProfileBtn];
    cover_completeProfileBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, 23);
    [cover_completeProfileBtn setBackgroundImage:[UIImage imageNamed:@"ProfileComplete.png"] forState:UIControlStateNormal];
    [cover_completeProfileBtn addTarget:self
                     action:@selector(CompleteProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
    cover_completeProfileBtn.alpha=1;
    
    
    if([[NSString stringWithFormat:@"%@",dataObj.userId] isEqualToString:[NSString stringWithFormat:@"%@",[UserSession getUserId]]])
    {
        //user-
        cover_addBtn.alpha=0;
        cover_addBtn.enabled=false;
        
        if(![dataObj.cover_photo isEqualToString:@""] && ![dataObj.profile_photo isEqualToString:@""] && ![dataObj.profile_story_title isEqualToString:@""] && ![dataObj.profile_story_description isEqualToString:@""] && ![dataObj.profession isEqualToString:@""] && ([dataObj.skills count] > 0) && ![dataObj.city isEqualToString:@""] && ![dataObj.dob isEqualToString:@""]){
            
            cover_completeProfileBtn.alpha = 0;
            cover_completeProfileBtn.enabled = false;
            
        }
        else{
            cover_completeProfileBtn.alpha = 1;
            cover_completeProfileBtn.enabled = true;
        }
        
    }
    else if([[dataObj.friendShipStatus lowercaseString] isEqualToString:@""])
    {
        //no
        cover_completeProfileBtn.alpha = 0;
        cover_completeProfileBtn.enabled = false;
        cover_addBtn.alpha=1;
        cover_addBtn.enabled=true;
    }
    else
    {
        //rejected, accepted,pending
        cover_addBtn.alpha=0;
        cover_addBtn.enabled=false;
        
        cover_completeProfileBtn.alpha = 0;
        cover_completeProfileBtn.enabled = false;
    }
    
    
}

-(void)CompleteProfileClicked:(id)sender
{
    ProfileCompleteComponent *compProfile =[[ProfileCompleteComponent alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:compProfile];
    [compProfile setUp];
    [compProfile setTarget:self andBackBtnFunc:@selector(CompleteProfileClosed:)];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect theBtn = cover_completeProfileBtn.frame;
        
        compProfile.alpha=1;
        compProfile.frame=self.bounds;

        theBtn.origin.y = self.bounds.size.height;
        cover_completeProfileBtn.frame = theBtn;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)CompleteProfileClosed:(id)sender
{
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect theBtn = cover_completeProfileBtn.frame;
        
        theBtn.origin.y = 0.0;
        cover_completeProfileBtn.frame = theBtn;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeBtnClicked:(id)sender
{
    [target performSelector:closeBtnClickedFunc withObject:nil afterDelay:0.01];
    
}
-(void)setUpIntroVideoItems
{
    UILabel *label=[[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment=NSTextAlignmentCenter;
    [introVideoView addSubview:label];
    label.text=@"Intro-Video";
    
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"mag_app_reducedvid" withExtension:@"mp4"];
    
    
    player=[[VideoLoopPlayer alloc] initWithFrame:self.bounds];
    [introVideoView addSubview:player];
    [player setUpWithURL:videoURL.absoluteString];
    
    
}


-(void)addStoryViewItems
{
    //
    //    UILabel *story_titleLBL;
    //    UILabel *story_descLBL;
    //    UILabel *story_tagsLBL;
    
    if(![storyDescStr isEqualToString:@""] && ![storyTitleStr isEqualToString:@""])
    {
        
        story_LBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50, self.frame.size.width-50, 20)];
        [storyView addSubview:story_LBL];
        story_LBL.textAlignment = NSTextAlignmentLeft;
        story_LBL.font=[UIFont fontWithName:k_fontSemiBold size:14];
        story_LBL.text = @"MY STORY";
        story_LBL.textColor=[UIColor whiteColor];
        
        story_titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 90, self.frame.size.width-50, 150)];
        story_titleLBL.text=storyTitleStr;
        [storyView addSubview:story_titleLBL];
        story_titleLBL.numberOfLines=4;
        story_titleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:33];
        story_titleLBL.adjustsFontSizeToFitWidth=YES;
        story_titleLBL.textColor=[UIColor whiteColor];
        
        story_descLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 270, self.frame.size.width-50, 250)];
        story_descLBL.numberOfLines = 0;
        [storyView addSubview:story_descLBL];
        story_descLBL.textColor=[UIColor whiteColor];
        NSString* string = storyDescStr;
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 25.0f;
        style.maximumLineHeight = 25.0f;
        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,NSFontAttributeName:[UIFont fontWithName:k_fontRegular size:15]};
        story_descLBL.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                       attributes:attributtes];
        [story_descLBL sizeToFit];
        
        
        
        story_tagsLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50+270+250, self.frame.size.width-50, 150)];
        story_tagsLBL.text=tagsArray;
        [storyView addSubview:story_tagsLBL];
        story_tagsLBL.numberOfLines=4;
        story_tagsLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
        story_tagsLBL.adjustsFontSizeToFitWidth=YES;
        story_tagsLBL.textColor=[UIColor whiteColor];
        
        
        
        story_tagsLBL.frame=CGRectMake(25, story_descLBL.frame.origin.y+story_descLBL.frame.size.height+10, self.frame.size.width-50, 100);
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
        
        
        
        
        
        
        story_tagsLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50, self.frame.size.width-50, self.frame.size.height-50)];
        [storyView addSubview:story_tagsLBL];
        story_tagsLBL.numberOfLines=0;
        story_tagsLBL.font=[UIFont fontWithName:k_fontBold size:30];
        story_tagsLBL.adjustsFontSizeToFitWidth=YES;
        story_tagsLBL.textColor=[UIColor whiteColor];
        story_tagsLBL.attributedText=attributedString;
        
        
        
    }
    
    
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
    
    cover_shortDescLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 420, self.frame.size.width-80, 50)];
    [coverView addSubview:cover_shortDescLBL];
    cover_shortDescLBL.numberOfLines=2;
    cover_shortDescLBL.text=proffesionCityStr;
    cover_shortDescLBL.font=[UIFont fontWithName:k_fontRegular size:14];
    cover_shortDescLBL.adjustsFontSizeToFitWidth=YES;
    cover_shortDescLBL.textColor=[UIColor whiteColor];
    
    
    
    cover_connectionCount=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_connectionCount.textColor=[UIColor whiteColor];
    cover_connectionCount.textAlignment=NSTextAlignmentCenter;
    cover_connectionCount.text=connectionCountStr;
    [coverView addSubview:cover_connectionCount];
    cover_connectionCount.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    cover_connectionLabel=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_connectionLabel.textColor=[UIColor whiteColor];
    cover_connectionLabel.textAlignment=NSTextAlignmentCenter;
    cover_connectionLabel.text=@"connections";
    [coverView addSubview:cover_connectionLabel];
    cover_connectionLabel.font=[UIFont fontWithName:k_fontRegular size:14];
    
    cover_profileViewCount=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_profileViewCount.textColor=[UIColor whiteColor];
    cover_profileViewCount.textAlignment=NSTextAlignmentCenter;
    cover_profileViewCount.text=noOfPosts;
    [coverView addSubview:cover_profileViewCount];
    cover_profileViewCount.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    cover_profileLabel=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_profileLabel.textColor=[UIColor whiteColor];
    cover_profileLabel.textAlignment=NSTextAlignmentCenter;
    cover_profileLabel.text=@"posts";
    [coverView addSubview:cover_profileLabel];
    cover_profileLabel.font=[UIFont fontWithName:k_fontRegular size:14];
    
    
    
    
    
    
    cover_connectionCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-95);
    cover_connectionLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-80);
    cover_profileViewCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-95);
    cover_profileLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-80);
    
    
    cover_connectionCount.alpha=1;
    cover_connectionLabel.alpha=1;
    cover_profileViewCount.alpha=1;
    cover_profileLabel.alpha=1;
}



-(void)setUpPostViewItems
{
    UILabel *label=[[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment=NSTextAlignmentCenter;
    [postView addSubview:label];
    label.text=@"posts";
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    CGRect collectionViewFrame = self.bounds;
    galleryView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    galleryView.delegate = self;
    galleryView.dataSource = self;
    galleryView.pagingEnabled = YES;
    galleryView.showsHorizontalScrollIndicator = NO;
    //galleryView.delaysContentTouches=NO;
    // galleryView.canCancelContentTouches=YES;
    
    [galleryView registerClass:[PostFullCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [postView addSubview:galleryView];
    
    
}
#pragma mark - CollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataRecords.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell setDataObj:[dataRecords objectAtIndex:indexPath.row]];
    [cell setPlayerScreenIdeantifier:screenIdentifier];
    [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];
    [cell onDeleteEvent:@selector(deleteAPost:)];
    
    // [cell setTarget:self shareBtnFunc:@selector(shareBtnClicked:) andCommentBtnFunc:@selector(commentBtnClicked:)];
    
    
    
    return cell;
    
}
#pragma mark - Cell Action
-(void)deleteAPost:(APIObjects_FeedObj *)obj
{
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestForDeletePost:obj.postId delegate:self andSelector:@selector(postDeletedCallBack:)];
    
    
    [FTIndicator showToastMessage:@"Deleting.."];
    
    
}
-(void)postDeletedCallBack:(NSArray *)responseArray
{
    APIResponseObj *responseObj=[responseArray objectAtIndex:0];
    NSString *postId=[responseArray objectAtIndex:1];
    
    if(responseObj.statusCode==200)
    {
        
        NSArray *array=dataRecords;
        
        int index=-1;
        for(int i=0;i<[array count];i++)
        {
            APIObjects_FeedObj *object=[array objectAtIndex:i];
            
            if([[NSString stringWithFormat:@"%@",postId] isEqualToString:[NSString stringWithFormat:@"%@",object.postId]])
            {
                index=i;
            }
            
        }
        
        
        if(index!=-1)
        {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:index inSection:0];
            
            [galleryView performBatchUpdates:^{
                
                NSArray *selectedItemsIndexPaths = @[indexPath];
                
                // Delete the items from the data source.
                [dataRecords removeObjectAtIndex:indexPath.row];
                
                // Now delete the items from the collection view.
                [galleryView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
                
            } completion:^(BOOL finished) {
                cover_profileViewCount.text=[NSString stringWithFormat:@"%d",(int)[dataRecords count]];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"REFRESH_HOME"
                 object:self];
                
                
                [self stoppedScrolling];
            }];
        }
        
        [FTIndicator showToastMessage:@"Deleted"];
        
    }
    else
    {
        [FTIndicator showToastMessage:@"Something went wrong"];
    }
    
}
-(void)commentBtnClicked:(NSString *)senderId
{
    if(commentDisplay==nil)
    {
        [self feedScreenGoesBack];
        
        
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

-(void)shareBtnClicked:(NSString *)senderId
{
    if(sharecompo==nil)
    {
        [self feedScreenGoesBack];
        
        sharecompo=[[ShareComponent alloc] initWithFrame:self.bounds];
        [sharecompo setUp];
        [sharecompo setTarget:self andCloseBtnClicked:@selector(commentFullClosed:)];
        
        [self addSubview:sharecompo];
    }
}

-(void)feedScreenGoesBack
{
    [HMPlayerManager sharedInstance].Profile_isPaused=true;
    
}
-(void)feedScreenComesToFront
{
    [HMPlayerManager sharedInstance].Profile_isPaused=false;
    
}
-(void)commentFullClosed:(id)sender
{
    [self feedScreenComesToFront];
    
    commentDisplay=nil;
    sharecompo=nil;
}

#pragma mark - API call

-(void)setUpDataRecordsForPosts
{
    
    APIManager *manager=[[APIManager alloc] init];
    
    [manager sendRequestForPostOfUsersId:[NSString stringWithFormat:@"%@",dataObj.userId] delegate:self andSelector:@selector(UserPostReceived:)];
    
    
    ////    dataRecords=[DataSession sharedInstance].homeFeedResults;
    //
    //    NSArray *array=[DataSession sharedInstance].homeFeedResults;
    //
    //    dataRecords=[[NSMutableArray alloc] init];
    //
    //
    //    for(int i=0;i<array.count;i++)
    //    {
    //
    //        APIObjects_FeedObj *obj=[array objectAtIndex:i];
    //
    //        NSString *feedUserId=[NSString stringWithFormat:@"%@",obj.user_id];
    //        NSString *comparingId=[NSString stringWithFormat:@"%@",dataObj.userId];
    //
    //        if([feedUserId isEqualToString:comparingId] && (obj.mediaType.intValue)!=2)
    //        {
    //            [dataRecords addObject:obj];
    //        }
    //
    //
    //    }
    
}

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
-(void)UserPostReceived:(APIResponseObj *)responseObj
{

    NSArray *responseArray=[NSMutableArray arrayWithArray:(NSArray *)responseObj.response];

    APIObjectsParser *parser=[[APIObjectsParser alloc] init];
    
    dataRecords=[NSMutableArray arrayWithArray:[parser parseObjects_FEEDPOST:responseArray]];
    
    cover_profileViewCount.text=[NSString stringWithFormat:@"%d",(int)[dataRecords count]];
    [galleryView reloadData];
    
    
}
#pragma mark - Scroll

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(masterScrollView.contentOffset.y>self.frame.size.height*2)
    {
        [HMPlayerManager sharedInstance].Profile_isVisibleBounds=true;
        [self stoppedScrolling];
        
    }
    else
    {
        [HMPlayerManager sharedInstance].Profile_isVisibleBounds=false;
        
        
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate
{
    if(masterScrollView.contentOffset.y>self.frame.size.height*2)
    {
        [HMPlayerManager sharedInstance].Profile_isVisibleBounds=true;
        
        
        if (!decelerate) {
            [self stoppedScrolling];
        }
        
        
    }
    else
    {
        [HMPlayerManager sharedInstance].Profile_isVisibleBounds=false;
        
        
    }
}

-(void)stoppedScrolling
{
    NSLog(@"%f",masterScrollView.contentOffset.y);
    NSLog(@"%f",galleryView.contentOffset.x);
    
    
    CGRect visibleRect = (CGRect){.origin = galleryView.contentOffset, .size = galleryView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [galleryView indexPathForItemAtPoint:visiblePoint];
    
    NSLog(@"Visible center - %d\n",(int)visibleIndexPath.row);
    
    
    
    for(UICollectionViewCell *cell in [galleryView visibleCells])
    {
        
        NSIndexPath *indexPath = [galleryView indexPathForCell:cell];
        NSLog(@"visibleCells %d",(int)indexPath.row);
        if(indexPath==visibleIndexPath)
        {
            NSArray *array=dataRecords;
            APIObjects_FeedObj *obj=[array objectAtIndex:indexPath.row];
            NSString *url=obj.video_url;
            
            
            if(![obj.video_url isEqualToString:[HMPlayerManager sharedInstance].Profile_urlIdentifier])
            {
                
                PostFullCell *cell=(PostFullCell *)[galleryView cellForItemAtIndexPath:visibleIndexPath];
                [cell playVideoIfAvaialble];
                
                [HMPlayerManager sharedInstance].Profile_screenIdentifier=screenIdentifier;
                [HMPlayerManager sharedInstance].Profile_urlIdentifier=url;
                
            }
            
            
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView==masterScrollView)
    {
        float progress=scrollView.contentOffset.y/scrollView.contentSize.height+0.33333;
        
        [closeProgressArcView setProgress:progress];
        
        if(scrollView.contentOffset.y>self.frame.size.height-50)
        {
            
            cover_addBtn.hidden=true;
            cover_completeProfileBtn.hidden = true;
        }
        else
        {
            cover_addBtn.hidden=false;
            cover_completeProfileBtn.hidden = false;
        }
        
    }
    
    
}
-(void)removingComponent
{
    [player clearLoopPlayer];
    
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [galleryView setDelegate:nil];
    [galleryView setDataSource:nil];
    [galleryView removeFromSuperview];
    
}
@end
