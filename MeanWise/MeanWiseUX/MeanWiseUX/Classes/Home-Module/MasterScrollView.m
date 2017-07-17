//
//  MasterScrollView.m
//  MeanWiseUX
//
//  Created by Hardik on 10/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "MasterScrollView.h"
#import "GUIScaleManager.h"

@implementation MasterScrollView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSLog(@"Passing all touches to the next view (if any), in the view stack.");

    
    if(point.y<RX_mainScreenBounds.size.height/2)
    {
        return false;
    }
    else
    {
        return YES;
    }
 //   return YES;
}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch=[touches anyObject];
//    CGPoint point=[touch locationInView:self];
//    
//    NSLog(@"touches");
//    
//    if (point.y<300) {
//        
//        [[self nextResponder] touchesBegan:touches withEvent:event];
//    }
//    else
//    {
//        
//        [super touchesBegan:touches withEvent:event];
//    }
//    
//}

@end
