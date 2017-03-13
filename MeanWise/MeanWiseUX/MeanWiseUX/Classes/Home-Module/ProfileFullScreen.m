//
//  ProfileFullScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileFullScreen.h"

@implementation ProfileFullScreen
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
{
    profileObj=obj;
    
}
-(void)setUpWithCellRect:(CGRect)rect
{
    self.backgroundColor=[UIColor clearColor];
   
    
    [self setUpCellRectResizerWithoutGesture:rect];
    
    containerView.backgroundColor=[UIColor clearColor];
    self.clipsToBounds=YES;
    
    forPostDetail=YES;
    
    containerView.clipsToBounds=YES;
   
    
    postIMGVIEW=[[UIImageHM alloc] initWithFrame:containerView.bounds];
    postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    [containerView addSubview:postIMGVIEW];
    postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    postIMGVIEW.clipsToBounds=YES;
    
   
    
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
    
    
    
    
    
    [self zoomDownGestureDetected];
    [self setUpCellRectResizerAnimate];
    
    [self setUpPanGesture];

    
  
    
 


  
    
}

-(void)zoomDownGestureDetected
{
        ck.hidden=true;
}
-(void)zoomDownGestureEnded
{
    ck.hidden=false;
}

-(void)setImage:(NSString *)string andNumber:(NSIndexPath *)indexPath
{
    postIMGVIEW.image=[UIImage imageNamed:string];

    globalPath=indexPath;

}
-(void)closeThisViewManuallyClicked:(id)sender
{
    postIMGVIEW.transform=CGAffineTransformMakeScale(1, 1);

    [self closeThisView];
    
}
-(void)FullScreenDone
{
    ck=[[ProfileAditionalScreen alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    
    [ck setUpProfileObj:profileObj];
    
    
    [ck setUp];
    [containerView addSubview:ck];
    [ck setDelegate:self andFunc1:@selector(closeThisViewManuallyClicked:)];
    

    [UIView animateKeyframesWithDuration:4.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced | UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse animations:^{
        
        postIMGVIEW.transform=CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        
       
    }];

    
}

-(void)setDelegate:(id)target andPageChangeCallBackFunc:(SEL)function1 andDownCallBackFunc:(SEL)function2;
{
    delegate=target;
    pageChangeCallBackFunc=function1;
    downCallBackFunc=function2;
    
}
-(void)zoomDownOut
{
    
    [delegate performSelector:downCallBackFunc withObject:globalPath afterDelay:0.0001];
    
    

    
    
}
@end
