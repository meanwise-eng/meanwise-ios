//
//  LoaderMin.m
//  MeanWiseUX
//
//  Created by Hardik on 14/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "LoaderMin.h"

@implementation LoaderMin

-(void)setUp
{
    self.opaque=YES;
    int sizeH=10;
    int sizeV=10;
    int gapH=4;
    
    int boundX=sizeH*0.1;
    //boundX=0;
    
    int sizeW=sizeH*3+gapH*2;
    
    sizeW=boundX+sizeH+gapH+sizeH+gapH+sizeH+boundX;
    
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeW, sizeV+boundX*2);
    
    
    //    shadow=[[UIImageView alloc] initWithFrame:self.bounds];
    //    [self addSubview:shadow];
    //    shadow.image=[UIImage imageNamed:@"squareDotGlow.png"];
    //    shadow.alpha=0.05;
    
    
    img1=[[UIImageView alloc] initWithFrame:CGRectMake(boundX, boundX, sizeH, sizeV)];
    img2=[[UIImageView alloc] initWithFrame:CGRectMake(sizeH+gapH+boundX, boundX, sizeH, sizeV)];
    img3=[[UIImageView alloc] initWithFrame:CGRectMake(sizeH*2+gapH*2+boundX, boundX, sizeH, sizeV)];
    
    [self addSubview:img1];
    [self addSubview:img2];
    [self addSubview:img3];
    
    img1.image=[UIImage imageNamed:@"squareDot.jpg"];
    img2.image=[UIImage imageNamed:@"squareDot.jpg"];
    img3.image=[UIImage imageNamed:@"squareDot.jpg"];
    
    img1.alpha=0;
    img2.alpha=0;
    img3.alpha=0;
    
    
    state=0;
    
    [self startAnimation];
}
-(void)startAnimation
{
    
    float duration=0.2;
    
    if(state==0)
    {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            
            
            img1.alpha=1;
            img3.alpha=0.2;
            img2.alpha=0.2;
            
            img1.transform=CGAffineTransformMakeScale(1, 1.5);
            img2.transform=CGAffineTransformMakeScale(1, 1);
            img3.transform=CGAffineTransformMakeScale(1, 1);
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else if(state==1)
    {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            
            
            img2.alpha=1;
            img1.alpha=0.2;
            img3.alpha=0.2;
            img2.transform=CGAffineTransformMakeScale(1, 1.5);
            img3.transform=CGAffineTransformMakeScale(1, 1);
            img1.transform=CGAffineTransformMakeScale(1, 1);
            
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else if(state==2)
    {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
            
            
            img3.alpha=1;
            img2.alpha=0.2;
            img1.alpha=0.2;
            img3.transform=CGAffineTransformMakeScale(1, 1.5);
            img2.transform=CGAffineTransformMakeScale(1, 1);
            img1.transform=CGAffineTransformMakeScale(1, 1);
            
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    state=state+1;
    
    
    if(state>2)
    {
        state=0;
    }
    
    
    
    
    
    //  [self performSelector:@selector(startAnimation) withObject:nil afterDelay:duration];
    
}
@end
