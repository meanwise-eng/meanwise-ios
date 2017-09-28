//
//  DetailPostComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 26/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "DetailPostComponent.h"

@implementation DetailPostComponent

-(void)setUp:(NSString *)string andCellRect:(CGRect)rect
{
    cellRect=rect;
    
    self.backgroundColor=[UIColor clearColor];

    containerView=[[UIView alloc] initWithFrame:rect];
    [self addSubview:containerView];
    containerView.clipsToBounds=YES;
    
    
    UIImageView *bgImage;

    bgImage=[[UIImageView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:bgImage];
    bgImage.image=[UIImage imageNamed:string];
    bgImage.clipsToBounds=YES;
    bgImage.contentMode=UIViewContentModeScaleAspectFill;
    bgImage.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

   

    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        containerView.frame=self.bounds;
        self.backgroundColor=[UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
   [self setUpPanGesture];
    
    
    self.clipsToBounds=YES;
}
-(void)setUpPanGesture
{
    swipeDownDetected=0;
    
    UIPanGestureRecognizer *recognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:recognizer];
    
    
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    
    [self addGestureRecognizer:pinchGesture];
    
    
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
    
    if(recognizer.state==UIGestureRecognizerStateChanged)
    {
        float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
        float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
        containerView.frame=CGRectMake(0, yOrigin, self.frame.size.width,ySize);

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
                
                
            }];
        }
        else{
            destRect=cellRect;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                containerView.frame=destRect;
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                
                
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                
            }];
        }
    }

    
    
}
-(void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    //CGPoint velocity=[recognizer velocityInView:self];
  //  CGPoint translation=[recognizer translationInView:self];
    CGPoint point=[recognizer locationInView:self];
    

    
    if(recognizer.state==UIGestureRecognizerStateBegan)
    {
        if(point.y<100)
        {
            swipeDownDetected=1;
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
            self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
            containerView.frame=CGRectMake(0, yOrigin, self.frame.size.width,ySize);
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
                    
                    
                }];
            }
            else{
                destRect=cellRect;
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    containerView.frame=destRect;
                    self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
                    
                    
                } completion:^(BOOL finished) {
                    
                    [self removeFromSuperview];
                    
                }];
            }
        }
        
    }
    
  
    
    
}


-(void)setUpTouchMethods
{
    
    swipeDownDetected=0;
    self.userInteractionEnabled=true;
    
}
/*
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    
    if(point.y<50)
    {
        swipeDownDetected=1;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point1=[touch locationInView:self];
   // CGPoint point2=[touch previousLocationInView:self];
    
   
    if(swipeDownDetected==1)
    {
        
        
        float y=2*point1.y/self.bounds.size.height;
        y=(point1.y-50)/cellRect.origin.y;
        
      //  NSLog(@"%f",y);
        
        if(y>=1)
        {
            y=1;
        }
        
        float yOrigin=self.frame.origin.y*(1-y)+cellRect.origin.y*(y);
        float ySize=self.frame.size.height*(1-y)+cellRect.size.height*(y);
        
//        float yOrigin=cellRect.origin.y+self.frame.origin.y*(1-y);
  //      float ySize=cellRect.size.height+self.frame.size.height*(1-y);
        
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:(1-y)];
        
        containerView.frame=CGRectMake(0, yOrigin, self.frame.size.width,ySize);
    }
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point1=[touch locationInView:self];

    if(swipeDownDetected==1)
    {
        
        float y=(point1.y-50)/cellRect.origin.y;
        
        NSLog(@"%f",y);
        
        if(y>=1)
        {
            y=1;
        }
        

        CGRect destRect=self.bounds;
        
        if(y<0.3)
        {
            destRect=self.bounds;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                containerView.frame=destRect;
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:1];

                
            } completion:^(BOOL finished) {
                
                
            }];
        }
        else{
            destRect=cellRect;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                containerView.frame=destRect;
                self.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

                
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                
            }];
        }
        
       
    }
    
    
    
    
    swipeDownDetected=0;
}
*/

@end
