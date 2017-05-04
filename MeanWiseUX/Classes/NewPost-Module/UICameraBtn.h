//
//  UICameraBtn.h
//  ExactResearch
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIArcView.h"

@interface UICameraBtn : UIView
{
    UIView *borderView;
    UIArcView *arcView;
    
    UIButton *cameraBtn;
    
    float time;
    
    int recordingStarted;
    
    id target;
    SEL photoCaptureFunc;
    SEL videoStartFunc;
    SEL videoStopFunc;
    
    BOOL interacting;
}
-(void)setUp;
-(void)setTarget:(id)delegate andPhotoCapture:(SEL)func1;
-(void)setTarget:(id)delegate andVideoStart:(SEL)func1 andVideoClose:(SEL)func2;

@end
