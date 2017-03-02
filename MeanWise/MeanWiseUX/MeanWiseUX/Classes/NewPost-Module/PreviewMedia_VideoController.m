//
//  PreviewMediaController.m
//  ExactResearch
//
//  Created by Hardik on 13/02/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "PreviewMedia_VideoController.h"
#import "VideoTextItemCell.h"

@implementation PreviewMedia_VideoController

-(void)setTarget:(id)targetReceived OnSuccess:(SEL)func1 OnFail:(SEL)func2;
{
    target=targetReceived;
    onSuccessFunc=func1;
    onCancelFunc=func2;
    
}

-(void)setUpWithString:(NSString *)strPath
{
    
    NSLog(@"%@",strPath);
    
    arrayOfSentences=[[NSMutableArray alloc] init];
    arrayHeightOfCell=[[NSMutableArray alloc] init];
    visualElements=[[NSMutableArray alloc] init];
  
    filePathStr=strPath;
    NSString *ext = [filePathStr pathExtension];
    
    if([ext.lowercaseString isEqualToString:@"png"] || [ext.lowercaseString isEqualToString:@"jpg"] || [ext.lowercaseString isEqualToString:@"jpeg"])
    {
        isVideo=false;
    }
    else{
        isVideo=true;
    }
    
    
    playerViewControl =
    [[AVPlayerViewController alloc] init];
    playerViewControl.player =
    [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePathStr]];
    [playerViewControl.player play];
    playerViewControl.showsPlaybackControls=false;
    playerViewControl.videoGravity=AVLayerVideoGravityResize;
    
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePathStr] options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks objectAtIndex:0];
    CGSize mediaSize = track.naturalSize;
   // playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width, mediaSize.height);
    [self addSubview:playerViewControl.view];
    playerViewControl.view.userInteractionEnabled=false;
    playerViewControl.view.frame=self.bounds;
    playerViewControl.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];


    
    
    
//    if(mediaSize.width>mediaSize.height)
//    {
//        ratio=scrollView.frame.size.height/mediaSize.height;
//        float width=ratio*mediaSize.width;
//        mediaSize=CGSizeMake(width, scrollView.frame.size.height);
//        
//    }
//    else
//    {
//        
//        ratio=scrollView.frame.size.width/mediaSize.width;
//        float height=ratio*mediaSize.height;
//        mediaSize=CGSizeMake(scrollView.frame.size.width, height);
//        
//    }
//    
    
    
    
    
    listOfTextTBL=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.frame.size.height-120)];
    [self addSubview:listOfTextTBL];
    listOfTextTBL.backgroundColor=[UIColor clearColor];
    
    EditingCancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self addSubview:EditingCancelBtn];
    EditingCancelBtn.center=CGPointMake(35, 35);
    [EditingCancelBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [EditingCancelBtn setBackgroundImage:[UIImage imageNamed:@"2_cancelBtn.png"] forState:UIControlStateNormal];
    
    
    
    EditingCorrectBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self addSubview:EditingCorrectBtn];
    EditingCorrectBtn.center=CGPointMake(self.frame.size.width-35, 35);
    [EditingCorrectBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [EditingCorrectBtn setBackgroundImage:[UIImage imageNamed:@"2_correctBtn.png"] forState:UIControlStateNormal];
    
    
    
    
    
    AddNewBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self addSubview:AddNewBtn];
    [AddNewBtn addTarget:self action:@selector(addNewItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [AddNewBtn setBackgroundImage:[UIImage imageNamed:@"2_add.png"] forState:UIControlStateNormal];

    AddNewBtn.center=CGPointMake(self.frame.size.width-48, self.frame.size.height-48);
    

}
#pragma operation status
-(void)doneBtnClicked:(id)sender
{
    
    [FTIndicator showProgressWithmessage:@"Preparing.." userInteractionEnable:NO];

    NSString *tempPath = filePathStr;


    if(arrayOfSentences.count!=0)
    {
    
    [self combineAndAddText1:tempPath andText:[NSArray arrayWithArray:arrayOfSentences]];
    
    ////
    
  
    }
    else
    {
        [self redirectWithPath:tempPath];
    }
    
    
}
-(void)redirectWithPath:(NSString *)path
{
    dispatch_async(dispatch_get_main_queue(), ^{

        [FTIndicator dismissProgress];

        [playerViewControl.player pause];
        playerViewControl.player=nil;
        [target performSelector:onSuccessFunc withObject:path afterDelay:0.01];
        [self removeFromSuperview];

        // Your code to run on the main queue/thread
    });


}
-(void)backBtnClicked:(id)sender
{
    
    [arrayHeightOfCell removeAllObjects];
    [arrayOfSentences removeAllObjects];
    
    
    //adjust indexing
    for(int i=0;i<[visualElements count];i++)
    {
        VideoTextItemCell *ck=[visualElements objectAtIndex:i];
        
        [ck removeFromSuperview];
        
    }
    [visualElements removeAllObjects];

    
    [playerViewControl.player pause];
    playerViewControl.player=nil;
    
    [target performSelector:onCancelFunc withObject:nil afterDelay:0.01];
    
    [self removeFromSuperview];
}

#pragma operation other

-(void)setUpdateGUI
{
    int totalHeight=0;
    
    for(int i=0;i<[visualElements count];i++)
    {
        float height=[[arrayHeightOfCell objectAtIndex:i] floatValue];
        
        VideoTextItemCell *c=[visualElements objectAtIndex:i];
        [c setFrame:CGRectMake(0, totalHeight, self.frame.size.width, height)];
        totalHeight=height+totalHeight;

        
    }
}

-(void)changeTextEvent:(NSArray *)array
{
 
    int path=[[array objectAtIndex:0] intValue];
    
    NSString *str=[array objectAtIndex:1];
    float value=[[array objectAtIndex:2] floatValue];
    
    [arrayOfSentences replaceObjectAtIndex:path withObject:str];
    [arrayHeightOfCell replaceObjectAtIndex:path withObject:[NSNumber numberWithFloat:value]];
    
   
    [self setUpdateGUI];
        

    
}

-(void)addNewItemBtnClicked:(id)sender
{
    int index=(int)[arrayOfSentences count];
    
    [arrayHeightOfCell addObject:[NSNumber numberWithFloat:75]];
    [arrayOfSentences addObject:@"hello"];
    
    
    
    VideoTextItemCell *cell=[[VideoTextItemCell alloc] init];
    [cell setUpMainWithFrame:CGRectMake(0, 0, self.frame.size.width, 75)];
    [cell setFrameX:CGRectMake(0, 0, self.frame.size.width, 75)];
    [cell setTextValue:[arrayOfSentences objectAtIndex:index] andIndexPath:index];
    [cell setTarget:self andtextchangeFunc:@selector(changeTextEvent:) andDeleteBtnClicked:@selector(deleteItemAtIndex:)];

    [visualElements addObject:cell];
    
    [listOfTextTBL addSubview:cell];
    
    [self setUpdateGUI];
    
}
-(void)deleteItemAtIndex:(NSNumber *)number
{
 
    [arrayHeightOfCell removeObjectAtIndex:number.intValue];
    [arrayOfSentences removeObjectAtIndex:number.intValue];
    VideoTextItemCell *c=[visualElements objectAtIndex:number.intValue];
    [visualElements removeObject:c];
    
    [c removeFromSuperview];
    
    //adjust indexing
    for(int i=0;i<[visualElements count];i++)
    {
        VideoTextItemCell *ck=[visualElements objectAtIndex:i];
        [ck updateIndexPath:i];
        
        
    }
    
    [self setUpdateGUI];

}

-(void)autoplayContinue:(id)sender
{
    
    AVPlayerItem *currentItem = playerViewControl.player.currentItem;
    
    NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
    
    NSTimeInterval duration = CMTimeGetSeconds(currentItem.duration);
    
    if(currentTime>=duration)
    {
        [playerViewControl.player seekToTime:kCMTimeZero];
        
    }
    [playerViewControl.player play];
    
    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];
    
}

-(UIButton *)setUpBtnWithTitle:(NSString *)str andSel:(SEL)selector
{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn.titleLabel.font=[UIFont fontWithName:@"Avenir-Roman" size:12];
    
    btn.backgroundColor=[UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}

-(UIImage *)createImageWithText:(NSString *)string andSize:(CGSize)size
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor=[UIColor clearColor];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, size.height/2, size.width-10, size.height/2-10)];
    label.font=[UIFont fontWithName:@"AvenirNext-Heavy" size:size.width/10];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    label.text=string;
    label.adjustsFontSizeToFitWidth=YES;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.layer.shadowColor=[UIColor blackColor].CGColor;
    label.layer.shadowOpacity=0.5;
    label.layer.shadowRadius=3;
    
    view.opaque=false;
    
    [view addSubview:label];
    
    return [self imageFromView:view];
    
}
- (UIImage *) imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}



-(void)combineAndAddText1:(NSString *)filePath andText:(NSArray *)textArray
{
    CGSize requiredVideoSize=[UIScreen mainScreen].bounds.size;

    
    requiredVideoSize=CGSizeMake(requiredVideoSize.width*2, requiredVideoSize.height*2);
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    
   
    
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
    
    
    
//    if([self isVideoPortrait:videoAsset])
//    {
//
//        NSLog(@"portrait and %@",NSStringFromCGSize(videoSize));
//        videoSize=CGSizeMake(videoSize.height, videoSize.width);
//
//    }
//    else
//    {
//        
//        NSLog(@"landscape and %@",NSStringFromCGSize(videoSize));
//        videoSize=CGSizeMake(videoSize.height, videoSize.width);
//
//    }
//    
    
    
    //NSLog(@"sizeOfVideo.width is %f",sizeOfVideo.width);
    //NSLog(@"sizeOfVideo.height is %f",sizeOfVideo.height);
    //TextLayer defines the text they want to add in Video
    
   /* UIImage *myImage = [UIImage imageNamed:@"profile3.jpg"];
    CALayer *aLayer = [CALayer layer];
    aLayer.contents = (id)myImage.CGImage;
    aLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    aLayer.opacity = 1.0f;
    aLayer.cornerRadius=600/16;
    aLayer.shadowColor = [[UIColor greenColor] CGColor];
    aLayer.shadowOffset = CGSizeMake(0, 0);
    aLayer.shadowOpacity = 0.5;
    aLayer.shadowRadius = 2.0f;
    aLayer.masksToBounds=YES;*/
    
    
    
   
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    
 //   [parentLayer addSublayer:aLayer];
    
    float duration=CMTimeGetSeconds(videoAsset.duration);
    
    int numberOfItems=(int)textArray.count+2;
    
    float interval=duration/numberOfItems;
    
    
    for (int i=0; i<[textArray count]; i++) {
        
        NSString *titleText=[textArray objectAtIndex:i];
        
        UIImage *myImage =[self createImageWithText:titleText andSize:videoSize];
;
        CALayer *titleLayer = [CALayer layer];
        titleLayer.contents = (id)myImage.CGImage;
        //titleLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
        titleLayer.frame = CGRectMake(-2*myImage.size.width, videoSize.height-myImage.size.height-10, myImage.size.width, myImage.size.height);

        
        
        /*
         CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
         animation.keyPath = @"position.x";
         animation.values = @[ @0, @10, @-10, @10, @0 ];
         animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
         animation.duration = 0.4;
         
         animation.additive = YES;
         
         [titleLayer addAnimation:animation forKey:@"shake"];*/
        
        //
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
        [opacityAnimation setToValue:[NSNumber numberWithFloat:0]];
        [opacityAnimation setDuration:0.5f];
        
        [opacityAnimation setBeginTime:i*interval+interval*2];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeForwards];
        [titleLayer addAnimation:opacityAnimation forKey:@"opacity"];
        
        
        
        /* CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
         
         [positionAnimation setFromValue:[NSNumber numberWithFloat:0]];
         [positionAnimation setToValue:[NSNumber numberWithFloat:videoSize.width/2]];
         
         
         [positionAnimation setDuration:0.5f];
         [positionAnimation setBeginTime:i*interval+interval/2*3];
         [positionAnimation setRemovedOnCompletion:NO];
         [positionAnimation setFillMode:kCAFillModeForwards];
         [titleLayer addAnimation:positionAnimation forKey:@"key"];
         */
        
        
        
        
        CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        position.values = @[
                            [NSNumber numberWithFloat:-videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width*3/2]
                            ];
        
        position.duration = interval;
        position.beginTime=i*interval+interval;
        position.fillMode=kCAFillModeForwards;
        position.removedOnCompletion=false;
        position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [titleLayer addAnimation:position forKey:@"position.x"];
        
        
        //        CAAnimationGroup *group = [CAAnimationGroup animation];
        //        group.duration=0.5;
        //        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //        group.animations = @[opacityAnimation,positionAnimation];
        //
        //        [titleLayer addAnimation:group forKey:@"allMyAnimations"];
        
        
        [parentLayer addSublayer:titleLayer];
        
        
        
        
        
        
        
        
        
        /*CABasicAnimation *animation = [CABasicAnimation animation];
         animation.keyPath = @"opacity";
         animation.fromValue = @0.0;
         animation.toValue = @1.0f;
         animation.duration = 1.0f;
         
         [titleLayer addAnimation:animation forKey:@"basic"];*/
        
        
        
        
    }
    
    
    
    
    
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=videoSize;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    
    
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
  
    [layerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    
    

    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
                
                NSLog(@"Export OK %@",destinationPath);
                
                
                    [self redirectWithPath:destinationPath];
                    
                    // Your code to run on the main queue/thread
                
                
                //if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                //   UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                //}
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
-(BOOL) isVideoPortrait:(AVAsset *)asset{
    BOOL isPortrait = FALSE;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = FALSE;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = FALSE;
        }
    }
    return isPortrait;
}


-(void)combineAndAddText:(NSString *)filePath andText:(NSArray *)textArray
{
    
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
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
    
    
    
    
    //NSLog(@"sizeOfVideo.width is %f",sizeOfVideo.width);
    //NSLog(@"sizeOfVideo.height is %f",sizeOfVideo.height);
    //TextLayer defines the text they want to add in Video
    
    UIImage *myImage = [UIImage imageNamed:@"profile3.jpg"];
    CALayer *aLayer = [CALayer layer];
    aLayer.contents = (id)myImage.CGImage;
    aLayer.frame = CGRectMake(15, 15, 600/8, 600/8);
    aLayer.opacity = 1.0f;
    aLayer.cornerRadius=600/16;
    aLayer.shadowColor = [[UIColor greenColor] CGColor];
    aLayer.shadowOffset = CGSizeMake(0, 0);
    aLayer.shadowOpacity = 0.5;
    aLayer.shadowRadius = 2.0f;
    aLayer.masksToBounds=YES;
    
    
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:aLayer];
    
    float duration=CMTimeGetSeconds(videoAsset.duration);
    
    int numberOfItems=(int)textArray.count+2;
    
    float interval=duration/numberOfItems;
    
    
    for (int i=0; i<[textArray count]; i++) {
        
        NSString *titleText=[textArray objectAtIndex:i];
        
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.string = titleText;
        titleLayer.fontSize = 25;
        titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
        titleLayer.font= CFBridgingRetain(@"AvenirNext-Heavy");
        
        //titleLayer.backgroundColor=[UIColor blackColor].CGColor;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.frame = CGRectMake(20-videoSize.width, 100, videoSize.width - 40, 80);
        [titleLayer displayIfNeeded];
        titleLayer.opacity=1.0f;
        titleLayer.wrapped=YES;
        
        
        titleLayer.shadowColor = [[UIColor blackColor] CGColor];
        titleLayer.shadowOffset = CGSizeMake(0, 0);
        titleLayer.shadowOpacity = 0.5;
        titleLayer.shadowRadius = 2.0f;
        
        /*
         CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
         animation.keyPath = @"position.x";
         animation.values = @[ @0, @10, @-10, @10, @0 ];
         animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
         animation.duration = 0.4;
         
         animation.additive = YES;
         
         [titleLayer addAnimation:animation forKey:@"shake"];*/
        
        //
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
        [opacityAnimation setToValue:[NSNumber numberWithFloat:0]];
        [opacityAnimation setDuration:0.5f];
        
        [opacityAnimation setBeginTime:i*interval+interval*2];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeForwards];
        [titleLayer addAnimation:opacityAnimation forKey:@"opacity"];
        
        
        
        /* CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
         
         [positionAnimation setFromValue:[NSNumber numberWithFloat:0]];
         [positionAnimation setToValue:[NSNumber numberWithFloat:videoSize.width/2]];
         
         
         [positionAnimation setDuration:0.5f];
         [positionAnimation setBeginTime:i*interval+interval/2*3];
         [positionAnimation setRemovedOnCompletion:NO];
         [positionAnimation setFillMode:kCAFillModeForwards];
         [titleLayer addAnimation:positionAnimation forKey:@"key"];
         */
        
        
        
        
        CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        position.values = @[
                            [NSNumber numberWithFloat:-videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width/2],[NSNumber numberWithFloat:videoSize.width*3/2]
                            ];
        
        position.duration = interval;
        position.beginTime=i*interval+interval;
        position.fillMode=kCAFillModeForwards;
        position.removedOnCompletion=false;
        position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [titleLayer addAnimation:position forKey:@"position.x"];
        
        
        //        CAAnimationGroup *group = [CAAnimationGroup animation];
        //        group.duration=0.5;
        //        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //        group.animations = @[opacityAnimation,positionAnimation];
        //
        //        [titleLayer addAnimation:group forKey:@"allMyAnimations"];
        
        
        [parentLayer addSublayer:titleLayer];
        
        
        
        
        
        
        
        
        
        /*CABasicAnimation *animation = [CABasicAnimation animation];
         animation.keyPath = @"opacity";
         animation.fromValue = @0.0;
         animation.toValue = @1.0f;
         animation.duration = 1.0f;
         
         [titleLayer addAnimation:animation forKey:@"basic"];*/
        
        
        
        
    }
    
    
    
    
    
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=videoSize;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    
    
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
                
                NSLog(@"Export OK %@",destinationPath);
                
                
                //if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                    //   UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                //}
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

-(void)exportDidFinish:(AVAssetExportSession*)session
{
    
}
@end
