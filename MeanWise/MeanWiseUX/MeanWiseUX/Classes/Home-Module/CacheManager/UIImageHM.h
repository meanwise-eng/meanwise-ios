//
//  UIImageHM.h
//  MeanWiseUX
//
//  Created by Hardik on 05/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIArcViewProgressBar.h"
#import "NSOperationStack.h"
#import "APIManager.h"

@interface UIImageHM : UIImageView
{
    UIArcViewProgressBar *progressBar;
    NSString *mainURL;
    UIButton *tapHolderBtn;
    NSDictionary *userDict;
    
    id target;
    SEL onClickFunc;

}
-(void)setUp:(NSString *)stringURL;
-(void)clearImageCache;
-(void)setPlaceHolderImage;
-(void)clearImageAll;
-(void)setDownloadedImage;
-(void)setDownloadedImageWithoutAnimation;
-(void)setTarget:(id)targetReceived OnClickFunc:(SEL)func WithObj:(NSDictionary *)obj;


@end
