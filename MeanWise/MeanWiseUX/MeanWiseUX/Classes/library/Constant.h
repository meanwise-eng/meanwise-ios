//
//  Constant.h
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FCAlertView.h"
#import "UIButton+ContentSize.h"
#import "APIPoster.h"


#define KK_globalMediaURL @"http://ec2-54-86-42-134.compute-1.amazonaws.com:8000"
/*
#define k_fontRegular @"Open Sans"
#define k_fontBold @"OpenSans-Bold"
#define k_fontExtraBold @"OpenSans-Extrabold"
#define k_fontSemiBold @"OpenSans-Semibold"
#define k_fontLight @"OpenSans-Light"
*/
#define k_fontRegular @"ProximaNova-Regular"
#define k_fontBold @"ProximaNova-Extrabld"
#define k_fontExtraBold @"OpenSans-Extrabold"
#define k_fontSemiBold @"ProximaNova-Semibold"
#define k_fontLight @"ProximaNova-Light"



#define k_fontAvenirNextHeavy @"AvenirNext-Heavy"


#define kk_chatFont [UIFont fontWithName:k_fontRegular size:16]
#define kk_chatBG1Color [UIColor colorWithRed:0.27 green:0.80 blue:1.00 alpha:1.00]
#define kk_chatBG2Color [UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00]
#define kk_chatFG1Color [UIColor whiteColor]
#define kk_chatFG2Color [UIColor blackColor]
#define kk_chatHeadMinHeight 60
#define kk_chatBoxTextViewHeight 60

#define kk_CommentHeadMinHeight 10

#define kk_homeFeedCellRatio 1.3



@interface Constant : NSObject

+(UITextField *)textField_Style1_WithRect:(CGRect)frame;

+(void)okAlert:(NSString *)alertTitle withSubTitle:(NSString *)subtitle onView:(UIView *)view andStatus:(int)status;

+(UIColor *)colorGlobal:(int)number;
+(UIImage *)takeScreenshot;
+(void)setUpGradient:(UIView *)parentView style:(int)number;


#pragma mark - File Manager

+ (NSURL *)applicationDocumentsDirectory;
+(NSString *)applicationDocumentsDirectoryPath;

+(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image WithFileName:(NSString *)filename;
+(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image;
+(NSString *)FM_saveVideoAtDocumentDirectory:(NSURL *)pathURL;

+(void)setStatusBarColorWhite:(BOOL)flag;
+ (UIViewController *) topMostController;


#pragma mark - File Manager
+(NSString *)static_getInterstFromId:(int)interstId;

@end
