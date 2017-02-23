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

-(void)cropFinished:(id)sender
{
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
        
        path=[Constant FM_saveImageAtDocumentDirectory:img];
        NSLog(@"%@",NSStringFromCGRect(visibleRect));

        
        [self removeAndClose:path];
        
        
        
    }
    
    

}
-(NSString *)applicationDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    return documentsPath;
}
-(void)saveNewVideo
{
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *track = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *track1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePathStr]];
    
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
    
    
    visibleRect=CGRectMake(visibleRect.origin.x/ratio, visibleRect.origin.y/ratio, visibleRect.size.width/ratio, visibleRect.size.height/ratio);
    
    NSLog(@"%@",NSStringFromCGRect(visibleRect));



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
    
//    SDAVAssetExportSession *exporter = [SDAVAssetExportSession.alloc initWithAsset:mixComposition];
//    exporter.outputFileType = AVFileTypeMPEG4;
//    exporter.outputURL = url;
//    exporter.videoSettings = @
//    {
//    AVVideoCodecKey: AVVideoCodecH264,
//    AVVideoWidthKey: [NSNumber numberWithInt:(mainCompositionInst.renderSize.width)],
//    AVVideoHeightKey: [NSNumber numberWithInt:(mainCompositionInst.renderSize.height)],
//    AVVideoCompressionPropertiesKey: @
//        {
//        AVVideoAverageBitRateKey: @6000000,
//        AVVideoProfileLevelKey: AVVideoProfileLevelH264Baseline31,
//        },
//    };
//    exporter.audioSettings = @
//    {
//    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
//    AVNumberOfChannelsKey: @2,
//    AVSampleRateKey: @44100,
//    AVEncoderBitRateKey: @128000,
//    };
    
    
    
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.blurBackground = YES;
    alert.hideAllButtons = YES;

    [alert showAlertInView:self
                 withTitle:@"Processing.."
              withSubtitle:nil
           withCustomImage:nil
       withDoneButtonTitle:nil
                andButtons:nil];
    [alert makeAlertTypeProgress];
    
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self removeAndClose:myPathDocs];
            
//            [self convertIntoUploadedFormat:myPathDocs];
            [alert dismissAlertView];

            
        });
    }];
    
    
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
-(void)removeAndClose:(NSString *)path
{
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

-(void)setUpWithPath:(NSString *)stringPath
{
    self.backgroundColor=[UIColor grayColor];
   
    filePathStr=stringPath;
    NSString *ext = [filePathStr pathExtension];
    
    if([ext.lowercaseString isEqualToString:@"png"] || [ext.lowercaseString isEqualToString:@"jpg"] || [ext.lowercaseString isEqualToString:@"jpeg"])
    {
        isVideo=false;
    }
    else{
        isVideo=true;
    }

    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:scrollView];
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
    
        if(image.size.width>image.size.height)
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
        playerViewControl.videoGravity=AVLayerVideoGravityResize;
        
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePathStr] options:nil];
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *track = [tracks objectAtIndex:0];
        CGSize mediaSize = track.naturalSize;
        
       
        
        if(mediaSize.width>mediaSize.height)
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
            
        }
        
        
        scrollView.contentSize=mediaSize;
        
        playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width, mediaSize.height);
        [scrollView addSubview:playerViewControl.view];
        playerViewControl.view.userInteractionEnabled=false;

        
        

        
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
        
        playBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-50, 40, 40)];
        [self addSubview:playBtn];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }

    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-80, 20, 70, 50)];
    [self addSubview:button];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:k_fontBold size:16];

    [button addTarget:self action:@selector(cropFinished:) forControlEvents:UIControlEventTouchUpInside];
    
 
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

@end
