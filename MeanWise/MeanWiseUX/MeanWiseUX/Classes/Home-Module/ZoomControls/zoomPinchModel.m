//
//  zoomPinchModel.m
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 31/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "zoomPinchModel.h"

@implementation zoomPinchModel


-(void)setUpCellRectResizer:(CGRect)rect;
{
    [self setUp:rect withObj:nil];
}

-(void)setUpCellRectResizerAnimate
{
    containerView.frame=self.bounds;
    containerView.transform=CGAffineTransformMakeScale(0.20f, 0.20f);

    containerView.center=CGPointMake(CGRectGetMidX(cellRect), CGRectGetMidX(cellRect));
    [self initAnimate];

}
-(void)setForPostDetail
{
}

-(void)setUp:(CGRect)frame withObj:(UIView *)obj;
{
    cellRect=frame;
    
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    handlerObj=obj;
    
    bgView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:bgView];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha=0;
    
    
    containerView=[[UIView alloc] initWithFrame:frame];
    [self addSubview:containerView];
    

    

//    
//    snapShot=[[UIImageView alloc] initWithFrame:containerView.bounds];
//    snapShot.image=[UIImage imageNamed:@"dummy_3"];
//    [containerView addSubview:snapShot];
//    snapShot.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    

    
    
    
    panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDetected:)];
    [self addGestureRecognizer:panGesture];
    panGesture.delegate=self;
    
}
-(void)setGestureEnabled:(BOOL)flag
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    panGesture.enabled=flag;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
  
    if(panGesture==panGestureRecognizer)
    {
        CGPoint velocity = [panGestureRecognizer velocityInView:self];
        BOOL flag=fabs(velocity.y) > fabs(velocity.x);

        if(flag==true)
        [self zoomDownGestureDetected];

        return flag;
    }
    else
    {
        return [super gestureRecognizerShouldBegin:panGestureRecognizer];
    }
}

-(void)panGestureRecognizerDetected:(UIPanGestureRecognizer *)gesture
{
    
    CGPoint currentPoint=[gesture locationInView:self];
 //   CGPoint velocity=[gesture velocityInView:self];
    CGPoint translation=[gesture translationInView:self];
    
    if(gesture.state==UIGestureRecognizerStateBegan )
    {
        firstPanTouchPoint=currentPoint;
   
    }
    else if(gesture.state==UIGestureRecognizerStateChanged)
    {
        float diffStart=self.frame.size.height-firstPanTouchPoint.y;
        float diffCurrent=currentPoint.y-firstPanTouchPoint.y;
        
        float ratio=1.0f-diffCurrent/diffStart;
      //  NSLog(@"%f",ratio);
        
        if(ratio>1)
        {
            ratio=1;
        }
        else
        {
            
        }

        
        containerView.transform=CGAffineTransformMakeScale(0.20f+0.8*ratio, 0.20f+0.8*ratio);
        bgView.alpha=ratio;

        CGPoint sPos=self.center;
        containerView.center=CGPointMake(sPos.x+translation.x/2, sPos.y+translation.y/2);
        
    }
    else if(gesture.state==UIGestureRecognizerStateEnded || panGesture.state==UIGestureRecognizerStateCancelled)
    {
        float diffStart=self.frame.size.height-firstPanTouchPoint.y;
        float diffCurrent=currentPoint.y-firstPanTouchPoint.y;
        float ratio=1.0f-diffCurrent/diffStart;

        if(ratio>0.5)
        {
            [self animateToFullMode];
        }
        else
        {
            [self animateToClose];
        }
        
    }

    

}
-(void)initAnimate
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    handlerObj.hidden=true;
    initialPointOfSnapshot=containerView.center;
    
    [self animateToFullMode];
    
}
-(void)animateToFullMode
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    [UIView animateWithDuration:0.7f delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        bgView.alpha=1;
        containerView.transform=CGAffineTransformMakeScale(1, 1);
        containerView.center=self.center;
        
    } completion:^(BOOL finished) {
        
        [self zoomDownGestureEnded];

        [self FullScreenDone];
    }];
    
}

-(void)animateToClose
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    [UIView animateWithDuration:0.7f delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        
        
        containerView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
        containerView.center=CGPointMake(CGRectGetMidX(cellRect),CGRectGetMaxX(cellRect));
        
        bgView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self zoomDownGestureEnded];
        [self zoomDownOut];

        [self removeFromSuperview];
        handlerObj.hidden=false;
        
    }];

}
-(void)closeThisView
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    [self animateToClose];
}

-(void)FullScreenDone
{
   NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
}
-(void)zoomDownGestureDetected
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    
    //Override when changes being detected
}
-(void)zoomDownGestureEnded
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    //Override when gesture stops detecting
    
}
-(void)zoomDownOut
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    //Override when about to close
    
}
@end
