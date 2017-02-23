//
//  ImageCropView.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface ImageCropView : UIView  <UIScrollViewDelegate>
{
    
    float ratioMain;
    
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
    
}
-(void)setUp:(float)ratio andRect:(CGRect)frame;
-(void)setUpImage:(UIImage *)image;
-(void)cropFinished:(id)sender;

-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2;



@end

 