//
//  Cropper.m
//  ExactResearch
//
//  Created by Hardik on 17/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "MediaCropper.h"
#import "SDAVAssetExportSession.h"

@implementation MediaCropper

-(void)setDirectCrop
{
    UIView *view=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:view];
    view.backgroundColor=[UIColor clearColor];
    
    title.hidden=true;
    doneBtn.hidden=true;
    trimSlider.hidden=true;
    view1.hidden=true;
    view2.hidden=true;
    view3.hidden=true;
    view4.hidden=true;

    gridView1.hidden=true;
    gridView2.hidden=true;
    gridView3.hidden=true;
    gridView4.hidden=true;
    gridView5.hidden=true;
    cancelBtn.hidden=true;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:blurEffectView];


    
    [self performSelector:@selector(cropFinished:) withObject:nil afterDelay:0.001];
}

-(void)setUpWithPath:(NSString *)stringPath
{
    defaultOrientation=0;
    self.backgroundColor=[UIColor blackColor];

    
    [self setUpContainerAndScroll];
    

    filePathStr=stringPath;
    NSString *ext = [filePathStr pathExtension];
        isPlayerPaused=false;
    if([ext.lowercaseString isEqualToString:@"png"] || [ext.lowercaseString isEqualToString:@"jpg"] || [ext.lowercaseString isEqualToString:@"jpeg"])
    {
        isVideo=false;
    }
    else
    {
        isVideo=true;
    }
    
 
    
    if(isVideo==false)
    {
        sourceImage=[UIImage imageWithContentsOfFile:filePathStr];
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0 , 0)];
        imageView.image=sourceImage;
        [commonView addSubview:imageView];

        
        
        CGSize imageViewSize=CGSizeMake(sourceImage.size.width, sourceImage.size.height);
        
        if(sourceImage.size.width>=sourceImage.size.height)
        {
            ratio=scrollView.frame.size.height/sourceImage.size.height;
            float width=ratio*sourceImage.size.width;
            imageViewSize=CGSizeMake(width, scrollView.frame.size.height);
        }
        else
        {
            ratio=scrollView.frame.size.width/sourceImage.size.width;
            float height=ratio*sourceImage.size.height;
            imageViewSize=CGSizeMake(scrollView.frame.size.width, height);
            
            if(imageViewSize.height<scrollView.frame.size.height) //bruteforce
            {
                float newratio=1.0f;
                for(int i=0;i<20;i++)
                {
                    float ratioTemp=1.0f+i*0.05;
                    if(height*ratioTemp>scrollView.frame.size.height)
                    {
                        newratio=ratioTemp;
                        break;
                    }
                    
                }
                
                NSLog(@"%@",@"YOYO - BEST FIT PORTRAIT");
                ratio=ratio*newratio;
                int width=scrollView.frame.size.width*newratio;
                height=height*newratio;
                imageViewSize=CGSizeMake(width, height);
            }
            
            
        }
        
        scrollView.contentSize=imageViewSize;
        commonView.frame=CGRectMake(0, 0,imageViewSize.width , imageViewSize.height);
        imageView.frame=CGRectMake(0, 0,imageViewSize.width , imageViewSize.height);
        
        
        
    }
    else
    {
        
        playerViewControl =
        [[AVPlayerViewController alloc] init];
        playerViewControl.player =
        [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePathStr]];
        [playerViewControl.player play];
        playerViewControl.showsPlaybackControls=false;
        playerStartTime=kCMTimeZero;
        playerEndTime=playerViewControl.player.currentItem.duration;
        
        [commonView addSubview:playerViewControl.view];
        playerViewControl.view.userInteractionEnabled=false;
        playerViewControl.videoGravity=AVLayerVideoGravityResizeAspect;
        [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];

        
        CGSize mediaSize=[self getTheSizeFromVideoPath:filePathStr];
        
        if(mediaSize.width>=mediaSize.height)
        {
            ratio=scrollView.frame.size.height/mediaSize.height;
            float width=ratio*mediaSize.width;
            mediaSize=CGSizeMake(width, scrollView.frame.size.height);
        }
        else
        {
            ratio=scrollView.frame.size.width/mediaSize.width;
            float height=ratio*mediaSize.height;
            mediaSize=CGSizeMake(scrollView.frame.size.width, height);
            
            if(mediaSize.height<scrollView.frame.size.height)
            {
                float newratio=1.0f;
                for(int i=0;i<20;i++)
                {
                    float ratioTemp=1.0f+i*0.05;
                    if(height*ratioTemp>scrollView.frame.size.height)
                    {
                        newratio=ratioTemp;
                        break;
                    }
                    
                }
                
                NSLog(@"%@",@"YOYO - BEST FIT PORTRAIT");
                ratio=ratio*newratio;
                int width=scrollView.frame.size.width*newratio;
                height=height*newratio;
                mediaSize=CGSizeMake(width, height);
            }
            
        }
        
        
        
        
        scrollView.contentSize=mediaSize;
        commonView.frame=CGRectMake(0, 0,mediaSize.width , mediaSize.height);
        playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width, mediaSize.height);
        
        
    }
    
    
    
    
    
    
    
    
    
    [self setUpBoundriesAndGrid];
    
    [self setUpButtons];
    
  
}
-(void)setUpContainerAndScroll
{
    containerView=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:containerView];
    containerView.clipsToBounds=false;
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [containerView addSubview:scrollView];
    scrollView.center=self.center;
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    scrollView.clipsToBounds=false;
    scrollView.layer.borderWidth=1;
    scrollView.layer.borderColor=[UIColor whiteColor].CGColor;
    scrollView.delegate=self;
    scrollView.minimumZoomScale=1.0f;
    scrollView.maximumZoomScale=2.0f;
    
    commonView=[[UIView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:commonView];
    

}
-(void)setUpButtons
{
    title=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 50)];
    [self addSubview:title];
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont fontWithName:k_fontBold size:16];
    title.textColor=[UIColor whiteColor];
    
    if(isVideo==false)
    {
        title.text=@"Crop Photo";
    }
    else
    {
        title.text=@"Crop Video";
        
        trimSlider=[[TrimSlider alloc] initWithFrame:CGRectMake(0, self.frame.size.height-65, self.frame.size.width, 50)];
        [self addSubview:trimSlider];
        [trimSlider setUp:filePathStr];
        [trimSlider setTarget:self andOnTrimmingDidChangeFunc:@selector(trimmingChange:)];
        
        
        //        CGSize mediaSize=[self getTheSizeFromVideoPath:filePathStr];
        //
        //        int orien=[self getOrientation_FromVideoPath:filePathStr];
        //
        //        title.text=[NSString stringWithFormat:@"%@,%d",NSStringFromCGSize(mediaSize),orien];
        
    }
    
    title.layer.shadowColor=[UIColor blackColor].CGColor;
    title.layer.shadowOpacity=0.5;
    title.layer.shadowRadius=2;
    title.layer.shadowOffset=CGSizeMake(0, 0);
    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-60, 30, 50, 50)];
    [self addSubview:doneBtn];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"3_correctBtn.png"] forState:UIControlStateNormal];

    doneBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:16];
    [doneBtn addTarget:self action:@selector(cropFinished:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    [self addSubview:cancelBtn];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainWhite.png"] forState:UIControlStateNormal];

    cancelBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:16];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
   
    rotateBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-60, 90, 50, 50)];
    [self addSubview:rotateBtn];
    [rotateBtn setBackgroundImage:[UIImage imageNamed:@"RotateMedia.png"] forState:UIControlStateNormal];
    rotateBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:16];
    [rotateBtn addTarget:self action:@selector(rotateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    doneBtn.titleLabel.layer.shadowColor=[UIColor blackColor].CGColor;
    doneBtn.titleLabel.layer.shadowOpacity=0.8;
    doneBtn.titleLabel.layer.shadowRadius=5;
    doneBtn.titleLabel.layer.shadowOffset=CGSizeMake(0, 0);
    
    cancelBtn.titleLabel.layer.shadowColor=[UIColor blackColor].CGColor;
    cancelBtn.titleLabel.layer.shadowOpacity=0.8;
    cancelBtn.titleLabel.layer.shadowRadius=5;
    cancelBtn.titleLabel.layer.shadowOffset=CGSizeMake(0, 0);
    
    
    rotateBtn.titleLabel.layer.shadowColor=[UIColor blackColor].CGColor;
    rotateBtn.titleLabel.layer.shadowOpacity=0.8;
    rotateBtn.titleLabel.layer.shadowRadius=5;
    rotateBtn.titleLabel.layer.shadowOffset=CGSizeMake(0, 0);
    
}
-(void)rotateBtnClicked:(id)sender
{
    if(isVideo==false)
    {
        CGSize imageViewSize;
        if(defaultOrientation==0)
        {


            [UIView animateWithDuration:0.2 animations:^{
                imageView.transform=CGAffineTransformMakeRotation(M_PI/2);
                rotateBtn.transform=CGAffineTransformMakeScale(-1, 1);
//                imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI/2);
            }];
            imageViewSize=CGSizeMake(sourceImage.size.height, sourceImage.size.width);
            defaultOrientation=1;
        }
        else
        {
            imageView.layer.anchorPoint=CGPointMake(0.5, 0.5);

            [UIView animateWithDuration:0.2 animations:^{
                imageView.transform=CGAffineTransformMakeRotation(0);
                rotateBtn.transform=CGAffineTransformMakeScale(1, 1);

            }];
            imageViewSize=CGSizeMake(sourceImage.size.width, sourceImage.size.height);
            defaultOrientation=0;

        }
        
        
        
        
        if(imageViewSize.width>=imageViewSize.height)
        {
            ratio=scrollView.frame.size.height/imageViewSize.height;
            float width=ratio*imageViewSize.width;
            imageViewSize=CGSizeMake(width, scrollView.frame.size.height);
        }
        else
        {
            ratio=scrollView.frame.size.width/imageViewSize.width;
            float height=ratio*imageViewSize.height;
            imageViewSize=CGSizeMake(scrollView.frame.size.width, height);
            
            if(imageViewSize.height<scrollView.frame.size.height) //bruteforce
            {
                float newratio=1.0f;
                for(int i=0;i<20;i++)
                {
                    float ratioTemp=1.0f+i*0.05;
                    if(height*ratioTemp>scrollView.frame.size.height)
                    {
                        newratio=ratioTemp;
                        break;
                    }
                    
                }
                
                NSLog(@"%@",@"YOYO - BEST FIT PORTRAIT");
                ratio=ratio*newratio;
                int width=scrollView.frame.size.width*newratio;
                height=height*newratio;
                imageViewSize=CGSizeMake(width, height);
            }
            
            
        }
        
        scrollView.contentSize=imageViewSize;
        imageView.frame=CGRectMake(0, 0,imageViewSize.width , imageViewSize.height);
        commonView.frame=CGRectMake(0, 0,imageViewSize.width , imageViewSize.height);
       scrollView.zoomScale=1;
        scrollView.contentOffset=CGPointZero;
    }
    else
    {
        
        CGSize mediaSize=[self getTheSizeFromVideoPath:filePathStr];
        if(defaultOrientation==0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                playerViewControl.view.transform = CGAffineTransformRotate(playerViewControl.view.transform, M_PI/2);
                rotateBtn.transform=CGAffineTransformMakeScale(-1, 1);

            }];
            mediaSize=CGSizeMake(mediaSize.height, mediaSize.width);
            defaultOrientation=1;
        }
        else
        {
            playerViewControl.view.layer.anchorPoint=CGPointMake(0.5,0.5);
            [UIView animateWithDuration:0.2 animations:^{
                playerViewControl.view.transform=CGAffineTransformMakeRotation(0);
                rotateBtn.transform=CGAffineTransformMakeScale(1, 1);
 
            }];
            mediaSize=CGSizeMake(mediaSize.width, mediaSize.height);
            defaultOrientation=0;
            
        }
        
       
        
        if(mediaSize.width>=mediaSize.height)
        {
            ratio=scrollView.frame.size.height/mediaSize.height;
            float width=ratio*mediaSize.width;
            mediaSize=CGSizeMake(width, scrollView.frame.size.height);
        }
        else
        {
            ratio=scrollView.frame.size.width/mediaSize.width;
            float height=ratio*mediaSize.height;
            mediaSize=CGSizeMake(scrollView.frame.size.width, height);
            
            if(mediaSize.height<scrollView.frame.size.height)
            {
                float newratio=1.0f;
                for(int i=0;i<20;i++)
                {
                    float ratioTemp=1.0f+i*0.05;
                    if(height*ratioTemp>scrollView.frame.size.height)
                    {
                        newratio=ratioTemp;
                        break;
                    }
                    
                }
                
                NSLog(@"%@",@"YOYO - BEST FIT PORTRAIT");
                ratio=ratio*newratio;
                int width=scrollView.frame.size.width*newratio;
                height=height*newratio;
                mediaSize=CGSizeMake(width, height);
            }
            
        }
        
        
        
        
        scrollView.contentSize=mediaSize;
        
        commonView.frame=CGRectMake(0, 0,mediaSize.width , mediaSize.height);
        playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width, mediaSize.height);

        scrollView.zoomScale=1;
        scrollView.contentOffset=CGPointZero;

    }
}

-(void)FixOrientation
{
    AVURLAsset* firstAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePathStr] options:nil];
    
    
    // CGSize requiredVideoSize=scrollView.frame.size;
    
    //  requiredVideoSize=CGSizeMake(requiredVideoSize.width/ratio, requiredVideoSize.height/ratio);
    
    if(firstAsset !=nil)
    {
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        CMTime duration=firstAsset.duration;
        CMTime startTime=kCMTimeZero;
//        

       /* CMTime duration=CMTimeSubtract(playerEndTime, playerStartTime);
        CMTime startTime=playerStartTime;*/
        
        
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:startTime error:nil];
        
        if([firstAsset tracksWithMediaType:AVMediaTypeAudio].count>0)
        {
        AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:startTime error:nil];
        }
        
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        CGSize naturalSize=FirstAssetTrack.naturalSize;
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
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
        
        
        CGSize requiredVideoSize=[self getTheSizeFromVideoPath:filePathStr];
        
        
        
        CGFloat FirstAssetScaleToFitRatio = requiredVideoSize.width/naturalSize.width;
        if(isFirstAssetPortrait_)
        {
            FirstAssetScaleToFitRatio = requiredVideoSize.width/naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }
        else
        {
            //  FirstAssetScaleToFitRatio = requiredVideoSize.height/naturalSize.width;
            //FirstAssetScaleToFitRatio=1;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
            
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];;
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = requiredVideoSize;
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fixOrientation-%d.mov",5]];
        
        
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
        
        
        
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        exporter.timeRange=CMTimeRangeMake(playerStartTime, CMTimeSubtract(playerEndTime, playerStartTime));
        
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if(exporter.status == AVAssetExportSessionStatusCompleted)
                 {
                     

                     [self saveNewVideoManage:myPathDocs];
                     
                     
                     NSLog(@"DONE - %@",myPathDocs);
                 }
                 else
                 {
                     NSLog(@"DONE - %@",myPathDocs);

                 }
             });
         }];
    }
    
    
}

-(void)saveNewVideoManage:(NSString *)path
{
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *track = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    
    if([asset tracksWithMediaType:AVMediaTypeAudio].count>0)
    {
        
        AVMutableCompositionTrack *track1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];


    [track1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    }
    
    
    NSString *documentsDirectory=[self applicationDocumentsDirectoryPath];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"/hello.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
    
    
    
    
    CGRect visibleRect = [scrollView convertRect:scrollView.bounds toView:playerViewControl.view];
    
    
    
    CGSize naturalSize=[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].naturalSize;
    
    NSLog(@"Natural Video Rect = %@",NSStringFromCGSize(naturalSize));
    NSLog(@"\nCropped Rect = %@",NSStringFromCGRect(visibleRect));
    
    //1387,777 - 720
    
    //float naturalSizeRatio=visibleRect.size.height/naturalSize.height;
    
    // NSLog(@"%f",naturalSizeRatio);
    
    visibleRect=CGRectMake(visibleRect.origin.x/ratio, visibleRect.origin.y/ratio, visibleRect.size.width/ratio, visibleRect.size.height/ratio);
    
    NSLog(@"\n\n\n\nNatural Video Rect = %@",NSStringFromCGSize(naturalSize));
    
    NSLog(@"\nCropped Rect = %@",NSStringFromCGRect(visibleRect));
    
    
    
    int width=roundf(visibleRect.size.width);
    int height=roundf(visibleRect.size.height);
    
    
    if(width%2==1)
    {
        width=width-1;
    }
    if(height%2==1)
    {
        height=height-1;
    }
    
    visibleRect=CGRectMake(visibleRect.origin.x, visibleRect.origin.y, width, height);
    
    
    
    
    
    
    
    
    
    
    
    [layerInstruction setCropRectangle:visibleRect atTime:kCMTimeZero];
    CGAffineTransform translate=CGAffineTransformMakeTranslation(-visibleRect.origin.x, -visibleRect.origin.y);
    [layerInstruction setTransform:translate atTime:kCMTimeZero];
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    mainCompositionInst.renderSize = CGSizeMake(visibleRect.size.width, visibleRect.size.height);
    mainCompositionInst.instructions = [NSArray arrayWithObject:instruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    AVAssetExportSession *exporter;
    
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:KK_VideoQualityRatio];
    
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    
    
    
    
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(exporter.status == AVAssetExportSessionStatusCompleted)
            {
                if(defaultOrientation==0)
                {
                [self removeAndClose:myPathDocs];
                }
                else
                {
                    [self RotateVideo:myPathDocs];
                }

                
               // [self saveNewVideoManage:myPathDocs];
                
                
                NSLog(@"DONE - %@",myPathDocs);
            }
            else
            {
                NSLog(@"DONE - %@",myPathDocs);
                
            }

            
            
        });
    }];
    
    
}
-(void)RotateVideo:(NSString *)path
{
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *track = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    
    if([asset tracksWithMediaType:AVMediaTypeAudio].count>0)
    {
        
        AVMutableCompositionTrack *track1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        [track1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    }
    
    
    NSString *documentsDirectory=[self applicationDocumentsDirectoryPath];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"/hello2.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
    

    
    
    
    
    
    
    CGSize naturalSize=[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].naturalSize;
    
    NSLog(@"Natural Video Rect = %@",NSStringFromCGSize(naturalSize));
    
    
    
   CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI/2);
    CGAffineTransform rotateTranslate = CGAffineTransformTranslate(rotationTransform,0,-naturalSize.height);
    [layerInstruction setTransform:rotateTranslate atTime:kCMTimeZero];
    
//
//
    
    instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction,nil];
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];

    
    mainCompositionInst.renderSize = CGSizeMake(naturalSize.height, naturalSize.width);
    mainCompositionInst.instructions = [NSArray arrayWithObject:instruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    AVAssetExportSession *exporter;
    
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:KK_VideoQualityRatio];
    
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    
    
    
    
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(exporter.status == AVAssetExportSessionStatusCompleted)
            {

                    [self removeAndClose:myPathDocs];
                
                
                
                
                // [self saveNewVideoManage:myPathDocs];
                
                
                NSLog(@"DONE - %@",myPathDocs);
            }
            else
            {
                NSLog(@"DONE - %@",myPathDocs);
                
            }
            
            
            
        });
    }];

    
    
}

-(void)trimmingChange:(NSArray *)array
{
    
    
    float start=[[array objectAtIndex:0] floatValue];
    float end=[[array objectAtIndex:1] floatValue];
    int selected=[[array objectAtIndex:2] intValue];
    int touch=[[array objectAtIndex:3] intValue];
    
    
   // float timeScale=playerViewControl.player.currentTime.timescale;
    
    playerStartTime=CMTimeMakeWithSeconds(start, 1);
    playerEndTime=CMTimeMakeWithSeconds(end, 1);
    
    if(selected==1)
    {
        [self playerSeekToTime:playerStartTime];

    }
    else
    {
        [self playerSeekToTime:playerEndTime];


    }
    
    if(touch==1)
    {
        [UIView animateWithDuration:0.2 animations:^{
            containerView.transform=CGAffineTransformMakeScale(0.75, 0.75);

        }];
        
        isPlayerPaused=true;
        [playerViewControl.player pause];

    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            containerView.transform=CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
        
        [self playerSeekToTime:playerStartTime];
        isPlayerPaused=false;

    }
    

    
}
-(void)playerSeekToTime:(CMTime)time
{
    NSTimeInterval currentTime = CMTimeGetSeconds(time);

    int32_t timeScale = playerViewControl.player.currentItem.asset.duration.timescale;
    CMTime time2 = CMTimeMakeWithSeconds(currentTime, timeScale);
    [playerViewControl.player seekToTime:time2 toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

    
//    CMTime currentT=CMTimeMakeWithSeconds(currentTime, 1);
//
//    [playerViewControl.player.currentItem seekToTime:currentT];

}
-(void)autoplayContinue:(id)sender
{
    
    if(isPlayerPaused==false)
    {
    AVPlayerItem *currentItem = playerViewControl.player.currentItem;
    
    NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
    
        CMTime currentT=CMTimeMakeWithSeconds(currentTime, 1);
        
        
    NSTimeInterval duration = CMTimeGetSeconds(playerEndTime);
        if(CMTimeCompare(playerEndTime, kCMTimeIndefinite)==0)
        {
            playerEndTime=playerViewControl.player.currentItem.duration;
            duration=CMTimeGetSeconds(playerEndTime);
        }
    
        
    if(currentTime>=duration)
    {
        [self playerSeekToTime:playerStartTime];

        
    }
    [playerViewControl.player play];
        
        [trimSlider updateProgress:playerStartTime endTime:playerEndTime andCurrentTime:currentItem.currentTime];
        

    }
    else{
        [playerViewControl.player pause];
    }

    [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];

}




-(int)getOrientation_FromVideoPath:(NSString *)filePath
{
    
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks objectAtIndex:0];
    CGSize mediaSize = track.naturalSize;
    
    
    AVAssetTrack *FirstAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    BOOL  isFirstAssetPortrait_  = NO;
    CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
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
    
    if(isFirstAssetPortrait_==true)
    {
        if(mediaSize.width>mediaSize.height)
        {
            mediaSize=CGSizeMake(mediaSize.height, mediaSize.width);
        }
        NSLog(@"portrait ori");
        
        return 1;
    }
    else
    {
        if(mediaSize.height>mediaSize.width)
        {
            mediaSize=CGSizeMake(mediaSize.height, mediaSize.width);
        }
        NSLog(@"landscape ori");
        
        return 0;
        
    }
    
}
-(CGSize)getTheSizeFromVideoPath:(NSString *)filePath
{
    
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks objectAtIndex:0];
    CGSize mediaSize = track.naturalSize;
    
    
    AVAssetTrack *FirstAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    BOOL  isFirstAssetPortrait_  = NO;
    CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
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
    
    if(isFirstAssetPortrait_==true)
    {
        if(mediaSize.width>mediaSize.height)
        {
            mediaSize=CGSizeMake(mediaSize.height, mediaSize.width);
        }
        NSLog(@"portrait size");
    }
    else
    {
        if(mediaSize.height>=mediaSize.width && FirstAssetOrientation_!=UIImageOrientationUp)
        {
            mediaSize=CGSizeMake(mediaSize.height, mediaSize.width);
        }
        
        NSLog(@"landscape size");
        
    }
    
    return mediaSize;
}



#pragma mark - Events
-(void)cancelBtnClicked:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if(isVideo)
        {
            isPlayerPaused=true;
            [playerViewControl.player pause];
            playerViewControl.player=nil;
            playerViewControl=nil;
            
        }
        else
        {
            
            
        }
        
        [target performSelector:cancelBtnClicked withObject:nil afterDelay:0.001];
        [self performSelector:@selector(removeThisView:) withObject:nil afterDelay:0.001];
        
    });
    
    
    
}

-(void)removeAndClose:(NSString *)path
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [FTIndicator dismissProgress];
        
        if(isVideo)
        {
            [playerViewControl.player pause];
            playerViewControl.player=nil;
            playerViewControl=nil;
            
        }
        else
        {
            
            
        }
        
        [target performSelector:doneBtnClicked withObject:path afterDelay:0.001];
        [self performSelector:@selector(removeThisView:) withObject:nil afterDelay:0.5];

    });
    
    
}
-(void)removeThisView:(id)sender
{
    [self removeFromSuperview];

}
-(void)replayBtnClicked:(id)sender
{
    [self playerSeekToTime:kCMTimeZero];

    [playerViewControl.player play];
    
}
-(void)cropFinished:(id)sender
{
    isPlayerPaused=true;
    
    /*
     CMTime playerEndTimeTemp=playerViewControl.player.currentItem.duration;
     float sec=CMTimeGetSeconds(playerEndTimeTemp);
     
     float fir=CMTimeGetSeconds(playerStartTime);
     
     if(sec-fir>25.0)
     {
     
     CMTime timeToAdd   = CMTimeMakeWithSeconds(25,1);
     
     playerEndTime  = CMTimeAdd(playerStartTime,timeToAdd);
     sec=CMTimeGetSeconds(playerEndTime);
     
     }
*/
    [FTIndicator showProgressWithmessage:@"Preparing.." userInteractionEnable:NO];
    CGRect visibleRect = [scrollView convertRect:scrollView.bounds toView:imageView];
    

    visibleRect=CGRectMake(visibleRect.origin.x/ratio, visibleRect.origin.y/ratio, visibleRect.size.width/ratio, visibleRect.size.height/ratio);
    
    if(isVideo)
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:blurEffectView];

        [self FixOrientation];
    }
    else
    {
        
        NSString *path=@"";
        UIImage *img=[self crop:visibleRect withImage:imageView.image];
        path=[self FM_saveImageAtDocumentDirectory:img];
        NSLog(@"%@",NSStringFromCGRect(visibleRect));
        
        
        [self removeAndClose:path];
        
    }
    
}
#pragma mark - Helper
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return commonView;
//    if(isVideo)
//    {
//        return playerViewControl.view;
//    }
//    else
//    {
//        return imageView;
//    }
}
- (UIImage *)crop:(CGRect)rect withImage:(UIImage *)image
{
//    UIImage *image=image2;
//    if(defaultOrientation==1)
//    {
//        image=[self rotateDegree:image2];
//    }

    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    if(defaultOrientation==1)
            {
                result=[self rotateDegree:result];
            }
    
    return result;
}

- (UIImage*)rotateDegree:(UIImage*)oldImage
{
    
    float degrees=90;
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;


}



-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2
{
    target=delegate;
    doneBtnClicked=func1;
    cancelBtnClicked=func2;
}

-(void)setUpBoundriesAndGrid
{
    
    
    UIColor *color=[UIColor colorWithWhite:0.0f alpha:0.5f];
    UIColor *color1=[UIColor colorWithWhite:1.0f alpha:0.3];
    
    view1=[[UIView alloc] initWithFrame:CGRectZero];
    view2=[[UIView alloc] initWithFrame:CGRectZero];
    view3=[[UIView alloc] initWithFrame:CGRectZero];
    view4=[[UIView alloc] initWithFrame:CGRectZero];
    
    view1.backgroundColor=color;
    view2.backgroundColor=color;
    view3.backgroundColor=color;
    view4.backgroundColor=color;
    
    [containerView addSubview:view1];
    [containerView addSubview:view2];
    [containerView addSubview:view3];
    [containerView addSubview:view4];
    
    
    view1.frame=CGRectMake(0, 0, self.frame.size.width, scrollView.frame.origin.y);
    view3.frame=CGRectMake(0, scrollView.frame.origin.y+scrollView.frame.size.height, self.frame.size.width, self.frame.size.height-(scrollView.frame.origin.y+scrollView.frame.size.height));
    
    
    view2.frame=CGRectMake(0,scrollView.frame.origin.y, scrollView.frame.origin.x, self.frame.size.height-2*scrollView.frame.origin.y);
    view4.frame=CGRectMake(scrollView.frame.origin.x+scrollView.frame.size.width,scrollView.frame.origin.y, self.frame.size.width-(scrollView.frame.size.width+scrollView.frame.origin.x), self.frame.size.height-2*scrollView.frame.origin.y);
    
    view1.frame=CGRectMake(-300, -300, self.frame.size.width+300, 300);
    view2.frame=CGRectMake(-300, self.frame.size.height, self.frame.size.width+300, 300);
    view3.frame=CGRectMake(self.frame.size.width, -300, 300, self.frame.size.height+600);
    view4.frame=CGRectMake(-300, 0, 300, self.frame.size.height);
    
    
    
    
     gridView1=[[UIView alloc] initWithFrame:CGRectZero];
    gridView2=[[UIView alloc] initWithFrame:CGRectZero];
    gridView3=[[UIView alloc] initWithFrame:CGRectZero];
    gridView4=[[UIView alloc] initWithFrame:CGRectZero];
    gridView5=[[UIView alloc] initWithFrame:CGRectZero];
    
    
    gridView1.backgroundColor=color1;
    gridView2.backgroundColor=color1;
    gridView3.backgroundColor=color1;
    gridView4.backgroundColor=color1;
    gridView5.backgroundColor=color1;
    
    [containerView addSubview:gridView1];
    [containerView addSubview:gridView2];
    [containerView addSubview:gridView3];
    [containerView addSubview:gridView4];
    [containerView addSubview:gridView5];
    
    
    CGSize size=scrollView.frame.size;
    
    gridView1.frame=CGRectMake(scrollView.frame.origin.x+size.width/3, scrollView.frame.origin.y, 1, size.height);
    
    gridView2.frame=CGRectMake(scrollView.frame.origin.x+size.width/3*2, scrollView.frame.origin.y, 1, size.height);
    
    gridView3.frame=CGRectMake(scrollView.frame.origin.x,scrollView.frame.origin.y+size.height/4, size.width, 1);
    
    gridView4.frame=CGRectMake(scrollView.frame.origin.x,scrollView.frame.origin.y+size.height/4*2, size.width, 1);
    
    gridView5.frame=CGRectMake(scrollView.frame.origin.x,scrollView.frame.origin.y+size.height/4*3, size.width, 1);
    
    
}
-(NSString *)getNewPathWith:(NSString *)string
{
    NSString *documentsDirectory=[self applicationDocumentsDirectoryPath];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:string];
    [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    
    return myPathDocs;
}
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




@end
