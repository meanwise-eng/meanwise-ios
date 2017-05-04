//
//  MiniProfileComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 19/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <pop/POP.h>
#import "Constant.h"
#import "APIManager.h"

@interface MiniProfileComponent : UIView<ASNetworkImageNodeDelegate>
{
    UIWindow *window;
    id target;
    SEL onCloseFunc;
    CGRect sourceFrame;

    
    UIView *containerView;
    
    NSDictionary *profileDict;
    
    ASNetworkImageNode *profileImageView;
    UILabel *FullNameLBL;
    UILabel *proffesionLBL;
    
    int isDataReceived;
    int isAnimationFinished;
    int isProfileOpened;
    int isCoverLoaded;
    
    APIObjects_ProfileObj *userData;
}
-(void)setUp:(NSDictionary *)dict;
-(void)setTarget:(id)targetReceived onClose:(SEL)func;

@end
