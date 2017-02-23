//
//  PreviewViewComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 02/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PreviewViewComponent : UIView
{
    CGRect smallRect;
    CGRect fullRect;
    CGRect fullPreviewRect;

    UIButton *tapToFullBtn;
    UIImageView *imageView;
    UIImageView *shadowImageView;
    UIButton *closeBtn;
    
    UIButton *fullModeBtnDone;
    
    
    UIImageView *playBtnImage;
    
    AVPlayerViewController *playerViewControl;

    BOOL isVideo;
    NSString *filePathStr;
    
    UIButton *playBtn;

}
-(void)setUp:(NSString *)path andRect:(CGRect)rect;
-(void)cleanUp;
-(void)openFullMode:(id)sender;
-(void)QuickOpen;

-(NSString *)getCurrentPath;

@end
