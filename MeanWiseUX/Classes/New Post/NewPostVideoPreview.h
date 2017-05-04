//
//  NewPostVideoPreview.h
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCRecorder/SCRecorder.h>
#import "LocationFilterView.h"
#import "NewPostVideoOverlay.h"

@interface NewPostVideoPreview : UIView<SCPlayerDelegate, SCAssetExportSessionDelegate>
{
    CGRect smallRect;
    CGRect fullRect;
    CGRect fullPreviewRect;
    CGRect initialRect;
    
    UIButton *tapToFullBtn;
    
    UIButton *closeBtn;
    UIButton *downloadBtn;
    UIButton *nextBtn;
    UIButton *playBtn;
    UIImageView *playBtnImage;
    
    UIView *mainView;
    
    UIImageView *shadowImageView;
    
    LocationFilterView *locationSticker;
    NewPostVideoOverlay *overlay;
    
    SCSwipeableFilterView *filterSwitcherView;
    SCRecordSession *recordSession;
    
    NSString* filePathStr;
    
    UIButton *fullModeBtnDone;
    
    UIButton *editBtn1;
    UIButton *editBtn2;
    UIButton *editBtn3;
    UIButton *editBtn4;
    
    BOOL isPlayerPaused;
    
    id target;
    SEL showFullScreenFunc;
    SEL showThumbScreenFunc;
    
    
}

@property (strong, nonatomic) SCAssetExportSession *exportSession;
@property (strong, nonatomic) SCPlayer *player;

-(void)setSession:(SCRecordSession*)session andRect:(CGRect)rect;
-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2;
-(void)cleanUp;
-(void)openFullMode:(id)sender;
-(void)QuickOpen;

-(NSData*)getVideoData;

@end