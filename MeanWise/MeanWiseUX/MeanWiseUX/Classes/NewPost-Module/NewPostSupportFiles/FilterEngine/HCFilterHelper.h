//
//  HCFilterHelper.h
//  Exacto
//
//  Created by Hardik on 19/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HCFilterHelper : NSObject

{
    
    UILabel *fancyToast;
    UIView *mainView;
}

-(void)setForView:(UIView *)view;

-(UIImage *)getUIImageFromName:(NSString *)string;
-(void)saveFile:(UIImage *)image withName:(NSString *)string;
- (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage;
- (CAGradientLayer *)flavescentGradientLayer:(UIColor *)color1 andColor2:(UIColor *)color2 andPoints:(NSArray *)pointArray;
-(void)showFancyToastWithMessage:(NSString *)string;
- (void)rippleWithView:(UIView *)view center:(CGPoint)center  colorFrom:(UIColor *)colorFrom colorTo:(UIColor *)colorTo;

-(NSMutableArray *)setUpCoreFilterData;
-(NSMutableArray *)setUpMasterImageFilterData;
-(NSMutableArray *)setUpMasterVideoFilterData;

@end
