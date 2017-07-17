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
    UIButton *doneBtn;
    UIButton *cancelBtn;
    
    UIView *view1,*view2,*view3,*view4;
    UIView *gridView1,*gridView2,*gridView3,*gridView4,*gridView5;

    
}
-(void)setUpWithPath:(NSString *)stringPath;
-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2;
-(void)setDirectCrop;

@end
