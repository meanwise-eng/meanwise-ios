//
//  UIArcView.h
//  ExactResearch
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIArcView : UIView
{
    float progress;
    float radious;
    
    
}
-(void)setProgress:(float)point;
-(void)setRadious:(float)point;
-(void)startAnimation:(id)sender;

@end
