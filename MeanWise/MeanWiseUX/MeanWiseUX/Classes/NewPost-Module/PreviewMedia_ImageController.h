//
//  PreviewMedia_ImageController.h
//  ExactResearch
//
//  Created by Hardik on 13/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FTIndicator.h"

@interface PreviewMedia_ImageController : UIView <UITextViewDelegate>
{
    NSString *filePathStr;
    BOOL isVideo;
    
    UIImageView *keyImageView;
    AVPlayerViewController *playerViewControl;

    UIImageView *shadowImageView;
    
    UIButton *editBtn;
    UIButton *doneBtn;
    UIButton *EditingCorrectBtn;
    UIButton *EditingCancelBtn;
    
    
    UIView *fieldContainerView;
    UITextView *field;
    float basicTransform;
    float scaleField;
    float rotationField;
    
    id target;
    SEL onSuccessFunc;
    SEL onCancelFunc;

    
    
    UIView *keyBoardBar;
    UIButton *blackColorBtn;
    UIButton *whiteColorBtn;

    UIButton *alignmentBtn;
    UIButton *fontSizeUpBtn;
    UIButton *fontSizeDownBtn;
    float fontSize;
    
    float fontSizeUpLimit;
    float fontSizeDownLimit;
    
    
    
}
-(void)setTarget:(id)targetReceived OnSuccess:(SEL)func1 OnFail:(SEL)func2;

-(void)setUpWithString:(NSString *)strPath;
@end
