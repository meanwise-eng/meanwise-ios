//
//  PortraitCropComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PortraitCropComponent : UIView 
{
    BOOL isVideo;
    
    UIView *palleteView;
    
    UIView *ViewContainer;
    
    UIImageView *imageView;
    
    UILabel *title;
    UIButton *btnFinished;
    UIButton *btnCancel;
    
    UIView *blurView1;
    UIView *blurView2;
    UIView *blurView3;
    UIView *blurView4;
    
    UIView *frameView;
    
    id target;
    SEL doneBtnClicked;
    SEL cancelBtnClicked;
    
    float lastScale;
    CGPoint translation;
    
    CGRect profilePicRect;
    AVPlayerViewController *playerViewControl;

    CGAffineTransform validLastTransform;
    CGPoint validLastTranslation;
    
    NSString *filePathStr;
    float zoomFactor;
    
    UIButton *playBtn;
}
-(void)setUpWithPath:(NSString *)path;
-(void)allowCancel:(BOOL)flag;

-(void)cropFinished:(id)sender;

-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2;


//Play Function
//Video Crop
//Video Trim
//Cancel Optional
//

/*
 
 
 NSString *documentsDirectory = [Constant applicationDocumentsDirectoryPath];
 
 NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
 
 
 // NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
 
 PortraitCropComponent *compo=[[PortraitCropComponent alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:compo];
 [compo setUpWithPath:tempPath];
 
 
 
 [compo setTarget:self andDoneBtn:@selector(cropFinishedImage:) andCancelBtn:nil];

 
 -(void)cropFinishedImage:(NSString *)path
 {
 int p=0;
 }
 
 */


@end

