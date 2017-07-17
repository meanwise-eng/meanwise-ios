//
//  VideoRecordComponent.m
//  MeanWiseUX
//
//  Created by Hardik on 17/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "VideoRecordComponent.h"
#import "HMVideoPlayer.h"


@implementation VideoRecordComponent


-(void)setUp
{
   imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"post_5.jpeg"]];
    imageView.clipsToBounds=YES;
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    
    cameraCaptureView=[[LLSimpleCamera alloc] init];
    cameraCaptureView.videoEnabled=true;
    cameraCaptureView.view.frame=imageView.frame;
    [self addSubview:cameraCaptureView.view];
    [cameraCaptureView updateFlashMode:LLCameraFlashOff];
    [cameraCaptureView start];

    
   cameraBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:cameraBtn];
    cameraBtn.layer.cornerRadius=25;
    cameraBtn.backgroundColor=[UIColor redColor];
    cameraBtn.layer.borderWidth=2;
    cameraBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    cameraBtn.center=CGPointMake(imageView.bounds.size.width/2,imageView.bounds.size.height-60);
    
    [cameraBtn addTarget:self action:@selector(cameraBtnTapDown:) forControlEvents:UIControlEventTouchDown];
    [cameraBtn addTarget:self action:@selector(cameraBtnTapUp:) forControlEvents:UIControlEventTouchUpInside];
    
    pro=[[LineProgressBar alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 8)];
    [self addSubview:pro];
    [pro setUp];
    pro.center=CGPointMake(imageView.bounds.size.width/2,imageView.bounds.size.height-120);
    [pro resetZero];

    

    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setShowsTouchWhenHighlighted:YES];
    cancelBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:13];
    cancelBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];

    switchCamBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [switchCamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchCamBtn setShowsTouchWhenHighlighted:YES];
    switchCamBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:13];
    switchCamBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    switchCamBtn.layer.cornerRadius=25;
    [switchCamBtn addTarget:self action:@selector(switchCamBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   // [switchCamBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    [self addSubview:switchCamBtn];

    
    flashLightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [flashLightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flashLightBtn setShowsTouchWhenHighlighted:YES];
    flashLightBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:12];
    flashLightBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    flashLightBtn.layer.cornerRadius=25;
    [flashLightBtn addTarget:self action:@selector(flashLightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[flashLightBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    [self addSubview:flashLightBtn];

    
    cancelBtn.center=CGPointMake(35,20+25);
    
    switchCamBtn.center=CGPointMake(35,imageView.bounds.size.height-60);
    flashLightBtn.center=CGPointMake(imageView.bounds.size.width-35,imageView.bounds.size.height-60);

}

-(void)cameraBtnTapDown:(id)sender
{
    [pro resetZero];
    
    
    
    

    [self CallContinue];
    
    NSURL *outputURL = [[[Constant applicationDocumentsDirectory]
                         URLByAppendingPathComponent:@"test1"] URLByAppendingPathExtension:@"mov"];
    
    
    [cameraCaptureView startRecordingWithOutputUrl:outputURL didRecord:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
        

        if(error==nil)
        {
            
            [Constant okAlert:outputURL.absoluteString withSubTitle:@"Success" onView:self andStatus:1];
            UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path, nil, NULL, NULL);
            [self getThumb:outputURL.path];


        }
        else
        {
            if (([error code] == AVErrorMaximumDurationReached)) {
                UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path, nil, NULL, NULL);
                
                [self getThumb:outputURL.path];

            }
            else
            {

            [Constant okAlert:@"Error" withSubTitle:error.localizedDescription onView:self andStatus:1];
            }

        }
        
        
    }];



}

-(void)cameraBtnTapUp:(id)sender
{
 
    [pro setProValue:0.5f];
    [cameraCaptureView stopRecording];
    
    
}


-(void)CallContinue
{
    if (cameraBtn.state != UIControlStateHighlighted)
    {
        return;
    }
    
    CMTime t=[cameraCaptureView getRecordedVideoLength];

    float dur = CMTimeGetSeconds(t);

    [pro setProValue:dur/25.0f];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CallContinue) object:nil];
    [self performSelector:@selector(CallContinue) withObject:nil afterDelay:0.02];


}




-(void)cancelBtnClicked:(id)sender
{
    
}
-(void)switchCamBtnClicked:(id)sender
{

    [cameraCaptureView togglePosition];
    
}
-(void)flashLightBtnClicked:(id)sender
{
    if(cameraCaptureView.flash==LLCameraFlashOff)
    {
        [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOff.png"] forState:UIControlStateNormal];

        [cameraCaptureView updateFlashMode:LLCameraFlashOn];
    }
    else if(cameraCaptureView.flash==LLCameraFlashOn)
    {
        [flashLightBtn setBackgroundImage:[UIImage imageNamed:@"FlashOn.png"] forState:UIControlStateNormal];

        [cameraCaptureView updateFlashMode:LLCameraFlashOff];
    }
    
    
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
