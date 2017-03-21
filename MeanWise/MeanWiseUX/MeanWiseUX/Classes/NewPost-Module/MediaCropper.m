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


-(void)setUpWithPath:(NSString *)stringPath
{
    
    
    
    
    self.backgroundColor=[UIColor grayColor];
    
    filePathStr=stringPath;
    NSString *ext = [filePathStr pathExtension];
    
    if([ext.lowercaseString isEqualToString:@"png"] || [ext.lowercaseString isEqualToString:@"jpg"] || [ext.lowercaseString isEqualToString:@"jpeg"])
    {
        isVideo=false;
    }
    else
    {
        isVideo=true;
    }
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:scrollView];
    scrollView.center=self.center;
    scrollView.showsHorizontalScrollIndicator=false;
    scrollView.showsVerticalScrollIndicator=false;
    scrollView.clipsToBounds=false;
    scrollView.layer.borderWidth=1;
    scrollView.layer.borderColor=[UIColor whiteColor].CGColor;
    scrollView.delegate=self;
    scrollView.minimumZoomScale=1.0f;
    scrollView.maximumZoomScale=5.0f;
    
    
    if(isVideo==false)
    {
        UIImage *image=[UIImage imageWithContentsOfFile:filePathStr];
        CGSize imageViewSize=CGSizeMake(image.size.width, image.size.height);
        
        if(image.size.width>=image.size.height)
        {
            ratio=scrollView.frame.size.height/image.size.height;
            float width=ratio*image.size.width;
            imageViewSize=CGSizeMake(width, scrollView.frame.size.height);
        }
        else
        {
            ratio=scrollView.frame.size.width/image.size.width;
            float height=ratio*image.size.height;
            imageViewSize=CGSizeMake(scrollView.frame.size.width, height);
            
            if(imageViewSize.height<scrollView.frame.size.height)
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
        
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,imageViewSize.width , imageViewSize.height)];
        imageView.image=image;
        [scrollView addSubview:imageView];
    }
    else
    {
        
        playerViewControl =
        [[AVPlayerViewController alloc] init];
        playerViewControl.player =
        [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePathStr]];
        [playerViewControl.player play];
        playerViewControl.showsPlaybackControls=false;
        //  playerViewControl.videoGravity=AVLayerVideoGravityResize;
        
        // CGSize mediaSize = track.naturalSize;
        
        
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
        
        playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width, mediaSize.height);
        [scrollView addSubview:playerViewControl.view];
        playerViewControl.view.userInteractionEnabled=false;
        playerViewControl.videoGravity=AVLayerVideoGravityResizeAspect;
        [self performSelector:@selector(autoplayContinue:) withObject:nil afterDelay:0.2f];
        
    }
    
    [self setUpBoundriesAndGrid];
    
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
        //        CGSize mediaSize=[self getTheSizeFromVideoPath:filePathStr];
        //
        //        int orien=[self getOrientation_FromVideoPath:filePathStr];
        //
        //        title.text=[NSString stringWithFormat:@"%@,%d",NSStringFromCGSize(mediaSize),orien];
        
    }
    
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-80, 20, 70, 50)];
    [self addSubview:button];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:k_fontBold size:16];
    [button addTarget:self action:@selector(cropFinished:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)saveNewVideo
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
        
        
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
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
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fixOrientation-%d.mov",arc4random() % 1000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if(exporter.status == AVAssetExportSessionStatusCompleted)
                 {
                     
                     [self saveNewVideoManage:myPathDocs];
                     
                     
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
    AVMutableCompositionTrack *track1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    
    [track1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    
    
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
    
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    
    
    
    
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self removeAndClose:myPathDocs];
            
            //            [self convertIntoUploadedFormat:myPathDocs];
            
            
        });
    }];
    
    
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

-(void)removeAndClose:(NSString *)path
{
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
    
    [target performSelector:doneBtnClicked withObject:path afterDelay:0.01];
    [self removeFromSuperview];
    
    
}
-(void)replayBtnClicked:(id)sender
{
    [playerViewControl.player.currentItem seekToTime:kCMTimeZero];
    [playerViewControl.player play];
    
}
-(void)cropFinished:(id)sender
{
    
    [FTIndicator showProgressWithmessage:@"Preparing.." userInteractionEnable:NO];
    CGRect visibleRect = [scrollView convertRect:scrollView.bounds toView:imageView];
    
    visibleRect=CGRectMake(visibleRect.origin.x/ratio, visibleRect.origin.y/ratio, visibleRect.size.width/ratio, visibleRect.size.height/ratio);
    
    if(isVideo)
    {
        [self saveNewVideo];
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
    if(isVideo)
    {
        return playerViewControl.view;
    }
    else
    {
        return imageView;
    }
}
- (UIImage *)crop:(CGRect)rect withImage:(UIImage *)image
{
    
    if (image.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * image.scale,
                          rect.origin.y * image.scale,
                          rect.size.width * image.scale,
                          rect.size.height * image.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2
{
    target=delegate;
    doneBtnClicked=func1;
    cancelBtnClicked=func2;
}

-(void)setUpBoundriesAndGrid
{
    
    UIColor *color=[UIColor colorWithWhite:0 alpha:0.7];
    UIColor *color1=[UIColor colorWithWhite:1.0f alpha:0.3];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *view2=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *view3=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *view4=[[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor=color;
    view2.backgroundColor=color;
    view3.backgroundColor=color;
    view4.backgroundColor=color;
    
    [self addSubview:view1];
    [self addSubview:view2];
    [self addSubview:view3];
    [self addSubview:view4];
    
    
    view1.frame=CGRectMake(0, 0, self.frame.size.width, scrollView.frame.origin.y);
    view3.frame=CGRectMake(0, scrollView.frame.origin.y+scrollView.frame.size.height, self.frame.size.width, self.frame.size.height-(scrollView.frame.origin.y+scrollView.frame.size.height));
    
    
    view2.frame=CGRectMake(0,scrollView.frame.origin.y, scrollView.frame.origin.x, self.frame.size.height-2*scrollView.frame.origin.y);
    view4.frame=CGRectMake(scrollView.frame.origin.x+scrollView.frame.size.width,scrollView.frame.origin.y, self.frame.size.width-(scrollView.frame.size.width+scrollView.frame.origin.x), self.frame.size.height-2*scrollView.frame.origin.y);
    
    UIView *gridView1=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *gridView2=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *gridView3=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *gridView4=[[UIView alloc] initWithFrame:CGRectZero];
    UIView *gridView5=[[UIView alloc] initWithFrame:CGRectZero];
    
    
    gridView1.backgroundColor=color1;
    gridView2.backgroundColor=color1;
    gridView3.backgroundColor=color1;
    gridView4.backgroundColor=color1;
    gridView5.backgroundColor=color1;
    
    [self addSubview:gridView1];
    [self addSubview:gridView2];
    [self addSubview:gridView3];
    [self addSubview:gridView4];
    [self addSubview:gridView5];
    
    
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

-(void)showMessage:(NSString*)message withTitle:(NSString *)titleMessage
{
    NSLog(@"BOOM \n\n\n\n %@ - %@\n\n\n",message,titleMessage);
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:titleMessage
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    // [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alert animated:YES completion:^{}];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

-(void)convertIntoUploadedFormat:(NSString *)convertFile
{
    
    
    
    //Configuration Path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *combinedPath = [documentsDirectory stringByAppendingPathComponent:@"/final.mp4"];
    NSLog(@"OUTPUT FILE = %@",combinedPath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:combinedPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:combinedPath error:nil];
    }
    NSURL *finalURL = [[NSURL alloc] initFileURLWithPath: combinedPath];
    
    
    
    
    NSString* filePath2=convertFile;
    
    NSURL *url1=[NSURL fileURLWithPath:filePath2];
    
    
    AVURLAsset* anAsset = [[AVURLAsset alloc]initWithURL:url1 options:nil];
    AVAssetTrack *track = [[anAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    CGSize dimensions = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
    
    
    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:anAsset];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = finalURL;
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: [NSNumber numberWithFloat:dimensions.width],
    AVVideoHeightKey: [NSNumber numberWithFloat:dimensions.height],
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @6000000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @128000,
    };
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             [self removeAndClose:convertFile];
             
             
         });
         
         
         
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"Video export succeeded");
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video export cancelled");
         }
         else
         {
             NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
         }
     }];
    
    
    
    
}

@end
