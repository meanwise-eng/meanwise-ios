//
//  zoomPinchModel.h
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 31/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zoomPinchModel : UIView <UIGestureRecognizerDelegate>
{
    UIView *bgView;
    UIView *containerView;
    UIImageView *snapShot;

    CGPoint initialPointOfSnapshot;
    
    
    UIPanGestureRecognizer *panGesture;
    CGPoint firstPanTouchPoint;
    
    UIView *handlerObj;
    
    CGRect cellRect;
}
-(void)setUp:(CGRect)frame withObj:(UIView *)obj;

-(void)closeThisView; //Override manually close
-(void)setGestureEnabled:(BOOL)flag;
-(void)FullScreenDone; //When Opened full screen like viewwillapear


-(void)zoomDownGestureDetected; //Override when changes being detected
-(void)zoomDownGestureEnded; //Override when gesture stops detecting
-(void)zoomDownOut; //Override when about to close


-(void)setUpCellRectResizer:(CGRect)rect;
-(void)setUpCellRectResizerAnimate;
-(void)setForPostDetail;

@end


/*

 detect horizontal only [done]
 
 full screen callback [done]
 close callback [done]
 
 
 Switch callback
 Collectionview setup
 
 
 
*/
