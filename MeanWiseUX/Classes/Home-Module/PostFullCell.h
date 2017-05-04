//
//  PostFullCell.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <pop/POP.h>
#import "Constant.h"
#import <AVKit/AVKit.h>
#import "VideoCacheManager.h"
#import "APIObjects_FeedObj.h"
#import "UIImageHM.h"
#import "APIManager.h"
#import "HMPlayer.h"

#define IMAGE_OFFSET_SPEED 50

@interface PostFullCell : UICollectionViewCell <UIGestureRecognizerDelegate, ASVideoNodeDelegate>
{
    
    
    id target;
    SEL commentBtnClickedFunc;
    SEL shareBtnClickedFunc;
    SEL commentWriteBtnClickedFunc;
    SEL onDeleteClickedFunc;

    
    int mediaType;
    
    UITapGestureRecognizer *doubleTap;
    APIObjects_FeedObj *dataObj;

    
    int liked;

    //Player + stop and kill + pause
    //loop + stream fast
    //show loader while streaming
    
    int heightBottom;

    HMPlayer *player;
    
    BOOL isVideo;

    NSString *screenIdentifier;
    
}
-(void)setPlayerScreenIdeantifier:(NSString *)string;

-(void)setTarget:(id)delegate shareBtnFunc:(SEL)func1 andCommentBtnFunc:(SEL)func2;
-(void)onDeleteEvent:(SEL)func3;

-(void)setCallBackForCommentWrite:(SEL)func3;

-(void)setDataObj:(APIObjects_FeedObj *)dict;

-(void)playVideoIfAvaialble;

-(void)pausePlayer;


@property (nonatomic, strong) UIImageView *shadowImage;

@property (nonatomic, strong) UIImageHM *profileIMGVIEW;
@property (nonatomic, strong) UILabel *nameLBL;
@property (nonatomic, strong) UILabel *profLBL;

@property (nonatomic, assign, readwrite) CGPoint imageOffset;

@property (nonatomic, strong) UILabel *statusLBL;
@property (nonatomic, strong) ASDisplayNode *postIMGVIEW;
@property (nonatomic, strong) ASVideoNode *mediaView;
@property (nonatomic, strong) UILabel *tagName;
@property (nonatomic, strong) UILabel *timeLBL;

@property (nonatomic, strong) UILabel *likeCountLBL;
@property (nonatomic, strong) UILabel *commentCountLBL;

@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *commentWriteBtn;



-(void)setUpMediaType:(int)number andColorNumber:(int)Cnumber;

-(void)setFrameX:(CGRect)frame;
-(void)setImage:(NSString *)string;
-(BOOL)isVideoContent;
-(void)cleanUp;

@end
