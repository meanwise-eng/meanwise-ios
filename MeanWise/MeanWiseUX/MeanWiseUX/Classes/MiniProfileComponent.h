//
//  MiniProfileComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 19/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "UIImageHM.h"
#import "APIManager.h"

@interface MiniProfileComponent : UIView
{
    UIWindow *window;
    id target;
    SEL onCloseFunc;
    CGRect sourceFrame;

    
    UIView *containerView;
    
    
    
    UIImageHM *profileImageView;
    UILabel *FullNameLBL;
    UILabel *proffesionLBL;
    
    int isDataReceived;
    int isAnimationFinished;
    int isProfileOpened;
    
    APIObjects_ProfileObj *userData;
}
-(void)setUp:(NSDictionary *)dict;
-(void)setTarget:(id)targetReceived onClose:(SEL)func;

@end
