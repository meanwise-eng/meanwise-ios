//
//  NewPostVideoPreview.m
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "NewPostVideoPreview.h"
#import "FTIndicator.h"


@implementation NewPostVideoPreview

-(void)setSession:(SCRecordSession*)session andRect:(CGRect)rect
{
    
    initialRect=rect;
    
    
    fullRect=[UIScreen mainScreen].bounds;
    smallRect=rect;
    self.backgroundColor=[UIColor blackColor];
    
    fullPreviewRect=CGRectMake(0, 0,fullRect.size.width, fullRect.size.height);
    
    
    recordSession = session;
    
    self.player = [SCPlayer player];
    
    [self setUpGeneral];
    
}

-(void)setUpGeneral
{
    self.hidden=false;
    
    mainView = [[UIView alloc]initWithFrame:fullRect];
    [self addSubview:mainView];
    
    shadowImageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:shadowImageView];
    shadowImageView.contentMode=UIViewContentModeScaleAspectFill;
    shadowImageView.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadowImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shadowImageView.alpha=0.1f;
    shadowImageView.transform=CGAffineTransformMakeScale(1, -1);
    
    
    filterSwitcherView = [[SCSwipeableFilterView alloc]initWithFrame:fullRect];
    [filterSwitcherView setContentMode:UIViewContentModeScaleAspectFill];
    filterSwitcherView.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:filterSwitcherView];
    
    overlay = [[NewPostVideoOverlay alloc]initWithFrame:filterSwitcherView.frame];
    [filterSwitcherView addSubview:overlay];

    
    if ([[NSProcessInfo processInfo] activeProcessorCount] > 1) {
       
        filterSwitcherView.filters = @[
                                       [SCFilter emptyFilter],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"bw" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"mono" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"false" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"tonal" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"sharp" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"sepia" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"comic" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"xray" withExtension:@"cisf"]],
                                       [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"thermal" withExtension:@"cisf"]]
                                       ];

        self.player.SCImageView = filterSwitcherView;
        
    }
    else
    {
        SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:self.player];
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerView.frame = filterSwitcherView.frame;
        playerView.autoresizingMask = filterSwitcherView.autoresizingMask;
        [filterSwitcherView.superview insertSubview:playerView aboveSubview:filterSwitcherView];
        [filterSwitcherView removeFromSuperview];
    }
    
    
    [self.player setItemByAsset:recordSession.assetRepresentingSegments];
    [self.player play];
    
    self.player.loopEnabled = YES;
    
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
    [downloadBtn addTarget:self action:@selector(downloadVideoToDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-65, fullPreviewRect.size.height-50-40/2, 45, 45)];
    [self addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"nextView.png"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(closeFullMode:) forControlEvents:UIControlEventTouchUpInside];
    
    downloadBtn.alpha=0;
    nextBtn.alpha=0;
    
    editBtn1=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35, 32.5, 18)];
    //[self addSubview:editBtn1];
    
    editBtn2=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35+18+20, 32.5,32.5)];
    //[self addSubview:editBtn2];
    
    editBtn3=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-20.5-23, 35+18+20, 20.5,32.5)];
    //[self addSubview:editBtn3];
    
    editBtn4=[[UIButton alloc] initWithFrame:CGRectMake(fullPreviewRect.size.width-32.5-15, 35+18+32.5+32.5+60, 32.5,18.5)];
   // [self addSubview:editBtn4];
    
    [editBtn1 setBackgroundImage:[UIImage imageNamed:@"addText.png"] forState:UIControlStateNormal];
    [editBtn2 setBackgroundImage:[UIImage imageNamed:@"crop.png"] forState:UIControlStateNormal];
    [editBtn3 setBackgroundImage:[UIImage imageNamed:@"addLocation.png"] forState:UIControlStateNormal];
    [editBtn4 setBackgroundImage:[UIImage imageNamed:@"addAnimatedText.png"] forState:UIControlStateNormal];
    
    editBtn1.alpha=0;
    editBtn2.alpha=0;
    editBtn3.alpha=0;
    editBtn4.alpha=0;
    
    
    [editBtn1 addTarget:self action:@selector(editBtnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn3 addTarget:self action:@selector(editBtnClicked2:) forControlEvents:UIControlEventTouchUpInside];
    //[editBtn3 addTarget:self action:@selector(editBtnClicked3:) forControlEvents:UIControlEventTouchUpInside];
    
    playBtnImage=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [self addSubview:playBtnImage];
    playBtnImage.image=[UIImage imageNamed:@"playBtn.png"];
    playBtnImage.center=CGPointMake(smallRect.size.width/2, smallRect.size.height/2);
    
    self.clipsToBounds=YES;
}


- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //float progress = assetExportSession.progress;

    });
}


-(NSData*)getVideoData
{

    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePathStr]];
    NSLog(@"RETURNING File size is : %.2f MB",(float)videoData.length/1024.0f/1024.0f);
    
    return videoData;
}

-(void)saveVideoData
{

    SCFilter *currentFilter = [filterSwitcherView.selectedFilter copy];
    [self.player pause];
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:recordSession.assetRepresentingSegments];
    exportSession.videoConfiguration.filter = currentFilter;
    exportSession.videoConfiguration.preset = SCPresetMediumQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = recordSession.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    exportSession.contextType = SCContextTypeAuto;
    _exportSession = exportSession;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [exportSession exportAsynchronouslyWithCompletionHandler:^{

                NSData *videoData = [NSData dataWithContentsOfURL:exportSession.outputUrl];
                
                NSLog(@"File size is : %.2f MB",(float)videoData.length/1024.0f/1024.0f);
                
                filePathStr = [exportSession.outputUrl absoluteString];

        }];
        
    });

}

-(NSString *)applicationDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    return documentsPath;
}

-(NSString *)FM_saveVideoAtDocumentDirectory:(NSData *)video
{
    
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"output.mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [video writeToFile:path atomically:NO];
    }
    else{
        [[NSFileManager defaultManager] createFileAtPath:path
                                                contents:video
                                              attributes:nil];
    }
    
   // NSString *savedVideoPath = [[self applicationDocumentsDirectoryPath] stringByAppendingPathComponent:@"output.mp4"];
    
   // [video writeToFile:savedVideoPath atomically:NO];
    
    return path;
    
}

-(void)editBtnClicked1:(id)sender
{
    
}

-(void)editBtnClicked2:(id)sender
{
 
        if(locationSticker==nil)
        {
            locationSticker=[[LocationFilterView alloc] initWithFrame:overlay.frame];
            [overlay addSubview:locationSticker];
            [locationSticker setTarget:self onLocationFail:@selector(locationFailed:)];
            [locationSticker setUp];
        }
        else
        {
            [self locationFailed:@""];
        }
}


-(void)locationFailed:(NSString *)message
{
    
    [locationSticker removeFromSuperview];
    locationSticker=nil;
    
    
    if(![message isEqualToString:@""])
    {
        [Constant okAlert:@"Location is disabled." withSubTitle:message onView:self andStatus:1];
        
    }
    
}


-(void)downloadVideoToDevice:(id)sender
{
    SCFilter *currentFilter = [filterSwitcherView.selectedFilter copy];
    [self.player pause];
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:recordSession.assetRepresentingSegments];
    exportSession.videoConfiguration.filter = currentFilter;
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = recordSession.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    exportSession.contextType = SCContextTypeAuto;
    _exportSession = exportSession;

    exportSession.videoConfiguration.overlay = overlay;
    NSLog(@"Starting exporting");
    
    CFTimeInterval time = CACurrentMediaTime();
    __weak typeof(self) wSelf = self;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        __strong typeof(self) strongSelf = wSelf;
        
        if (!exportSession.cancelled) {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        if (strongSelf != nil) {
            [strongSelf.player play];
            strongSelf.exportSession = nil;
        }
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            NSLog(@"Export was cancelled");
        } else if (error == nil) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (error == nil) {
                    [FTIndicator showSuccessWithMessage:@"Saved to gallery"];
                } else {
                    [FTIndicator showErrorWithMessage:@"Failed to save"];
                }
            }];
        } else {
            if (!exportSession.cancelled) {
               [FTIndicator showErrorWithMessage:@"Failed to save"];
            }
        }
    }];
}

-(void)closeFullMode:(id)sender
{
    
    [playBtn removeFromSuperview];
    playBtn=nil;
    
    [self.player pause];
    
    [self saveVideoData];
    
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        fullModeBtnDone.center=CGPointMake(10+25/2-200, 20+65/2-10);
        
        self.frame=smallRect;
        
        closeBtn.alpha=1;
        
        playBtnImage.center=CGPointMake(smallRect.size.width/2, smallRect.size.height/2);
        
        playBtnImage.alpha=1;
        
        
        [mainView setFrame:CGRectMake(0, 0, smallRect.size.width, smallRect.size.height)];
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
    playBtnImage.alpha=0;
    playBtnImage.center=CGPointMake(fullRect.size.width/2, fullRect.size.height/2);
    
    [self.player play];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        fullModeBtnDone.center=CGPointMake(10+25/2, 20+65/2-10);
        
        closeBtn.alpha=0;
        
        [mainView setFrame:fullRect];
        shadowImageView.frame=fullPreviewRect;
        
        editBtn1.alpha=1;
        editBtn2.alpha=1;
        editBtn3.alpha=1;
        editBtn4.alpha=1;
        nextBtn.alpha=1;
        downloadBtn.alpha=1;
        
        self.frame=fullRect;
        
    } completion:^(BOOL finished) {
        playBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-50, 40, 40)];
        [self addSubview:playBtn];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        playBtn.hidden=true;
        
        closeBtn.hidden=true;
        [target performSelector:showFullScreenFunc withObject:nil afterDelay:0.001];
        
    }];
    
    
}

-(void)replayBtnClicked:(id)sender
{
    [self.player.currentItem seekToTime:kCMTimeZero];
    [self.player play];
    
}

-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2
{
    
    target=delegate;
    showFullScreenFunc=func1;
    showThumbScreenFunc=func2;
    
}

-(void)cleanUp
{
    self.hidden=true;
  
    filterSwitcherView = nil;
    [self.player pause];
    self.player = nil;
    self.exportSession = nil;

    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)QuickOpen
{

  
}

@end
