//
//  ProfileAditionalScreen.h
//  MeanWiseUX
//
//  Created by Hardik on 13/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "VideoLoopPlayer.h"
#import "APIObjects_ProfileObj.h"
#import "MasterScrollView.h"
#import "UIArcView.h"
#import "APIManager.h"
#import "ShareComponent.h"
#import "FullCommentDisplay.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <pop/POP.h>

@interface NewProfileView : UIView  <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ASNetworkImageNodeDelegate>
{
    
    FullCommentDisplay *commentDisplay;
    ShareComponent *sharecompo;
    
    
    APIObjects_ProfileObj *dataObj;
    
    NSString *firstNameStr;
    NSString *proffesionCityStr;
    NSString *noOfPosts;

    NSString *coverPhoto;
    
    NSString *connectionCountStr;
    NSString *storyTitleStr;
    NSString *storyDescStr;
    
    NSArray *storySkillsArray;
    NSArray *storyInterestsArray;
    NSString *tagsArray;
    NSString *storySkillsStr;
    NSString *storyInterestsStr;
    
    
    NSString *frienshipStatusStr;
    
    CGRect sourceFrame;
    
    NSString *fromView;
    
    
    
    ////////
    UIView *coverView;
    MasterScrollView *masterScrollView;
    UIImageView *shadowImage;
    
    UIView *coverOverlayView;
    UIView *storyView;
    UIView *introVideoView;
    UIView *postView;
    
    
    //Close Btn
    UIArcView *closeProgressArcView;
    UIButton *closeBtn;
    id target;
    SEL closeBtnClickedFunc;
    
    ASNetworkImageNode* coverImage;
    
    
    //Cover View Items
    UILabel *cover_titleLBL;
    UILabel *cover_shortDescLBL;
    UILabel *cover_connectionCount,*cover_connectionLabel,*cover_profileViewCount,*cover_profileLabel;
    UIButton *cover_addBtn;
    UIButton *cover_completeProfileBtn;
    
    
    //StoryView
    UILabel *story_LBL;
    UILabel *story_titleLBL;
    UILabel *story_descLBL;
    UILabel *story_tagsLBL;
    
    
    //IntroVideoView;
    VideoLoopPlayer *player;
    
    //PostView
    NSMutableArray *dataRecords;
    UICollectionView *galleryView;
    
    NSString *screenIdentifier;
    
    NSIndexPath *profIndexPath;
    
}

@property (nonatomic, readwrite, assign) CGFloat cornerRadius;

-(void)setUpProfileObj:(NSDictionary *)obj;
-(void)removingComponent;
-(void)setUpFromView:(NSString *)view;
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1;
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1 withIndexPath:(NSIndexPath *)indexPath;

@end
