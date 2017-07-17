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
#import "ProfileFilterPostComponent.h"
#import "EmptyView.h"


@interface ProfileAditionalScreen : UIView  <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    FullCommentDisplay *commentDisplay;
    ShareComponent *sharecompo;

    
    APIObjects_ProfileObj *dataObj;
    

    /*
    
     - name, Profession, City, number of connections,
     - story title, story desc, skills, interests
     - cover video url
     - posts
    
     */
    
    NSString *firstNameStr;
    NSString *proffesionCityStr;
    NSString *noOfPosts;
    
    NSString *connectionCountStr;
    NSString *storyTitleStr;
    NSString *storyDescStr;
    
    NSArray *storySkillsArray;
    NSArray *storyInterestsArray;
    NSString *tagsArray;
    NSString *storySkillsStr;
    NSString *storyInterestsStr;
    
    
    NSString *frienshipStatusStr;

    
    
    
    
    
    
 ////////
    UIView *coverView;
    MasterScrollView *masterScrollView;
    UIImageView *shadowImage;

    UIView *coverOverlayView;
    UIView *storyView;
    UIView *introVideoView;
    UIView *postView;
    
    
    ProfileFilterPostComponent *postFilterview;

    
    //Close Btn
    UIArcView *closeProgressArcView;
    UIButton *closeBtn;
    id target;
    SEL closeBtnClickedFunc;
    

    
    //Cover View Items
    UILabel *cover_titleLBL;
    UILabel *cover_shortDescLBL;
    UILabel *cover_connectionCount,*cover_connectionLabel,*cover_profileViewCount,*cover_profileLabel;
    UIButton *cover_addBtn;
    UIButton *cover_completeProfileBtn;
    UIButton *cover_ColorChangeBtn;

    
    //StoryView
    UILabel *story_titleLBL;
    UILabel *story_descLBL;
    UILabel *story_tagsLBL;
    
    
    
    //PostView
    NSMutableArray *dataRecords;
    UICollectionView *galleryView;
    EmptyView *emptyPostView;

    NSString *screenIdentifier;
    
    
    //IntroVideoView;
    VideoLoopPlayer *player;
    

    NSNumber *refreshIdentifier;

}
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
-(void)removingComponent;
-(void)setUp;
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1;

@end
