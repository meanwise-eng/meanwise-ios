//
//  CameraView.m
//  MeanWiseUX
//
//  Created by Mohamed Aas on 4/16/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "CameraView.h"
#import <malloc/malloc.h>
#import "PhotoAlbumCCell.h"
#import "FTIndicator.h"

@implementation CameraView

-(void)setUpBasics
{
    overlayBlack=[[UIView alloc] initWithFrame:self.bounds];
    overlayBlack.backgroundColor=[UIColor clearColor];
    [self addSubview:overlayBlack];
    
    
    
    masterView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:masterView];
    masterView.backgroundColor=[UIColor whiteColor];
    
    masterScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [masterView addSubview:masterScrollView];
    [masterScrollView setContentSize:CGSizeMake(self.frame.size.width*2, 0)];
    masterScrollView.pagingEnabled=true;
    masterScrollView.showsHorizontalScrollIndicator=false;
    masterScrollView.showsVerticalScrollIndicator=false;
    masterScrollView.delegate=self;
    
    
    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(15,20, 40, 40)];
    [masterView addSubview:cancelBtn];
    
    
    switchBtnCamera=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-55,25, 40, 40)];
    switchBtnCamera.hidden = YES;
    
    [masterView addSubview:switchBtnCamera];
    
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cameraCancelBtn.png"] forState:UIControlStateNormal];
    [switchBtnCamera setBackgroundImage:[UIImage imageNamed:@"cameraSwitchBtn.png"] forState:UIControlStateNormal];
    

    switchBtnCamera.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    cancelBtn.titleLabel.font=[UIFont fontWithName:k_fontSemiBold size:14];
    
    [switchBtnCamera addTarget:self action:@selector(switchBtnCameraClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    switchBtnCamera.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    cancelBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    
    titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLBL.font=[UIFont fontWithName:k_fontSemiBold size:15];
    [masterView addSubview:titleLBL];
    titleLBL.center=CGPointMake(self.frame.size.width/2, 20+25);
    titleLBL.textColor=[UIColor blackColor];
    titleLBL.textAlignment=NSTextAlignmentCenter;
    titleLBL.text=@"Photo Gallery";
    
    
    
    
}


-(void)setUp:(int)section
{
    self.backgroundColor=[UIColor clearColor];
    shortFrame=self.frame;
    
    [self setUpBasics];
    
    [self setUpCameraSection];
    
    [self setUpGallerySection];
    
    masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        masterView.frame=self.bounds;
        overlayBlack.backgroundColor=[UIColor blackColor];
    }];
    
    masterScrollView.contentOffset=CGPointMake(self.frame.size.width*section, 0);
    if(section==0)
    { [self updateTitle:@"Gallery"];}
    else
    {[self updateTitle:@"Capture"];}
    
    
    masterScrollView.contentOffset=CGPointMake(self.frame.size.width, 0);
    [self scrollViewDidScroll:masterScrollView];
    
    
    // [self loadPhotos];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==masterScrollView)
    {
        if(scrollView.contentOffset.x<50)
        {
            
            
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cameraCancelBtn.png"] forState:UIControlStateNormal];
            
            //[switchBtn setBackgroundImage:[UIImage imageNamed:@"cameraSwitchBtn.png"] forState:UIControlStateNormal];
            
            switchBtn.hidden = YES;
            switchBtnCamera.hidden = NO;
            
            [self updateTitle:@"Gallery"];
            
            
        }
        else
        {
            
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"photoCancelBtn.png"] forState:UIControlStateNormal];
            
            switchBtn.hidden = NO;
            switchBtnCamera.hidden = YES;
            //[switchBtn setBackgroundImage:[UIImage imageNamed:@"photoSwitchBtn.png"] forState:UIControlStateNormal];
            
            [self updateTitle:@""];
            
        }
    }
    
}

#pragma mark - Camera Control Helpers


-(void)startRecordSession
{
    if (captureView.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];

        captureView.session = session;
        
        [captureView startRunning];
    }
}

-(void)setUpCameraSection
{

    imageViewCameraBack=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [masterScrollView addSubview:imageViewCameraBack];
    imageViewCameraBack.clipsToBounds=YES;
    imageViewCameraBack.contentMode=UIViewContentModeScaleAspectFill;
    imageViewCameraBack.hidden=false;
    imageViewCameraBack.backgroundColor=[UIColor blackColor];
    
    previewView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, imageViewCameraBack.frame.size.width, imageViewCameraBack.frame.size.height)];
    previewView.alpha = 0;
    [masterScrollView addSubview:previewView];

    captureView=[SCRecorder recorder];
    
    captureView.captureSessionPreset = SCPresetMediumQuality;
    captureView.autoSetVideoOrientation = NO;
    captureView.delegate = self;
    captureView.flashMode = SCFlashModeOff;
    
    UIView *preview = previewView;
    captureView.previewView = preview;
    
    self.focusView = [[SCRecorderToolsView alloc] initWithFrame:preview.bounds];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = captureView;
    [preview addSubview:self.focusView];
    

    
    captureView.initializeSessionLazily = YES;
    
    
    float widthMargin=self.frame.size.width;
    
    cameraBtn=[[UICameraBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [masterScrollView addSubview:cameraBtn];
    [cameraBtn setTarget:self andPhotoCapture:@selector(capturePhoto:)];
    [cameraBtn setTarget:self andVideoStart:@selector(videoStart:) andVideoClose:@selector(videoEnd:)];
    [cameraBtn setUp];
    cameraBtn.center=CGPointMake(widthMargin+imageViewCameraBack.bounds.size.width/2,imageViewCameraBack.bounds.size.height-60);


    switchCamBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25.5, 23.5)];
    [switchCamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchCamBtn setBackgroundImage:[UIImage imageNamed:@"cameraFlip.png"] forState:UIControlStateNormal];
    [switchCamBtn setShowsTouchWhenHighlighted:YES];
    switchCamBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:13];
    switchCamBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    switchCamBtn.layer.cornerRadius=25;
    [switchCamBtn addTarget:self action:@selector(switchCamBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [masterScrollView addSubview:switchCamBtn];
    
    
    flashLightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26.5, 26.5)];
    [flashLightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOff.png"] forState:UIControlStateNormal];
    [flashLightBtn setShowsTouchWhenHighlighted:YES];
    flashLightBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:12];
    flashLightBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    flashLightBtn.layer.cornerRadius=25;
    [flashLightBtn addTarget:self action:@selector(flashLightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [masterScrollView addSubview:flashLightBtn];
    
    switchBtn=[[UIButton alloc] initWithFrame:CGRectMake((widthMargin-40)/2,self.frame.size.height - 150, 40, 40)];
    [switchBtn setBackgroundImage:[UIImage imageNamed:@"photoSwitchBtn.png"] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    switchBtn.center=CGPointMake(widthMargin+imageViewCameraBack.bounds.size.width/2,imageViewCameraBack.bounds.size.height-150);
    [masterScrollView addSubview:switchBtn];
    
    
    switchCamBtn.center= CGPointMake(widthMargin+imageViewCameraBack.bounds.size.width-75,imageViewCameraBack.bounds.size.height-60);
    flashLightBtn.center= CGPointMake(widthMargin+75,imageViewCameraBack.bounds.size.height-60);
    
    
    
}


-(void)capturePhoto:(id)sender
{
    
    [captureView capturePhoto:^(NSError *error, UIImage *image) {
        
        if (image != nil) {

            [self sendImage:image];
        }
        else{
            NSLog(@"PHOTO CAPTURE FAILED!");
        }
        
    }];

}

-(void)videoStart:(id)sender
{
    [videoPrevTimer invalidate];
   [self startRecordingVideo];
}

-(void)videoEnd:(id)sender
{
    
    [captureView pause:^{
        
        [FTProgressIndicator showProgressWithmessage:@"" userInteractionEnable:NO];

        
        videoPrevTimer = [NSTimer scheduledTimerWithTimeInterval:(0.5)
                                                     target:self
                                                   selector:@selector(saveAndShowSession:)
                                                   userInfo:captureView.session
                                                    repeats:NO];
        
    }];
    
}

- (void)saveAndShowSession:(NSTimer *)timer {

    _recordSession = [timer userInfo];
    [self sendVideo:_recordSession];
    
}


-(void)startRecordingVideo
{
    
        [captureView record];
    
}




-(void)switchCamBtnClicked:(id)sender
{
 
   [captureView pause];
   [captureView switchCaptureDevices];
   [captureView startRunning];
    
}

- (void)flashLightBtnClicked:(id)sender {

        switch (captureView.flashMode) {
            case SCFlashModeOff:
                [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOn.png"] forState:UIControlStateNormal];
                captureView.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOff.png"] forState:UIControlStateNormal];
                captureView.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }

}


#pragma mark - Flow
-(void)cancelBtnClicked:(id)sender
{
    
    [delegate performSelector:cancelFunc withObject:nil afterDelay:0.01];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        // control.frame=CGRectMake(0, 160+85+200, self.frame.size.width, 50);
        masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        overlayBlack.backgroundColor=[UIColor clearColor];
        control.alpha=0;
        
        
    } completion:^(BOOL finished) {
        
        
        [self removeFromSuperview];
        
    }];
    
}
-(void)switchBtnClicked:(id)sender
{
    int offset=0;
    if(masterScrollView.contentOffset.x<50)
    {
        offset=masterScrollView.frame.size.width;
    }
    
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        masterScrollView.contentOffset=CGPointMake(offset, 0);
        
        
    } completion:^(BOOL finished) {
        
        // [self removeFromSuperview];
        
    }];
    
}

-(void)switchBtnCameraClicked:(id)sender
{
    int offset=0;
    if(masterScrollView.contentOffset.x<50)
    {
        offset=masterScrollView.frame.size.width;
    }
    
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        masterScrollView.contentOffset=CGPointMake(offset, 0);
        
        
    } completion:^(BOOL finished) {
        
        // [self removeFromSuperview];
        
    }];
    
}

-(void)photoBtnClicked:(id)sender
{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        masterScrollView.contentOffset=CGPointMake(0, 0);
        
        
    } completion:^(BOOL finished) {
        [self updateTitle:@"Photos"];
    }];
    
    
}
-(void)videoBtnClicked:(id)sender
{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        masterScrollView.contentOffset=CGPointMake(self.frame.size.width, 0);
        
        
    } completion:^(BOOL finished) {
        [self updateTitle:@"Capture"];
    }];

    
}

-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2 andSel3:(SEL)func3
{
    delegate=target;
    cancelFunc=func1;
    imageSelectedFunc=func2;
    videoSelectedFunc=func3;
    
}

-(void)sendVideo:(SCRecordSession *)session
{
    [delegate performSelector:videoSelectedFunc withObject:session afterDelay:0.01];
    
    [FTProgressIndicator dismiss];
    [videoPrevTimer invalidate];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        overlayBlack.backgroundColor=[UIColor clearColor];
        control.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}


-(void)sendImage:(UIImage *)image
{
    [delegate performSelector:imageSelectedFunc withObject:image afterDelay:0.01];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        masterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        overlayBlack.backgroundColor=[UIColor clearColor];
        control.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}



#pragma mark - CollectionView Detail

-(void)setUpGallerySection
{
    
    
    
    CGRect collectionViewFrame = CGRectMake(0,65, self.frame.size.width, self.frame.size.height-65);
    
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    
    photoGallery = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    photoGallery.delegate = self;
    photoGallery.dataSource = self;
    photoGallery.backgroundColor=[UIColor clearColor];
    [photoGallery registerClass:[PhotoAlbumCCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [masterScrollView addSubview:photoGallery];
    photoGallery.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    
    arrayData=[self getListOfPhotos:PHAssetMediaTypeImage];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
            [self startRecordSession];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [photoGallery reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                previewView.alpha = 1;
            }];
            
        });
        
        
    });
    

    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset=[arrayData objectAtIndex:indexPath.row];
    
    PHImageManager *manager = [PHImageManager defaultManager];
    //  NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
    
    
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // this one is key
    requestOptions.synchronous = false;
    
    if(asset.mediaType==PHAssetMediaTypeVideo)
    {
        [manager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
            
            
            NSURL *url = (NSURL *)[[(AVURLAsset *)avAsset URL] fileReferenceURL];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *path=[Constant FM_saveVideoAtDocumentDirectory:url];
                [self fixTheOrientationOfVideo:[NSURL fileURLWithPath:path]];

                
            });
            
            
        }];
    }
    else if (asset.mediaType==PHAssetMediaTypeImage)
    {
        
        
        
        [manager requestImageForAsset:asset
                           targetSize:CGSizeMake(400, 800)
                          contentMode:PHImageContentModeAspectFill
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{

                                [self sendImage:image];
                                
                            });
                            
                        }];
    }
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoAlbumCCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.photoView.image=nil;
    [cell setAsset:[arrayData objectAtIndex:indexPath.row]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int numberOfPhotos=(int)arrayData.count;

    return numberOfPhotos;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((self.frame.size.width-5)/4, (self.frame.size.width-5)/4);

}

-(void)fixTheOrientationOfVideo:(NSURL *)outputFileUrl
{
    
    
    if(outputFileUrl!=nil)
    {
        SCRecordSessionSegment *segment = [SCRecordSessionSegment segmentWithURL:outputFileUrl info:nil];
        
        [captureView.session addSegment:segment];
        _recordSession = [SCRecordSession recordSession];
        [_recordSession addSegment:segment];
        
        [self sendVideo:_recordSession];
        
        return;
    }
    
    NSURL *newVideoURL;
    NSError *error = nil;
    AVURLAsset *videoAssetURL = [[AVURLAsset alloc] initWithURL:outputFileUrl options:nil];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    
    
    
    AVAssetTrack *videoTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
    
    //    CGAffineTransform transformToApply = videoTrack.preferredTransform;
    //  [layerInstruction setTransform:transformToApply atTime:kCMTimeZero];
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    [layerInstruction setOpacity:0.0 atTime:videoAssetURL.duration];
    
    //max fix orientation
    
    CGSize mainSize=videoTrack.naturalSize;
    if(mainSize.width>mainSize.height)
    {
        mainSize=CGSizeMake(mainSize.height, mainSize.width);
    }
    //
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    
    BOOL  isFirstAssetPortrait_  = NO;
    
    CGAffineTransform firstTransform = videoTrack.preferredTransform;
    
    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
    {
        FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
    }
    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
    {
        FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
    }
    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
    {
        FirstAssetOrientation_ =  UIImageOrientationUp;
    }
    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
    {
        FirstAssetOrientation_ = UIImageOrientationDown;
    }
    
    
    CGFloat FirstAssetScaleToFitRatio = mainSize.width/videoTrack.naturalSize.width;
    
    if(isFirstAssetPortrait_)
    {
        FirstAssetScaleToFitRatio = mainSize.width/videoTrack.naturalSize.height;
        
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        
        [layerInstruction setTransform:CGAffineTransformConcat(videoTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }
    else
    {
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        
        [layerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(videoTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, mainSize.width/2)) atTime:kCMTimeZero];
    }
    
    //max
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake( kCMTimeZero, videoAssetURL.duration);
    instruction.layerInstructions = @[layerInstruction];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[instruction];
    videoComposition.frameDuration = CMTimeMake(1, 30); //select the frames per second
    videoComposition.renderScale = 1.0;
    
    
    
    videoComposition.renderSize = mainSize; //select you video size
    
    // [Constant okAlert:@"alert" withSubTitle:[NSString stringWithFormat:@"%@",NSStringFromCGSize(videoTrack.naturalSize)] onView:self andStatus:1];
    
    
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetPassthrough];
    
    
    NSURL *outputURL1 = [[[Constant applicationDocumentsDirectory]
                          URLByAppendingPathComponent:@"test4"] URLByAppendingPathExtension:@"mov"];
    
    
    [[NSFileManager defaultManager] removeItemAtURL:outputURL1 error:nil];
    
    
    exportSession.outputURL =outputURL1;
    
    newVideoURL=exportSession.outputURL;
    
    exportSession.outputFileType = AVFileTypeMPEG4; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = NO;
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration);
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.blurBackground = YES;
    
    [alert showAlertInView:self
                 withTitle:@"Processing.."
              withSubtitle:nil
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:nil];
    [alert makeAlertTypeProgress];
    
    alert.hideAllButtons = YES;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissAlertView];
            
            
            switch ([exportSession status])
            {
                    
                    
                case AVAssetExportSessionStatusCompleted: {
                    
                    
                    SCRecordSessionSegment *segment = [SCRecordSessionSegment segmentWithURL:newVideoURL info:nil];
                    
                    [captureView.session addSegment:segment];
                    _recordSession = [SCRecordSession recordSession];
                    [_recordSession addSegment:segment];
                    
                    [self sendVideo:_recordSession];
                    
                    break;
                }
                default: {
                    break;
                }
            }
        });
        
    }];
}


-(NSArray *)getListOfPhotos:(PHAssetMediaType)mediaType
{
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    
    
    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    
    NSSortDescriptor *sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO];
    
    allPhotosOptions.sortDescriptors = @[sortDesc1, sortDesc2];
    
    //    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    // allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",mediaType];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"!((mediaSubtype & %d) == %d) AND !((mediaSubtype & %d) == %d)", PHAssetMediaSubtypeVideoHighFrameRate,PHAssetMediaSubtypeVideoHighFrameRate,PHAssetMediaSubtypeVideoTimelapse,PHAssetMediaSubtypeVideoTimelapse];
    
    
    //  PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:mediaType options:allPhotosOptions];
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    NSMutableArray *assets=[[NSMutableArray alloc] init];
    
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        
        [assets addObject:asset];
        NSLog(@"asset %@", asset);
        
        
    }];
    
    return assets;
    
    
}

#pragma mark - Helper

-(UIInterfaceOrientation)getTheOrientation:(AVAssetTrack *)videoTrack
{
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
    
    
}

-(void)updateTitle:(NSString *)title
{
    titleLBL.text=title;
}

-(void)getThumb:(NSString *)path
{
    UIImage *image=[self generateThumbImage:path];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
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

@end


#pragma mark -  PhotosBtnController

@implementation PhotosBtnControl
-(void)setUp
{
    photoBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [self addSubview:photoBtn];
    
    [photoBtn addTarget:self action:@selector(photoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView *imgView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [photoBtn addSubview:imgView1];
    
    imgView1.center=CGPointMake(self.frame.size.width/2,25);
    
    
    imgView1.contentMode=UIViewContentModeScaleAspectFit;
    
    imgView1.image=[UIImage imageNamed:@"TakePicIcon.png"];
    
    
}
-(void)setTarget:(id)target andSel1:(SEL)func1 andSel2:(SEL)func2
{
    delegate=target;
    photoSelection=func1;
    
    
}
-(void)photoBtnClicked:(id)sender
{
    [delegate performSelector:photoSelection withObject:nil afterDelay:0.01];
}


@end

