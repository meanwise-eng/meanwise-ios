//
//  Constant.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "Constant.h"
#import "AppDelegate.h"
#import "ViewController.h"


@implementation Constant

+(UIColor *)colorGlobal:(int)number
{
    UIColor *blackColor;
    
    switch (number) {
        case 0://FF5252
            blackColor=[UIColor colorWithRed: 255/255.0f green: 82/255.0f blue:82/255.0f alpha:1.0f];
            break;
        case 1://FF4081
            blackColor=[UIColor colorWithRed: 255/255.0f green: 64/255.0f blue:129/255.0f alpha:1.0f ];
            break;
        case 2://E040FB
           blackColor= [UIColor colorWithRed: 224/255.0f green: 64/255.0f blue:251/255.0f alpha:1.0f];
            break;
        case 3://7C4DFF
            blackColor=[UIColor colorWithRed: 124/255.0f green: 77/255.0f blue:255/255.0f alpha:1.0f ];
            break;
        case 4://536DFE
            blackColor=[UIColor colorWithRed: 83/255.0f green: 109/255.0f blue:254/255.0f alpha:1.0f ];
            break;
        case 5://448AFF
            blackColor= [UIColor colorWithRed: 68/255.0f green: 138/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 6://40C4FF
            blackColor= [UIColor colorWithRed: 64/255.0f green: 196/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 7://64FFDA
            blackColor= [UIColor colorWithRed: 100/255.0f green: 255/255.0f blue:218/255.0f alpha:1.0f];
            break;
        case 8://00E676
            blackColor=[UIColor colorWithRed: 0/255.0f green: 230/255.0f blue:118/255.0f alpha:1.0f];
            break;
        case 9://FFEA00
            blackColor=[UIColor colorWithRed: 255/255.0f green: 234/255.0f blue:0/255.0f alpha:1.0f];
            break;
        case 10://FFD740
            blackColor= [UIColor colorWithRed: 255/255.0f green: 215/255.0f blue:64/255.0f alpha:1.0f];
            break;
        case 11://FFAB40
            blackColor=[UIColor colorWithRed: 255/255.0f green: 171/255.0f blue:64/255.0f alpha:1.0f];
            break;
        case 12://FF6E40
            blackColor= [UIColor colorWithRed: 255/255.0f green: 110/255.0f blue:64/255.0f alpha:1.0f];
            break;
        case 13://78909C
            blackColor=[UIColor colorWithRed: 120/255.0f green: 144/255.0f blue:156/255.0f alpha:1.0f];
            break;
            
        default:blackColor=[UIColor grayColor];
            break;
    }
    
    return blackColor;
}


+(UITextField *)textField_Style1_WithRect:(CGRect)frame
{
    UITextField *field=[[UITextField alloc] initWithFrame:frame];
    field.tintColor=[UIColor whiteColor];
    field.textColor=[UIColor whiteColor];
    field.font=[UIFont fontWithName:k_fontRegular size:25];
    field.keyboardAppearance=UIKeyboardAppearanceDark;
    field.enablesReturnKeyAutomatically=YES;
    return field;
    
}
+(BOOL)isNewPostTutorialFinished
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    
    int number=(int)[[ud valueForKey:@"Tutorial_NEWPOST"] intValue];
    
    [ud setInteger:1 forKey:@"Tutorial_NEWPOST"];
    
    if(number==1)
    {
        return true;
    }
    else
    {
        return false;
    }
    
}
+(BOOL)isHomePageTutorialFinished
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    

    int number=(int)[[ud valueForKey:@"Tutorial_HOME"] intValue];
    
    [ud setInteger:1 forKey:@"Tutorial_HOME"];
    
    if(number==1)
    {
        return true;
    }
    else
    {
        return false;
    }
        
}
+(void)okAlert:(NSString *)alertTitle withSubTitle:(NSString *)subtitle onView:(UIView *)view andStatus:(int)status
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    if(status==-1)
    {
    [alert makeAlertTypeCaution];
    }
    
    [alert showAlertInView:view
                 withTitle:alertTitle
              withSubtitle:subtitle
           withCustomImage:nil
       withDoneButtonTitle:@"OK"
                andButtons:nil];
}
+(UIImage *)takeScreenshot
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}
+(void)setUpGradient:(UIView *)parentView style:(int)number;
{
    UIView *view=[[UIView alloc] initWithFrame:parentView.bounds];
    [parentView addSubview:view];
    
    UIColor *color1;
    UIColor *color2;
    UIColor *color3;
    
    if(number==-1) //date picker
    {
        color1=[UIColor colorWithWhite:0.95 alpha:1.0f];
        color2=[UIColor colorWithWhite:0.92 alpha:1.0f];
        color3=[UIColor colorWithWhite:0.90 alpha:1.0f];

        
    }
    if(number==1)
    {
        color1=[UIColor colorWithHue:0.56 saturation:0.60 brightness:1.00 alpha:1.00];
        color2=[UIColor colorWithHue:0.62 saturation:0.65 brightness:1.00 alpha:1.00];
        color3=[UIColor colorWithHue:0.68 saturation:0.70 brightness:1.00 alpha:1.00];
    }
    else if(number==2)
    {
        color1=[UIColor colorWithHue:0.81 saturation:0.87 brightness:1.00 alpha:1.00];
        color2=[UIColor colorWithHue:0.785 saturation:0.82 brightness:0.87 alpha:1.00];
        color3=[UIColor colorWithHue:0.76 saturation:0.78 brightness:0.74 alpha:1.00];
        
    }
    else if(number==3)
    {
        color1=[UIColor colorWithHue:0.57 saturation:0.51 brightness:0.64 alpha:1.00];
        color2=[UIColor colorWithHue:0.57 saturation:0.53 brightness:0.52 alpha:1.00];
        color3=[UIColor colorWithHue:0.57 saturation:0.55 brightness:0.40 alpha:1.00];
        
    }
    else if(number==4)
    {
        color1=[UIColor colorWithHue:0.12 saturation:0.78 brightness:1.00 alpha:1.00];
        color2=[UIColor colorWithHue:0.10 saturation:0.875 brightness:1.00 alpha:1.00];
        color3=[UIColor colorWithHue:0.08 saturation:0.97 brightness:1.00 alpha:1.00];
        
    }
    else if(number==5)
    {
        color1=[UIColor colorWithHue:0.43 saturation:0.78 brightness:0.91 alpha:1.00];
        color2=[UIColor colorWithHue:0.495 saturation:0.705 brightness:0.855 alpha:1.00];
        color3=[UIColor colorWithHue:0.56 saturation:0.63 brightness:0.80 alpha:1.00];
        
    }
    else if(number==6)
    {
        color1=[UIColor colorWithHue:0.57 saturation:1.00 brightness:0.85 alpha:1.00];
        color2=[UIColor colorWithHue:0.615 saturation:0.82 brightness:0.715 alpha:1.00];
        color3=[UIColor colorWithHue:0.66 saturation:0.64 brightness:0.58 alpha:1.00];
        
    }
    else if(number==7)
    {
        color1=[UIColor colorWithHue:0.04 saturation:0.59 brightness:1.00 alpha:1.00];
        color2=[UIColor colorWithHue:0.04 saturation:0.59 brightness:1.00 alpha:1.00];
        color3=[UIColor colorWithHue:0.98 saturation:0.78 brightness:0.92 alpha:1.00];
        
    }
    else if(number==8)
    {
        color1=[UIColor colorWithHue:0.53 saturation:1.00 brightness:1.00 alpha:1.00];
        color2=[UIColor colorWithHue:0.565 saturation:0.865 brightness:0.92 alpha:1.00];
        color3=[UIColor colorWithHue:0.60 saturation:0.73 brightness:0.84 alpha:1.00];
        
    }
    else if(number==201)
    {
        color1=[UIColor colorWithHue:0 saturation:1.00 brightness:0 alpha:1.00];
        color2=[UIColor colorWithHue:0.2 saturation:0.90 brightness:0 alpha:1.00];
        color3=[UIColor colorWithHue:0.3 saturation:0.80 brightness:0 alpha:1.00];
        
    }
    else if(number==202)
    {
        //FFA7E7
        //EA6362
        
        color3=[UIColor colorWithRed:0.92 green:0.39 blue:0.38 alpha:1.00];
        color2=[UIColor colorWithRed:0.96 green:0.52 blue:0.69 alpha:1.00];
        color1=[UIColor colorWithRed:1.00 green:0.65 blue:0.91 alpha:1.00];
        
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = view.bounds;
    gradient.colors = @[(id)color1.CGColor,(id)color2.CGColor, (id)color3.CGColor];
    gradient.startPoint=CGPointMake(0.5, 0.5f);
    gradient.endPoint=CGPointMake(0.7, 1.2f);
    [view.layer insertSublayer:gradient atIndex:0];

}

+(UIView *)createProgressSignupViewWithWidth:(float)width andProgress:(float)percentage toPercentage:(float)toPercentage
{
    UIView *progressView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, width*percentage, 3)];
    progressView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        progressView.frame=CGRectMake(0, 20, width*toPercentage, 3);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    return progressView;
    
    
    
}
#pragma mark - File Manager

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
+(NSString *)applicationDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory

    return documentsPath;
}
+(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image WithFileName:(NSString *)filename
{
    NSString *savedImagePath = [[self applicationDocumentsDirectoryPath] stringByAppendingPathComponent:filename];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL flag=[imageData writeToFile:savedImagePath atomically:YES];
    
    return savedImagePath;

    
}
+(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image
{
    NSString *savedImagePath = [[self applicationDocumentsDirectoryPath] stringByAppendingPathComponent:@"savedImage.png"];
    
    [[NSFileManager defaultManager] removeItemAtPath:savedImagePath error:nil];

    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL flag=[imageData writeToFile:savedImagePath atomically:YES];
    
    
//    if (!flag) {
//        savedImagePath=@"";
//    }

    return savedImagePath;

}
+(NSString *)FM_saveVideoAtDocumentDirectory:(NSURL *)pathURL
{
    
    
    NSString *documentsDirectory = [self applicationDocumentsDirectoryPath];

    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
    
    
    NSData *videoData = [NSData dataWithContentsOfURL:pathURL];

    
    BOOL success = [videoData writeToFile:tempPath atomically:NO];

    return tempPath;
}

+(void)setStatusBarColorWhite:(BOOL)flag;
{
 
    UINavigationController *cont=(UINavigationController *)[self topMostController];

    if(flag==true)
    {

        cont.navigationBar.barStyle=UIBarStyleBlack;
        cont.navigationBar.opaque=false;

    }
    else
    {
        cont.navigationBar.barStyle=UIBarStyleDefault;
        cont.navigationBar.opaque=false;
    }
    
    
    

    
    
}
+(NSString *)getCompressedPathFromImagePath:(NSString *)sourcePath
{
    UIImage *inputImage=[UIImage imageWithContentsOfFile:sourcePath];
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.39f;
    int maxFileSize = (int)(1024);
    
    NSData *imageData = UIImageJPEGRepresentation(inputImage, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        NSLog(@"compression=%f",compression);
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(inputImage, compression);
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"compressedFile.jpg"];
    
    
    [imageData writeToFile:savedImagePath atomically:NO];
    
    NSLog(@"%@",savedImagePath);
    
    return savedImagePath;
    
}


+ (UIViewController *) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
#pragma mark - File Manager
+(NSString *)static_getInterstFromId:(int)interstId
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    NSArray *ud1=[ud objectForKey:@"DATA_INTEREST"];
    
    NSArray *filtered = [ud1 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(id == %d)", interstId]];
    
    if(filtered.count==1)
    {
        return [[filtered valueForKey:@"name"] objectAtIndex:0];
    }
    else
    {
        return @"";
    }


}
+(NSString *)static_getSKillFromId:(int)skillId
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    NSArray *ud1=[ud objectForKey:@"DATA_SKILLS"];
    
    NSArray *filtered = [ud1 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(id == %d)", skillId]];
    
    if(filtered.count==1)
    {
        return [[filtered valueForKey:@"text"] objectAtIndex:0];
    }
    else
    {
        return @"";
    }
    
    
}
+(BOOL)isAppDebugModeOn
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    BOOL flag=[ud boolForKey:@"UD_DEBUG"];
    
    return flag;
}
+(void)setAppDebugMode:(BOOL)flag
{
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setBool:flag forKey:@"UD_DEBUG"];

}

@end
