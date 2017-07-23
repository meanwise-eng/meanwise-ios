//
//  UICameraBtn.m
//  ExactResearch
//
//  Created by Hardik on 12/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UICameraBtn.h"

@implementation UICameraBtn

-(void)setTarget:(id)delegate andPhotoCapture:(SEL)func1
{
    
    target=delegate;
    photoCaptureFunc=func1;
    
}
-(void)setTarget:(id)delegate andVideoStart:(SEL)func1 andVideoClose:(SEL)func2
{
    target=delegate;
    videoStartFunc=func1;
    videoStopFunc=func2;
    
}
-(void)setUp
{
    
    
    int wi=self.frame.size.width;
    int hi=self.frame.size.height;
    
    
    borderView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, wi-10, hi-10)];
    [self addSubview:borderView];
    borderView.backgroundColor=[UIColor clearColor];
    borderView.clipsToBounds=YES;
    borderView.layer.cornerRadius=(wi-10)/2;
    
    arcView=[[UIArcView alloc] initWithFrame:CGRectMake(12.5, 12.5, wi-25, hi-25)];
    [self addSubview:arcView];
    [arcView setProgress:0];
    [arcView setLineThicknessCustom:4.0];
    [arcView setLineColorCustom:[UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0f alpha:1.0]];
    arcView.backgroundColor=[UIColor clearColor];
    [arcView setRadious:(wi-35)/2];
    
    cameraBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, 20, wi-40, hi-40)];
    cameraBtn.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0];;
    cameraBtn.clipsToBounds=YES;
    cameraBtn.layer.cornerRadius=(wi-40)/2;;
    cameraBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    cameraBtn.layer.borderWidth = 4.0;
    [self addSubview:cameraBtn];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = borderView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // [borderView addSubview:blurEffectView];
    
    
    
    
    [cameraBtn addTarget:self action:@selector(cameraBtnTapDown:) forControlEvents:UIControlEventTouchDown];
    [cameraBtn addTarget:self action:@selector(cameraBtnTapUp:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    self.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    //    self.clipsToBounds=YES;
    //    self.layer.cornerRadius=30;
    
}

-(void)setUp1
{
    
    
    int wi=self.frame.size.width;
    int hi=self.frame.size.height;
    
    
    borderView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, wi-10, hi-10)];
    [self addSubview:borderView];
    borderView.backgroundColor=[UIColor clearColor];
    borderView.clipsToBounds=YES;
    borderView.layer.cornerRadius=(wi-10)/2;
    
    arcView=[[UIArcView alloc] initWithFrame:CGRectMake(0, 0, wi, hi)];
    [self addSubview:arcView];
    [arcView setProgress:0];
    arcView.backgroundColor=[UIColor clearColor];
    [arcView setRadious:(wi-10)/2];
    
    cameraBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, 20, wi-40, hi-40)];
    cameraBtn.backgroundColor=[UIColor whiteColor];
    cameraBtn.clipsToBounds=YES;
    cameraBtn.layer.cornerRadius=(wi-40)/2;;
    [self addSubview:cameraBtn];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = borderView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [borderView addSubview:blurEffectView];
    
    
    
    
    
    
    
    
    [cameraBtn addTarget:self action:@selector(cameraBtnTapDown:) forControlEvents:UIControlEventTouchDown];
    [cameraBtn addTarget:self action:@selector(cameraBtnTapUp:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    self.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    //    self.clipsToBounds=YES;
    //    self.layer.cornerRadius=30;
    
}

-(void)cameraBtnTapDown:(id)sender
{
    time=0;
    recordingStarted=0;
    
    [self CallContinue];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        borderView.transform=CGAffineTransformMakeScale(1.2, 1.2);
        
    }];
}
-(void)CallContinue
{
    if (cameraBtn.state != UIControlStateHighlighted)
    {
        return;
    }
    
    time=time+0.02;
    
    if(time>1.0f && recordingStarted==0)
    {
        recordingStarted=1;
        [self startRecording];
        
    }
    if(recordingStarted==1)
    {
        [self updateRecording];
    }
    
    //  CMTime t=[cameraCaptureView getRecordedVideoLength];
    //
    //    float dur = CMTimeGetSeconds(t);
    //
    //    [pro setProValue:dur/25.0f];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CallContinue) object:nil];
    [self performSelector:@selector(CallContinue) withObject:nil afterDelay:0.02];
    
    
}
-(void)updateRecording
{
    float progress=(time-1.0f)/25.0f;
    
    [arcView setProgress:progress];
    
    
    NSLog(@"Update");
    
}
-(void)startRecording
{
    
    NSLog(@"Recording started");
    
    
    [target performSelector:videoStartFunc withObject:nil afterDelay:0.0001];
    
}

-(void)capturePhoto
{
    NSLog(@"Photo Captured");
    
    [target performSelector:photoCaptureFunc withObject:nil afterDelay:0.0001];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        borderView.transform=CGAffineTransformMakeScale(1, 1);
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
    
    
}

-(void)cameraBtnTapUp:(id)sender
{
    if(time<1.0f)
    {
        [self capturePhoto];
    }
    else
    {
        NSLog(@"Recording ended");
        [target performSelector:videoStopFunc withObject:nil afterDelay:0.0001];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            borderView.transform=CGAffineTransformMakeScale(1, 1);
            
        }];
    }
    
}

@end
