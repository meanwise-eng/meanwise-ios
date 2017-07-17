//
//  PortraitCropComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 23/11/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "PortraitCropComponent.h"

@implementation PortraitCropComponent

-(void)setUpWithPath:(NSString *)path;
{
    filePathStr=path;
    NSString *ext = [path pathExtension];

    if([ext.lowercaseString isEqualToString:@"png"])
    {
        isVideo=false;
    }
    else{
        isVideo=true;
    }
    
    
    CGRect photoframe=CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.height*0.8);
    
    
    palleteView=[[UIView alloc] initWithFrame:photoframe];
    [self addSubview:palleteView];
    palleteView.center=self.center;
    
    
    ViewContainer=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:ViewContainer];
    
    
    
    if(isVideo==false)
    {
        imageView=[[UIImageView alloc] initWithFrame:self.bounds];
        imageView.frame=CGRectMake(0, 0, photoframe.size.width*1.1, photoframe.size.height*1.1);
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        [ViewContainer addSubview:imageView];
        imageView.center=palleteView.center;
        
        UIImage *image=[UIImage imageWithContentsOfFile:path];
        imageView.image=image;

    }
    else
    {
        
        playerViewControl =
        [[AVPlayerViewController alloc] init];
        playerViewControl.player =
        [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
        [self addSubview:playerViewControl.view];
        [playerViewControl.player play];
        playerViewControl.showsPlaybackControls=false;
        playerViewControl.videoGravity=AVLayerVideoGravityResize;


        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *track = [tracks objectAtIndex:0];
        CGSize mediaSize = track.naturalSize;
        

        
        
        if(mediaSize.width>=mediaSize.height)
        {
            
            
            
            
            float ratio=photoframe.size.height/(mediaSize.height-5);

            zoomFactor=ratio;
            playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width*ratio, mediaSize.height*ratio);
            playerViewControl.view.center=palleteView.center;

        }

        if(mediaSize.height>mediaSize.width)
        {
            float ratio=photoframe.size.width/(mediaSize.width-5);
            
            zoomFactor=ratio;
            playerViewControl.view.frame=CGRectMake(0, 0, mediaSize.width*ratio, mediaSize.height*ratio);
            playerViewControl.view.center=palleteView.center;
            
        }

        


    }
    
    float blurViewAlpha=0.5;
    
    blurView1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, palleteView.frame.origin.y)];
    [self addSubview:blurView1];
    blurView1.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    blurView2=[[UIView alloc] initWithFrame:CGRectMake(0, palleteView.frame.origin.y+palleteView.frame.size.height, self.frame.size.width, self.frame.size.height-(palleteView.frame.origin.y+palleteView.frame.size.height))];
    
    [self addSubview:blurView2];
    blurView2.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    
    blurView3=[[UIView alloc] initWithFrame:CGRectMake(0, palleteView.frame.origin.y, palleteView.frame.origin.x, palleteView.frame.size.height)];
    [self addSubview:blurView3];
    blurView3.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    blurView4=[[UIView alloc] initWithFrame:
               CGRectMake(
                          palleteView.frame.origin.x+palleteView.frame.size.width,
                          palleteView.frame.origin.y,
                          self.frame.size.width-(palleteView.frame.origin.x+palleteView.frame.size.width),palleteView.frame.size.height)];
    
    
    [self addSubview:blurView4];
    blurView4.backgroundColor=[UIColor colorWithWhite:0 alpha:blurViewAlpha];
    
    
    
    
    frameView=[[UIView alloc] initWithFrame:palleteView.frame];
    [self addSubview:frameView];
    frameView.layer.borderWidth=1;
    frameView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    
    UIView *grid1=[[UIView alloc] initWithFrame:CGRectMake(palleteView.frame.size.width/3, 0, 1, palleteView.frame.size.height)];
    UIView *grid2=[[UIView alloc] initWithFrame:CGRectMake(2*palleteView.frame.size.width/3, 0, 1, palleteView.frame.size.height)];
    
    UIView *grid3=[[UIView alloc] initWithFrame:CGRectMake(0, palleteView.frame.size.height/3, palleteView.frame.size.width, 1)];
    UIView *grid4=[[UIView alloc] initWithFrame:CGRectMake(0, 2*palleteView.frame.size.height/3, palleteView.frame.size.width, 1)];
    
    
    [frameView addSubview:grid1];
    [frameView addSubview:grid2];
    [frameView addSubview:grid3];
    [frameView addSubview:grid4];
    
    grid1.backgroundColor=[UIColor whiteColor];
    grid2.backgroundColor=[UIColor whiteColor];
    grid3.backgroundColor=[UIColor whiteColor];
    grid4.backgroundColor=[UIColor whiteColor];
    
    
    
    
    
    
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
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *track = [tracks objectAtIndex:0];
   //     CGSize mediaSize = track.naturalSize;
        
    title.text=@"Crop Video";
        
        title.text=[NSString stringWithFormat:@"%f,%f",track.naturalSize.width,track.naturalSize.height];
        title.adjustsFontSizeToFitWidth=YES;
    }
    

    
    btnFinished=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-80, 20, 70, 50)];
    [self addSubview:btnFinished];
    [btnFinished setTitle:@"Finish" forState:UIControlStateNormal];
    [btnFinished setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFinished.titleLabel.font=[UIFont fontWithName:k_fontBold size:15];
    [btnFinished addTarget:self action:@selector(cropFinished:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 50)];
    [self addSubview:btnCancel];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont fontWithName:k_fontBold size:15];
    
    [btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    lastScale=1.0f;
    
    
    UIPinchGestureRecognizer *gesture1=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    [self addGestureRecognizer:gesture1];
    
    UIPanGestureRecognizer *gesture2=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFinger:)];
    [self addGestureRecognizer:gesture2];
 
    if(isVideo)
    {
    validLastTransform=playerViewControl.view.transform;
    }
    else
    {
        validLastTransform=imageView.transform;
    }
    [self checkValidation];
    
    if(isVideo)
    {
        playBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height-50, 40, 40)];
        [self addSubview:playBtn];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    
}
-(void)replayBtnClicked:(id)sender
{
    [playerViewControl.player.currentItem seekToTime:kCMTimeZero];
    [playerViewControl.player play];
    
}
-(void)allowCancel:(BOOL)flag;
{
    btnCancel.hidden=!flag;
}


-(void)panFinger:(UIPanGestureRecognizer *)gesture
{
    
    static CGPoint currentTranslation;
    static CGFloat currentScale = 0;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        currentTranslation = translation;
        
        if(isVideo==false)
        {
        currentScale = imageView.frame.size.width / imageView.bounds.size.width;
        }
        else
        {
            currentScale = playerViewControl.view.frame.size.width / playerViewControl.view.bounds.size.width;

        }
        
        
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation1;
        
        if(isVideo==false)
        {

        translation1= [gesture translationInView:imageView];
        }
        else
        {
            translation1= [gesture translationInView:playerViewControl.view];
   
        }
        if(fabs(translation1.x*lastScale)<10)
        {
            translation1=CGPointMake(0, translation1.y);
        }
        if(fabs(translation1.y*lastScale)<10)
        {
            translation1=CGPointMake(translation1.x,0);
        }
        

        
        translation1=CGPointMake(translation1.x, translation1.y);
        
        
        translation.x = translation1.x + currentTranslation.x;
        translation.y = translation1.y + currentTranslation.y;
        
        CGAffineTransform transform1 = CGAffineTransformMakeTranslation(translation.x , translation.y);
        CGAffineTransform transform2 = CGAffineTransformMakeScale(currentScale, currentScale);
        CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
        
        playerViewControl.view.transform=transform;
        imageView.transform = transform;
        [self checkValidation];


    }

    

    if(gesture.state==UIGestureRecognizerStateCancelled || gesture.state==UIGestureRecognizerStateEnded)
    {
        [self PerformValidationIfRequired];
    }
    
    
}
-(void)checkValidation
{
    CGRect mainRect=palleteView.frame;
    
    CGRect boxRect=playerViewControl.view.frame;
    
    if(!isVideo)
    {
        boxRect=imageView.frame;
    }
    
    if(CGRectContainsRect(boxRect, mainRect))
    {
        if(isVideo)
        {
        validLastTranslation=translation;
        validLastTransform=playerViewControl.view.transform;
        }
        else
        {
            validLastTranslation=translation;
            validLastTransform=imageView.transform;

        }
        self.backgroundColor=[UIColor blackColor];
    }
    else
    {
        
        //imageView.transform=transform;

//        self.backgroundColor=[UIColor yellowColor];
        
    }
    
    
}
-(void)PerformValidationIfRequired
{
    CGRect mainRect=palleteView.frame;
    CGRect boxRect=playerViewControl.view.frame;

    if(!isVideo)
    {
        boxRect=imageView.frame;
    }
    
    if(CGRectContainsRect(boxRect, mainRect))
    {
        validLastTranslation=translation;
        validLastTransform=playerViewControl.view.transform;
    }
    else
    {
        translation=validLastTranslation;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if(isVideo)
            {
            playerViewControl.view.transform=validLastTransform;
            }
            else
            {
                imageView.transform=validLastTransform;
            }

        }];
    }
}
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)gesture
{

    if (gesture.state == UIGestureRecognizerStateEnded
        || gesture.state == UIGestureRecognizerStateChanged) {
        
        NSLog(@"gesture.scale = %f", gesture.scale);
        
        lastScale =lastScale*gesture.scale;
        
        // lastScale=gesture.scale;
        
        if (lastScale > 3.0) {
            lastScale = 3.0;
        }
        if (lastScale < 1.0) {
            lastScale = 1.0;
        }
        
        CGAffineTransform transform1 = CGAffineTransformMakeTranslation(translation.x, translation.y);
        CGAffineTransform transform2 = CGAffineTransformMakeScale(lastScale, lastScale);
        CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
        
        playerViewControl.view.transform=transform;
        imageView.transform = transform;
        gesture.scale=1;
        
        
    }

    if(gesture.state==UIGestureRecognizerStateCancelled || gesture.state==UIGestureRecognizerStateEnded)
    {
        [self PerformValidationIfRequired];
    }
    

}


-(void)setTarget:(id)delegate andDoneBtn:(SEL)func1 andCancelBtn:(SEL)func2;
{
    target=delegate;
    doneBtnClicked=func1;
    cancelBtnClicked=func2;
}
-(void)btnCancel:(id)sender
{
    
    [self removeFromSuperview];
    
    
}
-(void)saveNewVideo
{
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *track = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *track1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    

    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePathStr]];

    [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    
    [track1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeMake(0, 1) error:nil];
    
    
    NSString *documentsDirectory=[Constant applicationDocumentsDirectoryPath];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"/hello.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];

    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
    
    CGSize sizeMain1= track.naturalSize;
    CGSize sizeMain2= playerViewControl.view.frame.size;
    float ratio=sizeMain2.width/sizeMain1.width;

    
    CGPoint x1=playerViewControl.view.frame.origin;
    CGPoint p1=palleteView.frame.origin;
    
    CGPoint diff=CGPointMake(-x1.x+p1.x, -x1.y+p1.y);
    
    
    CGRect CroppedRect=CGRectMake(diff.x/ratio, diff.y/ratio, palleteView.frame.size.width/ratio, palleteView.frame.size.height/ratio);
    
    [layerInstruction setCropRectangle:CroppedRect atTime:kCMTimeZero];
    
    CGAffineTransform t=CGAffineTransformMakeScale(ratio, ratio);
    
    CGAffineTransform translate=CGAffineTransformMakeTranslation(-diff.x, -diff.y);
    
    CGAffineTransform combine=CGAffineTransformConcat(t, translate);
    
    [layerInstruction setTransform:combine atTime:kCMTimeZero];


    [layerInstruction setOpacity:0.0 atTime:asset.duration];
    
    instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    mainCompositionInst.renderSize = CGSizeMake(palleteView.frame.size.width, palleteView.frame.size.height);
    mainCompositionInst.instructions = [NSArray arrayWithObject:instruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);

    AVAssetExportSession *exporter;
    
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset640x480];

    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
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

    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self removeAndClose:myPathDocs];

            [alert dismissAlertView];

        });
    }];


}
-(void)cropFinished:(id)sender
{
    
    if(isVideo)
    {
        [self saveNewVideo];

    }
    else
    {
    
    NSString *path=@"";
    
            UIImage *img=[self crop:palleteView.frame withImage:[self pb_takeSnapshot]];
    
            path=[Constant FM_saveImageAtDocumentDirectory:img];
    
    
        [self removeAndClose:path];
    
    
    
    }
    
    
    
    
}
-(void)removeAndClose:(NSString *)path
{
    if(isVideo)
    {
        [playerViewControl.player pause];
        playerViewControl.player=nil;
        playerViewControl=nil;
        
    }
    
    [target performSelector:doneBtnClicked withObject:path afterDelay:0.01];
    [self removeFromSuperview];

    
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

- (UIImage *)pb_takeSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [ViewContainer drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

@end
