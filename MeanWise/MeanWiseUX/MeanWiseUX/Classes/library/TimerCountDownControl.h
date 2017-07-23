//
//  TimerCountDownControl.h
//  Exacto
//
//  Created by Hardik on 23/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerCountDownControl : UIView
{
    int totalTime;
    UILabel *label;
    
    id target;
    SEL callBackFunc;

    
}
-(void)setUpWithTime:(int)seconds;
-(void)setTarget:(id)tReceived callBack:(SEL)callBack;

@end
