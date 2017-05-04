//
//  Cropper.h
//  ExactResearch
//
//  Created by Hardik on 17/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FTIndicator.h"
#import "Constant.h"
#import "TrimSlider.h"

@interface MediaCropper : UIView <UIScrollViewDelegate>
{
    UIView *containerView;
    UIScrollView *scrollView;
    UIImageView *imageView;
    
    AVPlayerViewController *playerViewControl;
    BOOL isPlayerPaused;
    TrimSlider *trimSlider;
    CMTime playerStartTime;
    CMTime playerEndTime;
    
    
    id target;
    SEL doneBtnClicked;
    SEL cancelBtnClicked;
    
    
    NSString *filePathStr;
    
    float ratio;
    BOOL isVideo;
    
    
    UILabel *title;
    
}
-(void)setUpWithPath:(NSString *)stringPath;
-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2;

@end
