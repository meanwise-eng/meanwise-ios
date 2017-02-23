//
//  PreviewViewComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 02/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PreviewViewComponent.h"

@implementation PreviewViewComponent


-(void)cleanUp;
{
    playerViewControl.player=nil;
    
    self.hidden=true;
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}
-(NSString *)getCurrentPath
{
    return filePathStr;
}

-(void)setUp:(NSString *)path andRect:(CGRect)rect
{
    filePathStr=path;
    isVideo=false;
    
    playerViewControl=nil;
    
    NSString *ext = [path pathExtension];

    
    fullRect=[UIScreen mainScreen].bounds;
    smallRect=rect;
    self.backgroundColor=[UIColor colorWithWhite:1.0f alpha:1.0f];
    

    fullPreviewRect=CGRectMake(0, 0,fullRect.size.width, fullRect.size.height);
    
    
    imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    
    if([ext.lowercaseString isEqualToString:@"png"])
    {
        UIImage *image=[UIImage imageWithContentsOfFile:path];

    imageView.image=image;
    }
    else{
        imageView.image=[self generateThumbImage:path];

        isVideo=true;
        
        playBtnImage=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
        [self addSubview:playBtnImage];
        playBtnImage.image=[UIImage imageNamed:@"playBtn.png"];
        playBtnImage.center=CGPointMake(smallRect.size.width/2, smallRect.size.height/2);

        
   

        
    }

   
    
    [self setUpGeneral];
    
}



-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

-(void)setUpGeneral
{
    self.hidden=false;
    
    shadowImageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:shadowImageView];
    shadowImageView.contentMode=UIViewContentModeScaleAspectFill;
    shadowImageView.image=[UIImage imageNamed:@"BlackShadow.png"];
//    shadowImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shadowImageView.alpha=0.2;
    shadowImageView.transform=CGAffineTransformMakeScale(1, -1);
    
    
    
    tapToFullBtn=[[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:tapToFullBtn];
    [tapToFullBtn addTarget:self action:@selector(openFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    fullModeBtnDone=[[UIButton alloc] initWithFrame:CGRectMake(20,35, 23*1.2, 16*1.2)];

    [fullModeBtnDone setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    
    fullModeBtnDone.center=CGPointMake(10+25/2-200, 20+65/2-10);

    [fullModeBtnDone addTarget:self
                        action:@selector(closeFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self addSubview:fullModeBtnDone];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(smallRect.size.width-2-30, 2, 30, 30)];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor redColor];
    closeBtn.clipsToBounds=YES;
    closeBtn.layer.cornerRadius=15;
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];

    
    self.clipsToBounds=YES;
}

-(void)closeFullMode:(id)sender
{
   if(isVideo==true)
   {
               [playerViewControl.player pause];
    playerViewControl.player=nil;
    [playerViewControl.view removeFromSuperview];
    playerViewControl=nil;
       
       [playBtn removeFromSuperview];
       playBtn=nil;
   }

    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        fullModeBtnDone.center=CGPointMake(10+25/2-200, 20+65/2-10);

        self.frame=smallRect;

        closeBtn.alpha=1;
        playBtnImage.center=CGPointMake(smallRect.size.width/2, smallRect.size.height/2);

        playBtnImage.alpha=1;
        
        imageView.frame=CGRectMake(0, 0, smallRect.size.width, smallRect.size.height);
        shadowImageView.frame=CGRectMake(0, 0, smallRect.size.width, smallRect.size.height);

        
        
    } completion:^(BOOL finished) {
        
        tapToFullBtn.hidden=false;
        closeBtn.hidden=false;
        [self.superview sendSubviewToBack:self];

        
    }];
}
-(void)openFullMode:(id)sender
{
    float duration=0.2;
    
    if(sender==nil)
    {
        duration=0;
    }
    
    [self.superview bringSubviewToFront: self];
    smallRect=self.frame;

    tapToFullBtn.hidden=true;
    closeBtn.alpha=0;

    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        fullModeBtnDone.center=CGPointMake(10+25/2, 20+65/2-10);

        closeBtn.alpha=0;
        playBtnImage.alpha=0;
        playBtnImage.center=CGPointMake(fullRect.size.width/2, fullRect.size.height/2);

        imageView.frame=fullPreviewRect;
        shadowImageView.frame=fullPreviewRect;
        
        self.frame=fullRect;

    } completion:^(BOOL finished) {
        
       if(isVideo==true)
       {
           playerViewControl =
           [[AVPlayerViewController alloc] init];
           playerViewControl.view.frame=fullPreviewRect;
           playerViewControl.player =
           [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePathStr]];
           [self addSubview:playerViewControl.view];
        //   [playerViewControl.player play];
           playerViewControl.showsPlaybackControls=true;
           playerViewControl.modalPresentationStyle = UIModalPresentationOverFullScreen;

           playerViewControl.showsPlaybackControls = false;
           playerViewControl.videoGravity=AVLayerVideoGravityResizeAspectFill;

           [self bringSubviewToFront:fullModeBtnDone];
           
           [playerViewControl.player play];

           playBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-50, 40, 40)];
           [self addSubview:playBtn];
           [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
           [playBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

           
       }
        closeBtn.hidden=true;

    }];
    
    
}
-(void)replayBtnClicked:(id)sender
{
    [playerViewControl.player.currentItem seekToTime:kCMTimeZero];
    [playerViewControl.player play];
    
}
-(void)QuickOpen
{
    [self.superview bringSubviewToFront: self];
    smallRect=self.frame;
    
    tapToFullBtn.hidden=true;
    fullModeBtnDone.center=CGPointMake(10+25/2, 20+65/2-10);
    
    closeBtn.alpha=0;
    playBtnImage.alpha=0;
    playBtnImage.center=CGPointMake(fullRect.size.width/2, fullRect.size.height/2);
    
    imageView.frame=fullPreviewRect;
    shadowImageView.frame=fullPreviewRect;
    
    self.frame=fullRect;


    if(isVideo==true)
    {
        playerViewControl =
        [[AVPlayerViewController alloc] init];
        playerViewControl.view.frame=fullPreviewRect;
        playerViewControl.player =
        [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePathStr]];
        [self addSubview:playerViewControl.view];
        //   [playerViewControl.player play];
        playerViewControl.showsPlaybackControls=true;
        playerViewControl.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        playerViewControl.showsPlaybackControls = true;
        playerViewControl.videoGravity=AVLayerVideoGravityResizeAspectFill;
        
        [self bringSubviewToFront:fullModeBtnDone];
        
        
    }
    closeBtn.hidden=true;

}


@end
