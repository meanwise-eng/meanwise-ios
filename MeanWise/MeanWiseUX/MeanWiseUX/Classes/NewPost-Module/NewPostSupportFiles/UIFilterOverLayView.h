//
//  UIFilterOverLayView.h
//  VideoPlayerDemo
//
//  Created by Hardik on 27/03/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFilterOverLayView : UIView

{
    
    
    int effectNo;
    
    NSMutableArray *mainViews;
    
    
}
-(void)generateNewEffectPoint:(CGPoint)point;
-(void)cleanUp;
-(void)setUp;

@end
