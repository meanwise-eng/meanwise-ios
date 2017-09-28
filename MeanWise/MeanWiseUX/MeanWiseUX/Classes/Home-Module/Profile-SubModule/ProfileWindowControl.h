//
//  ProfileWindowControl.h
//  MeanWiseUX
//
//  Created by Hardik on 08/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageHM.h"
#import "APIManager.h"

@interface ProfileWindowControl : UIView
{
    
    UIWindow *window;
    id target;
    SEL onCloseFunc;
    
    UIView *containerView;
    UIImageHM *coverPhoto;
    
    UIView *animationView;
    
    CGRect sourceFrame;
    
    APIObjects_ProfileObj *userData;
    
    int isAnimationFinished;
    int isDataReceived;
    int isProfileOpened;
}
-(void)setUp:(NSDictionary *)dict andSourceFrame:(CGRect)frame;
-(void)setTarget:(id)targetReceived onClose:(SEL)func;


@end
