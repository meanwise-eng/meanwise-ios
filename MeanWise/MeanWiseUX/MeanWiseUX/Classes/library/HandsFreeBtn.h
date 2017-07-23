//
//  HandsfreeBtn.h
//  Exacto
//
//  Created by Hardik on 23/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandsFreeBtn : UIView
{
    UIButton *fullScreenBtn;
    float duration;
    int status;
    UIView *circleView;
    
    id target;
    SEL videoStopCallBackFunc;
    CAShapeLayer *circle;
}

-(void)setUpWithTime:(float)timer;
-(void)setTarget:(id)tReceived OnVideoStopCallBack:(SEL)callBack;
-(void)startAnimation;
-(void)continueAnimation;


@end
