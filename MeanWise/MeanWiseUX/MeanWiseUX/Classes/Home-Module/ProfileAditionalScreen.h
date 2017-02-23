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


@interface ProfileAditionalScreen : UIView  <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    APIObjects_ProfileObj *profileObj;

    UIView *coverView;
    UIScrollView *masterScrollView;
    UIImageView *shadowImage;

    UIView *coverOverlayView;
    UIView *storyView;
    UIView *introVideoView;
    UIView *postView;

    
    //Close Btn
    UIButton *closeBtn;
    id target;
    SEL closeBtnClickedFunc;
    

    
    //Cover View Items
    UILabel *cover_titleLBL;
    UILabel *cover_shortDescLBL;
    UILabel *cover_connectionCount,*cover_connectionLabel,*cover_profileViewCount,*cover_profileLabel;
    UIButton *cover_addBtn;

    
    //StoryView
    UILabel *story_titleLBL;
    UILabel *story_descLBL;
    UILabel *story_tagsLBL;
    
    
    //IntroVideoView;
    VideoLoopPlayer *player;
    
    //PostView
    NSMutableArray *dataRecords;
    UICollectionView *galleryView;

}
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;

-(void)setUp;
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1;

@end
