//
//  SnapZoom.h
//  MeanWiseUX
//
//  Created by Hardik on 22/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnapZoomView : UIView
{
    UIView *viewBG;
    
    UIView *alphaView;
    
    CGRect cellRect;
    
    UIView *containerView;
    
    int swipeDownDetected;
    float swipeDownFirstPoint;
    
    UIImageView *imgView;
}
-(void)setUpCellRect:(CGRect)rect;

@end
