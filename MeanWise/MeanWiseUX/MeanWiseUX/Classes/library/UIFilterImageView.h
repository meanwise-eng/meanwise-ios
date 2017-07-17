//
//  UIFilterImageView.h
//  VideoPlayerDemo
//
//  Created by Hardik on 27/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTIndicator.h"

@interface UIFilterImageView : UIView

{
    
    
    NSMutableArray *effectNameList;
    NSMutableArray *arrayOfImageViews;
    NSMutableArray *effectedImages;
    
    UIImage *nextEffectImage;
    int nextImageNo;
    
    
    
    NSString *imagePath;
    
    
    
    
    NSArray *arrayOfEffects;
    
    
    
    
    
    
}
-(void)setUpWithImage:(NSString *)path;
-(void)generateNewEffectPoint:(CGPoint)point;
-(void)cleanUp;

@end
