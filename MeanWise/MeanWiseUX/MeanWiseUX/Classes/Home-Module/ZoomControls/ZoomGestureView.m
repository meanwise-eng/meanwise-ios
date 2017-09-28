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
    forMiniProfile=false;
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
-(void)setForMiniProfile
{
    forMiniProfile=true;

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
    [UIView animateWithDuration:0.3 animations:^{
        
        containerView.frame=self.bounds;
        self.backgroundColor=[UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
        [self FullScreenDone];
        [self viewWillBecomeFullScreen];
        [self zoomDownGestureEnded];
    }];
    
  
    
//    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        
//        containerView.frame=self.bounds;
//        self.backgroundColor=[UIColor blackColor];
//        
//    } completion:^(BOOL finished) {
//        [self FullScreenDone];
//        [self zoomDownGestureEnded];
//        
//    }];
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
-(void)FullScreenDone
{
    
}

-(void)zoomDownOut
{
    
}
-(void)viewWillBecomeFullScreen
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
    
    if(forPostDetail==true && forMiniProfile==false)
    {
        [self panGesture_forPostDetail_RecognizerSnapChat:recognizer];
    }
    else if(forMiniProfile==true)
    {
        [self panGesture_forMiniProfile_RecognizerSnapChat:recognizer];
    }
    else
    {
        [self panGesture_Other_Recognizer:recognizer];

    }
    

}
-(void)panGesture_forMiniProfile_RecognizerSnapChat:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point=[recognizer locationInView:self];
    CGPoint translation=[recognizer translationInView:self];
    containerView.backgroundColor=[UIColor clearColor];

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
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        containerView.center=self.center;
                        containerView.layer.cornerRadius=containerView.frame.size.height/2;


                    } completion:^(BOOL finished) {
                    }];

                    
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
                
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y*y*y)];
                
                containerView.clipsToBounds=YES;
                
                containerView.frame=CGRectMake(xOrigin+translation.x/3, yOrigin+translation.y/3, ySize,ySize);
                
                containerView.layer.cornerRadius=ySize/2;
                containerView.center=self.center;

                
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
                    containerView.layer.cornerRadius=0;

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
                    float minRatio=1-cellRect.size.height/self.frame.size.height;
                    
                    float diffStart=self.frame.size.height-topPoint;
                    float diffCurrent=point.y-topPoint;
                    
                    float ratio=diffCurrent/diffStart;
                    //  NSLog(@"%f",ratio);
                    
                   
                    if(ratio>minRatio)
                    {
                        ratio=minRatio;
                    }
                    if(ratio<0)
                    {
                        ratio=0;
                    }
                    
                    

                    float yOrigin=self.frame.origin.y*(1-ratio)+cellRect.origin.y*(ratio);
                    float ySize=self.frame.size.height*(1-ratio)+cellRect.size.height*(ratio);
                    float xOrigin=self.frame.origin.x*(1-ratio)+cellRect.origin.x*(ratio);
                    float xSize=self.frame.size.width*(1-ratio)+cellRect.size.width*(ratio);
                    self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-ratio)];
                    
                    
                    xOrigin=0;
                    yOrigin=0;
                    ySize=self.frame.size.height*(1-ratio);
                    xSize=self.frame.size.width*(1-ratio);
                    containerView.frame=CGRectMake(0, 0, xSize, ySize);
                    containerView.center=CGPointMake(self.bounds.size.width/2+translation.x/3, self.bounds.size.height/2+translation.y/3);
                    
                    
                    //containerView.frame=CGRectMake(xOrigin+translation.x/3, yOrigin+translation.y/3, xSize,ySize);
                    NSLog(@"%@",NSStringFromCGRect(containerView.frame));
                }
            }
        }
        else if(recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled)
        {
            if(swipeDownDetected==1)
            {
                
                swipeDownDetected=0;
                
                float diffStart=self.frame.size.height-topPoint;
                float diffCurrent=point.y-topPoint;
                
                float ratio=diffCurrent/diffStart;
                //  NSLog(@"%f",ratio);
                
                if(ratio>1)
                {
                    ratio=1;
                }
                else
                {
                    
                }
                
                
                CGRect destRect=self.bounds;
                if(ratio<0.3)
                {
                    destRect=self.bounds;
                    [UIView animateWithDuration:0.2 animations:^{
                        containerView.frame=destRect;
                        self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
                    } completion:^(BOOL finished) {
                        [self zoomDownGestureEnded];
                                [self viewWillBecomeFullScreen];
                    }];
                }
                else
                {
                   
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

-(void)panGesture_forPostDetail_RecognizerSnapChat1:(UIPanGestureRecognizer *)recognizer
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
    
    if(forMiniProfile==false)
    {
    [self zoomDownGestureDetected];

    CGRect destRect=self.bounds;
    destRect=cellRect;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        containerView.frame=destRect;
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

    } completion:^(BOOL finished) {
        
        [self zoomDownGestureEnded];
        [self zoomDownOut];
        
        [self removeFromSuperview];
    }];
    }
    else
    {
        [self zoomDownGestureDetected];
        
        containerView.clipsToBounds=YES;
        
        CGRect destRect=self.bounds;
        destRect=cellRect;

        containerView.layer.cornerRadius=self.frame.size.height/2;
        containerView.backgroundColor=[UIColor whiteColor];
        
        
        containerView.frame=CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        containerView.center=self.center;
        
        
        
        

//
//        
        [UIView animateWithDuration:0.5 animations:^{
            
            containerView.center=CGPointMake(CGRectGetMidX(cellRect), CGRectGetMidY(cellRect));
            containerView.transform=CGAffineTransformMakeScale(0.1, 0.1);
            
            
        } completion:^(BOOL finished) {
            
            [self zoomDownGestureEnded];
            [self zoomDownOut];
            
            [self removeFromSuperview];
        }];

    }

}

@end

