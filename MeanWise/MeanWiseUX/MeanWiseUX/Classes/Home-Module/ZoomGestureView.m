//
//  ZoomGestureView.m
//  MeanWiseUX
//
//  Created by Hardik on 27/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ZoomGestureView.h"

@implementation ZoomGestureView

-(void)setUpCellRect:(CGRect)rect;
{
    forPostDetail=false;
    cellRect=rect;
    
    self.backgroundColor=[UIColor clearColor];
    
    containerView=[[UIView alloc] initWithFrame:rect];
    [self addSubview:containerView];
    containerView.backgroundColor=[UIColor clearColor];

    [UIView animateWithDuration:0.5 animations:^{
        
        containerView.frame=self.bounds;
        self.backgroundColor=[UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    [self setUpPanGesture];
    
    self.clipsToBounds=YES;


}
-(void)setForPostDetail
{
    forPostDetail=true;
}
-(void)setUpCellRectResizerWithoutGesture:(CGRect)rect;
{
    cellRect=rect;
    
    self.backgroundColor=[UIColor clearColor];
    
    containerView=[[UIView alloc] initWithFrame:rect];
    [self addSubview:containerView];
    
    
    
    
    
    self.clipsToBounds=YES;
    
    
}

-(void)setUpCellRectResizer:(CGRect)rect;
{
    cellRect=rect;
    
    self.backgroundColor=[UIColor clearColor];
    
    containerView=[[UIView alloc] initWithFrame:rect];
    [self addSubview:containerView];
    
    
   
    
    [self setUpPanGesture];
    
    self.clipsToBounds=YES;
    
    
}
-(void)setUpCellRectResizerAnimate
{
    [UIView animateWithDuration:0.5 animations:^{
        
        containerView.frame=self.bounds;
        self.backgroundColor=[UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
        [self FullScreenDone];
        [self zoomDownGestureEnded];
    }];
    
}
-(void)FullScreenDone
{
    
}

-(void)setUpPanGesture
{
    swipeDownDetected=0;
    
    panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:panGesture];
    
    
    pinchGesture=[[UIPinchGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    
    [self addGestureRecognizer:pinchGesture];

    
}
-(void)zoomDownGestureDetected
{
    
}
-(void)zoomDownGestureEnded
{
    
}
-(void)zoomDownOut
{
    
}
-(void)setGestureEnabled:(BOOL)flag
{

    panGesture.enabled=flag;
    pinchGesture.enabled=flag;
    
}

-(void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer
{
    
    float y=recognizer.scale;
    NSLog(@"%f",y);
    
    if(y>=1) y=1;
    if(y<=0)
    {
        y=0;
    }

    y=1-y;
    
    if(recognizer.state==UIGestureRecognizerStateRecognized)
    {
     //   [self zoomDownGestureDetected];
    }
    
    if(recognizer.state==UIGestureRecognizerStateChanged)
    {
        [self zoomDownGestureDetected];

        float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
        float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);

        float xOrigin=self.frame.origin.x*(1-y)+cellRect.origin.x*(y);
        float xSize=self.frame.size.width*(1-y)+cellRect.size.width*(y);

        
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
        containerView.frame=CGRectMake(xOrigin, yOrigin, xSize,ySize);
    }
    if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        CGRect destRect=self.bounds;
        
        if(y<0.3)
        {
            destRect=self.bounds;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                containerView.frame=destRect;
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                
            } completion:^(BOOL finished) {
                [self zoomDownGestureEnded];

                
            }];
        }
        else{
            destRect=cellRect;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                containerView.frame=destRect;
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                
                
            } completion:^(BOOL finished) {
                
                [self zoomDownGestureEnded];

                [self zoomDownOut];
                [self removeFromSuperview];
                
            }];
        }
    }
    
    
    
}
-(void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
 //   CGPoint point=[recognizer locationInView:self];
   // CGPoint velocity=[recognizer velocityInView:self];
 //   CGPoint translation=[recognizer translationInView:self];

    
  /*  if(forPostDetail==false)
    {
        if(recognizer.state==UIGestureRecognizerStateBegan)
        {
            if(point.y<100)
            {
                swipeDownDetected=1;
                [self zoomDownGestureDetected];
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateChanged)
        {
            if(swipeDownDetected==1)
            {
                float y=2*point.y/self.bounds.size.height;
                y=(point.y-100)/cellRect.origin.y;
                NSLog(@"%f",y);
                if(y>=1)
                {
                    y=1;
                }
                if(y<=0)
                {
                    y=0;
                }
                float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                float xOrigin=self.frame.origin.x*(1-y)+cellRect.origin.x*(y);
                float xSize=self.frame.size.width*(1-y)+cellRect.size.width*(y);
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                containerView.frame=CGRectMake(xOrigin, yOrigin, xSize,ySize);
                // float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                // float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                // self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                // containerView.frame=CGRectMake(0, yOrigin, self.frame.size.width,ySize);
                
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateEnded)
        {
            if(swipeDownDetected==1)
            {
                float y=(point.y-50)/cellRect.origin.y;
                if(y>=1) y=1;
                if(y<=0)
                {
                    y=0;
                }
                //                float speed=velocity.y;
                //
                //
                //            speed=0.4+0.2/speed;
                CGRect destRect=self.bounds;
                if(y<0.3)
                {
                    destRect=self.bounds;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                    }];
                }
                else{
                    destRect=cellRect;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                        [self zoomDownOut];

                        [self removeFromSuperview];
                    }];
                }
            }
        }
    }
    
    if(forPostDetail==true)
    {
        
        if(recognizer.state==UIGestureRecognizerStateChanged)
        {
            if(swipeDownDetected==0)
            {
                
                if(translation.x==0 || fabs(translation.y)/fabs(translation.x)>2)
                {
                    swipeDownDetected=1;
                    topPoint=point.y;
                    [self zoomDownGestureDetected];
                    

                }
                
            }
            else
            {
                if(translation.x==0 || fabs(translation.y)/fabs(translation.x)>2)
                {


                float y=2*point.y/self.bounds.size.height;
                y=(point.y-topPoint)/cellRect.origin.y;
                NSLog(@"%f",y);
                NSLog(@"Top point=%f",topPoint);

                if(y>=1)
                {
                    y=1;
                }
                if(y<=0)
                {
                    y=0;
                }
                float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                float xOrigin=self.frame.origin.x*(1-y)+cellRect.origin.x*(y);
                float xSize=self.frame.size.width*(1-y)+cellRect.size.width*(y);
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                
                
                containerView.frame=CGRectMake(xOrigin, yOrigin, xSize,ySize);
                NSLog(@"%@",NSStringFromCGRect(containerView.frame));
                }
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled)
        {
            if(swipeDownDetected==1)
            {
                
                swipeDownDetected=0;
                
                float y=(point.y-topPoint)/cellRect.origin.y;
                if(y>=1) y=1;
                if(y<=0)
                {
                    y=0;
                }
                //                float speed=velocity.y;
                //
                //
                //            speed=0.4+0.2/speed;
                CGRect destRect=self.bounds;
                if(y<0.3)
                {
                    destRect=self.bounds;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                    }];
                }
                else{
                    destRect=cellRect;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                        [self zoomDownOut];

                        [self removeFromSuperview];
                    }];
                }
            }
        }
        

    }*/
    
    if(forPostDetail==true)
    {
        [self panGesture_forPostDetail_RecognizerSnapChat:recognizer];
    }
    else
    {
        [self panGesture_Other_Recognizer:recognizer];

    }

}
-(void)panGesture_forPostDetail_RecognizerSnapChat:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point=[recognizer locationInView:self];
    // CGPoint velocity=[recognizer velocityInView:self];
    CGPoint translation=[recognizer translationInView:self];

    containerView.backgroundColor=[UIColor clearColor];
    
   
    
    if(forPostDetail==true)
    {
        
        if(recognizer.state==UIGestureRecognizerStateChanged)
        {
            if(swipeDownDetected==0)
            {
                if(translation.y>0)
                {
                if(translation.x==0 || fabs(translation.y)/fabs(translation.x)>2)
                {
                    swipeDownDetected=1;
                    topPoint=point.y;
                    [self zoomDownGestureDetected];
                    
                    
                }
                }
            }
            else
            {
                if(translation.x==0 || fabs(translation.y)/fabs(translation.x)>2)
                {
                    
                    
                    float y=2*point.y/self.bounds.size.height;
                    y=(point.y-topPoint)/(cellRect.origin.y+1);
                    NSLog(@"%f",y);
                    NSLog(@"Top point=%f",topPoint);
                    
                    if(y>=1)
                    {
                        y=1;
                    }
                    if(y<=0)
                    {
                        y=0;
                    }
                    float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                    float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                    float xOrigin=self.frame.origin.x*(1-y)+cellRect.origin.x*(y);
                    float xSize=self.frame.size.width*(1-y)+cellRect.size.width*(y);
                    self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                    
                    
                    containerView.frame=CGRectMake(xOrigin+translation.x/3, yOrigin+translation.y/3, xSize,ySize);
                    NSLog(@"%@",NSStringFromCGRect(containerView.frame));
                }
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled)
        {
            if(swipeDownDetected==1)
            {
                
                swipeDownDetected=0;
                
                float y=(point.y-topPoint)/cellRect.origin.y;
                if(y>=1) y=1;
                if(y<=0)
                {
                    y=0;
                }
                //                float speed=velocity.y;
                //
                //
                //            speed=0.4+0.2/speed;
                CGRect destRect=self.bounds;
                if(y<0.3)
                {
                    destRect=self.bounds;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                    }];
                }
                else{
                    destRect=cellRect;
                    [UIView animateWithDuration:0.2 animations:^{
                       
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                        
                    } completion:^(BOOL finished) {
                        [self zoomDownOut];
                        
                        [UIView animateWithDuration:0.01 animations:^{


                        } completion:^(BOOL finished) {
                            [self zoomDownGestureEnded];

                        [self removeFromSuperview];
                        }];

                    }];
                }
            }
        }
        
        
    }
 
    
    
}
-(void)panGesture_forPostDetail_Recognizer:(UIPanGestureRecognizer *)recognizer

{
    CGPoint point=[recognizer locationInView:self];
     CGPoint velocity=[recognizer velocityInView:self];
    CGPoint translation=[recognizer translationInView:self];

    
    if(recognizer.state==UIGestureRecognizerStateChanged)
    {
        
        if(swipeDownDetected==0 && velocity.y>5 && velocity.x<2 && velocity.x>-2)
        {
            swipeDownDetected=1;
            swipeDownFirstPoint=point.y;
            [self zoomDownGestureDetected];

        }
        
        if(swipeDownDetected==1)
        {
            
            float diff=1-(point.y-swipeDownFirstPoint)/(self.frame.size.height);
            
         //   NSLog(@"%f",diff);
            
            
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
            self.backgroundColor=[UIColor colorWithWhite:0 alpha:diff];

        }
        
        
    }
    if(recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled)
    {
        
        
        
        if(swipeDownDetected==1)
        {
            
            if(velocity.y<=0)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    
                 //   alphaView.alpha=1;
                    CGAffineTransform transform=CGAffineTransformMakeTranslation(1, 1);
                    containerView.transform=transform;

                    self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                } completion:^(BOOL finished) {
                    containerView.frame=self.frame;

                    [self zoomDownGestureEnded];
                }];

            }
            else
            {
                float ratio=cellRect.size.height/self.frame.size.height;

                NSLog(@"%f",ratio);
                [UIView animateWithDuration:0.2 animations:^{
                    

                    
                   // alphaView.alpha=0;
                    CGAffineTransform transform=CGAffineTransformMakeScale(ratio, ratio);
                    containerView.transform=transform;


                    
                    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                } completion:^(BOOL finished) {
                    

                    
                    [UIView animateWithDuration:0.2 animations:^{
                        //CGAffineTransform transform=CGAffineTransformMakeScale(1, 1);
                        //containerView.transform=transform;
                        
                        containerView.frame=cellRect;


                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                        [self zoomDownOut];
                        
                        [self removeFromSuperview];


                    }];

                }];

                
            }
            
            swipeDownDetected=0;
        }
    }
    
    /*
    if(forPostDetail==true && 1==2)
    {
        
        if(recognizer.state==UIGestureRecognizerStateChanged)
        {
            if(swipeDownDetected==0)
            {
                
                if(translation.x==0 || fabs(translation.y)/fabs(translation.x)>2)
                {
                    swipeDownDetected=1;
                    topPoint=point.y;
                    [self zoomDownGestureDetected];
                    
                    
                }
                
            }
            else
            {
                if(translation.x==0 || fabs(translation.y)/fabs(translation.x)>2)
                {
                    
                    
                    float y=2*point.y/self.bounds.size.height;
                    y=(point.y-topPoint)/cellRect.origin.y;
                    NSLog(@"%f",y);
                    NSLog(@"Top point=%f",topPoint);
                    
                    if(y>=1)
                    {
                        y=1;
                    }
                    if(y<=0)
                    {
                        y=0;
                    }
                    float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                    float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                    float xOrigin=self.frame.origin.x*(1-y)+cellRect.origin.x*(y);
                    float xSize=self.frame.size.width*(1-y)+cellRect.size.width*(y);
                    self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                    
                    
                    containerView.frame=CGRectMake(xOrigin, yOrigin, xSize,ySize);
                    NSLog(@"%@",NSStringFromCGRect(containerView.frame));
                }
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled)
        {
            if(swipeDownDetected==1)
            {
                
                swipeDownDetected=0;
                
                float y=(point.y-topPoint)/cellRect.origin.y;
                if(y>=1) y=1;
                if(y<=0)
                {
                    y=0;
                }
                //                float speed=velocity.y;
                //
                //
                //            speed=0.4+0.2/speed;
                CGRect destRect=self.bounds;
                if(y<0.3)
                {
                    destRect=self.bounds;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                    }];
                }
                else{
                    destRect=cellRect;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                        [self zoomDownOut];
                        
                        [self removeFromSuperview];
                    }];
                }
            }
        }
        
        
    }*/
}
-(void)panGesture_Other_Recognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point=[recognizer locationInView:self];
    // CGPoint velocity=[recognizer velocityInView:self];
//    CGPoint translation=[recognizer translationInView:self];

    if(forPostDetail==false)
    {
        if(recognizer.state==UIGestureRecognizerStateBegan)
        {
            if(point.y<100)
            {
                swipeDownDetected=1;
                [self zoomDownGestureDetected];
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateChanged)
        {
            if(swipeDownDetected==1)
            {
                float y=2*point.y/self.bounds.size.height;
                y=(point.y-100)/cellRect.origin.y;
                NSLog(@"%f",y);
                if(y>=1)
                {
                    y=1;
                }
                if(y<=0)
                {
                    y=0;
                }
                float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                float xOrigin=self.frame.origin.x*(1-y)+cellRect.origin.x*(y);
                float xSize=self.frame.size.width*(1-y)+cellRect.size.width*(y);
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                containerView.frame=CGRectMake(xOrigin, yOrigin, xSize,ySize);
                // float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
                // float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
                // self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
                // containerView.frame=CGRectMake(0, yOrigin, self.frame.size.width,ySize);
                
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateEnded)
        {
            if(swipeDownDetected==1)
            {
                float y=(point.y-50)/cellRect.origin.y;
                if(y>=1) y=1;
                if(y<=0)
                {
                    y=0;
                }
                //                float speed=velocity.y;
                //
                //
                //            speed=0.4+0.2/speed;
                CGRect destRect=self.bounds;
                if(y<0.3)
                {
                    destRect=self.bounds;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                    }];
                }
                else{
                    destRect=cellRect;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                        [self zoomDownOut];
                        
                        [self removeFromSuperview];
                    }];
                }
            }
        }
    }
}

-(void)closeThisView
{
    [self zoomDownGestureDetected];

    CGRect destRect=self.bounds;

    destRect=cellRect;
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
      
        
    } completion:^(BOOL finished) {
        
        
     

    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        containerView.frame=destRect;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

    } completion:^(BOOL finished) {
        
        [self zoomDownGestureEnded];
        [self zoomDownOut];
        
        [self removeFromSuperview];
    }];

}

@end

