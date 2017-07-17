//
//  PreviewMaxScreen.h
//  VideoPlayerDemo
//
//  Created by Hardik on 09/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomRotatePanImageView.h"
#import "LocationStickerView.h"
#import "OverlayStickerView.h"
#import "OverlaySettingsPanel.h"
#import "UIFilterImageView.h"
#import "VidLoopPlayer.h"
#import "UIFilterOverLayView.h"


@interface PreviewMaxScreen : UIView
{
    
    int mediaType;
    BOOL isOpenFullMode;
    
    id target;
    SEL showFullScreenFunc;
    SEL showThumbScreenFunc;
    SEL attachmentRemoveFunc;
    
    UIView *mediaView;
    
    
    
    
    
    UIFilterImageView *mediaImageView;
    UIFilterOverLayView *videoOverLayView;
    VidLoopPlayer *loopPlayer;
    
    
    CGRect fullRect;
    CGRect smallRect;
    UIButton *fullScreenBtn;
    
    //Preview Section
    UIButton *mediaCancelThisMediaBtn;
    UIButton *mediaNextBtn;
    UIButton *mediaDownloadBtn;
    UIButton *locationFilterPhaseBtn;
    UIButton *textFilterPhaseBtn;
    
    UIButton *trashIcon;
    
    NSString *actualMediaPath;
    
    OverlaySettingsPanel *overLayStickerKeyboardBar;
    
    
    
    LocationStickerView *MX_locationStickerObj;
    OverlayStickerView *sticker;
    
    NSMutableArray *MX_overlayStickers;
    
    
}
-(void)setAttachmentRemoveCallBack:(SEL)func3;
-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2;
-(void)seUpBasics:(CGRect)smallScreenRect;
-(void)setUpPath:(NSString *)path;
-(void)cleanUp;
-(void)openFullScreen:(id)sender;

-(NSString *)getFinalOutPutPath;
-(BOOL)isMediaTypeVideo;

-(UIImage *)getOverLayVideoImage;

-(NSString *)getCroppedVideoPath;

@end