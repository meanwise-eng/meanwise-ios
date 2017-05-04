//
//  PreviewViewComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 02/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PreviewViewComponent.h"
#import "PreviewMedia_ImageController.h"
#import "PreviewMedia_VideoController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation PreviewViewComponent

-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2
{
 
    target=delegate;
    showFullScreenFunc=func1;
    showThumbScreenFunc=func2;
}
-(void)cleanUp;
{
    playerViewControl.player=nil;
    //imageView.image = nil;
    
    self.hidden=true;
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //[self removeFromSuperview];
    
}

-(NSString *)getCurrentPath
{
    return filePathStr;
}

-(void)setUp:(NSString *)path andRect:(CGRect)rect
{
    initialRect=rect;
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
    
    keyImageView=[[UIFilterImageView alloc] initWithFrame:self.bounds];
    [self addSubview:keyImageView];
    keyImageView.clipsToBounds=YES;
    keyImageView.userInteractionEnabled=false;
    keyImageView.hidden = true;
    
    if([ext.lowercaseString isEqualToString:@"png"])
    {
        //UIImage *image=[UIImage imageWithContentsOfFile:path];
        //imageView.image=image;
        
        imageView.hidden = true;
        
        [keyImageView setUpWithImage:path];
        keyImageView.hidden = false;
        
    }
    else{
        imageView.image=[self generateThumbImage:path];
        
        isVideo=true;
        
        playBtnImage=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
        [self addSubview:playBtnImage];
        playBtnImage.image=[UIImage imageNamed:@"playBtn.png"];
        playBtnImage.center=CGPointMake(smallRect.size.width/2, smallRect.size.height/2);
    }
    
    
    isPlayerPaused=false;
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(autoplayContinue:)
                                               object:nil];
    
    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];
    
    
    [self setUpGeneral];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(touches.count==1)
    {
        UITouch *touch=[touches anyObject];
        CGPoint location=[touch locationInView:self];
        
        if(touch.tapCount==2)
        {
           // [self setState:2];
            [keyImageView generateNewEffectPoint:location];
        }
        
        
    }
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
    shadowImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shadowImageView.alpha=0.1f;
    shadowImageView.transform=CGAffineTransformMakeScale(1, -1);
    
    
    
    tapToFullBtn=[[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:tapToFullBtn];
    [tapToFullBtn addTarget:self action:@selector(openFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    fullModeBtnDone=[[UIButton alloc] initWithFrame:CGRectMake(20,20, 40, 40)];
    fullModeBtnDone.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    [fullModeBtnDone setBackgroundImage:[UIImage imageNamed:@"photoCancelBtn.png"] forState:UIControlStateNormal];
    
    [fullModeBtnDone addTarget:self
                        action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self addSubview:fullModeBtnDone];
    
    closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(smallRect.size.width-10-35, 10, 35, 35)];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"removePic.png"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, fullPreviewRect.size.height-50-40/2, 28, 48.5)];
    [self addSubview:downloadBtn];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"saveImage.png"] forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadTheMedia:) forControlEvents:UIControlEventTouchUpInside];
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-65, fullPreviewRect.size.height-50-40/2, 45, 45)];
    [self addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextView.png"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(closeFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn.alpha=0;
    nextBtn.alpha=0;
    
    editBtn1=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35, 32.5, 18)];
    [self addSubview:editBtn1];
    
    editBtn2=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35+18+20, 32.5,32.5)];
    [self addSubview:editBtn2];
    
    editBtn3=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-20.5-23, 35+18+32.5+40, 20.5,32.5)];
    [self addSubview:editBtn3];
    
    editBtn4=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35+18+32.5+32.5+60, 32.5,18.5)];
    [self addSubview:editBtn4];
    
    [editBtn1 setBackgroundImage:[UIImage imageNamed:@"addText.png"] forState:UIControlStateNormal];
    [editBtn2 setBackgroundImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
    [editBtn3 setBackgroundImage:[UIImage imageNamed:@"addLocation.png"] forState:UIControlStateNormal];
    [editBtn4 setBackgroundImage:[UIImage imageNamed:@"addAnimatedText.png"] forState:UIControlStateNormal];

    
    if(isVideo==false)
    {
        editBtn4.hidden=true;
    }
    else
    {
        editBtn4.hidden=false;
    }
    
    
    editBtn1.alpha=0;
    editBtn2.alpha=0;
    editBtn3.alpha=0;
    editBtn4.alpha=0;
    
    
    [editBtn1 addTarget:self action:@selector(editBtnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    //[editBtn2 addTarget:self action:@selector(editBtnClicked2:) forControlEvents:UIControlEventTouchUpInside];

    [editBtn4 addTarget:self action:@selector(editBtnClicked4:) forControlEvents:UIControlEventTouchUpInside];

    self.clipsToBounds=YES;
}
    

    
-(void)downloadTheMedia:(id)sender
{
    if(isVideo==false)
    {
        
        // UISaveVideoAtPathToSavedPhotosAlbum(filePathStr, nil, NULL, NULL);
        
        UIImageWriteToSavedPhotosAlbum(imageView.image,
                                       self, // send the message to 'self' when calling the callback
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                       NULL); // you generally won't need a contextInfo here

    }
    
    else
    {
        
        UISaveVideoAtPathToSavedPhotosAlbum(filePathStr,
                                       self, // send the message to 'self' when calling the callback
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                       NULL); // you generally won't need a contextInfo here

        
    }
    
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        
        [FTIndicator showErrorWithMessage:@"Failed to Save"];
        
    } else {
        
        [FTIndicator showSuccessWithMessage:@"Saved to Gallery"];
    }
}
-(void)editBtnClicked1:(id)sender
{
  
        PreviewMedia_ImageController *sc=[[PreviewMedia_ImageController alloc] initWithFrame:self.bounds];
        [self addSubview:sc];
        [sc setUpWithString:filePathStr];
        [sc setTarget:self OnSuccess:@selector(addedOverLay:) OnFail:@selector(cancelOverLay:)];
   
    if(isVideo==true)
    {
        [playerViewControl.player pause];
        isPlayerPaused=true;
    }

}
    
-(void)editBtnClicked4:(id)sender
{
   
        PreviewMedia_VideoController *sc=[[PreviewMedia_VideoController alloc] initWithFrame:self.bounds];
        [self addSubview:sc];
        [sc setUpWithString:filePathStr];
        [sc setTarget:self OnSuccess:@selector(addedOverLay:) OnFail:@selector(cancelOverLay:)];
        [playerViewControl.player pause];
        isPlayerPaused=true;
    
}

-(void)addedOverLay:(NSString *)string
{
    
    if(isVideo==false)
    {
        
        //
        //        NSArray *viewsToRemove = [self subviews];
        //        for (UIView *v in viewsToRemove) {
        //            [v removeFromSuperview];
        //        }
        //
        //        tapToFullBtn=nil;
        //        imageView=nil;
        //        shadowImageView=nil;
        //        closeBtn=nil;
        //        fullModeBtnDone=nil;
        //        playBtn=nil;
        //        playBtnImage=nil;
        //        playerViewControl=nil;
        //        editBtn=nil;
        //
        
        self.frame=initialRect;
        [self cleanUp];
        [self setUp:string andRect:initialRect];
        [self openFullMode:nil];
        
        
        //        [self removeFromSuperview];
    }
    else
    {
        if([string isEqualToString:filePathStr])
        {
            [playerViewControl.player.currentItem seekToTime:kCMTimeZero];
            [playerViewControl.player play];
            isPlayerPaused=false;
        }
        else
        {
            self.frame=initialRect;
            [self cleanUp];
            [self setUp:string andRect:initialRect];
            [self openFullMode:nil];
        }
    }
    
}
-(void)cancelOverLay:(id)sender
{
    if(isVideo==false)
    {
        
    }
    else
    {
        [playerViewControl.player.currentItem seekToTime:kCMTimeZero];
        [playerViewControl.player play];
        isPlayerPaused=false;
        
    }
    
}

-(void)closeFullMode:(id)sender
{
    if(isVideo==true)
    {
        isPlayerPaused=true;
        
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
        keyImageView.frame=CGRectMake(0, 0, smallRect.size.width, smallRect.size.height);
        shadowImageView.frame=CGRectMake(0, 0, smallRect.size.width, smallRect.size.height);
        
        editBtn1.alpha=0;
        editBtn2.alpha=0;
        editBtn3.alpha=0;
        editBtn4.alpha=0;
        
        downloadBtn.alpha=0;
        nextBtn.alpha=0;
        
        
        
    } completion:^(BOOL finished) {
        
        tapToFullBtn.hidden=false;
        closeBtn.hidden=false;
        [self.superview sendSubviewToBack:self];
        
        [target performSelector:showThumbScreenFunc withObject:nil afterDelay:0.001];
        
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
        keyImageView.frame=fullPreviewRect;
        shadowImageView.frame=fullPreviewRect;
        editBtn1.alpha=1;
        editBtn2.alpha=1;
        editBtn3.alpha=1;
        editBtn4.alpha=1;
        nextBtn.alpha=1;
        downloadBtn.alpha=1;
        
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
           // playerViewControl.modalPresentationStyle = UIModalPresentationOverFullScreen;
            
            [self bringSubviewToFront:fullModeBtnDone];

            playerViewControl.showsPlaybackControls = false;
            playerViewControl.videoGravity=AVLayerVideoGravityResize;
            playerViewControl.view.bounds=CGRectMake(0, 0, fullPreviewRect.size.width, fullPreviewRect.size.height);



            
            [playerViewControl.player play];
            
            playBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-50, 40, 40)];
            [self addSubview:playBtn];
            [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
            [playBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            playBtn.hidden=true;
            
            [self bringSubviewToFront:editBtn1];
            [self bringSubviewToFront:editBtn2];
            [self bringSubviewToFront:editBtn3];
            [self bringSubviewToFront:editBtn4];

            [self bringSubviewToFront:downloadBtn];
            
            isPlayerPaused=false;
            
        }
        closeBtn.hidden=true;
        
                [target performSelector:showFullScreenFunc withObject:nil afterDelay:0.001];
    }];
    
    
}
-(void)autoplayContinue:(id)sender
{
    if(playerViewControl.player!=nil)
    {
        if(isPlayerPaused==false)
        {
            AVPlayerItem *currentItem = playerViewControl.player.currentItem;
            
            NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
            
            NSTimeInterval duration = CMTimeGetSeconds(currentItem.duration);
            
            if(currentTime>=duration)
            {
                [playerViewControl.player seekToTime:kCMTimeZero];
                
            }
            
            [playerViewControl.player play];
        }
        else
        {
            [playerViewControl.player pause];
            
            
        }
    }
    
    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];
    
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
    keyImageView.frame=fullPreviewRect;
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
