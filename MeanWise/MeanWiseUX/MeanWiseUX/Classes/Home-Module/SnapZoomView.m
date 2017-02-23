//
//  SnapZoom.m
//  MeanWiseUX
//
//  Created by Hardik on 22/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "SnapZoomView.h"

@implementation SnapZoomView

-(void)setUpCellRect:(CGRect)rect
{
     cellRect=rect;
    

    
    viewBG=[[UIView alloc] initWithFrame:cellRect];
    [self addSubview:viewBG];
    viewBG.clipsToBounds=YES;
    viewBG.backgroundColor=[UIColor grayColor];
    
    alphaView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:alphaView];
    alphaView.backgroundColor=[UIColor blackColor];
    alphaView.alpha=0;

    
    
    containerView=[[UIView alloc] initWithFrame:cellRect];
    [self addSubview:containerView];
    containerView.clipsToBounds=YES;
    
    imgView=[[UIImageView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:imgView];
    //imgView.image=[UIImage imageNamed:@"Portfolio2.jpeg"];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    
    
    NSString *testBundlePath =
    [[NSBundle mainBundle] pathForResource:@"Portfolio2" ofType:@"jpeg"];
    imgView.image=[UIImage imageWithContentsOfFile:testBundlePath];


    imgView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self zoomInToFitAnimate];
    
     swipeDownDetected=0;

    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [containerView addGestureRecognizer:panGesture];
    
    
//    pinchGesture=[[UIPinchGestureRecognizer alloc]
//                  initWithTarget:self action:@selector(pinchGestureRecognizer:)];
//    
//    [self addGestureRecognizer:pinchGesture];

}
-(void)zoomInToFitAnimate
{
    [UIView animateWithDuration:0.5 animations:^{
        
        alphaView.alpha=1;
        containerView.frame=self.frame;

    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    

    CGPoint point=[recognizer locationInView:self];
    CGPoint velocity=[recognizer velocityInView:self];
    CGPoint translation=[recognizer translationInView:self];

   
    if(recognizer.state==UIGestureRecognizerStateChanged)
    {
        
        if(swipeDownDetected==0 && velocity.y>5 && velocity.x==0)
        {
            swipeDownDetected=1;
            swipeDownFirstPoint=point.y;
        }
        
        if(swipeDownDetected==1)
        {
            
            float diff=1-(point.y-swipeDownFirstPoint)/(self.frame.size.height);
            
            NSLog(@"%f",diff);
            

            if(diff>=1)
            {
                diff=1;
            }
            if(diff<0.2)
            {
                diff=0.2;
            }

            
            CGAffineTransform transform=CGAffineTransformMakeTranslation(translation.x, translation.y);
            transform=CGAffineTransformConcat(transform, CGAffineTransformMakeScale(diff, diff));
            
            
            containerView.transform=transform;
            alphaView.alpha=diff;
        }

        
    }
    if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        
        
        
        if(swipeDownDetected==1)
        {
            
            if(velocity.y>0)
            {
             
                [self zoomOutAndClose];
            }
            else
            {
                [self zoomInToFitAnimate];
            }
            
            swipeDownDetected=0;
        }
    }
    

    
}
-(void)zoomOutAndClose
{
    [UIView animateWithDuration:0.5 animations:^{
        alphaView.alpha=0;
        containerView.frame=cellRect;
        
    } completion:^(BOOL finished) {
      
        imgView.image=nil;
        [imgView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}
@end
