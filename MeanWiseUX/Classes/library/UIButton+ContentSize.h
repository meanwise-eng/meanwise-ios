//
//  UIButton+ContentSize.h
//  MeanWiseUX
//
//  Created by Hardik on 05/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
//[button setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
