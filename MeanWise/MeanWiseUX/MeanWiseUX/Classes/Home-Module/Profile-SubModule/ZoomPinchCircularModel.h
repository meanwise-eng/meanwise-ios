//
//  ZoomPinchCircularModel.h
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 08/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomPinchCircularModel : UIView <UIGestureRecognizerDelegate>
{
    CGRect sourceRect;
    CGRect fullRect;
    
    
    UIView *containerView;
    UIView *cropView;
    
    
    
    float minRatio;
    
    UIPanGestureRecognizer *panGesture;
    CGPoint firstPanTouchPoint;
    
    CAShapeLayer *circle;
    float lastRadius;
    
    id target;
    SEL onCloseFunc;
    
}
-(void)setUp:(CGRect)rect;

-(void)setTarget:(id)targetReceived onCloseFunc:(SEL)func;
-(void)animateToClose;

@end
