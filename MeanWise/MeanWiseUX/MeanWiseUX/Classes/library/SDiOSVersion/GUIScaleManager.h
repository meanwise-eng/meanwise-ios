//
//  UIScaleManager.h
//  MeanWiseUX
//
//  Created by Hardik on 22/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RX_mainScreenBounds CGRectMake(0,0,375,667)
//#define RX_mainScreenBounds [UIScreen mainScreen].bounds

@interface GUIScaleManager : NSObject

+(void)setTransform:(UIView *)view;
+(void)setInverseTransform:(UIView *)view;

@end
