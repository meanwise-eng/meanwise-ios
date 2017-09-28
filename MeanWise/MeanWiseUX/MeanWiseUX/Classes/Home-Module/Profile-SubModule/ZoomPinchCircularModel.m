//
//  ZoomPinchCircularModel.m
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 08/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ZoomPinchCircularModel.h"

@implementation ZoomPinchCircularModel

-(void)setTarget:(id)targetReceived onCloseFunc:(SEL)func;
{
    target=targetReceived;
    onCloseFunc=func;
}
-(void)zoomDownOut
{
    
}
-(void)setUp:(CGRect)rect
{
    sourceRect=rect;
    
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:1.0f];
    
    fullRect=CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    lastRadius=fullRect.size.width*2;
    
    cropView=[[UIView alloc] initWithFrame:fullRect];
    cropView.clipsToBounds=YES;
    [self addSubview:cropView];

    containerView=[[UIView alloc] initWithFrame:self.bounds];
    containerView.clipsToBounds=YES;
    [cropView addSubview:containerView];
    
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.bounds];
//    [containerView addSubview:imageView];
//    [imageView setImage:[UIImage imageNamed:@"pqr1.jpg"]];
//    imageView.contentMode=UIViewContentModeScaleAspectFill;
//    imageView.clipsToBounds=YES;
    
    
    
    cropView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    containerView.center=CGPointMake(fullRect.size.width/2, fullRect.size.height/2);
    
    circle = [CAShapeLayer layer];
    circle.path= [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height/2, self.bounds.size.height/2) radius:lastRadius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
    cropView.layer.mask=circle;
    
    
    panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDetected:)];
    [self addGestureRecognizer:panGesture];
    panGesture.delegate=self;
    
    minRatio=sourceRect.size.height/self.bounds.size.height;
    
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
        else if(ratio<minRatio)
        {
            ratio=minRatio;
        }
        
        lastRadius=fullRect.size.width/2*ratio;
        // cropView.transform=CGAffineTransformMakeScale(ratio, ratio);
        circle.path= [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height/2, self.bounds.size.height/2) radius:lastRadius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:ratio];

        //bgView.alpha=ratio;
        
        
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
-(void)animateToFullMode
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];

        cropView.transform=CGAffineTransformMakeScale(1, 1);
        cropView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        
    } completion:^(BOOL finished) {
        
        lastRadius=fullRect.size.width*2;
        [UIView animateWithDuration:0.8 animations:^{
            
            
            circle.path= [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height/2, self.bounds.size.height/2) radius:lastRadius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}
-(void)animateToClose
{
    
    
    float delay=0;
    float closeUpTo=sourceRect.size.width/(2*lastRadius);
    
    if(lastRadius>fullRect.size.width)
    {
        delay=0.5f;
        lastRadius=fullRect.size.width/2*0.5;
        
        UIBezierPath *newPath =  [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height/2, self.bounds.size.height/2) radius:lastRadius startAngle:0 endAngle:2*M_PI clockwise:YES];

        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
        pathAnim.toValue = (id)newPath.CGPath;

        CAAnimationGroup *anims = [CAAnimationGroup animation];
        anims.animations = [NSArray arrayWithObjects:pathAnim, nil];
        anims.removedOnCompletion = NO;
        anims.duration = delay;
        anims.fillMode  = kCAFillModeForwards;

        [circle addAnimation:anims forKey:nil];
        closeUpTo=0.25f;

    }
    
    
    [UIView animateWithDuration:0.3f delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
        cropView.center=CGPointMake(sourceRect.origin.x+sourceRect.size.width/2, sourceRect.origin.y+sourceRect.size.width/2);
        
        cropView.transform=CGAffineTransformMakeScale(closeUpTo, closeUpTo);

    } completion:^(BOOL finished) {
       
        [self zoomDownOut];
        [target performSelector:onCloseFunc withObject:nil afterDelay:0.01];
        
        [self removeFromSuperview];

    }];
  
    
    
    
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
-(void)zoomDownGestureDetected
{
    NSLog(@"%s [Line %d] %@ ", __PRETTY_FUNCTION__, __LINE__,@"hello");
    
    [UIView animateWithDuration:0.9 animations:^{
        
       // lastRadius=fullRect.size.width/2;
        
      //  circle.path= [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height/2, self.bounds.size.height/2) radius:lastRadius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    //Override when changes being detected
}


@end
