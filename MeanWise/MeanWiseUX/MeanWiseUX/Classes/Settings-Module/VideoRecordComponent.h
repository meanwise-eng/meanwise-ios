//
//  VideoRecordComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineProgressBar.h"
#import "Constant.h"
#import "LLSimpleCamera.h"

@interface VideoRecordComponent : UIView
{

    //Camera Front/Rear Button
    //Flash light on/off
    //Cancel
    //Retake
    //Preview
    
    
    UIImageView *imageView;
    UIButton *cameraBtn;
    LLSimpleCamera *cameraCaptureView;
    
    UIButton *cancelBtn;
    UIButton *switchCamBtn;
    UIButton *flashLightBtn;
    LineProgressBar *pro;


    
}
-(void)setUp;


/*
 NSTimeInterval someTimeInterval = 1;
 
 - (IBAction)action:(id)sender {
 UIButton * const button = sender;
 if (button.state != UIControlStateHighlighted) {
 return;
 }
 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:sender];
 [self performSelector:_cmd withObject:sender afterDelay:someTimeInterval];
 }

 */

@end
