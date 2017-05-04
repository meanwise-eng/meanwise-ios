//
//  PreviewViewComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 02/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIFilterImageView.h"



@interface PreviewViewComponent : UIView
{
    CGRect smallRect;
    CGRect fullRect;
    CGRect fullPreviewRect;
    CGRect initialRect;
    
    UIButton *tapToFullBtn;
    UIImageView *imageView;
    UIFilterImageView *keyImageView;
    UIImageView *shadowImageView;
    UIButton *closeBtn;
    UIButton *downloadBtn;
    UIButton *nextBtn;
    
    UIButton *fullModeBtnDone;
    
    
    UIImageView *playBtnImage;
    
    AVPlayerViewController *playerViewControl;
    
    BOOL isVideo;
    NSString *filePathStr;
    
    UIButton *playBtn;
    
    UIButton *editBtn1;
    UIButton *editBtn2;
    UIButton *editBtn3;
    UIButton *editBtn4;
    
    BOOL isPlayerPaused;
    
    id target;
    SEL showFullScreenFunc;
    SEL showThumbScreenFunc;
    
    
}
-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2;

-(void)setUp:(NSString *)path andRect:(CGRect)rect;
-(void)cleanUp;
-(void)openFullMode:(id)sender;
-(void)QuickOpen;
-(NSString *)getCurrentPath;
@end

