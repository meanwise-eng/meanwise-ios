//
//  ZoomRotatePanImageView.h
//
//
//  Created by bennythemink on 20/07/12.
//  Copyright (c) 2012 bennythemink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ZoomRotatePanImageView : UIView <UIGestureRecognizerDelegate> {
    
    
    
    id delegate;
    SEL onMovementCallBackFunc;
    
@protected
    UIPinchGestureRecognizer *_pinchRecogniser;
    UIRotationGestureRecognizer *_rotateRecogniser;
    UIPanGestureRecognizer *_panRecogniser;
    UITapGestureRecognizer *_tapRecogniser;
    
    
}


- (void) reset;
- (void) resetWithAnimation:(BOOL)animation;

-(void)setTarget:(id)target OnMovementCallBack:(SEL)func;

@end

