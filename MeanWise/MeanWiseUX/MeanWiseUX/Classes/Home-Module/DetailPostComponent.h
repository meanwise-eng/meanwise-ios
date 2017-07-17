//
//  DetailPostComponent.h
//  MeanWiseUX
//
//  Created by Hardik on 26/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPostComponent : UIView
{
    
    UIView *containerView;
 
    int swipeDownDetected;
    
    CGRect cellRect;
}
-(void)setUp:(NSString *)string andCellRect:(CGRect)rect;

@end
