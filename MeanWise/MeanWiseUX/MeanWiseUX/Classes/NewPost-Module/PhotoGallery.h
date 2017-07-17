//
//  PhotoGallery.h
//  MeanWiseUX
//
//  Created by Hardik on 03/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import <Photos/Photos.h>
#import "LineProgressBar.h"
#import "UICameraBtn.h"
#import <AVFoundation/AVFoundation.h>

@interface PhotosBtnController : UIView
{
    UIButton *photoBtn;
    
    id delegate;
    SEL photoSelection;
    
    
}
-(void)setUp;
-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2;
@end


@interface PhotoGallery : UIView  <UICollectionViewDelegate,UICollectionViewDataSource>

{
    BOOL isSourceCamera;
    
    PhotosBtnController *control;

    UIView *overlayBlack;
    UIView *masterView;
    CGRect shortFrame;
    UILabel *titleLBL;
    UIScrollView *masterScrollView;

    UIButton *cancelBtn;
    UIButton *switchBtn;
    

    id delegate;
    SEL cancelFunc;
    SEL mediaSelectedFunc;
    
    
    UICollectionView *photoGallery;
    NSMutableArray *arrayImagesAll;
    NSArray *arrayData;

    
    UIView *imageViewCameraBack;
    LLCameraPosition cameraPosition;
    LLSimpleCamera *cameraCaptureView;
    UICameraBtn *cameraBtnMax;
    UIButton *switchCamBtn;
    UIButton *flashLightBtn;

    float columunWidth;
    NSUInteger numColumns;

    
}
-(void)setUp:(int)section;
-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2;

@end



//http://stackoverflow.com/questions/12633843/get-all-of-the-pictures-from-an-iphone-photolibrary-in-an-array-using-assetslibr

