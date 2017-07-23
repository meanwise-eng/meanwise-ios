//
//  PreviewMaxScreen.m
//  VideoPlayerDemo
//
//  Created by Hardik on 09/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PreviewMaxScreen.h"
#import "FTIndicator.h"
#import "Constant.h"
#import "SDAVAssetExportSession.h"
#import "GUIScaleManager.h"


@implementation PreviewMaxScreen
-(void)cleanUp
{
    self.frame=smallRect;
    
    [sticker cleanUp];
    [loopPlayer killPlayer];
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.hidden=true;
    
    
    
}
-(void)seUpBasics:(CGRect)smallScreenRect
{
    
    self.hidden=false;
    
    fullRect=RX_mainScreenBounds;
    smallRect=smallScreenRect;
    
    isOpenFullMode=false;
    
    [self setUpMediaSection];
    [self setUpPreviewSection];
    
}
-(void)setUpMediaSection
{
    
    mediaView=[[UIView alloc] initWithFrame:fullRect];
    [self addSubview:mediaView];
    mediaImageView=[[HCFilterImageView alloc] initWithFrame:fullRect];
    [mediaView addSubview:mediaImageView];
    [mediaImageView setUp];
    [mediaImageView cleanUp];
    
    
    
    loopPlayer=[[HCFilterVideoView alloc] initWithFrame:fullRect];
    [self addSubview:loopPlayer];
    [loopPlayer setUp];
    
   
    
}
-(void)setUpPath:(NSString *)path
{
    audioOption=1;
    actualMediaPath=path;
    
    NSString *ext = [path pathExtension];
    
    if([ext.lowercaseString isEqualToString:@"png"] || [ext.lowercaseString isEqualToString:@"jpg"])
    {
        
        
        mediaType=0;
        loopPlayer.hidden=true;
        [mediaImageView setUpPath:path];
        
        filterBtn.hidden=true;
        soundToggleBtn.hidden=true;
    }
    else
    {
        
        mediaType=1;
        mediaImageView.hidden=true;
        
        [loopPlayer cleanUpAndsetPath:path];
        filterBtn.hidden=true;
        soundToggleBtn.hidden=false;

    }
    
    
}
-(void)setUpPreviewSection
{
    
    
    fullScreenBtn=[[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:fullScreenBtn];
    [fullScreenBtn addTarget:self action:@selector(openFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    fullScreenBtn.hidden=true;
    fullScreenBtn.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    //MX_removePic.png
    //MX_cCloseBtn.png
    mediaCancelThisMediaBtn=[self getButton:@"MX_cCloseBtn.png" andCallBack:@selector(cancelThisMedia:)];
    [self addSubview:mediaCancelThisMediaBtn];
    mediaCancelThisMediaBtn.center=CGPointMake(25, 25+15);
    
    mediaNextBtn=[self getButton:@"MX_nextView.png" andCallBack:@selector(collapseScreen:)];
    [self addSubview:mediaNextBtn];
    mediaNextBtn.center=CGPointMake(fullRect.size.width-25-10, fullRect.size.height-25-10);
    
    
    mediaDownloadBtn=[self getButton:@"MX_saveImage.png" andCallBack:@selector(saveToGallery:)];
    [self addSubview:mediaDownloadBtn];
    mediaDownloadBtn.center=CGPointMake(25+10, fullRect.size.height-25-10);
    
    
    textFilterPhaseBtn=[self getButton:@"MX_addText.png" andCallBack:@selector(textFilterPhaseBtnClicked:)];
    [self addSubview:textFilterPhaseBtn];
    textFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10, 25+15);
    


    
    
    trashIcon=[self getButton:@"MX_TrashIcon.png" andCallBack:nil];
    [self addSubview:trashIcon];
    trashIcon.center=CGPointMake(fullRect.size.width/2, fullRect.size.height-40);
    trashIcon.showsTouchWhenHighlighted=false;
    
    
    locationFilterPhaseBtn=[self getButton:@"MX_addLocation.png" andCallBack:@selector(locationFilterPhaseBtnClicked:)];
    [self addSubview:locationFilterPhaseBtn];
    locationFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10,100+15);
    
    isFilterModeOn=false;
    
    filterBtn=[self getButton:@"MX_addLocation.png" andCallBack:@selector(filterBtnClicked:)];
    [self addSubview:filterBtn];
    filterBtn.center=CGPointMake(fullRect.size.width-25-10,100+150);
    
    soundToggleBtn=[self getButton:@"MX_Volume_unMute.png" andCallBack:@selector(soundToggleBtnClicked:)];
    [self addSubview:soundToggleBtn];
    soundToggleBtn.center=CGPointMake(fullRect.size.width/2,25+15);
    
    UITapGestureRecognizer *gestureTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self addGestureRecognizer:gestureTap];
    
    
    overLayStickerKeyboardBar=[[OverlaySettingsPanel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    [self addSubview:overLayStickerKeyboardBar];
    overLayStickerKeyboardBar.hidden=true;
    [overLayStickerKeyboardBar setUp];
    [overLayStickerKeyboardBar setTarget:self onPropertyChange:@selector(overLayStickerPropertyChange:)];
    
    
    
    
    
    MX_locationStickerObj=nil;
    sticker=nil;
    
    
}
-(void)soundToggleBtnClicked:(id)sender
{
    if(audioOption==0)
    {
        audioOption=1;

        [soundToggleBtn setBackgroundImage:[UIImage imageNamed:@"MX_Volume_unMute.png"] forState:UIControlStateNormal];


        [loopPlayer setSoundSettings:false];

    }
    else
    {

        [soundToggleBtn setBackgroundImage:[UIImage imageNamed:@"MX_Volume_mute.png"] forState:UIControlStateNormal];


        audioOption=0;

        [loopPlayer setSoundSettings:true];

     
    }
}
-(void)filterBtnClicked:(id)sender
{

    if(isFilterModeOn==false)
    {
        filterBtn.center=CGPointMake(fullRect.size.width-25-10, 25+15);
        isFilterModeOn=true;
        mediaCancelThisMediaBtn.hidden=true;
        mediaNextBtn.hidden=true;
        mediaDownloadBtn.hidden=true;
        locationFilterPhaseBtn.hidden=true;
        textFilterPhaseBtn.hidden=true;
        trashIcon.hidden=true;
        fullScreenBtn.hidden=true;
    }
    else
    {
        filterBtn.center=CGPointMake(fullRect.size.width-25-10,100+150);
        isFilterModeOn=false;
        mediaCancelThisMediaBtn.hidden=false;
        mediaNextBtn.hidden=false;
        mediaDownloadBtn.hidden=false;
        locationFilterPhaseBtn.hidden=false;
        textFilterPhaseBtn.hidden=false;
        trashIcon.hidden=false;
                fullScreenBtn.hidden=false;
    }
}


-(void)textFilterPhaseBtnClicked:(id)sender
{
    
    if(sticker==nil)
    {
        [AnalyticsMXManager PushAnalyticsEvent:@"Media-textoverlay"];
        
        sticker=[[OverlayStickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [self addSubview:sticker];
        
        sticker.center=self.center;
        
        
        [sticker setTarget:self OnMovementCallBack:@selector(hideKeyboard:)];
        [sticker setEditingDelegate:self onEditingStart:@selector(textOverLayEditingStart:) onEditingEnd:@selector(textOverLayEditingStop:)];
        
        [sticker setUpOverLaySticker];
        
        [sticker setDeleteCallBack:@selector(onDeleteCallBackOfSticker:)];
        
        
    }
    else
    {
        [sticker becomeResponsderThis];
    }
    
}
-(void)onDeleteCallBackOfSticker:(UIView *)obj
{
    //[[jsonDict valueForKey:@"results"] isKindOfClass:[NSArray class]]
    
    
  
    [AnalyticsMXManager PushAnalyticsEvent:@"Media-textoverlay-del"];


    [UIView animateWithDuration:0.5 animations:^{
        
        obj.alpha=0;
      
        
    } completion:^(BOOL finished) {
       
        

        if([obj isKindOfClass:[LocationStickerView class]])
        {
            [MX_locationStickerObj removeFromSuperview];
            MX_locationStickerObj=nil;
            
        }
        else
        {
            
            [sticker removeFromSuperview];
            sticker=nil;
            
            
        }
    }];
    
   
    
}
-(void)textOverLayEditingStart:(OverlayStickerView *)sender
{
    
    
    mediaCancelThisMediaBtn.hidden=true;
    mediaNextBtn.hidden=true;
    mediaDownloadBtn.hidden=true;
    locationFilterPhaseBtn.hidden=true;
    textFilterPhaseBtn.hidden=true;
    trashIcon.hidden=true;
    
    
    overLayStickerKeyboardBar.hidden=false;
    float height=[sender getKeyboardHeight];
    
    [self bringSubviewToFront:overLayStickerKeyboardBar];
    
    
    int heightTop=self.frame.size.height-height-100;
    
    if(RX_isiPhone5Res)
    {
        heightTop=heightTop-45;
    }
    if(RX_isiPhone7PlusRes)
    {
        heightTop=heightTop+30;
    }
    overLayStickerKeyboardBar.frame=CGRectMake(0, heightTop, self.frame.size.width, 100);
    
    
    
}
-(void)overLayStickerPropertyChange:(NSDictionary *)dict
{
    [sticker changeProperty:dict];
    
}
-(void)textOverLayEditingStop:(OverlayStickerView *)sender
{
    mediaCancelThisMediaBtn.hidden=false;
    mediaNextBtn.hidden=false;
    mediaDownloadBtn.hidden=false;
    locationFilterPhaseBtn.hidden=false;
    textFilterPhaseBtn.hidden=false;
    trashIcon.hidden=false;
    overLayStickerKeyboardBar.hidden=true;
    
}
-(void)hideKeyboard:(id)sender
{
    [sticker resignResponderThis];
}
-(void)locationFilterPhaseBtnClicked:(id)sender
{
    
    if(MX_locationStickerObj==nil)
    {
        [AnalyticsMXManager PushAnalyticsEvent:@"Media-locfilter"];

        MX_locationStickerObj=[[LocationStickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self addSubview:MX_locationStickerObj];
        MX_locationStickerObj.center=self.center;
        [MX_locationStickerObj setUpLocationSticker];
        [MX_locationStickerObj setTarget:self OnMovementCallBack:@selector(hideKeyboard:)];
        [MX_locationStickerObj setDeleteCallBack:@selector(onDeleteCallBackOfSticker:)];

    }
}


#pragma mark - Text Filter Control
-(void)tapCallBackOnLocationFilter
{
    
}



#pragma mark - Preview controls

-(void)cancelThisMedia:(id)sender
{
    [AnalyticsMXManager PushAnalyticsEvent:@"Media-Cancelled"];

    [target performSelector:attachmentRemoveFunc withObject:nil afterDelay:0.001];
    
    //    [self cleanUp];
    
    
}
-(BOOL)isMediaTypeVideo
{
    if(mediaType==1)
    {
        return true;
    }
    else
    {
        return false;
    }
}
-(NSString *)getFinalOutPutPath
{
    
    UIImage *image=[self getFinalOutputImage];
    NSString *path=[self FM_saveImageAtDocumentDirectory:image];
    path=[Constant getCompressedPathFromImagePath:path];
    
    
    return path;
    
    
}
-(NSString *)getCroppedVideoPath
{
    return actualMediaPath;
}
-(UIImage *)getFinalOutputImage
{
    mediaCancelThisMediaBtn.hidden=true;
    mediaNextBtn.hidden=true;
    mediaDownloadBtn.hidden=true;
    locationFilterPhaseBtn.hidden=true;
    textFilterPhaseBtn.hidden=true;
    trashIcon.hidden=true;
    
    CGRect originalFrame=self.frame;
    self.frame=fullRect;
    
    UIImage *image=[self imageFromView:self];
    
    self.frame=originalFrame;
    
    trashIcon.hidden=false;
    mediaCancelThisMediaBtn.hidden=false;
    mediaNextBtn.hidden=false;
    mediaDownloadBtn.hidden=false;
    locationFilterPhaseBtn.hidden=false;
    textFilterPhaseBtn.hidden=false;
    
    return image;
    
}
-(void)saveToGallery:(id)sender
{
    
    if(mediaType==0)
    {
        [AnalyticsMXManager PushAnalyticsEvent:@"Media-save-Photo"];

        UIImage *image=[self getFinalOutputImage];
        
        
        UIImageWriteToSavedPhotosAlbum(image,
                                       self, // send the message to 'self' when calling the callback
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                       NULL); // you generally won't need a contextInfo here
        
    }
    else
    {
        [AnalyticsMXManager PushAnalyticsEvent:@"Media-save-Video"];

        NSDictionary *dict=[self getMetaDataOptions];
        UIImage *image=[self getOverLayVideoImage];
        
//        [self exportVideoWithOverLay:image withMetadata:dict];
        [self exportCompositionToVideo:image withMetadata:dict];
        
        
        NSString *path=[self FM_saveImageAtDocumentDirectory:image];
        NSLog(@"%@",path);
        
        
        
        
    }
    
}
-(NSDictionary *)getMetaDataOptions;
{
    


    NSDictionary *dict2=[loopPlayer getFilterDict];
    
    //        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:snapshotImage,@"OVERLAY",currentCompo,@"COMPOSITION",nil];

    if(dict2.allKeys.count!=0)
    {
    
    NSDictionary *dict=@{
                         @"audioOption":[NSNumber numberWithInt:audioOption],
                         @"COMPOSITION":[dict2 valueForKey:@"COMPOSITION"],
                         @"OVERLAY":[dict2 valueForKey:@"OVERLAY"]
                         
                         };
        return dict;

    }
    else
    {
        NSDictionary *dict=@{
                             @"audioOption":[NSNumber numberWithInt:audioOption],
                             
                             };
        return dict;

    }
    
   
}
-(UIImage *)getOverLayVideoImage
{
    mediaCancelThisMediaBtn.hidden=true;
    mediaNextBtn.hidden=true;
    mediaDownloadBtn.hidden=true;
    locationFilterPhaseBtn.hidden=true;
    textFilterPhaseBtn.hidden=true;
    trashIcon.hidden=true;
    soundToggleBtn.hidden=true;
    loopPlayer.hidden=true;
    
    self.backgroundColor=[UIColor clearColor];
    
    self.opaque = NO;
    
    CGRect originalFrame=self.frame;
    self.frame=fullRect;
    
    UIImage *image=[self imageFromView:self];
    
    self.frame=originalFrame;
    
    self.opaque = false;
    
    self.backgroundColor=[UIColor grayColor];
    
    
    loopPlayer.hidden=false;
    
    mediaCancelThisMediaBtn.hidden=false;
    mediaNextBtn.hidden=false;
    mediaDownloadBtn.hidden=false;
    locationFilterPhaseBtn.hidden=false;
    textFilterPhaseBtn.hidden=false;
    trashIcon.hidden=false;
    if(mediaType==1)
    {
        soundToggleBtn.hidden=false;
    }
    return image;
    
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        
        [FTIndicator showErrorWithMessage:@"Failed to Save"];
        
    } else {
        
        [FTIndicator showSuccessWithMessage:@"Saved to Gallery"];
    }
}


- (UIImage *) imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
-(void)updateStickerInteraction
{
    
    if(isOpenFullMode==true)
    {
        
        MX_locationStickerObj.userInteractionEnabled=true;
        sticker.userInteractionEnabled=true;
        
    }
    else
    {
        MX_locationStickerObj.userInteractionEnabled=false;
        sticker.userInteractionEnabled=false;
        
    }
    
    
}

-(void)openFullScreen:(id)sender
{
    isOpenFullMode=true;
    [self updateStickerInteraction];
    
    [loopPlayer resumeBtnClicked:nil];
    
    float duration=0.5;
    
    if(sender==nil)
    {
        mediaCancelThisMediaBtn.center=CGPointMake(25, 25+15);
        textFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10, 25+15);
        locationFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10,100+15);
        [mediaCancelThisMediaBtn setBackgroundImage:[UIImage imageNamed:@"MX_cCloseBtn.png"] forState:UIControlStateNormal];
        
        soundToggleBtn.center=CGPointMake(fullRect.size.width/2,25+15);
        
        self.frame=fullRect;
        
        fullScreenBtn.hidden=true;
        [target performSelector:showFullScreenFunc withObject:nil afterDelay:0.001];
        
        
    }
    else
    {
        smallRect=self.frame;
        [target performSelector:showFullScreenFunc withObject:nil afterDelay:0.001];
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [mediaCancelThisMediaBtn setBackgroundImage:[UIImage imageNamed:@"MX_cCloseBtn.png"] forState:UIControlStateNormal];
            
            mediaCancelThisMediaBtn.center=CGPointMake(25, 25+15);
            textFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10, 25+15);
            locationFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10,100+15);
            soundToggleBtn.center=CGPointMake(fullRect.size.width/2,25+15);

            self.frame=fullRect;
            
        } completion:^(BOOL finished) {
            
            fullScreenBtn.hidden=true;
            
            
        }];
        
        
    }
    
    
    
    
}
-(void)collapseScreen:(id)sender
{
    isOpenFullMode=false;
    [self updateStickerInteraction];
    
    [loopPlayer pauseBtnClicked:nil];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        
        [mediaCancelThisMediaBtn setBackgroundImage:[UIImage imageNamed:@"MX_removePic.png"] forState:UIControlStateNormal];
        
        mediaCancelThisMediaBtn.center=CGPointMake(fullRect.size.width-25, 25);
        textFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10, -100);
        locationFilterPhaseBtn.center=CGPointMake(fullRect.size.width-25-10,-100);
        soundToggleBtn.center=CGPointMake(fullRect.size.width/2,-100);

        self.frame=smallRect;
        
    } completion:^(BOOL finished) {
        
        
        fullScreenBtn.hidden=false;
        [target performSelector:showThumbScreenFunc withObject:nil afterDelay:0.001];
        
    }];
    
}

#pragma mark - Helper
-(void)setAttachmentRemoveCallBack:(SEL)func3;
{
    attachmentRemoveFunc=func3;
}
-(void)setTarget:(id)delegate showFullScreenCallBack:(SEL)func1 andShowThumbCallBack:(SEL)func2
{
    target=delegate;
    showFullScreenFunc=func1;
    showThumbScreenFunc=func2;
}
-(UIButton *)getNormalButton1:(NSString *)title andCallBack:(SEL)func
{
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:func forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.adjustsFontSizeToFitWidth=YES;
    return btn;
    
}
-(UIButton *)getButton:(NSString *)imagePath andCallBack:(SEL)func
{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    [btn addTarget:self action:func forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    //    btn.layer.shadowRadius=5;
    //    btn.layer.shadowColor=[UIColor blackColor].CGColor;
    //    btn.layer.shadowOffset=CGSizeMake(0, 0);
    //    btn.layer.shadowOpacity=0.6;
    
    return btn;
    
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if(touches.count==1 && mediaType==0)
//    {
//        UITouch *touch=[touches anyObject];
//        CGPoint location=[touch locationInView:self];
//        
//        if(touch.tapCount==2)
//        {
//            [AnalyticsMXManager PushAnalyticsEvent:@"Media-imageFilter"];
//
//            [mediaImageView generateNewEffectPoint:location];
//        }
//    }
//    else if(touches.count==1 && mediaType==1)
//    {
//        UITouch *touch=[touches anyObject];
//        CGPoint location=[touch locationInView:self];
//        
//        if(touch.tapCount==2)
//        {
//        }
//        
//    }
//}
-(NSString *)FM_saveImageAtDocumentDirectory:(UIImage *)image
{
    
    NSString *savedImagePath = [[self applicationDocumentsDirectoryPath] stringByAppendingPathComponent:@"savedImage.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL flag=[imageData writeToFile:savedImagePath atomically:YES];
    
    return savedImagePath;
    
}
-(NSString *)applicationDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    return documentsPath;
}
-(void)exportVideoWithOver2Lay1:(UIImage *)overLayImage
{
    
    
    CGSize requiredVideoSize=RX_mainScreenBounds.size;
    
    
    requiredVideoSize=CGSizeMake(requiredVideoSize.width*2, requiredVideoSize.height*2);
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:actualMediaPath] options:nil];
    
    
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //If you need audio as well add the Asset Track for audio here
    
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    
    CGSize videoSize=clipVideoTrack.naturalSize;
    
    
    
    
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    
    
    CALayer *titleLayer = [CALayer layer];
    titleLayer.contents = (id)overLayImage.CGImage;
    //titleLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    titleLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:titleLayer];
    
    
    
    
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=videoSize;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    
    
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    
    // [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov",@"555"];
    
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];

    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:KK_VideoQualityRatio];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
                
            {
                NSLog(@"Export OK %@",destinationPath);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                //    NSData *data=[NSData dataWithContentsOfFile:destinationPath];
                //    [FTIndicator showToastMessage:[NSString stringWithFormat:@"Original %d kb",(int)data.length/1024]];
                });
                
                
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
                }
            }
                
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export Cancelled");
                break;
                
            default: break;
        }
    }];
    
}
-(void)exportCompositionToVideo:(UIImage *)overLayImage withMetadata:(NSDictionary *)dict
{
    AVMutableVideoComposition *currentCompo=[dict valueForKey:@"COMPOSITION"];
    
    if(currentCompo==nil)
    {
        [self exportVideoWithOverLay:overLayImage withMetadata:dict withNewPath:actualMediaPath];

    }
    else
    {
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:actualMediaPath] options:nil];
    AVAssetTrack *track = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize dimensions = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destinationPath =  [documentsDirectory stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"ProcessedVideo-%d.mov", arc4random() % 1000]];
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
    
    
    
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:actualMediaPath]]];
    encoder.outputFileType = AVFileTypeQuickTimeMovie;
    encoder.outputURL = [NSURL fileURLWithPath:destinationPath];
    encoder.videoComposition=currentCompo;
    
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: [NSNumber numberWithFloat:dimensions.width],
    AVVideoHeightKey: [NSNumber numberWithFloat:dimensions.height],
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @1100000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @(44100/2),
    AVEncoderBitRateKey: @(128000/2),
    };
    
    
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {

                    [self exportVideoWithOverLay:overLayImage withMetadata:dict withNewPath:destinationPath];

//             NSLog(@"Export OK %@",destinationPath);
//             if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
//                 UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
//             }
//             
             NSLog(@"Video export succeeded 1");
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video cancel error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
         else
         {
             NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
     }];
    }

    

}
-(void)exportVideoWithOverLay:(UIImage *)overLayImage withMetadata:(NSDictionary *)dict withNewPath:(NSString *)filteredPath
{
    
    int kAudioOption=[[dict valueForKey:@"audioOption"] intValue];
    
    UIImage *imageFirst=[dict valueForKey:@"OVERLAY"];
    
    
    
    CGSize requiredVideoSize=RX_mainScreenBounds.size;
    
    
    requiredVideoSize=CGSizeMake(requiredVideoSize.width*2, requiredVideoSize.height*2);
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filteredPath] options:nil];
    
    
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];

    if([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0 && kAudioOption!=0)
    {
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];

    }
    
    
    
    
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    
    CGSize videoSize=clipVideoTrack.naturalSize;
    
    
    
    
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    
    
    CALayer *firstLayer = [CALayer layer];
    firstLayer.contents = (id)imageFirst.CGImage;
    //titleLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    firstLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:firstLayer];
    
    
    CALayer *titleLayer = [CALayer layer];
    titleLayer.contents = (id)overLayImage.CGImage;
    //titleLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    titleLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:titleLayer];
    
    
    
    
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=videoSize;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    
    
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    
    // [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov",@"555"];
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];

    
    
    
    AVAssetTrack *track = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize dimensions = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
    
    
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:mixComposition];
    encoder.outputFileType = AVFileTypeQuickTimeMovie;
    encoder.outputURL = [NSURL fileURLWithPath:destinationPath];
    encoder.videoComposition=videoComposition;
    
    
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: [NSNumber numberWithFloat:dimensions.width],
    AVVideoHeightKey: [NSNumber numberWithFloat:dimensions.height],
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @1100000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @(44100/2),
    AVEncoderBitRateKey: @(128000/2),
    };
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
              //   NSData *data=[NSData dataWithContentsOfFile:destinationPath];
                // [FTIndicator showToastMessage:[NSString stringWithFormat:@"Compressed %d kb",(int)data.length/1024]];
             });
             
             
             if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                 UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
             }
             
             NSLog(@"Export OK %@ ",destinationPath);
             
             NSLog(@"Video export succeeded 2");
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video cancel error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
         else
         {
             NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
     }];
    
    
    
}







@end
