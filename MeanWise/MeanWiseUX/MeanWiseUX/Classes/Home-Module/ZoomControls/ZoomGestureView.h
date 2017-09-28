//
//  ZoomGestureView.h
//  MeanWiseUX
//
//  Created by Hardik on 27/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomGestureView : UIView
{
    
    UIView *containerView;
    int swipeDownDetected;
    CGRect cellRect;
    
    BOOL forPostDetail;
    BOOL forMiniProfile;
    
    float topPoint;

    UIPanGestureRecognizer *panGesture;
    UIPinchGestureRecognizer *pinchGesture;
    
    
    float swipeDownFirstPoint;
    
    
   
    
}
-(void)setUpCellRect:(CGRect)rect;
-(void)setUpCellRectResizer:(CGRect)rect;;
-(void)setUpCellRectResizerWithoutGesture:(CGRect)rect;

-(void)setUpCellRectResizerAnimate;


-(void)zoomDownGestureDetected; //Override when changes being detected
-(void)zoomDownGestureEnded; //Override when gesture stops detecting

-(void)setForMiniProfile;
-(void)setForPostDetail; //To differentiate
-(void)zoomDownOut; //Override when about to close
-(void)FullScreenDone; //When Opened full screen like viewwillapear

-(void)viewWillBecomeFullScreen; //Every time when screen become full screen by gesture or through animation

-(void)setGestureEnabled:(BOOL)flag; //Override 
-(void)closeThisView; //Override manually close

-(void)setUpPanGesture;

@end
