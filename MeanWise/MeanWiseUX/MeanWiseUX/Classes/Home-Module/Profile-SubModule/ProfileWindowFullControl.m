//
//  ProfileWindowFullControl.m
//  MeanWiseUX
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileWindowFullControl.h"


@implementation ProfileWindowFullControl

-(void)setTarget:(id)delegateR onCloseBtn:(SEL)func;
{
    delegate=delegateR;
    downCallBackFunc=func;
}
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
{
    profileObj=obj;
    
    

    
}
-(void)setUpCustom:(CGRect)rect
{
    
    [self setUp:rect];
    
    self.backgroundColor=[UIColor colorWithWhite:1.0f alpha:0.2f];
    
    
    
    self.clipsToBounds=YES;
    
    
    
    
    postIMGVIEW=[[UIImageHM alloc] initWithFrame:self.bounds];
    postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    [containerView addSubview:postIMGVIEW];
    postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    postIMGVIEW.clipsToBounds=YES;
    
    postIMGVIEW.hidden=false;
    
    if(profileObj.cover_photo.class!=[NSNull class])
    {
        if(![profileObj.cover_photo isEqualToString:@""])
        {
            [postIMGVIEW setUp:profileObj.cover_photo];
        }
        else
        {
            
        }
    }
    else
    {
        
    }
    
//    ck=[[ProfileAditionalScreen alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
//    
//    [ck setUpProfileObj:profileObj];
//    [ck setUp];
//    [containerView addSubview:ck];
//    [ck setDelegate:self andFunc1:@selector(closeThisViewManuallyClicked:)];
//
    
    mk=[[ProfileWindowAditionalScreen alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    
    [mk setUpProfileObj:profileObj];
    [mk setUp];
    [containerView addSubview:mk];
    [mk setDelegate:self andFunc1:@selector(closeThisViewManuallyClicked:)];

    

    
    
    [UIView animateKeyframesWithDuration:4.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced | UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse animations:^{
        
        postIMGVIEW.transform=CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        
        
    }];

    
    
    
}



-(void)closeThisViewManuallyClicked:(id)sender
{
    
    [self animateToClose];
    
}

-(void)zoomDownOut
{
    
    
    [ck removingComponent];
    
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    
    [delegate performSelector:downCallBackFunc withObject:globalPath afterDelay:0.0001];
    
    
    
    
    
}
@end
