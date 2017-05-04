//
//  ProfileFullScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileFullScreen.h"
#import "HMPlayerManager.h"

@implementation ProfileFullScreen
-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
{
    profileObj=obj;
    isStatic = NO;
    
}

-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj profileImage:(UIImage *)image
{
     profileObj=obj;
     profileImage = image;
     isStatic = YES;
}

-(void)setUpWithCellRect:(CGRect)rect
{
    
    [[HMPlayerManager sharedInstance] StopKeepKillingProfileFeedVideosIfAvaialble];
    
    self.backgroundColor=[UIColor clearColor];
   
    
    [self setUpCellRectResizerWithoutGesture:rect];
    
    containerView.backgroundColor=[UIColor clearColor];
    self.clipsToBounds=YES;
    
    forPostDetail=YES;
    
    containerView.clipsToBounds=YES;
   
    

    postIMGVIEW = [[ASNetworkImageNode alloc] init];
    [postIMGVIEW setFrame:containerView.bounds];
    postIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
    [containerView addSubview:postIMGVIEW.view];
    postIMGVIEW.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    postIMGVIEW.clipsToBounds=YES;
    
   
   
    if(isStatic){
        postIMGVIEW.defaultImage = profileImage;
    }
    else{
        if(profileObj.cover_photo.class!=[NSNull class])
        {
            if(![profileObj.cover_photo isEqualToString:@""])
            {
                [postIMGVIEW setURL:[NSURL URLWithString:profileObj.cover_photo]];
            }
            else
            {
                
            }
        }
    }
    
    
    
    
    
    [self zoomDownGestureDetected];
    [self setUpCellRectResizerAnimate];
    
   // [self setUpPanGesture];


  
    
}
-(void)setClosingFrame:(CGRect)rect;
{
    cellRect=rect;

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
    if(!isStatic){
        postIMGVIEW.URL=[NSURL URLWithString:string];
    }
    
    globalPath=indexPath;

}
-(void)closeThisViewManuallyClicked:(id)sender
{
    
    postIMGVIEW.view.transform=CGAffineTransformMakeScale(1, 1);

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
        
        postIMGVIEW.view.transform=CGAffineTransformMakeScale(1.2, 1.2);
        
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
    
    
    [ck removingComponent];
    
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    [[HMPlayerManager sharedInstance] StartKeepKillingProfileFeedVideosIfAvaialble];

    [delegate performSelector:downCallBackFunc withObject:globalPath afterDelay:0.0001];
    
    

    
    
}
@end
