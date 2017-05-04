//
//  CameraView.h
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <SCRecorder/SCRecorder.h>
#import "LineProgressBar.h"
#import "UICameraBtn.h"

@interface PhotosBtnControl : UIView
{
    UIButton *photoBtn;
    
    id delegate;
    SEL photoSelection;
    
    
}
-(void)setUp;
-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2;
@end

@interface CameraView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,SCRecorderDelegate>

{
    PhotosBtnControl *control;
    
    UIView *overlayBlack;
    UIView *masterView;
    CGRect shortFrame;
    UILabel *titleLBL;
    UIScrollView *masterScrollView;
    
    UIButton *cancelBtn;
    UIButton *switchBtn;
    UIButton *switchBtnCamera;
    
    
    id delegate;
    SEL cancelFunc;
    SEL imageSelectedFunc;
    SEL videoSelectedFunc;
    
    NSTimer *videoPrevTimer;
    
    UICollectionView *photoGallery;
    NSMutableArray *arrayImagesAll;
    NSArray *arrayData;
    
    UIView *previewView;
    
    UIView *imageViewCameraBack;
    
    SCRecorder *captureView;
    SCRecordSession *_recordSession;
    
    UICameraBtn *cameraBtn;
    UIButton *switchCamBtn;
    UIButton *flashLightBtn;
    
    
}

@property (strong, nonatomic) SCRecorderToolsView *focusView;

-(void)setUp:(int)section;
-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2 andSel3:(SEL)func3;

@end
